//
//  Bird.m
//  8.Runtime Messaging消息转发
//
//  Created by 蒋鹏 on 17/1/17.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "Bird.h"
#import "Dog.h"

@implementation Bird

/**<
 http://cc.cocimg.com/api/uploads/20151014/1444814548720164.png
 
 1.动态方法解析，在此添加自定义函数方法，替换原来不能响应的选择子
    + (BOOL)resolveInstanceMethod:(SEL)sel
    + (BOOL)resolveClassMethod:(SEL)sel
 
 2.返回备用响应者
    - (id)forwardingTargetForSelector:(SEL)aSelector
 
 3.完整转发
    3.1 返回方法签名描述
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
    
    3.2 再次用备选的响应者 替换换调用目标\
            [anInvocation invokeWithTarget:[Dog new]];
        或者改换选择子,使用备选的选择子
            anInvocation.selector = @selector(fly);\
            [anInvocation invokeWithTarget:self];
 
    - (void)forwardInvocation:(NSInvocation *)anInvocation
 
 */



+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if ([NSStringFromSelector(sel) isEqualToString:@"jump"]) {
//        class_addMethod(self, sel, (IMP)jump, "v@:");
//        return YES;
//    }

    return [super resolveInstanceMethod:sel];//NO
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if ([NSStringFromSelector(aSelector) isEqualToString:@"jump"]) {
//        return [[Dog alloc]init];
//    }
    return [super forwardingTargetForSelector:aSelector];//nil
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"jump"]) {
//        Method method = class_getInstanceMethod(self.class, aSelector);
//        const char * type = method_getTypeEncoding(method);
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];//"v@:"
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    // 改变调用目标
//    [anInvocation invokeWithTarget:[Dog new]];
    
    // 或者改换选择子
    anInvocation.selector = @selector(fly);
    [anInvocation invokeWithTarget:self];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"doesNotRecognizeSelector: %@",NSStringFromSelector(aSelector));
}

- (void)fly {
    NSLog(@"bird fly");
}

@end
