//
//  Dog.m
//  8.Runtime Messaging消息转发
//
//  Created by 蒋鹏 on 17/1/17.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "Dog.h"
#import <objc/runtime.h>

@implementation Dog




+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if ([NSStringFromSelector(sel) isEqualToString:@"jump"]) {
        class_addMethod(self, sel, (IMP)jump, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}


void jump (id self, SEL cmd) {
    NSLog(@"%@ jump",self);
}

@end
