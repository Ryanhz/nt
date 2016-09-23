//
//  AppDelegate+UM.h
//  neituiDemo
//
//  Created by hzf on 16/6/27.
//  Copyright © 2016年 neitui. All rights reserved.

//18310956657 杜

#import "AppDelegate.h"

@interface AppDelegate (UM)

/**
 *  友盟统计分析
 *
 *  @param application   application单例
 *  @param launchOptions application的launchOptions
 *  @param appKey        友盟的appkey
 *  @param channelId     hannelId的值为应用的渠道标识。默认为 @"App Store
 *  @param version       app的版本号
 */
- (void)umApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
               appKey:(NSString *)appKey
            channelId:(NSString *)channelId
           appVersion:(NSString *)version;

/**
 *  友盟第三方登陆和分享的设置
 *
 *  @param appkey 友盟的appkey
 */
- (void)UMSocialCofigWhithAppkey:(NSString *)appkey;

@end
