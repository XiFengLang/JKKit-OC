//
//  JKTimerHolder.m
//  珍夕健康
//
//  Created by 蒋鹏 on 16/11/15.
//  Copyright © 2016年 深圳市见康云科技有限公司. All rights reserved.
//

#import "JKTimerHolder.h"
#import <objc/runtime.h>

@interface JKTimerHolder ()

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

@end

@implementation JKTimerHolder
- (void)dealloc {
    [self invalidateTimer];
    
    NSLog(@"%@ 已释放",self.class);
}


- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}


- (void)startTimerWithTimeInterval:(NSTimeInterval)seconds
                     actionHandler:(id)handler
                    callBackAction:(SEL)callBack
                       repeatCount:(NSUInteger)repeatCount {
    
    if (self.timer) {
        [self invalidateTimer];
    }
    
    Method callBackMethod = class_getInstanceMethod([handler class], callBack);
    if (callBackMethod == NULL) {
        NSLog(@"JKTimerHolder Error:  %@ 未实现",NSStringFromSelector(callBack));
        return;
    } else if ([handler respondsToSelector:callBack] == NO) {
        NSLog(@"JKTimerHolder Error:  [%@ 不能响应 %@]",[handler class],NSStringFromSelector(callBack));
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


- (void)setSuspended:(BOOL)suspended {
    _suspended = suspended;
    if (suspended) {
        [self.timer setFireDate:[NSDate distantFuture]];
    } else {
        [self.timer setFireDate:[NSDate date]];
    }
}



- (void)handleTimerAction:(NSTimer *)timer {
    self.currentRepeatCount += 1;
    if (self.currentRepeatCount > self.repeatCount) {
        [self invalidateTimer];
    }
    
    /// 实际最多只支持一个自定义参数（self.numberOfArguments - 2）
    if (self.numberOfArguments > 3) {
        NSLog(@"JKTimerHolder Crash Error: 不支持多参数回调方法，最多支持一个自定义参数(NSTimer *类型), [%@ %@]",[self.actionHandler class],NSStringFromSelector(self.callBackAction));
    }
    
    
    /// 使用IMP调用方法
    typedef void (* MessageForwardFunc)(id, SEL, id);
    IMP impPointer = [self.actionHandler methodForSelector:self.callBackAction];
    MessageForwardFunc func = (MessageForwardFunc)impPointer;
    func(self.actionHandler, self.callBackAction, timer);
}



@end
