//
//  NSError+NetHelper.h
//  neitui
//
//  Created by hzf on 16/8/2.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (NetHelper)
+ (NSError *)createError:(NSDictionary *)dic;
@end
