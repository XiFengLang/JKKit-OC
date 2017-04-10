//
//  UIColor+JKViewFactory.m
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "UIColor+JKViewFactory.h"

@implementation UIColor (JKViewFactory)


+ (UIColor *)jk_colorWithHEXString:(NSString *)hexStr{
    //  #ff21af64
    if ([hexStr hasPrefix:@"#"] && hexStr.length == 9) {
        
        NSMutableString * colorString = [self mutableCopy];
        [colorString deleteCharactersInRange:NSMakeRange(0, 1)];
        
        NSString * alphaString = [colorString substringWithRange:NSMakeRange(0, 2)];
        NSString * redString   = [colorString substringWithRange:NSMakeRange(2, 2)];
        NSString * greenString = [colorString substringWithRange:NSMakeRange(4, 2)];
        NSString * blueString  = [colorString substringWithRange:NSMakeRange(6, 2)];
        
        unsigned long red   = strtoul([redString UTF8String], 0, 16);
        unsigned long green = strtoul([greenString UTF8String], 0, 16);
        unsigned long blue  = strtoul([blueString UTF8String], 0, 16);
        unsigned long alpha  = strtoul([alphaString UTF8String], 0, 16);
        
        UIColor * color = [UIColor colorWithRed:(float)red/ 255.0
                                          green:(float)green/ 255.0
                                           blue:(float)blue/ 255.0
                                          alpha:(float)alpha/ 255.0];
        return color;
    } else if ([hexStr hasPrefix:@"#"] && hexStr.length == 7){
        
        NSMutableString * colorString = [self mutableCopy];
        [colorString deleteCharactersInRange:NSMakeRange(0, 1)];
        
        NSString * redString   = [colorString substringWithRange:NSMakeRange(0, 2)];
        NSString * greenString = [colorString substringWithRange:NSMakeRange(2, 2)];
        NSString * blueString  = [colorString substringWithRange:NSMakeRange(4, 2)];
        
        unsigned long red   = strtoul([redString UTF8String], 0, 16);
        unsigned long green = strtoul([greenString UTF8String], 0, 16);
        unsigned long blue  = strtoul([blueString UTF8String], 0, 16);
        
        UIColor * color = [UIColor colorWithRed:(float)red/ 255.0
                                          green:(float)green/ 255.0
                                           blue:(float)blue/ 255.0
                                          alpha:1.0];
        return color;
        
    } else if ([hexStr hasPrefix:@"0x"]) {
        
        unsigned long rgb = strtoul([hexStr UTF8String], 0, 16);
        return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0
                               green:((float)((rgb & 0xFF00) >> 16))/255.0
                                blue:((float)((rgb & 0xFF) >> 16))/255.0
                               alpha:1.0];
    }
    return nil;
}


@end
