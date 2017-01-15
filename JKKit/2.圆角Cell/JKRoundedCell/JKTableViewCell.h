//
//  JKTableViewCell.h
//  JKRoundedCell
//
//  Created by 蒋鹏 on 17/1/4.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKViewFactory.h"
#import "UIView+CGRect.h"
#import "NSObject+Swizzling.h"


@interface JKTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jk_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jk_subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jk_imageView;

- (void)configueCellWithDatas:(NSArray <NSString *>*)datas;

- (void)willHighlight;

- (void)didUnhighlight;

@end
