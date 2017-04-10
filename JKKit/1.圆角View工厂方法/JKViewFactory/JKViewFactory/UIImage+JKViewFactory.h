//
//  UIImage+JKViewFactory.h
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JKImageTextModel) {
    JKImageTextModelImageLeftTextRight,
    JKImageTextModelImageRightTextLeft,
    JKImageTextModelImageTopTextBottom,
    JKImageTextModelImageBottomTextTop
};


static inline CGFloat JKImageTextMargin(){
    return 10;
}


@interface UIImage (JKViewFactory)


#pragma mark - 使用tintColor重绘图片

/**
 【JK-Image】二次修改Image的颜色，实现类似TintColor的效果
 
 @param tintColor tintColor
 @return 使用tintColor重绘图片
 */
- (UIImage *)jk_imageWithTintColor:(UIColor *)tintColor;




/**
 【JK-Image】二次修改Image的颜色，实现类似TintColor的效果,kCGBlendModeOverlay灰阶色、kCGBlendModeDestinationIn彩色
 
 @param tintColor tintColor
 @param blendModel kCGBlendModeOverlay灰阶色、kCGBlendModeDestinationIn彩色
 @return 使用tintColor重绘图片
 */
- (UIImage *)jk_imageWithTintColor:(UIColor *)tintColor
                        blendModel:(CGBlendMode)blendModel;




#pragma mark - 给图片倒圆角



/**
 【JK-Image】居中裁切圆形图片，可设置边框效果
 
 @param image 原图
 @param size 目标大小
 @param cornerRadius 圆角半径
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return 居中裁切圆形图片
 */
+ (UIImage *)jk_roundingImage:(UIImage *)image
                         size:(CGSize)size
                  borderWidth:(CGFloat)borderWidth
                 cornerRadius:(CGFloat)cornerRadius
                  borderColor:(UIColor *)borderColor;




/**
 【JK-Image】居中裁切圆形图片
 
 @param image 原图
 @param size 裁剪后的大小
 @return 裁切圆形图片
 */
+ (UIImage *)jk_roundingImage:(UIImage *)image
                         size:(CGSize)size;





/**
 【JK-Image】裁剪后的圆形图片
 
 @return 裁剪后的圆形图片
 */
- (UIImage *)jk_roundedImage;



/**
 【JK-Image】裁剪图片的像素
 
 @param image 原图
 @param size 裁剪后的大小
 @return 裁剪图片
 */
+ (UIImage *)jk_resizeImage:(UIImage *)image targetSize:(CGSize)size;


#pragma mark - 使用颜色绘制图片

/**
 【JK-Image】用颜色创建‘无边框’+‘圆角’图片，cornerRadius=0时则为矩形
 
 @param size size
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @return ‘无边框’+‘圆角’图片，cornerRadius=0时则为矩形
 */
+ (UIImage *)jk_borderlessImageWithFillColor:(UIColor *)fillColor
                                        size:(CGSize)size
                                cornerRadius:(CGFloat)cornerRadius;



/**
 【JK-Image】用颜色创建‘带边框’+‘圆角’图片，cornerRadius=0时则为矩形
 
 @param size size
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @return ‘带边框’+‘圆角’图片，cornerRadius=0时则为矩形
 */
+ (UIImage *)jk_boundedImageWithFillColor:(UIColor *)fillColor
                              borderColor:(UIColor *)borderColor
                              borderWidth:(CGFloat)borderWidth
                                     size:(CGSize)size
                             cornerRadius:(CGFloat)cornerRadius;



#pragma mark - 使用颜色+icon绘制图片


/**
 【JK-Image】用背景色绘制‘带icon’+‘无边框’+‘圆角’底图，icon居中
 
 @param size size
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @param icon icon图片
 @param iconSize icon的size
 @return ‘icon’居中显示+‘无边框’+‘圆角’图片
 */
+ (UIImage *)jk_borderlessImageWithIcon:(UIImage *)icon
                              fillColor:(UIColor *)fillColor
                               iconSize:(CGSize)iconSize
                                   size:(CGSize)size
                           cornerRadius:(CGFloat)cornerRadius;




/**
 【JK-Image】用背景色绘制‘带icon’+‘带边框’+‘圆角’底图，icon居中
 
 @param size size
 @param fillColor 背景色
 @param cornerRadius 圆角半径
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param icon icon图片
 @param iconSize icon的size
 @return ‘icon’居中显示+‘带边框’+‘圆角’图片
 */
