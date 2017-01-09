//
//  UIImage+JKViewFactory.m
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "UIImage+JKViewFactory.h"
#import "UIBezierPath+JKViewFactory.h"
#import "NSString+JKViewFactory.h"
#import "UIView+JKViewFactory.h"
#import "UIColor+JKViewFactory.h"

@implementation UIImage (JKViewFactory)

UIImage * JKGraphicsImageContext(CGSize size,void(^block)()){
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(size, false, JKScreenScale());
        block();
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}



- (UIImage *)jk_imageWithTintColor:(UIColor *)tintColor{
    return [self jk_imageWithTintColor:tintColor blendModel:kCGBlendModeDestinationIn];
}

- (UIImage *)jk_imageWithTintColor:(UIColor *)tintColor blendModel:(CGBlendMode)blendModel{
    return JKGraphicsImageContext(self.size, ^{
        [tintColor setFill];
        CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
        UIRectFill(bounds);
        
        [self drawInRect:bounds blendMode:blendModel alpha:1.0];
        
        if (blendModel != kCGBlendModeDestinationIn) {
            [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
        }
    });
}


#pragma mark - 给图片倒圆角

+ (UIImage *)jk_roundingImage:(UIImage *)image
                         size:(CGSize)size
                  borderWidth:(CGFloat)borderWidth
                 cornerRadius:(CGFloat)cornerRadius
                  borderColor:(UIColor *)borderColor{
    return JKGraphicsImageContext(size, ^{
        
        [borderColor ? : JKClearColor() setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_borderlessPathWithSize:size cornerRadius:cornerRadius];
        /// 裁剪后面绘制的画布内容  fill是填充
        [bezierPath addClip];
        
        /// 居中剪切
        CGFloat minWH = MIN(size.height, size.width);
        CGFloat imageWH = minWH - 2 * borderWidth;
        CGRect imageFrame = CGRectMake((size.width - imageWH) /2.0, (size.height - imageWH) /2.0, imageWH, imageWH);
        [image drawInRect:imageFrame];
    });
}

+ (UIImage *)jk_roundingImage:(UIImage *)image size:(CGSize)size{
    return [self jk_roundingImage:image size:size borderWidth:0 cornerRadius:MIN(size.height, size.width) / 2.0 borderColor:nil];
}


- (UIImage *)jk_roundedImage{
    return [UIImage jk_roundingImage:self size:self.size];
}



+ (UIImage *)jk_resizeImage:(UIImage *)image targetSize:(CGSize)size{
    return JKGraphicsImageContext(size, ^{
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    });
}

#pragma mark - 使用颜色+文字/icon绘制图片



+ (UIImage *)jk_borderlessImageWithFillColor:(UIColor *)fillColor
                                        size:(CGSize)size
                                cornerRadius:(CGFloat)cornerRadius{
    
    return JKGraphicsImageContext(size, ^{
        [fillColor setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_borderlessPathWithSize:size cornerRadius:cornerRadius];
        [bezierPath fill];
    });
}


+ (UIImage *)jk_boundedImageWithFillColor:(UIColor *)fillColor
                              borderColor:(UIColor *)borderColor
                              borderWidth:(CGFloat)borderWidth
                                     size:(CGSize)size
                             cornerRadius:(CGFloat)cornerRadius {
    return JKGraphicsImageContext(size, ^{
        [fillColor setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_boundedPathWithSize:size borderWidth:borderWidth cornerRadius:cornerRadius];
        [bezierPath fill];
        [borderColor setStroke];
        [bezierPath stroke];
    });
}


+ (UIImage *)jk_borderlessImageWithIcon:(UIImage *)icon
                              fillColor:(UIColor *)fillColor
                               iconSize:(CGSize)iconSize
                                   size:(CGSize)size
                           cornerRadius:(CGFloat)cornerRadius{
    
    return JKGraphicsImageContext(size, ^{
        [fillColor setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_borderlessPathWithSize:size cornerRadius:cornerRadius];
        [bezierPath fill];
        
        if (icon) {
            CGRect iconFrame = CGRectMake((size.width - iconSize.width) / 2.0, (size.height - iconSize.height) / 2.0, iconSize.width, iconSize.height);
            [icon drawInRect:iconFrame];
        }
    });
}


+ (UIImage *)jk_boundedImageWithIcon:(UIImage *)icon
                         borderColor:(UIColor *)borderColor
                           fillColor:(UIColor *)fillColor
                         borderWidth:(CGFloat)borderWidth
                            iconSize:(CGSize)iconSize
                                size:(CGSize)size
                        cornerRadius:(CGFloat)cornerRadius {
    return JKGraphicsImageContext(size, ^{
        [fillColor setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_boundedPathWithSize:size borderWidth:borderWidth cornerRadius:cornerRadius];
        [bezierPath fill];
        [borderColor setStroke];
        [bezierPath stroke];
        
        if (icon) {
            CGRect iconFrame = CGRectMake((size.width - iconSize.width) / 2.0, (size.height - iconSize.height) / 2.0, iconSize.width, iconSize.height);
            [icon drawInRect:iconFrame];
        }
    });
}


+ (UIImage *)jk_borderlessImageWithTextColor:(UIColor *)textColor
                                   fillColor:(UIColor *)fillColor
                                        size:(CGSize)size
                                cornerRadius:(CGFloat)cornerRadius
                                        font:(UIFont *)font
                                        text:(NSString *)text{
    
    return JKGraphicsImageContext(size, ^{
        [fillColor setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_borderlessPathWithSize:size cornerRadius:cornerRadius];
        [bezierPath fill];
        
        
        NSAttributedString * attributedStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        CGSize textSize = attributedStr.jk_textSize;
        CGRect textFrame = CGRectMake((size.width - textSize.width) / 2.0, (size.height - textSize.height) / 2.0, textSize.width, textSize.height);
        [attributedStr drawInRect:textFrame];
    });
}


+ (UIImage *)jk_boundedImageWithTextColor:(UIColor *)textColor
                              borderColor:(UIColor *)borderColor
                                fillColor:(UIColor *)fillColor
                                     size:(CGSize)size
                             cornerRadius:(CGFloat)cornerRadius
                              borderWidth:(CGFloat)borderWidth
                                     font:(UIFont *)font
                                     text:(NSString *)text{
    
    return JKGraphicsImageContext(size, ^{
        [fillColor setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_boundedPathWithSize:size borderWidth:borderWidth cornerRadius:cornerRadius];
        [bezierPath fill];
        [borderColor setStroke];
        [bezierPath stroke];
        
        
        NSAttributedString * attributedStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:textColor}];
        CGSize textSize = attributedStr.jk_textSize;
        CGRect textFrame = CGRectMake((size.width - textSize.width) / 2.0, (size.height - textSize.height) / 2.0, textSize.width, textSize.height);
        [attributedStr drawInRect:textFrame];
    });
}




