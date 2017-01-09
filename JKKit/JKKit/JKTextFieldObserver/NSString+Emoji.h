//
//  NSString+Emoji.h
//  E顿饭
//
//  Created by 蒋鹏 on 16/12/23.
//  Copyright © 2016年 深圳市见康云科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

/**
 是否有Emoji
 
 @return hasEmoji
 */
- (BOOL)hasEmoji;



/**
 移除Emoji
 
 @return 移除Emoji
 */
- (NSString *)removedEmojiString;

@end
