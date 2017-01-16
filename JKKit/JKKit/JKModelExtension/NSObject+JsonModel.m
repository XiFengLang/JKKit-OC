//
//  NSObject+JsonModel.m
//  7.Runtime-Json-Model
//
//  Created by 蒋鹏 on 17/1/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "NSObject+JsonModel.h"
#import "JKFoundationObj.h"
#import <objc/runtime.h>
#import <CoreData/CoreData.h>


/// 遵守的协议
//    class_copyProtocolList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
/// 方法列表
//    class_copyMethodList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
/// 成员变量列表
//    class_copyIvarList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
/// 属性名列表
//    class_copyPropertyList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)




@implementation NSObject (JsonModel)



static const char * kJKJsonModelPropertiesKey = "kJKJsonModelPropertiesKey";
//static const char * kJKJsonModel

- (NSArray<JKPropertyObj *> *)jk_properties {
    
    NSArray * properties = objc_getAssociatedObject(self, kJKJsonModelPropertiesKey);
    if (nil == properties && 0 == properties.count) {
        properties = [self.class jk_properties];
        objc_setAssociatedObject(self, kJKJsonModelPropertiesKey, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return properties;
}


+ (NSArray <JKPropertyObj *>*)jk_properties {
    if (self == [NSObject class]) {
        return nil;
    }
    NSMutableArray * mutArray = [[NSMutableArray alloc] init];
    NSArray * superClassPropeties = [[self superclass] jk_properties];
    if (superClassPropeties) {
        [mutArray addObjectsFromArray:superClassPropeties];
    }
    
    unsigned int propertiesCount = 0;
    objc_property_t * propertyList = class_copyPropertyList(self.class, &propertiesCount);
    for (NSInteger index = 0; index < propertiesCount; index ++) {
        @autoreleasepool {
            objc_property_t property = propertyList[index];
            const char * propertyCName = property_getName(property);
            const char * propertyCAttributes = property_getAttributes(property);
            
            NSString * propertyOCName = [NSString stringWithUTF8String:propertyCName];
            NSString * propertyOCAttributes = [NSString stringWithUTF8String:propertyCAttributes];
            
            JKPropertyObj * propertyObj = [JKPropertyObj objWithName:propertyOCName attributes:propertyOCAttributes];
            [mutArray addObject:propertyObj];
        }
    }
    free(propertyList);
    return mutArray.copy;
}

- (NSDictionary *)jk_dictionary {
    
    /// 不是自定义的model类，而是写基础数据类型就返回self
    if ([JKFoundationObj isIsFoundationTypeClass:self.class]) {
        return (NSDictionary *)self;
    }
    
    NSMutableDictionary * mutDict = [[NSMutableDictionary alloc] init];
    [self.jk_properties enumerateObjectsUsingBlock:^(JKPropertyObj * _Nonnull propertyObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        /// 可在此处判断被忽略、不允许KVC的属性名
        
        id value = [propertyObj valueForObj:self];
        if (value) {
            
            /// 如果是模型属性
            if (NO == propertyObj.isFoundationType && propertyObj.classType) {
                value = [value jk_dictionary];
                
            /// 数组属性（可能有模型）
            } else if ([value isKindOfClass:[NSArray class]]) {
                value = [NSObject jk_dictionaryArrayWithObjArray:value];
            
            /// 处理NSURL
            } else if (propertyObj.classType == [NSURL class]) {
                value = [value absoluteString];
            }
            
            
            /// 赋值[在此判断被替换名字的属性名]
            [mutDict setObject:value forKey:propertyObj.name];
        }
        
    }];
    return mutDict.copy;
}


/**
 处理model数组

 @param objArray model数组
 @return 字典数组
 */
+ (NSArray *)jk_dictionaryArrayWithObjArray:(NSArray *)objArray {
    NSMutableArray * mutArray = [NSMutableArray array];
    [objArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutArray addObject:[obj jk_dictionary]];
    }];
    return mutArray.copy;
}



