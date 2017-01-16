//
//  NSObject+Property.m
//  7.Runtime-Json-Model
//
//  Created by 蒋鹏 on 17/1/16.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

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


@end
