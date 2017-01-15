//
//  JKFoundationObj.h
//  7.Runtime-Json-Model
//
//  Created by 蒋鹏 on 17/1/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKFoundationObj : NSObject


/**
 判断是不是基础数据类型

 @param cls class
 @return bool
 */
+ (BOOL)isIsFoundationTypeClass:(Class)cls;

@end