+ (NSArray *)jk_objectArrayWithDictionaryArray:(NSArray *)dictArray {
    dictArray = [dictArray jk_JSONObject];
    
    if ([dictArray isKindOfClass:[NSArray class]] == NO) {
        return nil;
    }
    
    NSMutableArray * mutArray = [[NSMutableArray alloc]init];
    [dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [mutArray addObject:[self jk_objectArrayWithDictionaryArray:obj]];
        } else {
            id model = [self jk_objectWithDictionary:obj];
            if (model) [mutArray addObject:model];
        }
    }];
    return mutArray.copy;
}


+ (instancetype)jk_objectWithDictionary:(NSDictionary *)dict {
    return [[[self alloc] init] jk_objectWithDictionary:dict];
}


- (instancetype)jk_objectWithDictionary:(NSDictionary *)dict {
    dict = [dict jk_JSONObject];
    [self.jk_properties enumerateObjectsUsingBlock:^(JKPropertyObj * _Nonnull propertyObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        /// 在此检查是否被忽略
        id value = [propertyObj valueForObj:dict];
        if (nil == value) {
            return ;
        }
        
        
        
        /// 不可变——>可变
        if (propertyObj.classType == [NSMutableArray class] && [value isKindOfClass:[NSArray class]]) {
            value = [NSMutableArray arrayWithArray:value];
        } else if (propertyObj.classType == [NSMutableDictionary class] && [value isKindOfClass:[NSDictionary class]]) {
            value = [NSMutableDictionary dictionaryWithDictionary:value];
        } else if (propertyObj.classType == [NSMutableString class] && [value isKindOfClass:[NSString class]]) {
            value = [NSMutableString stringWithString:value];
        } else if (propertyObj.classType == [NSMutableData class] && [value isKindOfClass:[NSData class]]) {
            value = [NSMutableData dataWithData:value];
        }
        
        /// 模型嵌套模型
        if (!propertyObj.isFoundationType && propertyObj.classType) {
            value = [propertyObj.classType jk_objectWithDictionary:value];
            
            /// 中间可处理特殊类型
        } else {
            if (propertyObj.classType == [NSString class]) {
                if ([value isKindOfClass:[NSNumber class]]) {
                    value = [value description];
                } else if ([value isKindOfClass:[NSURL class]]) {
                    value = [value absoluteString];
                }
            } else if ([value isKindOfClass:[NSString class]]) {
                if (propertyObj.classType == [NSURL class]) {
                    value = [value jk_url];
                } else if (propertyObj.isNumberType) {
                    NSString * oldValue = value;
                    if (propertyObj.classType == [NSDecimalNumber class]) {
                        value = [NSDecimalNumber decimalNumberWithString:oldValue];
                    } else {
                        value = [[[NSNumberFormatter alloc] init] numberFromString:oldValue];
                    }
                    
                    if (propertyObj.isBoolType) {
                        NSString * lower = oldValue.lowercaseString;
                        if ([lower isEqualToString:@"yes"] || [lower isEqualToString:@"true"]) {
                            value = @YES;
                        } else if ([lower isEqualToString:@"no"] || [lower isEqualToString:@"false"]) {
                            value = @NO;
                        }
                    }
                }
            }
        }
        
        /// 赋值
        [propertyObj setValue:value forObj:self];
    }];
    return self;
}


- (NSURL *)jk_url {
    return [NSURL URLWithString:[(NSString *)self URLEncodingString]];
}


- (NSData *)jk_JSONData {
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)self;
    }
    return [NSJSONSerialization dataWithJSONObject:[self jk_JSONObject] options:NSJSONWritingPrettyPrinted error:nil];
}


- (id)jk_JSONObject {
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    } else if ([self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:NSJSONReadingMutableContainers error:nil];
    }
    return self.jk_dictionary;
}

- (NSString *)jk_JSONString {
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    return [[NSString alloc] initWithData:[self jk_JSONData] encoding:NSUTF8StringEncoding];
}


@end


@implementation NSString (JsonModel)

- (NSString *)URLEncodingString {
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < self.length) {
        NSUInteger length = MIN(self.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [self rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [self substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        index += range.length;
    }
    return escaped;
}

@end
