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



/**
 model转字典

 @return 字典
 */
- (NSDictionary *)jk_dictionary;


/**
 model数组转字典数组

 @param objArray model数组
 @return 字典数组
 */
+ (NSArray *)jk_dictionaryArrayWithObjArray:(NSArray *)objArray;




/**
 字典转model

 @param dict 字典
 @return model对象
 */
+ (instancetype)jk_objectWithDictionary:(NSDictionary *)dict;




/**
 字典数组转model数组

 @param dictArray 字典数组
 @return model数组
 */
+ (NSArray *)jk_objectArrayWithDictionaryArray:(NSArray *)dictArray;



/**
 对象转NSData

 @return data
 */
- (NSData *)jk_JSONData;


/**
 对象转数组或者字典

 @return 数组或字典
 */
- (id)jk_JSONObject;


/**
 对象转json字符串

 @return json字符串
 */
- (NSString *)jk_JSONString;
@end



@interface NSString (JsonModel)


/**
 URL编码过的字符串，摘自AFNetworking

 @return URL编码过的字符串
 */
- (NSString *)URLEncodingString;

@end
