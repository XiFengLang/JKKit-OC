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





struct JKLayout {
    CGFloat left;
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
};
typedef struct JKLayout JKLayout;

static inline NSString * NSStringFromJKLayout(JKLayout layout) {
    return [NSString stringWithFormat:@"{\n\tleft = %f,\n\ttop = %f,\n\tright = %f,\n\tbottom = %f,\n\n\twidth = %f,\n\theight = %f\n}",layout.left,layout.top,layout.right,layout.bottom,fabs(layout.right - layout.left),fabs(layout.bottom - layout.top)];
}

@interface UIView (JKLayout)

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;


@property (nonatomic, assign) JKLayout layout;


- (CGFloat)maxY;
- (CGFloat)maxX;
- (CGFloat)midX;
- (CGFloat)midY;


/**
 相对View本身bounds的中心点，也就是宽高的一半
 */
- (CGPoint)centerOfBounds;


/**
 相对Keywindow的frame
 */
- (CGRect)windowFrame;



/**
 以view.centerOfBounds为中心点，宽度size的frame

 @param size size
 */
- (CGRect)suitableCenterFrameWithSize:(CGSize)size;

@end
