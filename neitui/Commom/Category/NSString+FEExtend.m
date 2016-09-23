//
//  NSString+Size.m
//  neitui
//
//  Created by hzf on 16/7/8.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NSString+FEExtend.h"

@implementation NSString (Size)

- (CGSize)sizeWithFontOfSize:(CGFloat )Size maxSize:(CGSize)maxSize {
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:Size]};
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
}


- (CGFloat)newlineStringHeightWithFontOfSize:(CGFloat )Size lineSpacing:(CGFloat)lineSpacing maxSize:(CGSize)maxSize {
    NSArray *array = [self componentsSeparatedByString:@"\n"];
    CGFloat string_height = 0;
    if (array && array.count >1) {
        for (NSString *string in array) {
            string_height += [string sizeWithFontOfSize:Size lineSpacing:lineSpacing maxSize:maxSize].height;
        }
        
    } else {
        string_height = [self sizeWithFontOfSize:Size lineSpacing:lineSpacing maxSize:maxSize].height;
    }
    return string_height;
}

- (CGSize)sizeWithFontOfSize:(CGFloat )Size lineSpacing:(CGFloat)lineSpacing maxSize:(CGSize)maxSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpacing];
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:Size],NSParagraphStyleAttributeName :paragraphStyle};
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
}

@end

@implementation NSString (attributedPlaceholder)

- (NSAttributedString *)attributedStringWithFontSize:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    NSAttributedString *attributedSting = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName :paragraphStyle}];
    return attributedSting;
}

- (NSAttributedString *)attributedPlaceholderWithString {
     NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName :[UIFont systemFontOfSize: NTFontSize_12], NSForegroundColorAttributeName : NTGreyColor,NSBaselineOffsetAttributeName: @(-1)}];
    return attributedString;
}

@end

@implementation NSString (time)

- (NSString *)timeStringTransformToTimedescription {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //2016-07-19 15:24:40
    NSDate *date = [formatter dateFromString:self];
    //    NSDate *date = [formatter dateFromString:@"2016-07-22 15:24:40"];
    
    NSString *update = nil;
    NSDate * newDate = [NSDate date];
    if ([date isToday]) {
        NSInteger beforeHoure = [date hoursBeforeDate:[NSDate date]];
        
        if (beforeHoure == 0) {
            NSInteger beforemminutes = [date minutesBeforeDate:newDate];
            if (beforemminutes < 1) {
                update = @"刚刚";
            } else {
                update = [NSString stringWithFormat:@"%ld 分钟前",(long)beforemminutes];
            }
        } else {
            update = [NSString stringWithFormat:@"%ld 小时前",(long)beforeHoure];
        }
        
        
    } else {
        NSInteger BeforeDate = [date daysBeforeDate:[NSDate date]];
        update = [NSString stringWithFormat:@"%ld 天前",(long)BeforeDate];
    }
    return update;
}

- (NSString *)transTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:self];
    [formatter setDateFormat:@"yyyy.MM"];
    NSString *str = [formatter stringFromDate:date];
    return str ? str : @"";
 }

@end

@implementation NSString (URL)

- (NSURL *)transformURLWithUTF8Encoding {
    NSString *str = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *iconStr = [NSURL URLWithString:str];
    return iconStr;
}


@end

@implementation NSString(check)


#pragma 正则匹配邮箱号
+ (BOOL)checkMailInput:(NSString *)mail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
}

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,183,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[356])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:telNumber] == YES)
        || ([regextestcm evaluateWithObject:telNumber] == YES)
        || ([regextestct evaluateWithObject:telNumber] == YES)
        || ([regextestcu evaluateWithObject:telNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName
{
    
    //    NSString *pattern = @"^[A-Za-z0-9]{6,20}+$";
    NSString *pattern = @"^([\u4e00-\u9fa5]+|([a-zA-Z]+\s?)+)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}


@end


