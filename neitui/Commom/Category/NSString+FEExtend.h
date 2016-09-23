//
//  NSString+Size.h
//  neitui
//
//  Created by hzf on 16/7/8.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

-(CGSize)sizeWithFontOfSize:(CGFloat )Size maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFontOfSize:(CGFloat )Size lineSpacing:(CGFloat)lineSpacing maxSize:(CGSize)maxSize;

/**
 *  获取一个有换行符的字符串的高度
 *
 *  @param Size        字体大小
 *  @param lineSpacing 行间距
 *  @param maxSize     限制尺寸
 *
 *  @return 字符串的高度
 */
- (CGFloat)newlineStringHeightWithFontOfSize:(CGFloat )Size lineSpacing:(CGFloat)lineSpacing maxSize:(CGSize)maxSize;

@end

@interface NSString (attributedPlaceholder)

- (NSAttributedString *)attributedStringWithFontSize:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing;
/**
 *  设置searchBar placeHolerde 的attributedString
 *
 *  @return attributedPlaceholder
 */
- (NSAttributedString *)attributedPlaceholderWithString;

@end

@interface NSString (time)
/**
 *  把时间字符串变成 昨天 几天前的形式
 *
 *  @return 变换后的描述
 */
- (NSString *)timeStringTransformToTimedescription;
/**
 *  2015-07-31 变成 2015.07
 *
 *  @return 变换后的字符串
 */
- (NSString *)transTime;

@end


@interface NSString (URL)

/**
 *  把字符串通过utf-8编码后再换成url
 *
 *  @return NSURL
 */
- (NSURL *)transformURLWithUTF8Encoding;


@end



@interface NSString (check)

+ (BOOL)checkMailInput:(NSString *)mail;

+ (BOOL)checkTelNumber:(NSString *) telNumber;

+ (BOOL)checkUserName : (NSString *) userName;

@end
