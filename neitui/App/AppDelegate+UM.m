//
//  AppDelegate+UM.m
//  neituiDemo
//
//  Created by hzf on 16/6/27.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "AppDelegate+UM.h"
#import <UMSocial.h>
#import <UMMobClick/MobClick.h>
#import <UMSocialSinaSSOHandler.h>
#import <UMSocialQQHandler.h>
 #import "UMSocialWechatHandler.h"

@implementation AppDelegate (UM)

//开始应用统计
//ChannelId的值为应用的渠道标识
- (void)umApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
               appKey:(NSString *)appKey
            channelId:(NSString *)channelId
           appVersion:(NSString *)version{
    
    UMConfigInstance.appKey = appKey;
    UMConfigInstance.channelId = channelId;
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
//    [MobClick setLogEnabled:YES];

}

- (void)UMSocialCofigWhithAppkey:(NSString *)appkey{
    [UMSocialData setAppKey:appkey];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaWB_APPKEY secret:SinaWB_AppSecret RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialQQHandler setQQWithAppId:QQ_APPID appKey:QQ_APPKEY url:@"http://www.umeng.com/social"];
    
    [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_APPSECRET url:@"http://www.umeng.com/social"];
}

//注意如果同时使用微信支付、支付宝等其他需要改写回调代理的SDK，请在if分支下做区分，否则会影响 分享、登录的回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
            BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
//         调用其他SDK，例如支付宝SDK等
    }
    return result;
}


@end
