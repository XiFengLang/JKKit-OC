//
//  JKNSTimerHolder.h
//  珍夕健康
//
//  Created by 蒋鹏 on 16/11/15.
//  Copyright © 2016年 深圳市见康云科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma clang assume_nonnull begin
@interface JKNSTimerHolder : NSObject



/**
 挂起，暂停定时器，此处不会释放定时器，JKNSTimerHolder仍被NSTimer强引用
 */
@property (nonatomic, assign) BOOL suspended;




/**
 开始定时器，repeatCount = 0时不重复，repeatCount = 总数 -1，调用cancelNSTimer取消
 
 @param seconds 间隔
 @param repeatCount 重复次数，repeatCount = 总数 -1
 @param handler 回调响应者
 @param callBack 回调SEL
 */
- (void)startNSTimerWithTimeInterval:(NSTimeInterval)seconds
                         repeatCount:(NSUInteger)repeatCount
                       actionHandler:(id __nonnull)handler
                      callBackAction:(SEL __nonnull)callBack;




/**
 关闭定时器，内部会释放定时器，JKNSTimerHolder不被NSTimer强引用
 */
- (void)cancelNSTimer;

@end
#pragma clang assume_nonnull end
