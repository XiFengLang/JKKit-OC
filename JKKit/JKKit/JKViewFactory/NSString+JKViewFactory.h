//
//  NSString+JKViewFactory.h
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static inline NSString * jk_stringWithInt(NSInteger value){
    return [NSString stringWithFormat:@"%zd",value];
}

static inline NSString * jk_stringWithFloat(CGFloat value){
    return [NSString stringWithFormat:@"%f",value];
}

static inline UIFont * JKFontWithSize(CGFloat size){
    return [UIFont systemFontOfSize:size];
}

static inline UIFont * JKFont_Default_15(){
    return JKFontWithSize(15);
}


@interface NSString (JKViewFactory)


/**
 【JK-String-Size】计算文本的宽高
 
 @param font 字体
 @param size 最大的size
 @return CGSize
 */
- (CGSize)jk_sizeWithFont:(UIFont *)font andFitSize:(CGSize)size;



/**
 【JK-String-Size】计算文本的宽高

 @param font 字体
 @param width 最大宽度
 @return 文本的宽高
 */
- (CGSize)jk_sizeWithFont:(UIFont *)font andFitWidth:(CGFloat)width;

@end



@interface NSAttributedString (JKViewFactory)


/**
 【JK-AttributedString】

 @param font 字体
 @param foregroundColor 文字颜色
 @param string 文本
 @return 富文本
 */
+ (instancetype)jk_attributeStringWithFont:(UIFont *)font
                        foregroundColor:(UIColor *)foregroundColor
                                 string:(NSString *)string;


/**
 【JK-AttributedString-Size】计算富文本长宽

 @param size 最大的size
 @return 计算富文本长宽
 */
- (CGSize)jk_sizeForFitSize:(CGSize)size;



/**
 【JK-AttributedString-Size】计算富文本长宽

 @return 计算富文本长宽
 */
- (CGSize)jk_textSize;

@end

