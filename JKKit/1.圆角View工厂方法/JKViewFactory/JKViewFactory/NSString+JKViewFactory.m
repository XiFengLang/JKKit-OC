//
//  NSString+JKViewFactory.m
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "NSString+JKViewFactory.h"

@implementation NSString (JKViewFactory)

- (CGSize)jk_sizeWithFont:(UIFont *)font andFitSize:(CGSize)size{
    @autoreleasepool {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 5;
        paragraphStyle.paragraphSpacing = 0;
        NSDictionary * attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
        
        CGSize newSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
        return CGSizeMake(ceil(newSize.width), ceil(newSize.height));
    }
}

- (CGSize)jk_sizeWithFont:(UIFont *)font andFitWidth:(CGFloat)width{
    return [self jk_sizeWithFont:font andFitSize:CGSizeMake(width, MAXFLOAT)];
}

@end


@implementation NSAttributedString (JKViewFactory)

+ (instancetype)jk_attributeStringWithFont:(UIFont *)font
                        foregroundColor:(UIColor *)foregroundColor
                                 string:(NSString *)string{
    @autoreleasepool {
        return [[self alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:foregroundColor,NSFontAttributeName:font}];
    }
}

- (CGSize)jk_sizeForFitSize:(CGSize)size{
    CGSize newSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return CGSizeMake(ceil(newSize.width), ceil(newSize.height));
}

- (CGSize)jk_textSize{
    return [self jk_sizeForFitSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

@end

