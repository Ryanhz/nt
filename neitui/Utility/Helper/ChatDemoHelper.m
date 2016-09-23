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

#import "ChatDemoHelper.h"

#import "AppDelegate.h"
#import "MBProgressHUD.h"

static ChatDemoHelper *helper = nil;

@implementation ChatDemoHelper

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatDemoHelper alloc] init];
    });
    return helper;
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

- (void)initHelper
{

    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];

    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)asyncPushOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    });
}

/**
 *  <#Description#>
 */
- (void)asyncConversationFromDB
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId deleteMessages:NO];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself.messageViewController) {
                [weakself.messageViewController refreshDataSource];
            }
            
            if (weakself.mainTabBarController) {
                [weakself.mainTabBarController setupUnreadMessageCount];
            }
        });
    });
}

#pragma mark - EMClientDelegate

/**
 *
 *
 *  @return <#return value description#>
 */
// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
//    [self.mainVC networkChanged:connectionState];
}

/**
 *  <#Description#>
 *
 *  @param error <#error description#>
 */
- (void)didAutoLoginWithError:(EMError *)error
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"自动登录失败，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
    } else if([[EMClient sharedClient] isConnected]){
        UIView *view = self.mainTabBarController.view;
        [MBProgressHUD showHUDAddedTo:view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL flag = [[EMClient sharedClient] dataMigrationTo3];
            if (flag) {
                [self asyncConversationFromDB];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:view animated:YES];
            });
        });
    }
}

/**
 *  <#Description#>
 */
- (void)didLoginFromOtherDevice
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

/**
 *  EMClientDelegate
 */

- (void)didRemovedFromServer
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

/**
 *  EMClientDelegate
 */

- (void)didServersChanged
{
    [self _clearHelper];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

/**
 *  EMClientDelegate
 */
- (void)didAppkeyChanged
{
    [self _clearHelper];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - EMChatManagerDelegate

- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    if (self.mainTabBarController) {
        [_mainTabBarController setupUnreadMessageCount];
    }
    
    if (self.messageViewController) {
        [_messageViewController refreshDataSource];
    }
}

- (BOOL)isNeedShowNotification:(EMMessage *)message {
   ChatViewController *chat = [self _getCurrentChatView];
    BOOL flag = NO;
    if (!chat) {
        flag = YES;
    }
    if (![chat.conversation.conversationId isEqualToString:message.from]) {
        flag = YES;
    }
    return flag;
}

- (void)didReceiveMessages:(NSArray *)aMessages
{
    BOOL isRefreshCons = YES;
    for(EMMessage *message in aMessages){
        BOOL needShowNotification = [self isNeedShowNotification:message];
        
        if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
            UIApplicationState state = [[UIApplication sharedApplication] applicationState];
            switch (state) {
                case UIApplicationStateActive:
                    [self.mainTabBarController playSoundAndVibration];
                    break;
                case UIApplicationStateInactive:
                    [self.mainTabBarController playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
                    [self.mainTabBarController showNotificationWithMessage:message];
                    break;
                default:
                    break;
            }
#endif
        }
        
        if (_chatViewController == nil) {
            _chatViewController = [self _getCurrentChatView];
        }
        BOOL isChatting = NO;
        if (_chatViewController) {
            isChatting = [message.conversationId isEqualToString:_chatViewController.conversation.conversationId];
            isChatting = YES;
        }
        if (_chatViewController == nil || !isChatting) {
            if (self.messageViewController) {
                [_messageViewController refreshDataSource];
            }
            
            if (self.mainTabBarController) {
                [_mainTabBarController setupUnreadMessageCount];
            }
            return;
        }
        
        if (isChatting) {
            isRefreshCons = NO;
        }
    }
    
    if (isRefreshCons) {
        if (self.messageViewController) {
            [_messageViewController refreshDataSource];
        }
        
        if (self.mainTabBarController) {
            [_mainTabBarController setupUnreadMessageCount];
        }
    }
}

- (ChatViewController*)_getCurrentChatView
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:_mainTabBarController.messageViewController.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    return chatViewContrller;
}

- (void)_clearHelper
{
//    self.mainTabBarController = nil;
////    self.conversationListVC = nil;
//    self.chatViewController = nil;
////    self.contactViewVC = nil;
    
    [[EMClient sharedClient] logout:YES];
    
}
@end
