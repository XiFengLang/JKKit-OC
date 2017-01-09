//
//  NSObject+GCDDelayTask.m
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/9.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//  参考：https://github.com/Spaceman-Labs/Dispatch-Cancel

#import "NSObject+GCDDelayTask.h"
#import <objc/runtime.h>

static const char * kJKGCDDelayTaskKey = "kJKGCDDelayTaskKey";

@implementation NSObject (GCDDelayTask)


JKGCDDelayTaskBlock JK_GCDDelayTaskBlock(CGFloat delayInSeconds, dispatch_block_t block) {
    
    if (nil == block) {
        return nil;
    }
    
    // block is likely a literal defined on the stack, even though we are using __block to allow us to modify the variable
    // we still need to move the block to the heap with a copy
    __block dispatch_block_t blockToExecute = [block copy];
    __block JKGCDDelayTaskBlock delayHandleCopy = nil;
    
    JKGCDDelayTaskBlock delayHandle = ^(BOOL cancel){
        if (NO == cancel && nil != blockToExecute) {
            dispatch_async(dispatch_get_main_queue(), blockToExecute);
        }
        
        // Once the handle block is executed, canceled or not, we free blockToExecute and the handle.
        // Doing this here means that if the block is canceled, we aren't holding onto retained objects for any longer than necessary.
#if !__has_feature(objc_arc)
        [blockToExecute release];
        [delayHandleCopy release];
#endif
        
        blockToExecute = nil;
        delayHandleCopy = nil;
    };
    
    // delayHandle also needs to be moved to the heap.
    delayHandleCopy = [delayHandle copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (nil != delayHandleCopy) {
            delayHandleCopy(NO);
        }
    });
    
    return delayHandleCopy;
};



void JK_CancelGCDDelayedTask(JKGCDDelayTaskBlock delayedHandle) {
    if (nil == delayedHandle) {
        return;
    }
    delayedHandle(YES);
#if !__has_feature(objc_arc)
    [delayedHandle release];
#endif
    delayedHandle = nil;
}










- (void)jk_excuteDelayTask:(CGFloat)delayInSeconds
               inMainQueue:(dispatch_block_t)block {
    [self jk_excuteDelayTaskWithKey:nil delayInSeconds:delayInSeconds inMainQueue:block];
}



- (void)jk_excuteDelayTaskWithKey:(const void *)key
                   delayInSeconds:(CGFloat)delayInSeconds
                      inMainQueue:(dispatch_block_t)block {
    
    __block dispatch_block_t blockCopy = [block copy];
    __block JKGCDDelayTaskBlock taskBlockCopy = nil;
    JKGCDDelayTaskBlock taskBlock = ^(BOOL cancel) {
        if (NO == cancel && nil != blockCopy) {
            dispatch_async(dispatch_get_main_queue(), blockCopy);
        }
        
        blockCopy = nil;
        taskBlockCopy = nil;
        objc_setAssociatedObject(self, key ?: kJKGCDDelayTaskKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    };
    taskBlockCopy = [taskBlock copy];
    
    objc_setAssociatedObject(self, key ?: kJKGCDDelayTaskKey, taskBlockCopy, OBJC_ASSOCIATION_COPY_NONATOMIC);
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
        if (nil != taskBlockCopy) {
            taskBlockCopy(NO);
        }
    });
}


- (void)jk_cancelGCDDelayTaskForKey:(const void *)key {
    JKGCDDelayTaskBlock taskBlockCopy = objc_getAssociatedObject(self, key ?: kJKGCDDelayTaskKey);
    if (taskBlockCopy) {
        taskBlockCopy(YES);
        taskBlockCopy = nil;
    }
}

@end
