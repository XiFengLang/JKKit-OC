//
//  UIButton+JKViewFactory.m
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/21.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "UIButton+JKViewFactory.h"
#import "UIImage+JKViewFactory.h"
#import "UIColor+JKViewFactory.h"

@implementation UIButton (JKViewFactory)

- (void)setTitleFont:(UIFont *)titleFont{
    self.titleLabel.font = titleFont;
}

- (UIFont *)titleFont{
    return self.titleLabel.font;
}


- (void)jk_addTarget:(id)target touchUpInsideAction:(SEL)action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


+ (instancetype)jk_buttonWithFrame:(CGRect)frame
                        titleColor:(UIColor *)titleColor
                            target:(id)target
                            action:(SEL)action
                             title:(NSString *)title{
    @autoreleasepool {
        UIButton * button = [self buttonWithType:UIButtonTypeSystem];
        button.frame = frame;
        button.backgroundColor = JKWhiteColor();
        if (title) {
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:titleColor forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateHighlighted];
            [button setTitleColor:titleColor forState:UIControlStateHighlighted];
        }
        [button jk_addTarget:target touchUpInsideAction:action];
        return button;
    }
}


+ (instancetype)jk_borderlessButtonWithAttributedStr:(NSAttributedString *)attributedStr
                                               frame:(CGRect)frame
                                           fillColor:(UIColor *)fillColor
                                        cornerRadius:(CGFloat)cornerRadius{
    @autoreleasepool {
        UIButton * button = [self buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.backgroundColor = JKWhiteColor();
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage * normal = [UIImage jk_borderlessImageWithAttributedStr:attributedStr
                                                              fillColor:fillColor
                                                                   size:frame.size
                                                           cornerRadius:cornerRadius];
        [button setBackgroundImage:normal forState:UIControlStateNormal];
        
        UIImage * highlight = [normal jk_imageWithTintColor:[JKColorWithRGB(60, 60, 60) colorWithAlphaComponent:0.8] blendModel:kCGBlendModeOverlay];
        [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
        return button;
    }
}


+ (instancetype)jk_boundedButtonWithAttributedStr:(NSAttributedString *)attributedStr
                                            frame:(CGRect)frame
                                        fillColor:(UIColor *)fillColor
                                     cornerRadius:(CGFloat)cornerRadius
                                      borderWidth:(CGFloat)borberWidth
                                      borderColor:(UIColor *)borderColor{
    @autoreleasepool {
        UIButton * button = [self buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.backgroundColor = JKWhiteColor();
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage * normal = [UIImage jk_boundedImageWithAttributedStr:attributedStr
                                                         borderColor:borderColor
                                                           fillColor:fillColor
                                                                size:frame.size
                                                        cornerRadius:cornerRadius
                                                         borderWidth:borberWidth];
        [button setBackgroundImage:normal forState:UIControlStateNormal];
        
        UIImage * highlight = [normal jk_imageWithTintColor:[JKColorWithRGB(60, 60, 60) colorWithAlphaComponent:0.8] blendModel:kCGBlendModeOverlay];
        [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
        return button;
    }
}


+ (instancetype)jk_borderlessButtonWithFrame:(CGRect)frame
                                   fillColor:(UIColor *)fillColor
                                cornerRadius:(CGFloat)cornerRadius
                                  titleColor:(UIColor *)titleColor
                                       title:(NSString *)title{
    @autoreleasepool {
        UIButton * button = [self buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.backgroundColor = JKWhiteColor();
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage * normal = [UIImage jk_borderlessImageWithFillColor:fillColor
                                                               size:frame.size
                                                       cornerRadius:cornerRadius];
        [button setBackgroundImage:normal forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        
        UIImage * highlight = [normal jk_imageWithTintColor:[JKColorWithRGB(60, 60, 60) colorWithAlphaComponent:0.8] blendModel:kCGBlendModeOverlay];
        [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateHighlighted];
        [button setTitleColor:titleColor forState:UIControlStateHighlighted];
        return button;
    }
}

+ (instancetype)jk_boundedButtonWithFrame:(CGRect)frame
                               titleColor:(UIColor *)titleColor
                              borderColor:(UIColor *)borderColor
                                fillColor:(UIColor *)fillColor
                             cornerRadius:(CGFloat)cornerRadius
                              borderWidth:(CGFloat)borberWidth
                                    title:(NSString *)title{
    @autoreleasepool {
        UIButton * button = [self buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.backgroundColor = JKWhiteColor();
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage * normal = [UIImage jk_boundedImageWithFillColor:fillColor
                                                     borderColor:borderColor
                                                     borderWidth:borberWidth
                                                            size:frame.size
                                                    cornerRadius:cornerRadius];
        
        [button setBackgroundImage:normal forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateHighlighted];
        
        UIImage * highlight = [normal jk_imageWithTintColor:[JKColorWithRGB(60, 60, 60) colorWithAlphaComponent:0.8] blendModel:kCGBlendModeOverlay];
        [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateHighlighted];
        [button setTitleColor:titleColor forState:UIControlStateHighlighted];
        return button;
    }
}



+ (instancetype)jk_borderlessButtonWithIcon:(UIImage *)icon
                                 iconSize:(CGSize)iconSize
                                    frame:(CGRect)frame
                                 fillColor:(UIColor *)fillColor
                              cornerRadius:(CGFloat)cornerRadius{
    @autoreleasepool {
        UIButton * button = [self buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.backgroundColor = JKWhiteColor();
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage * normal = [UIImage jk_borderlessImageWithIcon:icon
                                                     fillColor:fillColor
                                                      iconSize:iconSize
                                                          size:frame.size
                                                  cornerRadius:cornerRadius];
        [button setBackgroundImage:normal forState:UIControlStateNormal];
        
        UIImage * highlight = [normal jk_imageWithTintColor:[JKColorWithRGB(60, 60, 60) colorWithAlphaComponent:0.8] blendModel:kCGBlendModeOverlay];
        [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
        return button;
    }
}

+ (instancetype)jk_boundedButtonWithIcon:(UIImage *)icon
                                iconSize:(CGSize)iconSize
                                   frame:(CGRect)frame
                                fillColor:(UIColor *)fillColor
                             cornerRadius:(CGFloat)cornerRadius
                              borderWidth:(CGFloat)borberWidth
                              borderColor:(UIColor *)borderColor{
    @autoreleasepool {
        UIButton * button = [self buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.backgroundColor = JKWhiteColor();
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage * normal = [UIImage jk_boundedImageWithIcon:icon
                                                borderColor:borderColor
                                                  fillColor:fillColor
                                                borderWidth:borberWidth
                                                   iconSize:iconSize
                                                       size:frame.size
                                               cornerRadius:cornerRadius];
        [button setBackgroundImage:normal forState:UIControlStateNormal];
        
        UIImage * highlight = [normal jk_imageWithTintColor:[JKColorWithRGB(60, 60, 60) colorWithAlphaComponent:0.8] blendModel:kCGBlendModeOverlay];
        [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
        return button;
    }
}


+ (instancetype)jk_borderlessButtonWithAttributedStr:(NSAttributedString *)attributedStr
                                    imageTextModel:(JKImageTextModel)imageTextModel
                                              icon:(UIImage *)icon
                                          iconSize:(CGSize)iconSize
                                             frame:(CGRect)frame
                                         fillColor:(UIColor *)fillColor
                                      cornerRadius:(CGFloat)cornerRadius{
    @autoreleasepool {
        UIButton * button = [self buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.backgroundColor = JKWhiteColor();
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage * normal = [UIImage jk_borderlessImageWithAttributedStr:attributedStr
                                                                   icon:icon
                                                              fillColor:fillColor
                                                                   size:frame.size
                                                           cornerRadius:cornerRadius
                                                             imageModel:imageTextModel
                                                               iconSize:iconSize];
        [button setBackgroundImage:normal forState:UIControlStateNormal];
        
        UIImage * highlight = [normal jk_imageWithTintColor:[JKColorWithRGB(60, 60, 60) colorWithAlphaComponent:0.8] blendModel:kCGBlendModeOverlay];
        [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
        return button;
    }
}



+ (instancetype)jk_boundedButtonWithAttributedStr:(NSAttributedString *)attributedStr
                                 imageTextModel:(JKImageTextModel)imageTextModel
                                           icon:(UIImage *)icon
                                       iconSize:(CGSize)iconSize
                                          frame:(CGRect)frame
                                      fillColor:(UIColor *)fillColor
                                   cornerRadius:(CGFloat)cornerRadius
                                    borderColor:(UIColor *)borderColor
                                    borderWidth:(CGFloat)borberWidth{
    @autoreleasepool {
        UIButton * button = [self buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.backgroundColor = JKWhiteColor();
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImage * normal = [UIImage jk_boundedImageWithAttributedStr:attributedStr
                                                                icon:icon
                                                         borderColor:borderColor
                                                           fillColor:fillColor
                                                                size:frame.size
                                                        cornerRadius:cornerRadius
                                                         borderWidth:borberWidth
                                                          imageModel:imageTextModel
                                                            iconSize:iconSize];
        [button setBackgroundImage:normal forState:UIControlStateNormal];
        
        UIImage * highlight = [normal jk_imageWithTintColor:[JKColorWithRGB(60, 60, 60) colorWithAlphaComponent:0.8] blendModel:kCGBlendModeOverlay];
        [button setBackgroundImage:highlight forState:UIControlStateHighlighted];
        return button;
    }
}




@end
