//
//  ViewController.m
//  3D下沉
//
//  Created by 蒋鹏 on 17/1/18.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSInteger, TransformType) {
    TransformTypeM32 = 0,
    TransformTypeM34,
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (CATransform3D)firstTransformWithType:(TransformType)type {
    CATransform3D transform = CATransform3DIdentity;
    CGFloat m = 1.0 / -900;
    if (type == TransformTypeM32) {
        transform.m32 = m;
    } else {
        transform.m34 = m;
    }
    
    /// x/y轴缩放
    transform = CATransform3DScale(transform, 0.95, 0.95, 1);
    
    /// 绕X轴旋转15度
    transform = CATransform3DRotate(transform, 15.0 * M_PI/180.0, 1, 0, 0);
    
    return transform;
}


- (CATransform3D)secondTransformWithType:(TransformType)type {
    CATransform3D transform = CATransform3DIdentity;
    if (type == TransformTypeM32) {
        transform.m32 = [self firstTransformWithType:type].m32;
    } else {
        transform.m34 = [self firstTransformWithType:type].m34;
    }
    
    /// 沿Y轴上移
    transform = CATransform3DTranslate(transform, 0, self.view.frame.size.height * (-0.08), 0);
    
    /// x/y轴再次缩放
    transform = CATransform3DScale(transform, 0.8, 0.8, 1);
    
    return transform;
}


- (IBAction)down:(id)sender {
    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.layer.transform = [self firstTransformWithType:TransformTypeM32];
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.view.layer.transform = [self secondTransformWithType:TransformTypeM32];
//        }];
//    }];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.navigationController.view.layer.transform = [self firstTransformWithType:TransformTypeM34];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.navigationController.view.layer.transform = [self secondTransformWithType:TransformTypeM34];
        } completion:nil];
    }];

}
- (IBAction)up:(id)sender {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.view.layer.transform = [self firstTransformWithType:TransformTypeM32];
        self.navigationController.view.layer.transform = [self firstTransformWithType:TransformTypeM34];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.navigationController.view.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
