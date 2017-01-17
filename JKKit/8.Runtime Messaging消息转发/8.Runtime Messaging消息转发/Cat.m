//
//  Cat.m
//  8.Runtime Messaging消息转发
//
//  Created by 蒋鹏 on 17/1/17.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "Cat.h"
#import "Dog.h"

@implementation Cat


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"jump"]) {
        return [[Dog alloc]init];
    }return [super forwardingTargetForSelector:aSelector];
}

@end
