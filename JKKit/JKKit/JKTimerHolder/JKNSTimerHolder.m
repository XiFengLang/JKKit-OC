//
//  JKNSTimerHolder.m
//  珍夕健康
//
//  Created by 蒋鹏 on 16/11/15.
//  Copyright © 2016年 深圳市见康云科技有限公司. All rights reserved.
//

#import "JKNSTimerHolder.h"
#import <objc/runtime.h>

@interface JKNSTimerHolder ()

/**
 定时器对象
 */
@property (nonatomic, nonatomic, strong) NSTimer * timer;

/**
 重复次数，0即不重复
 */
@property (nonatomic, assign) NSUInteger repeatCount;


/**
 当前执行callBackAction的次数
 */
@property (nonatomic, assign) NSUInteger currentRepeatCount;



@property (nonatomic, assign) SEL callBackAction;
@property (nonatomic, weak)   id actionHandler;


/**
 callBackAction 方法中的参数（实际的自定义参数个数 = self.numberOfArguments - 2）
 */
@property (nonatomic, assign) unsigned int numberOfArguments;


@property (nonatomic, copy) JKNSTimerHandle handleBlock;

@end

@implementation JKNSTimerHolder
- (void)dealloc {
    [self cancelNSTimer];
#ifdef DEBUG
    NSLog(@"%@ 已释放",self.class);
#endif
}


- (void)cancelNSTimer {
    if (self.timer) {
        [_timer invalidate];
        _timer = nil;
        _currentRepeatCount = 0;
        _handleBlock = nil;
        _callBackAction = NULL;
        _repeatCount = 0;
    }
}


- (void)startNSTimerWithTimeInterval:(NSTimeInterval)seconds
                         repeatCount:(NSUInteger)repeatCount
                       actionHandler:(id)handler
                      callBackAction:(SEL)callBack {
    
    [self cancelNSTimer];

    
    Method callBackMethod = class_getInstanceMethod([handler class], callBack);
    if (callBackMethod == NULL) {
        NSLog(@"JKNSTimerHolder Error:  %@ 未实现",NSStringFromSelector(callBack));
        return;
    } else if ([handler respondsToSelector:callBack] == NO) {
        NSLog(@"JKNSTimerHolder Error:  [%@ 不能响应 %@]",[handler class],NSStringFromSelector(callBack));
        return;
    }
    
    /// 方法的参数个数（实际的自定义参数个数 = self.numberOfArguments - 2）
    self.numberOfArguments = method_getNumberOfArguments(callBackMethod);
    //    NSLog(@"%s",method_getTypeEncoding(callBackMethod));
    //    NSLog(@"%s",method_copyReturnType(callBackMethod));
    //    unsigned int count = method_getNumberOfArguments(callBackMethod);
    //    NSLog(@"%s",method_copyArgumentType(callBackMethod, count-1));
    
    
    _actionHandler = handler;
    _callBackAction = callBack;
    _repeatCount = repeatCount;
    _timer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                              target:self
                                            selector:@selector(handleTimerAction:)
                                            userInfo:nil
                                             repeats:repeatCount];
}


- (void)handleTimerAction:(NSTimer *)timer {
    self.currentRepeatCount += 1;
    if (self.currentRepeatCount > self.repeatCount) {
        [self cancelNSTimer];
    }
    
    /// 实际最多只支持一个自定义参数（self.numberOfArguments - 2）
    if (self.numberOfArguments > 3) {
        NSLog(@"JKNSTimerHolder Crash Error: 不支持多参数回调方法，最多支持一个自定义参数(NSTimer *类型), [%@ %@]",[self.actionHandler class],NSStringFromSelector(self.callBackAction));
    }
    
    
    /// 使用IMP调用方法
    if ([self.actionHandler respondsToSelector:self.callBackAction]) {
        typedef void (* MessageForwardFunc)(id, SEL, id);
        IMP impPointer = [self.actionHandler methodForSelector:self.callBackAction];
        MessageForwardFunc func = (MessageForwardFunc)impPointer;
        func(self.actionHandler, self.callBackAction, timer);
    } else {
        /// 比如：外部响应者已释放
        [self cancelNSTimer];
    }
}



- (void)setSuspended:(BOOL)suspended {
    _suspended = suspended;
    if (suspended) {
        [self.timer setFireDate:[NSDate distantFuture]];
    } else {
        [self.timer setFireDate:[NSDate date]];
    }
}






- (void)startBlockTimerWithTimeInterval:(NSTimeInterval)seconds repeatCount:(NSUInteger)repeatCount actionHandler:(id)handler callBack:(JKNSTimerHandle)handle {
    [self cancelNSTimer];
    
    if (nil == handle || nil == handler) {
        return;
    }
    

    
    _handleBlock = handle;
    _actionHandler = handler;
    _repeatCount = repeatCount;
    _timer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                              target:self
                                            selector:@selector(handleBlockTimerAction:)
                                            userInfo:nil
                                             repeats:repeatCount];
}

- (void)handleBlockTimerAction:(NSTimer *)timer {
    self.currentRepeatCount += 1;
    if (self.currentRepeatCount > self.repeatCount) {
        [self cancelNSTimer];
    }
    
    if (nil != self.actionHandler) {
        if (nil != self.handleBlock) {
            self.handleBlock(self, self.actionHandler, self.currentRepeatCount);
        }
    } else {
        /// 比如：外部响应者已释放
        [self cancelNSTimer];
    }
}



@end
