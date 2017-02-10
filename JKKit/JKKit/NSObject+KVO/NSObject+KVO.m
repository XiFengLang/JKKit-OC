//
//  NSObject+KVO.m
//  9.SafeKVO
//
//  Created by 蒋鹏 on 17/1/18.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>


#pragma mark - PrivateKVOObserver



/**
 桥梁对象，真实的监听者。
 */
@interface JKPrivateObserver : NSObject

@property (nonatomic, copy) JKObserverHandle observerHandle;

- (JKPrivateObserver *)initWithKVOHandle:(JKObserverHandle)handle;

@end

@implementation JKPrivateObserver



- (JKPrivateObserver *)initWithKVOHandle:(JKObserverHandle)handle {
    if (self = [super init]) {
        _observerHandle = handle;
    }return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (nil == self.observerHandle) {
        return;
    }
    
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    
    if (![newValue isEqual:oldValue]) {
        if (self.observerHandle) {
            self.observerHandle(newValue, oldValue);
        }
    }
}


@end



/*---------------------------------------------------------------------------------------------
                                            传说中的分割线
 --------------------------------------------------------------------------------------------*/

/// 用来缓存已进行runtime swizzling的类，防止重复swizzling
static NSMutableDictionary * StaticDict = nil;
static inline NSMutableDictionary * JKRuntimeSwizzingCachePool() {
    if (nil == StaticDict) {
        StaticDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    }return StaticDict;
}


@implementation NSObject (KVO)



/// Runtime Swizzing Method

#if !__has_include("NSObejct+Swizzling.h")

void JK_ExchangeInstanceMethod(SEL originalSEL, SEL objectSEL, Class objectClass) {
    Method originalMethod = class_getInstanceMethod(objectClass, originalSEL);
    Method replaceMethod = class_getInstanceMethod(objectClass, objectSEL);
    
    if (originalMethod == NULL || replaceMethod == NULL) {
        NSLog(@"\n.\tWarning! JK_ExchangeInstanceMethod 失败!  [%@及其SuperClasses] 均未实现方法 [%@]\n.",objectClass,originalMethod == NULL ? NSStringFromSelector(originalSEL) : NSStringFromSelector(objectSEL));
        return;
    }
    BOOL add = class_addMethod(objectClass, originalSEL, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
    
    if (add) {
        class_replaceMethod(objectClass, objectSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, replaceMethod);
    }
}

#endif

#pragma mark - Runtime Swizzing


/**
 runtime swizzling，监听当前类的dealloc方法，完了就存入缓存池，防止重复swizzling
 */
- (void)jk_runtimeSwizzingMethod {
    NSString * className = NSStringFromClass(self.class);
    
    if (nil == [JKRuntimeSwizzingCachePool() objectForKey:className]) {
        NSString * deallocSel = @"dealloc";
        NSString * customDeallocSel = @"jk_objectWillDealloc";
        JK_ExchangeInstanceMethod(NSSelectorFromString(deallocSel), NSSelectorFromString(customDeallocSel), self.class);
        [JKRuntimeSwizzingCachePool() setObject:@(YES) forKey:className];
    }
}

/// 移除所有的KVO
- (void)jk_objectWillDealloc {
    [self jk_removeAllObservers];
    [self jk_objectWillDealloc];
}


#pragma mark - KVO


- (void)jk_addKVOWithKeyPath:(NSString *)keyPath handle:(JKObserverHandle)handle {
    if (nil == keyPath || 0 == keyPath.length) {
        return;
    } else if ([[self observerCacheDict] objectForKey:keyPath]) {
        return;
    }
    /// 先用runtime监听dealloc方法
    [self jk_runtimeSwizzingMethod];
    
    /// 使用内部监听者进行KVO
    JKPrivateObserver * observer = [[JKPrivateObserver alloc] initWithKVOHandle:handle];
    [[self observerCacheDict] setObject:observer forKey:keyPath];
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}


- (void)jk_removeObserverWithKeyPath:(NSString *)keyPath {
    if (nil == keyPath || 0 == keyPath.length) {
        return;
    } else if (nil == objc_getAssociatedObject(self, kJKObserverCacheDictKey) ||
               nil == [[self observerCacheDict] objectForKey:keyPath]) {
        return;
    }

    JKPrivateObserver * observer = [[self observerCacheDict] objectForKey:keyPath];
    [self removeObserver:observer forKeyPath:keyPath];
    observer.observerHandle = nil;
    [[self observerCacheDict] removeObjectForKey:keyPath];
    
    if ([self observerCacheDict].count == 0) {
        [self clearObserverCache];
    }
}


- (void)jk_removeAllObservers {
    if (objc_getAssociatedObject(self, kJKObserverCacheDictKey)) {
        [[self observerCacheDict] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, JKPrivateObserver * _Nonnull obj, BOOL * _Nonnull stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
        [self clearObserverCache];
    }
}


#pragma mark - ObserverCache监听者缓存队列

static const char * kJKObserverCacheDictKey = "kJKObserverCacheDictKey";
- (NSMutableDictionary <NSString *, JKPrivateObserver * >*)observerCacheDict {
    NSMutableDictionary <NSString *, JKPrivateObserver * >* cacheDict = objc_getAssociatedObject(self, kJKObserverCacheDictKey);
    if (nil == cacheDict) {
        cacheDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        objc_setAssociatedObject(self, kJKObserverCacheDictKey, cacheDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cacheDict;
}

- (void)clearObserverCache {
    [[self observerCacheDict] removeAllObjects];
    objc_setAssociatedObject(self, kJKObserverCacheDictKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
