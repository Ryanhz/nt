//
//  NTReference_MainTabBarViewController.m
//  neitui
//
//  Created by hzf on 16/7/26.
//  Copyright © 2016年 neitui. All rights reserved.
//
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";

#import "NTReference_MainTabBarViewController.h"
#import "ChatDemoHelper.h"

@interface NTReference_MainTabBarViewController ()

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation NTReference_MainTabBarViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    [self setupSubviews];
    
    
    [ChatDemoHelper shareHelper].messageViewController = _messageViewController;
    [ChatDemoHelper shareHelper].reference_MainTabBarViewController = self;
}

- (void)setupSubviews {
    
    
    //    主页
    _resumeViewController = [[NTReferee_ResumeViewController alloc]init];
    _resumeViewController.tabBarItem = [self setTabBarItemWithTitle:@"简历" imageStr:@"bar_Referee_home" selectedImageStr:@"bar_Referee_home_selected"];
    UINavigationController *homeNav = [[UINavigationController alloc ]initWithRootViewController:_resumeViewController];
    
    //    求职者
    _candidateViewController = [[NTReferee_CandidateViewController alloc]init];
    _candidateViewController.tabBarItem = [self setTabBarItemWithTitle:@"人才" imageStr:@"bar_Referee_candidate" selectedImageStr:@"bar_Referee_candidate_selected"];
    UINavigationController *candidateNav = [[UINavigationController alloc ]initWithRootViewController:_candidateViewController];
    
    //    消息
    _messageViewController = [[NTMessageViewController alloc]init];
    _messageViewController.tabBarItem =[self setTabBarItemWithTitle:@"消息" imageStr:@"bar_Referee_message" selectedImageStr:@"bar_Referee_message_selected"];
    
    UINavigationController *messageNav = [[UINavigationController alloc ]initWithRootViewController:_messageViewController];
    
    _reference_MyViewController  = [[NTReferee_MyViewController alloc]init];
    _reference_MyViewController.tabBarItem =  [self setTabBarItemWithTitle:@"我的" imageStr:@"bar_Referee_my" selectedImageStr:@"bar_Referee_my_selected"];
    
    UINavigationController *myNav = [[UINavigationController alloc ]initWithRootViewController:_reference_MyViewController];
    
    self.viewControllers = @[homeNav, candidateNav, messageNav, myNav];
    
}

- (UITabBarItem *)setTabBarItemWithTitle:(NSString *)title imageStr:(NSString *)imageStr selectedImageStr:(NSString *)selectedImageStr {
    //    UIImage *image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];  //原图效果不好
    UIImage *image = [UIImage imageNamed:imageStr];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    tabBarItem.title = title;
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x30739e)} forState:UIControlStateSelected];
    //    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xbfbfbf)} forState:UIControlStateNormal]; //文字颜色不清晰
    tabBarItem.image = image;
    tabBarItem.selectedImage = selectedImage;
    return tabBarItem;
}

- (void)setupUnreadMessageCount {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_messageViewController) {
        if (unreadCount > 0) {
            _messageViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _messageViewController.tabBarItem.badgeValue = nil;
        }
    }
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)networkChanged:(EMConnectionState)connectionState {
    
}

- (void)playSoundAndVibration {
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        DLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
    
}

- (void)showNotificationWithMessage:(EMMessage *)message {
    
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = @"Image";
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = @"Location";
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr =  @"Voice";
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = @"Video";
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"you have a new message";
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = @"Open";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        DLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
    
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}


- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if (self.selectedViewController == self.messageViewController.navigationController) {
            
            if (((UINavigationController *)self.selectedViewController).viewControllers.count == 1) {
                
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
                
                chatViewController = [[ChatViewController alloc]initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                chatViewController.title = conversationChatter;
                [self.messageViewController.navigationController pushViewController:chatViewController animated:NO];
                
            } else {
                
                ChatViewController *chatViewController = (ChatViewController *)((UINavigationController *)self.selectedViewController).viewControllers[1];
                NSString *conversationChatter = userInfo[kConversationChatter];
                if ([chatViewController.conversation.conversationId isEqualToString:conversationChatter]) {
                    
                    [(UINavigationController *)self.selectedViewController popToViewController:chatViewController animated:NO];
                    
                } else {
                    
                    [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
                    chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:EMConversationTypeChat];
                    [(UINavigationController *)self.selectedViewController pushViewController:chatViewController animated:NO];
                }
            }
        } else {
            
            self.selectedIndex = 1;
            NSString *conversationChatter = userInfo[kConversationChatter];
            ChatViewController *chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:EMConversationTypeChat];
            [self.messageViewController.navigationController pushViewController:chatViewController animated:NO];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
