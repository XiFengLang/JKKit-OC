//
//  NSObject+JsonModel.h
//  7.Runtime-Json-Model
//
//  Created by 蒋鹏 on 17/1/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKPropertyObj.h"

@interface NSObject (JsonModel)


//- (NSArray *)declaredInstanceVariables;

- (NSArray <JKPropertyObj *>*)jk_properties;
+ (NSArray <JKPropertyObj *>*)jk_properties;

- (NSDictionary *)jk_dictionary;

+ (instancetype)jk_objectWithDictionary:(NSDictionary *)dict;



@end
