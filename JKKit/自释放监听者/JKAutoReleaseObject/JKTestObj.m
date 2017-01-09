//
//  JKTestObj.m
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/9.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKTestObj.h"

@implementation JKTestObj

- (void)dealloc {
    NSLog(@"%@ 已释放",self.class);
}


- (void)testSEL {
    NSLog(@"已执行 testSEL");
}

@end
