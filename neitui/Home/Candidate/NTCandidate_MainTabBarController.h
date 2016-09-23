//
//  MainTabBarController.h
//  Neitui
//
//  Created by hzf on 16/6/30.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NTHomeViewController.h"
#import "NTPositionViewController.h"
#import "NTFollowViewController.h"
#import "NTMessageViewController.h"
#import "NTMyViewController.h"


@interface NTCandidate_MainTabBarController : UITabBarController

@property (nonatomic, strong) NTHomeViewController     *homeViewController;        // 首页
@property (nonatomic, strong) NTPositionViewController *positionViewController;    //
@property (nonatomic, strong) NTFollowViewController *referenceViewController;  //
@property (nonatomic, strong) NTMessageViewController  *messageViewController;     //
@property (nonatomic, strong) NTMyViewController *myViewController;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)playSoundAndVibration;
- (void)showNotificationWithMessage:(EMMessage *)message;

@end
