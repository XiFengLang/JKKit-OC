//
//  NSObject+Property.h
//  7.Runtime-Json-Model
//
//  Created by 蒋鹏 on 17/1/16.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPropertyObj.h"


@interface NSObject (Property)


/**
 所有的成员变量

 @return 成员变量数组
 */
- (NSArray *)jk_declaredInstanceVariables;


/**
 所有的属性列表
 
 @return JKPropertyObj数组
 */
- (NSArray <JKPropertyObj *>*)jk_properties;





/**
 所有的属性列表
 
 @return JKPropertyObj数组
 */
+ (NSArray <JKPropertyObj *>*)jk_properties;




@end