+ (UIImage *)jk_borderlessImageWithAttributedStr:(NSAttributedString *)attributedStr
                                       fillColor:(UIColor *)fillColor
                                            size:(CGSize)size
                                    cornerRadius:(CGFloat)cornerRadius{
    
    return JKGraphicsImageContext(size, ^{
        [fillColor setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_borderlessPathWithSize:size cornerRadius:cornerRadius];
        [bezierPath fill];
        
        CGSize textSize = attributedStr.jk_textSize;
        CGRect textFrame = CGRectMake((size.width - textSize.width) / 2.0, (size.height - textSize.height) / 2.0, textSize.width, textSize.height);
        [attributedStr drawInRect:textFrame];
    });
}


+ (UIImage *)jk_boundedImageWithAttributedStr:(NSAttributedString *)attributedStr
                                  borderColor:(UIColor *)borderColor
                                    fillColor:(UIColor *)fillColor
                                         size:(CGSize)size
                                 cornerRadius:(CGFloat)cornerRadius
                                  borderWidth:(CGFloat)borderWidth {
    
    return JKGraphicsImageContext(size, ^{
        [fillColor setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_boundedPathWithSize:size borderWidth:borderWidth cornerRadius:cornerRadius];
        [bezierPath fill];
        [borderColor setStroke];
        [bezierPath stroke];
        
        
        CGSize textSize = attributedStr.jk_textSize;
        CGRect textFrame = CGRectMake((size.width - textSize.width) / 2.0, (size.height - textSize.height) / 2.0, textSize.width, textSize.height);
        [attributedStr drawInRect:textFrame];
    });
}



#pragma mark - 绘制图文混排的图片


+ (UIImage *)jk_borderlessImageWithAttributedStr:(NSAttributedString *)attributedStr
                                            icon:(UIImage *)icon
                                       fillColor:(UIColor *)fillColor
                                            size:(CGSize)size
                                    cornerRadius:(CGFloat)cornerRadius
                                      imageModel:(JKImageTextModel)imageModel
                                        iconSize:(CGSize)iconSize {
    return [self jk_boundedImageWithAttributedStr:attributedStr
                                             icon:icon
                                      borderColor:nil
                                        fillColor:fillColor
                                             size:size
                                     cornerRadius:cornerRadius
                                      borderWidth:0.0f
                                       imageModel:imageModel
                                         iconSize:iconSize];
}


