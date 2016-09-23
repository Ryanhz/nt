//
//  NSDictionary+Job.m
//  neitui
//
//  Created by hzf on 16/7/22.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NSDictionary+Job.h"

@implementation NSDictionary (Job)


+ (NSString *)getWork_ExperienceStringWithKey:(NSString *)key {
    NSDictionary *dic = @{
                          @"0" : @"不限",
                          @"1" : @"应届毕业生",
                          @"2" : @"1~3年",
                          @"3" : @"3~5年",
                          @"4" : @"5年以上",
                          };
    return dic[key];
}

+ (NSString *)getJob_SalaryStringWithKey:(NSString *)key {
    NSDictionary *dic = @{
                          @"0" : @"不限",
                          @"1" : @"5k以下",
                          @"2" : @"5k~10k",
                          @"3" : @"10k~15k",
                          @"4" : @"15k~25k",
                          @"5" : @"25k~50"
                          };
    return dic[key];
}

+ (NSString *)getScale_typWithKey:(NSString *)key {
    NSDictionary *dic = @{ @"angel" : @"初创公司",
                           @"nice" : @"成熟型公司",
                           @"go" : @"成长型公司",
                           @"a" : @"A轮",
                           @"b" : @"B轮",
                           @"c" : @"C轮",
                           @"d" : @"D轮",
                           @"ipo" : @"上市公司",
                           @"hide" : @"未融资",
                           @"nowant" :@"无需融资"

                           };
    return dic[key];
}

+ (NSString *)getCompany_ScaleWithKey:(NSNumber *)key {
    NSDictionary *dic = @{ @1 : @"15人以下",
                           @2 : @"15-50人",
                           @3 : @"50-100人",
                           @4 : @"100-500人",
                           @5 : @"500-1000人",
                           @6 : @"1000以上",
                           
                           };
    return dic[key];
}

+ (NSString *)edu_careerWithKey:(NSString *)key {
    NSDictionary *dic = @{
                          @"1" : @"大专",
                          @"2" : @"本科",
                          @"3" : @"硕士",
                          @"4" : @"博士",
                          @"9" : @"其他"
                          };
    return dic[key];
}

+ (NSString *)edu_careerKeyformValue:(NSString *)value {
    NSDictionary *dic = @{
                          @"大专" : @"1",
                          @"本科" : @"2",
                          @"硕士":  @"3",
                          @"博士" : @"4",
                          @"其他" : @"9"
                          };
    return dic[value];
}

+ (NSString *)reusmeStateWithKey:(NSString *)key {
    NSDictionary *dic = @{
                          @"5" : @"待定",
                          @"4" : @"通知面试",
                          @"3" : @"已内推",
                          @"1" : @"未通过",
                          @"0" : @"已投递",
                          @"-1" : @"已查看",
                          };
    return dic[key];
}


@end
