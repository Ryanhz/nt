//
//  AppDelegate.m
//  neitui
//
//  Created by hzf on 16/7/1.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"
#import "AppDelegate+UM.h"
#import "NTSignInViewController.h"
#import <IQKeyboardManager.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    NTSignInViewController *signInVC = [[NTSignInViewController alloc]init];
//    UINavigationController *signInNav = [[UINavigationController alloc]initWithRootViewController:signInVC];
//    window.rootViewController = signInNav;
    self.window = window;
    [self.window makeKeyAndVisible];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [self umApplication:application didFinishLaunchingWithOptions:launchOptions appKey:UM_APPKEY channelId:@"App Store" appVersion:version];
    [self UMSocialCofigWhithAppkey:UM_APPKEY];
    
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:EASE_APPKEY apnsCertName:EASE_APNSCERTNAME otherConfig:@{kSDKConfigEnableConsoleLogger : [NSNumber numberWithBool:YES]}];
    
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x2d2d2d)];
    [[UINavigationBar appearance] setBarTintColor:NTBarTintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          UIColorFromRGB(0x2d2d2d), NSForegroundColorAttributeName,nil]];
//    UINavigationBar.appearance.translucent = NO;
    
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
//    
//    [NTNetworkHelper startMonitoring];
//    [NTNetworkHelper stopMonitoring];
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"deviceID:%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
   
    
    return YES;
}

//- (void)logout3 {
//    [self logout];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
