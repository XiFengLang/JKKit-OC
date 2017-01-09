//
//  JKTableViewCell.m
//  JKRoundedCell
//
//  Created by 蒋鹏 on 17/1/4.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKTableViewCell.h"

@interface JKTableViewCell ()


@property (nonatomic, strong)UIImage * normalImage;
@property (nonatomic, strong) UIImage * hightlightImage;

@end


@implementation JKTableViewCell

- (UIImage *)normalImage {
    if (!_normalImage) {
        _normalImage = [UIImage imageNamed:@"im_rigth_decoration"];
    } return _normalImage;
}

- (UIImage *)hightlightImage {
    if (!_hightlightImage) {
        _hightlightImage = [[UIImage imageNamed:@"im_rigth_decoration"] jk_imageWithTintColor:JKWhiteColor()];
    } return _hightlightImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.jk_imageView.image = self.normalImage;
    
    
    CGSize size = [@"日历账户管理" jk_sizeWithFont:self.jk_titleLabel.font andFitWidth:250];
    self.jk_titleLabel.frame = JKRectMake(30, (60 - size.height) / 2.0, size);
    
    CGSize imageSize = CGSizeMake(30, 18);
    self.jk_imageView.frame = JKRectMake(JKScreenWidth() - 30 - imageSize.width, (60 - imageSize.height) / 2.0, imageSize);
    
    CGSize subSize = [@"所有日历" jk_sizeWithFont:self.jk_subTitleLabel.font andFitWidth:250];
    self.jk_subTitleLabel.frame = JKRectMake(self.jk_imageView.jk_x - subSize.width - 5, (60 - subSize.height) / 2.0, subSize);
    
}

- (void)configueCellWithDatas:(NSArray<NSString *> *)datas {
    self.jk_titleLabel.text = datas.firstObject;
    self.jk_subTitleLabel.text = datas.lastObject;
    
    self.jk_titleLabel.textColor = JKBlackColor();
    self.jk_subTitleLabel.textColor = JKColorWithRGB(101, 135, 209);
    
    CGSize size = [self.jk_titleLabel.text jk_sizeWithFont:self.jk_titleLabel.font andFitWidth:250];
    self.jk_titleLabel.frame = JKRectMake(30, (60 - size.height) / 2.0, size);

    
    CGSize subSize = [self.jk_subTitleLabel.text jk_sizeWithFont:self.jk_subTitleLabel.font andFitWidth:250];
    self.jk_subTitleLabel.frame = JKRectMake(self.jk_imageView.jk_x - subSize.width - 5, (60 - subSize.height) / 2.0, subSize);
}


- (void)willHighlight {
    self.jk_titleLabel.textColor = JKWhiteColor();
    self.jk_subTitleLabel.textColor = JKWhiteColor();
    self.jk_imageView.image = self.hightlightImage;
}


- (void)didUnhighlight {
    self.jk_titleLabel.textColor = JKBlackColor();
    self.jk_subTitleLabel.textColor = JKColorWithRGB(101, 135, 209);
    self.jk_imageView.image = self.normalImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