+ (UIImage *)jk_boundedImageWithAttributedStr:(NSAttributedString *)attributedStr
                                         icon:(UIImage *)icon
                                  borderColor:(UIColor *)borderColor
                                    fillColor:(UIColor *)fillColor
                                         size:(CGSize)size
                                 cornerRadius:(CGFloat)cornerRadius
                                  borderWidth:(CGFloat)borderWidth
                                   imageModel:(JKImageTextModel)imageModel
                                     iconSize:(CGSize)iconSize {
    return JKGraphicsImageContext(size, ^{
        [fillColor setFill];
        UIBezierPath * bezierPath = [UIBezierPath jk_boundedPathWithSize:size borderWidth:borderWidth cornerRadius:cornerRadius];
        [bezierPath fill];
        
        if (borderWidth > 0.0f && borderColor) {
            [borderColor setStroke];
            [bezierPath stroke];
        }
        CGSize textSize = CGSizeZero;
        CGFloat iconMinX = 0.0f;
        CGFloat iconMinY = 0.0f;
        CGRect iconFrame = CGRectZero;
        CGRect textFrame = CGRectZero;
        
        switch (imageModel) {
                /// 左图右文
            case JKImageTextModelImageLeftTextRight:{
                textSize = [attributedStr jk_sizeForFitSize:CGSizeMake(size.width - 3 * JKImageTextMargin() - iconSize.width, size.height - 2 * JKImageTextMargin())];
                iconMinX = (size.width - iconSize.width - textSize.width - JKImageTextMargin()) * 0.5;
                iconMinY = (size.height - iconSize.height) * 0.5;
                iconFrame = JKRectMake(iconMinX, iconMinY, iconSize);
                
                
                textFrame = JKRectMake(CGRectGetMaxX(iconFrame) + JKImageTextMargin(), (size.height - textSize.height) * 0.5, textSize);
                
            }break;
                /// 左文右图
            case JKImageTextModelImageRightTextLeft:{
                textSize = [attributedStr jk_sizeForFitSize:CGSizeMake(size.width - 3 * JKImageTextMargin() - iconSize.width, size.height - 2 * JKImageTextMargin())];
                iconMinX = (size.width - iconSize.width - textSize.width - JKImageTextMargin()) * 0.5 + textSize.width + JKImageTextMargin();
                iconMinY = (size.height - iconSize.height) * 0.5;
                iconFrame = JKRectMake(iconMinX, iconMinY, iconSize);
                
                
                textFrame = JKRectMake((size.width - iconSize.width - textSize.width - JKImageTextMargin()) * 0.5, (size.height - textSize.height) * 0.5, textSize);
            }break;
                /// 上图下文
            case JKImageTextModelImageTopTextBottom:{
                textSize = [attributedStr jk_sizeForFitSize:CGSizeMake(size.width - 2 * JKImageTextMargin(), size.height - 3 * JKImageTextMargin() - iconSize.height)];
                iconMinX = (size.width - iconSize.width) * 0.5;
                iconMinY = (size.height - iconSize.height - textSize.height - JKImageTextMargin()) * 0.5;
                iconFrame = JKRectMake(iconMinX, iconMinY, iconSize);
                
                textFrame = JKRectMake((size.width - textSize.width) * 0.5, CGRectGetMaxY(iconFrame) + JKImageTextMargin(), textSize);
                
            }break;
                /// 上文下图
            case JKImageTextModelImageBottomTextTop:{
                textSize = [attributedStr jk_sizeForFitSize:CGSizeMake(size.width - 2 * JKImageTextMargin(), size.height - 3 * JKImageTextMargin() - iconSize.height)];
                iconMinX = (size.width - iconSize.width) * 0.5;
                
                CGFloat spacing = (size.height - textSize.height - iconSize.height - JKImageTextMargin()) * 0.5;
                iconMinY = spacing + textSize.height + JKImageTextMargin();
                iconFrame = JKRectMake(iconMinX, iconMinY, iconSize);
                
                textFrame = JKRectMake((size.width - textSize.width) * 0.5, spacing, textSize);
            }break;
        }
        
        [icon drawInRect:iconFrame];
        [attributedStr drawInRect:textFrame];
    });
}

@end