+ (UIImage *)jk_boundedImageWithIcon:(UIImage *)icon
                         borderColor:(UIColor *)borderColor
                           fillColor:(UIColor *)fillColor
                         borderWidth:(CGFloat)borderWidth
                            iconSize:(CGSize)iconSize
                                size:(CGSize)size
                        cornerRadius:(CGFloat)cornerRadius;



#pragma mark - 使用颜色+文字绘制图片

/**
 【JK-Image】绘制‘无边框’+‘带文字’的图片
 
 @param fillColor 背景色
 @param size size
 @param cornerRadius 圆角半径
 @param textColor 文字颜色
 @param font 文字字体
 @param text 文字
 @return ‘无边框’带文字的图片
 */
+ (UIImage *)jk_borderlessImageWithTextColor:(UIColor *)textColor
                                   fillColor:(UIColor *)fillColor
                                        size:(CGSize)size
                                cornerRadius:(CGFloat)cornerRadius
                                        font:(UIFont *)font
                                        text:(NSString *)text;



/**
 【JK-Image】绘制‘带边框’+‘带文字’的图片
 
 @param fillColor 背景色
 @param size size
 @param cornerRadius 圆角半径
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param textColor 文字颜色
 @param font 文字字体
 @param text 文字
 @return ‘带边框’+‘带文字’的图片
 */
+ (UIImage *)jk_boundedImageWithTextColor:(UIColor *)textColor
                              borderColor:(UIColor *)borderColor
                                fillColor:(UIColor *)fillColor
                                     size:(CGSize)size
                             cornerRadius:(CGFloat)cornerRadius
                              borderWidth:(CGFloat)borderWidth
                                     font:(UIFont *)font
                                     text:(NSString *)text;



/**
 【JK-Image】使用富文本绘制‘无边框’+‘富文本’的图片
 
 @param fillColor 背景色
 @param size size
 @param cornerRadius 圆角半径
 @param attributedStr 富文本
 @return ‘无边框’+‘富文本’的图片
 */
+ (UIImage *)jk_borderlessImageWithAttributedStr:(NSAttributedString *)attributedStr
                                       fillColor:(UIColor *)fillColor
                                            size:(CGSize)size
                                    cornerRadius:(CGFloat)cornerRadius;




/**
 【JK-Image】使用富文本绘制‘有边框’+‘富文本’的图片
 
 @param fillColor 背景色
 @param size size
 @param cornerRadius 圆角半径
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param attributedStr 富文本
 @return ‘有边框’+‘富文本’的图片
 */
+ (UIImage *)jk_boundedImageWithAttributedStr:(NSAttributedString *)attributedStr
                                  borderColor:(UIColor *)borderColor
                                    fillColor:(UIColor *)fillColor
                                         size:(CGSize)size
                                 cornerRadius:(CGFloat)cornerRadius
                                  borderWidth:(CGFloat)borderWidth;



#pragma mark - 绘制图文混排的图片


/**
 【JK-Image】使用富文本和icon 绘制'图文混排'+‘无边框’的图片

 @param fillColor 背景色
 @param size 绘制的图片大小
 @param cornerRadius 圆角半径
 @param imageModel 图文混排类型，参考“JKImageTextModel”
 @param icon 小图标
 @param iconSize icon大小
 @param attributedStr 富文本
 @return '图文混排'+‘无边框’的图片
 */
+ (UIImage *)jk_borderlessImageWithAttributedStr:(NSAttributedString *)attributedStr
                                            icon:(UIImage *)icon
                                       fillColor:(UIColor *)fillColor
                                            size:(CGSize)size
                                    cornerRadius:(CGFloat)cornerRadius
                                      imageModel:(JKImageTextModel)imageModel
                                        iconSize:(CGSize)iconSize;



/**
 JK-Image】使用富文本和icon 绘制'图文混排'+‘带边框’的图片

 @param fillColor 背景色
 @param size 绘制的图片大小
 @param cornerRadius 圆角半径
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param imageModel 图文混排类型，参考“JKImageTextModel”
 @param icon 图标
 @param iconSize 图标大小
 @param attributedStr 富文本
 @return '图文混排'+‘带边框’的图片
 */
+ (UIImage *)jk_boundedImageWithAttributedStr:(NSAttributedString *)attributedStr
                                         icon:(UIImage *)icon
                                  borderColor:(UIColor *)borderColor
                                    fillColor:(UIColor *)fillColor
                                         size:(CGSize)size
                                 cornerRadius:(CGFloat)cornerRadius
                                  borderWidth:(CGFloat)borderWidth
                                   imageModel:(JKImageTextModel)imageModel
                                     iconSize:(CGSize)iconSize;

@end
