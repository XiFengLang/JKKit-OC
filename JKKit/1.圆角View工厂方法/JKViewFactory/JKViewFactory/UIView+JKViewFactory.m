//
//  UIView+JKViewFactory.m
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "UIView+JKViewFactory.h"
#import "NSString+JKViewFactory.h"
#import "UIColor+JKViewFactory.h"
#import "UIImage+JKViewFactory.h"

@implementation UIView (JKViewFactory)


+ (instancetype)jk_viewWithFrame:(CGRect)frame{
    @autoreleasepool {
        return [self jk_viewWithFrame:frame backgroundColor:JKWhiteColor()];
    }
}

+ (instancetype)jk_viewWithFrame:(CGRect)frame
                 backgroundColor:(UIColor *)bgColor{
    @autoreleasepool {
        UIView * view = [[self alloc] initWithFrame:frame];
        view.backgroundColor = bgColor;
        return view;
    }
}


+ (instancetype)jk_roundedViewWithFrame:(CGRect)frame
                            cornrRadius:(CGFloat)cornerRadius
                        backgroundColor:(UIColor *)bgColor{
    @autoreleasepool {
        UIView * view = [self jk_viewWithFrame:frame backgroundColor:bgColor];
        [view jk_radiusingWithCornrRadius:cornerRadius borderWidth:0.0f borderColor:nil];
        return view;
    }
}


+ (instancetype)jk_roundedViewWithFrame:(CGRect)frame
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
                            cornrRadius:(CGFloat)cornerRadius
                        backgroundColor:(UIColor *)bgColor{
    @autoreleasepool {
        UIView * view = [self jk_viewWithFrame:frame backgroundColor:bgColor];
        [view jk_radiusingWithCornrRadius:cornerRadius borderWidth:borderWidth borderColor:borderColor];
        return view;
    }
}


- (void)jk_radiusingWithCornrRadius:(CGFloat)cornerRadius
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    if (borderWidth > 0.0f && borderColor) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = borderColor.CGColor;
    }
}

- (CALayer *)jk_addBottomLineWithHorizontalMargin:(CGFloat)horizontalMargin{
    CALayer * layer = [CALayer layer];
    layer.backgroundColor = JKLineColor().CGColor;
    layer.frame = CGRectMake(horizontalMargin, self.bounds.size.height - 1.0, self.bounds.size.width - horizontalMargin * 2, 1.0);
    [self.layer addSublayer:layer];
    return layer;
}

- (CALayer *)jk_addBottomLine{
    return [self jk_addBottomLineWithHorizontalMargin:0];
}


- (CALayer *)jk_addTopLineWithHorizontalMargin:(CGFloat)horizontalMargin{
    CALayer * layer = [CALayer layer];
    layer.backgroundColor = JKLineColor().CGColor;
    layer.frame = CGRectMake(horizontalMargin, 0, self.bounds.size.width - horizontalMargin * 2, 1.0);
    [self.layer addSublayer:layer];
    return layer;
}

- (CALayer *)jk_addTopLine{
    return [self jk_addTopLineWithHorizontalMargin:0];
}

@end


@implementation UILabel (JKViewFactory)

+ (instancetype)jk_labelWithFrame:(CGRect)frame
                        textColor:(UIColor *)textColor
                         fontSize:(CGFloat)fontSize
                             text:(NSString *)text{
    @autoreleasepool {
        UILabel * label = [[self alloc] initWithFrame:frame];
        label.backgroundColor = JKWhiteColor();
        label.textColor = textColor;
        label.text = text;
        label.font = JKFontWithSize(fontSize);
        return label;
    }
}


+ (instancetype)jk_labelWithFrame:(CGRect)frame
                         fontSize:(CGFloat)fontSize
                             text:(NSString *)text{
    @autoreleasepool {
        return [self jk_labelWithFrame:frame
                             textColor:JKBlackColor()
                              fontSize:fontSize
                                  text:text];
    }
}

+ (instancetype)jk_adaptiveLabelWithOrigin:(CGPoint)origin
                                  fontSize:(CGFloat)fontSize
                               andFitWidth:(CGFloat)width
                                      text:(NSString *)text{
    @autoreleasepool {
        CGSize size = [text jk_sizeWithFont:JKFontWithSize(fontSize) andFitWidth:width];
        UILabel * label = [self jk_labelWithFrame:CGRectMake(origin.x, origin.y, size.width, size.height) fontSize:fontSize text:text];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
}


+ (instancetype)jk_labelWithAttributeds:(NSAttributedString *)attributeds
                                  frame:(CGRect)frame{
    @autoreleasepool {
        UILabel * label = [self jk_viewWithFrame:frame backgroundColor:JKWhiteColor()];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.attributedText = attributeds;
        return label;
    }
}


+ (instancetype)jk_adaptiveLabelWithAttributeds:(NSAttributedString *)attributeds origin:(CGPoint)origin{
    @autoreleasepool {
        return [self jk_labelWithAttributeds:attributeds frame:JKRectMake(origin.x, origin.y, attributeds.jk_textSize)];
    }
}

@end



@implementation UIImageView (JKViewFactory)

+ (instancetype)jk_imageViewWithFrame:(CGRect)frame image:(UIImage *)image{
    @autoreleasepool {
        UIImageView * imageView = [self jk_viewWithFrame:frame backgroundColor:JKWhiteColor()];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        return imageView;
    }
}

@end


@implementation UITextField (JKViewFactory)

+ (UITextField *)jk_textFieldWithFrame:(CGRect)frame
                             leftImage:(UIImage *)leftImage
                           placeholder:(NSString *)placeholder {
    UITextField * textField = [[self alloc]initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    textField.backgroundColor = JKWhiteColor();
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (leftImage) {
        UIImage * image = [UIImage jk_borderlessImageWithIcon:leftImage
                                                    fillColor:JKWhiteColor()
                                                     iconSize:CGSizeMake(20, 20)
                                                         size:CGSizeMake(30, 30)
                                                 cornerRadius:0];
        UIImageView * leftView = [UIImageView jk_imageViewWithFrame:CGRectMake(0, 0, 30, 30) image:image];
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return textField;
}

@end
