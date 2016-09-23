/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "AppDelegate+EaseMob.h"
#import "NTSignInViewController.h"
#import "ChatDemoHelper.h"
#import "MBProgressHUD.h"
#import "ChatViewController.h"

/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (EaseMob)

#pragma mark--start ps：临时用
#pragma mark--改变登陆状态



#pragma mark---end

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(logout)
//                                                 name:KNOTIFICATION_logout
//                                               object:nil];
    
    [[EaseSDKHelper shareHelper] easemobApplication:application
                    didFinishLaunchingWithOptions:launchOptions
                                           appkey:appkey
                                     apnsCertName:apnsCertName
                                      otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
//    [ChatDemoHelper shareHelper];
//    [[EMClient sharedClient].options setIsAutoLogin:NO];
//    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    
//    BOOL isAutoLogin = NO;
//    NTUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:userFile];
//    if (user && user.uid) {
//        isAutoLogin = YES;
//    }
//    NSDictionary * dic = @{ @"userType" : @(candidate), @"loginChange" : @YES };
    
//    NTUserType userType = user_referee;
    NTUserType userType = user_candidate;
    BOOL isAutoLogin = NO;
    if (isAutoLogin){
        
//        NSDictionary * dic = @{ @"userType" : @(referee), @"loginChange" : @YES };
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:loginChangeDic(userType, YES)]; //kNotification_loginChange
    }
    else
    {
//        NSDictionary * dic = @{ @"userType" : @(referee), @"loginChange" : @YES };
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:loginChangeDic(userType, NO)];
    }
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                                            initWithTitle:@"apns.failToRegisterApns"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - login changed

 - (void)loginStateChange:(NSNotification *)notification
 {
     DLog(@"%@",notification);
     NSDictionary *dic = notification.object;
     
     NTUserType type = [dic[@"userType"] integerValue];
      BOOL loginSuccess = [dic[@"loginChange"] boolValue];
     if (type == user_candidate) {
         [self candidateLogin:loginSuccess];
     } else {
         [self refereeLogin:loginSuccess];
     }
     
    
     
//     [self candidateLogin:loginSuccess];
 }

- (void)refereeLogin:(BOOL) loginSuccess {
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
        if (self.refereeMainTabBarController == nil) {
            self.refereeMainTabBarController = [[NTReference_MainTabBarViewController alloc] init];
            self.mainTabBarController = nil;
        }
        //通过登陆页登陆成功 加载主窗口控制器
        if (self.loginNavigationController) {
            
            UIViewController *vc = self.loginNavigationController;
            [UIView transitionFromView:vc.view toView:self.refereeMainTabBarController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
                self.window.rootViewController = self.refereeMainTabBarController;
                self.loginNavigationController = nil;
            }];
        } else {
            //autoLogin 加载主窗口控制器
            self.window.rootViewController = self.refereeMainTabBarController;
        }
        
    } else {
        
        if (self.loginNavigationController == nil) {
            NTSignInViewController *loginController = [[NTSignInViewController alloc] init];
            self.loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
        }
        
        // 注销登陆 显示登陆页
        if (self.mainTabBarController) {
            UIViewController *vc = self.loginNavigationController;
            [UIView transitionFromView:self.mainTabBarController.view toView: vc.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
                self.window.rootViewController = self.loginNavigationController;
                self.mainTabBarController = nil;
            }];
            
        } else {
            // autoLogin is not
            self.window.rootViewController = self.loginNavigationController;
        }
        
    }

}

- (void)candidateLogin:(BOOL)loginSuccess {
    if (loginSuccess) {//登陆成功加载主窗口控制器
        if (self.mainTabBarController == nil) {
            self.mainTabBarController = [[NTMainTabBarController alloc] init];
            self.refereeMainTabBarController = nil;
        }
        //通过登陆页登陆成功 加载主窗口控制器
        if (self.loginNavigationController) {
            
            UIViewController *vc = self.loginNavigationController;
            [UIView transitionFromView:vc.view toView:self.mainTabBarController.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
                self.window.rootViewController = self.mainTabBarController;
                self.loginNavigationController = nil;
            }];
        } else {
            //autoLogin 加载主窗口控制器
            self.window.rootViewController = self.mainTabBarController;
        }
        
    } else {
        
        if (self.loginNavigationController == nil) {
            NTSignInViewController *loginController = [[NTSignInViewController alloc] init];
            self.loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
        }
        
        // 注销登陆 显示登陆页
        if (self.mainTabBarController) {
            UIViewController *vc = self.loginNavigationController;
            [UIView transitionFromView:self.mainTabBarController.view toView: vc.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
                self.window.rootViewController = self.loginNavigationController;
                self.mainTabBarController = nil;
            }];
            
        } else {
            // autoLogin is not
            self.window.rootViewController = self.loginNavigationController;
        }
        
    }
}

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"apns.content"
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
    
}

@end
