//
//  AFHTTPSessionManager+FEOnce.m
//  neitui
//
//  Created by hzf on 16/8/15.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "AFHTTPSessionManager+FEOnce.h"

static AFHTTPSessionManager *manager;
//static AFURLSessionManager *urlSession;

@implementation AFHTTPSessionManager (Once)

+ (AFHTTPSessionManager *)shareHttpSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];

    });
    return manager;
}


@end
