//
//  AppDelegate.h
//  neitui
//
//  Created by hzf on 16/7/1.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTMainTabBarController.h"
#import "NTReference_MainTabBarViewController.h"

typedef NS_ENUM(NSUInteger, NTUserType) {
    user_candidate = 1,
    user_referee,
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NTMainTabBarController *mainTabBarController;
@property (nonatomic, strong) NTReference_MainTabBarViewController *refereeMainTabBarController;
@property (nonatomic, strong) UINavigationController *loginNavigationController;
@property (nonatomic, assign) NTUserType *userType;

@end

