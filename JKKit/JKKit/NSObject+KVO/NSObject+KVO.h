//
//  NSObject+KVO.h
//  9.SafeKVO
//
//  Created by 蒋鹏 on 17/1/18.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef    weak
#if __has_feature(objc_arc)
#define weak(object) __weak __typeof__(object) weak##object = object
#else
#define weak(object) autoreleasepool{} __block __typeof__(object) block##object = object
#endif
#endif
#ifndef    strong
#if __has_feature(objc_arc)
#define strong(object) __typeof__(object) object = weak##object
#else
#define strong(object) try{} @finally{} __typeof__(object) object = block##object
#endif
#endif


typedef void(^JKObserverHandle)(id newValue, id oldValue);

@interface NSObject (KVO)


/**
 Runtime Swizzing Method,建议在+load方法中加上dispatch_once

 @param originalSEL originalSEL
 @param objectSEL objectSEL or customSEL
 @param objectClass objectClass
 */
void JK_ExchangeInstanceMethod(SEL originalSEL, SEL objectSEL, Class objectClass);



/**
 添加KVO 监听，建议进行__weak、__strong转换，以免造成循环引用。这是可能存在的引用关系\
    obj(self) --> observerCache --> observer --> block --> obj(self)

 @param keyPath 对应的keyPath
 @param handle 回调Block
 */
- (void)jk_addKVOWithKeyPath:(nonnull NSString *)keyPath handle:(nonnull JKObserverHandle)handle;


/**
 根据keyPath移除相应的KVO监听者,进行__weak、__strong转换的话可以不调用此方法，内部会在对象dealloc的时候调用jk_removeAllObservers

 @param keyPath 对应的KVO keyPath
 */
- (void)jk_removeObserverWithKeyPath:(NSString *)keyPath;



/**
 移除所有的KVO监听者，进行__weak、__strong转换的话可以不调用此方法，内部会在对象dealloc的时候调用
 */
- (void)jk_removeAllObservers;

@end
NS_ASSUME_NONNULL_END
