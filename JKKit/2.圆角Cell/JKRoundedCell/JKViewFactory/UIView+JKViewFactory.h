//
//  UIView+JKViewFactory.h
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CGRect.h"


@interface UIView (JKViewFactory)


/**
 【JK-View】创建View,默认白色的背景颜色
 
 @param frame frame
 @return 白色view
 */
+ (instancetype)jk_viewWithFrame:(CGRect)frame;



/**
 【JK-View】创建View
 
 @param frame frame
 @param bgColor 背景颜色
 @return View
 */
+ (instancetype)jk_viewWithFrame:(CGRect)frame
                 backgroundColor:(UIColor *)bgColor;



/**
 【JK-View】创建无边框圆角化的View
 
 @param frame frame
 @param cornerRadius 圆角半径
 @param bgColor 背景颜色
 @return 圆角化的View
 */
+ (instancetype)jk_roundedViewWithFrame:(CGRect)frame
                            cornrRadius:(CGFloat)cornerRadius
                        backgroundColor:(UIColor *)bgColor;



/**
 【JK-View】创建带边框圆角化的View
 
 @param frame frame
 @param cornerRadius 圆角半径
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @param bgColor 背景颜色
 @return 带边框圆角化的View
 */
+ (instancetype)jk_roundedViewWithFrame:(CGRect)frame
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
                            cornrRadius:(CGFloat)cornerRadius
                        backgroundColor:(UIColor *)bgColor;


/**
 【JK-View】对View进行圆角化操作
 
 @param cornerRadius 圆角半径
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 */
- (void)jk_radiusingWithCornrRadius:(CGFloat)cornerRadius
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor;



/**
 【JK-View】在view.layer的底部添加线条,高度为1，线条的颜色默认 RGB(209, 200, 209)
 
 @param horizontalMargin 水平边距
 @return layer
 */
- (CALayer *)jk_addBottomLineWithHorizontalMargin:(CGFloat)horizontalMargin;


/**
 【JK-View】在view.layer的底部添加线条，和view等宽,高度为1，线条的颜色默认 RGB(209, 200, 209)
 
 @return layer
 */
- (CALayer *)jk_addBottomLine;


/**
 【JK-View】在view.layer的顶部添加线条,高度为1，线条的颜色默认 RGB(209, 200, 209)
 
 @param horizontalMargin 水平边距
 @return layer
 */
- (CALayer *)jk_addTopLineWithHorizontalMargin:(CGFloat)horizontalMargin;


/**
 【JK-View】在view.layer的底部添加线条，和view等宽,高度为1，线条的颜色默认 RGB(209, 200, 209)
 
 @return layer
 */
- (CALayer *)jk_addTopLine;
@end


@interface UILabel (JKViewFactory)

/**
 【JK-Label】单行左对齐的Label
 
 @param frame frame
 @param textColor 字体颜色
 @param fontSize 字体大小
 @param text text
 @return 单行左对齐的Label
 */
+ (instancetype)jk_labelWithFrame:(CGRect)frame
                        textColor:(UIColor *)textColor
                         fontSize:(CGFloat)fontSize
                             text:(NSString *)text;



/**
 【JK-Label】单行左对齐的Label,默认黑色字体
 
 @param frame frame
 @param fontSize 字体大小
 @param text text
 @return 单行左对齐的Label
 */
+ (instancetype)jk_labelWithFrame:(CGRect)frame
                         fontSize:(CGFloat)fontSize
                             text:(NSString *)text;




/**
 【JK-Label】自适应大小、居中对齐、自动换行的Label
 
 @param origin X.Y坐标
 @param fontSize 字体大小
 @param width 文本的最大宽度
 @param text 文本
 @return 自适应大小、居中对齐、自动换行的Label
 */
+ (instancetype)jk_adaptiveLabelWithOrigin:(CGPoint)origin
                                  fontSize:(CGFloat)fontSize
                               andFitWidth:(CGFloat)width
                                      text:(NSString *)text;



/**
 【JK-Label】自动换行的富文本label
 
 @param attributeds 富文本
 @param frame frame
 @return 富文本label
 */
+ (instancetype)jk_labelWithAttributeds:(NSAttributedString *)attributeds
                                  frame:(CGRect)frame;



/**
 【JK-Label】自动计算frame的富文本label
 
 @param attributeds 富文本
 @param origin x.y坐标
 @return 自动计算frame的富文本label
 */
+ (instancetype)jk_adaptiveLabelWithAttributeds:(NSAttributedString *)attributeds
                                         origin:(CGPoint)origin;

@end




@interface UIImageView (JKViewFactory)


/**
 【JK-ImageView】创建白色ImageView
 
 @param frame frame
 @param image image
 @return ImageView
 */
+ (instancetype)jk_imageViewWithFrame:(CGRect)frame
                                image:(UIImage *)image;

@end



@interface UITextField (JKViewFactory)


/**
 【JK-TextField】创建Textfield
 
 @param frame frame
 @param leftImage leftImage 图标
 @param placeholder 占位符
 @return Textfield
 */
+ (UITextField *)jk_textFieldWithFrame:(CGRect)frame
                             leftImage:(UIImage *)leftImage
                           placeholder:(NSString *)placeholder;

@end
