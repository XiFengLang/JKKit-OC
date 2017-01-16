//
//  JKModel
//  溪枫狼
//
//  Created by 蒋鹏 on 16/12/2.
//  Copyright © 2016年 孙国林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKBaseObj.h"

@interface JKModel : JKBaseObj
{
    NSString * _jkProperty;
}

@property (nonatomic, assign) NSUInteger vendingid;
@property (nonatomic, copy) NSString * storeid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * sname;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * sn;
@property (nonatomic, copy) NSString * displaysize;
@property (nonatomic, strong)NSNumber * track_lists;

@end
