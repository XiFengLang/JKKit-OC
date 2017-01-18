//
//  NSObject+KVO.h
//  9.SafeKVO
//
//  Created by 蒋鹏 on 17/1/18.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JKObjectKVOHandle)(id newValue, id oldValue);

@interface NSObject (KVO)


/**
 Runtime Swizzing Method,建议在+load方法中加上dispatch_once

 @param originalSEL originalSEL
 @param objectSEL objectSEL or customSEL
 @param objectClass objectClass
 */
void JK_ExchangeInstanceMethod(SEL originalSEL, SEL objectSEL, Class objectClass);



- (void)jk_addKVOWithKeyPath:(nonnull NSString *)keyPath handle:(nonnull JKObjectKVOHandle)handle;


@end
NS_ASSUME_NONNULL_END
