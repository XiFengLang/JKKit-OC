//
//  JKFoundationObj.m
//  7.Runtime-Json-Model
//
//  Created by 蒋鹏 on 17/1/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKFoundationObj.h"
#import <CoreData/CoreData.h>

static NSSet * FoundationClasses;


@implementation JKFoundationObj

+ (NSSet *)foundationClasses {
    if (nil == FoundationClasses) {
        FoundationClasses = [NSSet setWithObjects:
                             [NSURL class],
                             [NSData class],
                             [NSValue class],
                             [NSDate class],
                             [NSString class],
                             [NSError class],
                             [NSArray class],
                             [NSDictionary class],
                             [NSAttributedString class], nil];
    }return FoundationClasses;
}


+ (BOOL)isIsFoundationTypeClass:(Class)cls {
    if (cls == [NSObject class] || cls == [NSManagedObject class]) return YES;
    
    __block BOOL ret = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class _Nonnull obj, BOOL * _Nonnull stop) {
        if ([cls isSubclassOfClass:obj]) {
            ret = YES;
            *stop = YES;
        }
    }];
    return ret;
}



@end
