//
//  JKTimerHolder.h
//  珍夕健康
//
//  Created by 蒋鹏 on 16/11/15.
//  Copyright © 2016年 深圳市见康云科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JKTimerHolder : NSObject

/**
 挂起，暂停定时器，此处不会释放定时器，JKTimerHolder仍被NSTimer强引用
 */
@property (nonatomic, assign) BOOL suspended;


/**
 开始定时器

 @param seconds 间隔
 @param handler 回调响应者
 @param callBack 回调SEL
 @param repeatCount 重复周期，0即不重复
 */
- (void)startTimerWithTimeInterval:(NSTimeInterval)seconds
                     actionHandler:(nullable id)handler
                    callBackAction:(nullable SEL)callBack
                       repeatCount:(NSUInteger)repeatCount;


/**
 关闭定时器，内部会释放定时器，JKTimerHolder不被NSTimer强引用
 */
- (void)invalidateTimer;

@end
