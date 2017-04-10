//
//  UIView+CGRect.h
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline CGFloat JKScreenScale() {
    return [UIScreen mainScreen].scale;
}

static inline CGRect JKMainScreenBounds(){
    return [UIScreen mainScreen].bounds;
}


static inline CGFloat JKScreenWidth(){
    return JKMainScreenBounds().size.width;
}

static inline CGFloat JKScreenHeight(){
    return JKMainScreenBounds().size.height;
}

static inline CGRect JKRectMake(CGFloat x, CGFloat y, CGSize size){
    return CGRectMake(x, y, size.width, size.height);
}

@interface UIView (CGRect)

@property (nonatomic, assign) CGFloat jk_x;
@property (nonatomic, assign) CGFloat jk_y;
@property (nonatomic, assign) CGFloat jk_width;
@property (nonatomic, assign) CGFloat jk_height;
@property (nonatomic, assign) CGFloat jk_centerX;
@property (nonatomic, assign) CGFloat jk_centerY;
@property (nonatomic, assign) CGPoint jk_origin;
@property (nonatomic, assign) CGSize  jk_size;



- (CGFloat)jk_maxY;
- (CGFloat)jk_maxX;
- (CGFloat)jk_midX;
- (CGFloat)jk_midY;


/**
 相对View本身bounds的中心点，也就是宽高的一半
 */
- (CGPoint)jk_centerOfBounds;


/**
 相对Keywindow的frame
 */
- (CGRect)jk_windowFrame;



/**
 以view.jk_centerOfBounds为中心点，宽度size的frame

 @param size size
 */
- (CGRect)jk_suitableCenterFrameWithSize:(CGSize)size;

@end
