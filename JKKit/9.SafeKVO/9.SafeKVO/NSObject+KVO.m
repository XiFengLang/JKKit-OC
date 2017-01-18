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

@interface JKPrivateKVOObserver : NSObject

@property (nonatomic, copy) JKObjectKVOHandle kvoHandle;

- (JKPrivateKVOObserver *)initWithKVOHandle:(JKObjectKVOHandle)handle;

@end

@implementation JKPrivateKVOObserver



- (JKPrivateKVOObserver *)initWithKVOHandle:(JKObjectKVOHandle)handle {
    if (self = [super init]) {
        _kvoHandle = handle;
    }return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (nil == self.kvoHandle) {
        return;
    }
    
    id oldValue = change[NSKeyValueChangeOldKey];
    id newValue = change[NSKeyValueChangeNewKey];
    
    if (![newValue isEqual:oldValue]) {
        if (self.kvoHandle) {
            self.kvoHandle(newValue, oldValue);
        }
    }
}


//- (void)dealloc {
//    NSLog(@"%@ 已释放",self.class);
//}

@end



/*---------------------------------------------------------------------------------------------
                                            传说中的分割线
 --------------------------------------------------------------------------------------------*/
static NSMutableDictionary * StaticDict = nil;
static inline NSMutableDictionary * JKRuntimeSwizzingCachePool() {
    if (nil == StaticDict) {
        StaticDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    }return StaticDict;
}


@implementation NSObject (KVO)


#pragma mark - Custom (Inline) Function




//static const char * kStaticSerialQueueKey = "kStaticSerialQueueKey";
//static dispatch_queue_t StaticQueue = nil;
//static inline dispatch_queue_t JKStaticSerialQueue() {
//    if (nil == StaticQueue) {
//        StaticQueue = dispatch_queue_create(kStaticSerialQueueKey, DISPATCH_QUEUE_SERIAL);
//    }return StaticQueue;
//}


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

#pragma mark - Runtime Swizzing


- (void)jk_runtimeSwizzingMethod {
    NSString * className = NSStringFromClass(self.class);
    if (nil == [JKRuntimeSwizzingCachePool() objectForKey:className]) {
        NSString * deallocSel = @"dealloc";
        NSString * customDeallocSel = @"jk_objectWillDealloc";
        JK_ExchangeInstanceMethod(NSSelectorFromString(deallocSel), NSSelectorFromString(customDeallocSel), self.class);
        [JKRuntimeSwizzingCachePool() setObject:@(YES) forKey:className];
    }
}


- (void)jk_objectWillDealloc {
    [self jk_removeAllObservers];
    
    [self jk_objectWillDealloc];
}


#pragma mark - KVO


- (void)jk_addKVOWithKeyPath:(NSString *)keyPath handle:(JKObjectKVOHandle)handle {
    if (nil == keyPath || 0 == keyPath.length) {
        return;
    } else if ([[self observerCacheDict] objectForKey:keyPath]) {
        return;
    }
    
    [self jk_runtimeSwizzingMethod];
    
    JKPrivateKVOObserver * observer = [[JKPrivateKVOObserver alloc] initWithKVOHandle:handle];
    [[self observerCacheDict] setObject:observer forKey:keyPath];
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}


- (void)jk_removeKVOWithKeyPath:(NSString *)keyPath {
    if (nil == keyPath || 0 == keyPath.length) {
        return;
    } else if ([[self observerCacheDict] objectForKey:keyPath]) {
        return;
    }

    JKPrivateKVOObserver * observer = [[self observerCacheDict] objectForKey:keyPath];
    [self removeObserver:observer forKeyPath:keyPath];
    observer.kvoHandle = nil;
    [[self observerCacheDict] removeObjectForKey:keyPath];
}


- (void)jk_removeAllObservers {
    [[self observerCacheDict] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, JKPrivateKVOObserver * _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:key];
    }];
    [self clearObserverCache];
}


#pragma mark - ObserverCache

static const char * kJKObserverCacheDictKey = "kJKObserverCacheDictKey";
- (NSMutableDictionary <NSString *, JKPrivateKVOObserver * >*)observerCacheDict {
    NSMutableDictionary <NSString *, JKPrivateKVOObserver * >* cacheDict = objc_getAssociatedObject(self, kJKObserverCacheDictKey);
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
