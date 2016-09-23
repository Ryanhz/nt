//
//  NSError+NetHelper.m
//  neitui
//
//  Created by hzf on 16/8/2.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NSError+NetHelper.h"

@implementation NSError (NetHelper)

+ (NSError *)createError:(NSDictionary *)dic {
    return [NSError errorWithDomain:dic[@"message"] code:[dic[@"code"] intValue] userInfo:dic];
}

@end
