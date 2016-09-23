//
//  NSDictionary+Job.h
//  neitui
//
//  Created by hzf on 16/7/22.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Job)
/**
 *  根据key获取对应的工作经验String
 *
 *  @param key key
 *
 *  @return 工作经验String
 */
+ (NSString *)getWork_ExperienceStringWithKey:(NSString *)key;

/**
 *  根据key获取对应的薪酬String
 *
 *  @param key key description
 *
 *  @return 薪酬String
 */
+ (NSString *)getJob_SalaryStringWithKey:(NSString *)key;

/**
 *  根据key获取对应的公司发展阶段String
 *
 *  @param key key description
 *
 *  @return 公司发展阶段String
 */
+ (NSString *)getScale_typWithKey:(NSString *)key;

/**
 *  根据key获取对应的公司人数String
 *
 *  @param key key description
 *
 *  @return 公司人数String
 */
+ (NSString *)getCompany_ScaleWithKey:(NSNumber *)key;

/**
 *  根据key获取对应学历String
 *
 *  @param key  1 ，2， 3， 4， 9
 *
 *  @return @"大专" @"本科"  @"硕士"  @"博士"  @"其他"
 */
+ (NSString *)edu_careerWithKey:(NSString *)key;


/**
 *  根据value获取对应学历key
 *
 *  @param  @"大专" @"本科"  @"硕士"  @"博士"  @"其他"
 *
 *  @return  key  1 ，2， 3， 4， 9
 */
+ (NSString *)edu_careerKeyformValue:(NSString *)value;

/**
 *  根据key获取对应简历状态String
 *
 *  @param key @"5", @"4", @"3", @"1", @"0", @"-1"
 *
 *  @return @"待定", @"通知面试", @"已内推", @"未通过", @"已投递", @"已查看",
 */
+ (NSString *)reusmeStateWithKey:(NSString *)key;

@end
