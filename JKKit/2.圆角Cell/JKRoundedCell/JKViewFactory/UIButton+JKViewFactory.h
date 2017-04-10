//
//  UIButton+JKViewFactory.h
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/21.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+JKViewFactory.h"

@interface UIButton (JKViewFactory)


/**
 设置字体

 @param titleFont 字体
 */
- (void)setTitleFont:(UIFont *)titleFont;
- (UIFont *)titleFont;



/**
 添加点击事件的响应者
 
 */
- (void)jk_addTarget:(id)target touchUpInsideAction:(SEL)action;



/**
 【JK-Button】创建普通的标题按钮

 @param frame frame
 @param titleColor 标题颜色
 @param title 标题
 @param target target
 @param action action
 @return 普通的标题按钮
 */
+ (instancetype)jk_buttonWithFrame:(CGRect)frame
                        titleColor:(UIColor *)titleColor
                            target:(id)target
                            action:(SEL)action
                             title:(NSString *)title;



/**
 【JK-Button】创建 ‘无边框’ + ‘富文本’ 按钮

 @param attributedStr 富文本
 @param frame frame
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @return ‘无边框’ + ‘富文本’ 按钮
 */
+ (instancetype)jk_borderlessButtonWithAttributedStr:(NSAttributedString *)attributedStr
                                               frame:(CGRect)frame
                                           fillColor:(UIColor *)fillColor
                                        cornerRadius:(CGFloat)cornerRadius;




/**
 【JK-Button】创建‘带边框’ + ‘富文本’ 按钮

 @param attributedStr 富文本
 @param frame frame
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @param borberWidth 边框宽度
 @param borderColor 边框颜色
 @return  ‘带边框’ + ‘富文本’ 按钮
 */
+ (instancetype)jk_boundedButtonWithAttributedStr:(NSAttributedString *)attributedStr
                                            frame:(CGRect)frame
                                        fillColor:(UIColor *)fillColor
                                     cornerRadius:(CGFloat)cornerRadius
                                      borderWidth:(CGFloat)borberWidth
                                      borderColor:(UIColor *)borderColor;



/**
 【JK-Button】创建‘圆角背景’ + ‘标题’的无边框按钮

 @param frame frame
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @param titleColor 标题颜色
 @param title 标题
 @return 创建‘圆角背景’ + ‘标题’的按钮
 */
+ (instancetype)jk_borderlessButtonWithFrame:(CGRect)frame
                                   fillColor:(UIColor *)fillColor
                                cornerRadius:(CGFloat)cornerRadius
                                  titleColor:(UIColor *)titleColor
                                       title:(NSString *)title;



/**
 【JK-Button】创建‘圆角背景’ + ‘标题’ + ‘带边框’按钮
 
 @param frame frame
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @param borberWidth 边框宽度
 @param borderColor 边框颜色
 @param titleColor 标题颜色
 @param title 标题
 @return ‘圆角背景’ + ‘标题’的带边框按钮
 */
+ (instancetype)jk_boundedButtonWithFrame:(CGRect)frame
                               titleColor:(UIColor *)titleColor
                              borderColor:(UIColor *)borderColor
                                fillColor:(UIColor *)fillColor
                             cornerRadius:(CGFloat)cornerRadius
                              borderWidth:(CGFloat)borberWidth
                                    title:(NSString *)title;



/**
 【JK-Button】绘制带‘小icon’ + ‘带边框’按钮

 @param icon 小图标
 @param iconSize 小图标的大小size
 @param frame frame
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @param borberWidth 边框宽度
 @param borderColor 边框颜色
 @return ‘小icon’+‘带边框’按钮
 */
+ (instancetype)jk_boundedButtonWithIcon:(UIImage *)icon
                                iconSize:(CGSize)iconSize
                                   frame:(CGRect)frame
                               fillColor:(UIColor *)fillColor
                            cornerRadius:(CGFloat)cornerRadius
                             borderWidth:(CGFloat)borberWidth
                             borderColor:(UIColor *)borderColor;







/**
 【JK-Button】绘制带‘小icon’ + ‘无边框’按钮

 @param icon 小图标
 @param iconSize 小图标的大小size
 @param frame frame
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @return 绘制带‘小icon’ + ‘无边框’按钮
 */
+ (instancetype)jk_borderlessButtonWithIcon:(UIImage *)icon
                                 iconSize:(CGSize)iconSize
                                    frame:(CGRect)frame
                                fillColor:(UIColor *)fillColor
                             cornerRadius:(CGFloat)cornerRadius;



/**
 【JK-Button】绘制‘icon’ + ‘富文本’ + ‘无边框’的‘图文混排’按钮

 @param attributedStr 富文本
 @param imageTextModel 图文分布枚举类型
 @param icon 小图标
 @param iconSize 小图标的大小size
 @param frame frame
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @return 绘制‘icon’ + ‘富文本’ + ‘无边框’的‘图文混排’按钮
 */
+ (instancetype)jk_borderlessButtonWithAttributedStr:(NSAttributedString *)attributedStr
                                    imageTextModel:(JKImageTextModel)imageTextModel
                                              icon:(UIImage *)icon
                                          iconSize:(CGSize)iconSize
                                             frame:(CGRect)frame
                                         fillColor:(UIColor *)fillColor
                                      cornerRadius:(CGFloat)cornerRadius;



/**
 【JK-Button】绘制‘icon’ + ‘富文本’ + ‘有边框’的‘图文混排’按钮

 @param attributedStr 富文本
 @param imageTextModel 图文分布枚举类型
 @param icon 小图标
 @param iconSize 小图标的大小size
 @param frame frame
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @param borderColor 边框颜色
 @param borberWidth 边框宽度
 @return 绘制‘icon’ + ‘富文本’ + ‘有边框’的‘图文混排’按钮
 */
+ (instancetype)jk_boundedButtonWithAttributedStr:(NSAttributedString *)attributedStr
                                 imageTextModel:(JKImageTextModel)imageTextModel
                                           icon:(UIImage *)icon
                                       iconSize:(CGSize)iconSize
                                          frame:(CGRect)frame
                                      fillColor:(UIColor *)fillColor
                                   cornerRadius:(CGFloat)cornerRadius
                                    borderColor:(UIColor *)borderColor
                                    borderWidth:(CGFloat)borberWidth;
@end
