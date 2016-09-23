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

#import <Foundation/Foundation.h>
#import "NTSignInViewController.h"
#import "NTMainTabBarController.h"
#import "NTHomeViewController.h"
#import "NTPositionViewController.h"
#import "NTMessageViewController.h"
#import "NTSettingViewController.h"
#import "ChatViewController.h"
#import "NTReference_MainTabBarViewController.h"

@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate>

@property (nonatomic, weak) NTPositionViewController *positionViewController;

@property (nonatomic, weak) NTMessageViewController *messageViewController;

@property (nonatomic, weak) NTMainTabBarController  *mainTabBarController;

@property (nonatomic, weak) NTReference_MainTabBarViewController *reference_MainTabBarViewController;

@property (nonatomic, weak) NTSettingViewController *settingViewController;

@property (nonatomic, weak) NTHomeViewController    *homeViewController;

@property (nonatomic, weak) ChatViewController      *chatViewController;

+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncConversationFromDB;


@end
