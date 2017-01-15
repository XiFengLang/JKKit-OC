//
//  JKPropertyObj.h
//  7.Runtime-Json-Model
//
//  Created by 蒋鹏 on 17/1/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKPropertyObj : NSObject

@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSString * attributes;
@property (nonatomic, copy, readonly) NSString * code;
@property (nonatomic, readonly) Class classType;
@property (nonatomic, readonly) BOOL KVCDisabled;
@property (nonatomic, readonly) BOOL isNumberType;
@property (nonatomic, readonly) BOOL isIdType;
@property (nonatomic, readonly) BOOL isBoolType;
@property (nonatomic, readonly) BOOL isFoundationType;


- (instancetype)initWithName:(NSString *)name attributes:(NSString *)attributes;
+ (instancetype)objWithName:(NSString *)name attributes:(NSString *)attributes;


- (id)valueForObj:(id)obj;

- (void)setValue:(id)value forObj:(id)obj;

@end
