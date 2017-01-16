//
//  JKPropertyObj.m
//  7.Runtime-Json-Model
//
//  Created by 蒋鹏 on 17/1/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKPropertyObj.h"
#import "NSObject+JsonModel.h"
#import "JKFoundationObj.h"

/// MJExtension
static NSString *const JKPropertyTypeInt = @"i";
static NSString *const JKPropertyTypeShort = @"s";
static NSString *const JKPropertyTypeFloat = @"f";
static NSString *const JKPropertyTypeDouble = @"d";
static NSString *const JKPropertyTypeLong = @"l";
static NSString *const JKPropertyTypeLongLong = @"q";
static NSString *const JKPropertyTypeChar = @"c";
static NSString *const JKPropertyTypeBOOL1 = @"c";
static NSString *const JKPropertyTypeBOOL2 = @"b";
static NSString *const JKPropertyTypePointer = @"*";

static NSString *const JKPropertyTypeIvar = @"^{objc_ivar=}";
static NSString *const JKPropertyTypeMethod = @"^{objc_method=}";
static NSString *const JKPropertyTypeBlock = @"@?";
static NSString *const JKPropertyTypeClass = @"#";
static NSString *const JKPropertyTypeSEL = @":";
static NSString *const JKPropertyTypeId = @"@";



@implementation JKPropertyObj




/// http://www.th7.cn/d/file/p/2016/01/27/477393fbb47fc169c9a3433bf168881c.jpg
/// http://www.th7.cn/d/file/p/2016/01/27/431cdd22b40a2cbbd87e34068cdd021a.jpg
+ (instancetype)objWithName:(NSString *)name attributes:(NSString *)attributes {
    return [[self alloc] initWithName:name attributes:attributes];
}


- (instancetype)initWithName:(NSString *)name attributes:(NSString *)attributes {
    if (self = [super init]) {
        _name = name;
        _attributes = attributes;
        
        NSUInteger commaLocation = [attributes rangeOfString:@","].location;
        NSString * codeStr = nil;
        NSUInteger loc = 1;
        if (commaLocation == NSNotFound) {
            codeStr = [attributes substringFromIndex:loc];
        } else {
            codeStr = [attributes substringWithRange:NSMakeRange(loc, commaLocation-1)];
            if ([codeStr hasPrefix:@"^"]) {
                codeStr = [codeStr stringByReplacingOccurrencesOfString:@"^" withString:@""];
            }
        }
        _code = codeStr;
        
        if ([codeStr isEqualToString:JKPropertyTypeId]) {
            _isIdType = YES;
        } else if (codeStr.length == 0) {
            _KVCDisabled = YES;
        } else if (codeStr.length > 3 && [codeStr hasPrefix:@"@\""]) {
            _code = [codeStr componentsSeparatedByString:@"\""][1];
            _classType = NSClassFromString(_code);
            _isFoundationType = [JKFoundationObj isIsFoundationTypeClass:_classType];
            _isNumberType = [_classType isSubclassOfClass:[NSNumber class]];
        } else if ([codeStr isEqualToString:JKPropertyTypeIvar] ||
                   [codeStr isEqualToString:JKPropertyTypeSEL]  ||
                   [codeStr isEqualToString:JKPropertyTypeMethod]||
                   [codeStr isEqualToString:JKPropertyTypeBlock] ||
                   [codeStr isEqualToString:JKPropertyTypeClass]) {
            _KVCDisabled = YES;
        }
        
        NSString * lowerCode = _code.lowercaseString;
        NSArray * numberTypes = @[JKPropertyTypeInt  , JKPropertyTypeShort,
                                  JKPropertyTypeBOOL1, JKPropertyTypeBOOL2,
                                  JKPropertyTypeFloat, JKPropertyTypeDouble,
                                  JKPropertyTypeLong , JKPropertyTypeLongLong,
                                  JKPropertyTypeChar];
        if ([numberTypes containsObject:lowerCode]) {
            _isNumberType = YES;
            
            if ([lowerCode isEqualToString:JKPropertyTypeBOOL1] ||
                [codeStr isEqualToString:JKPropertyTypeBOOL2]) {
                _isBoolType = YES;
            }
        }
        
    }return self;
}


- (id)valueForObj:(id)obj {
    if (self.KVCDisabled) {
        return [NSNull null];
    }
    return [obj valueForKey:self.name];
}


- (void)setValue:(id)value forObj:(id)obj {
    if (self.KVCDisabled) {
        return;
    }
    [obj setValue:value forKey:self.name];
}



@end
