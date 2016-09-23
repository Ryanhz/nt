//
//  SignInAndUpHelper.m
//  Neitui
//
//  Created by hzf on 16/6/30.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "SignInAndUpHelper.h"
#import "WXApi.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "ChatDemoHelper.h"

@interface SignInAndUpHelper ()


@property (nonatomic, assign) UMLoginType loginType;
@property (nonatomic, strong) NTUser *user;

@end

@implementation SignInAndUpHelper

static SignInAndUpHelper *signInAndUpHelper = nil;

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        signInAndUpHelper = [[SignInAndUpHelper alloc] init];
    });
    return signInAndUpHelper;
}

- (void)loginWithType:(UMLoginType)type delegate:(UIViewController<SignInAndUpDelegate> *)delegate {
    
    if (!delegate) {
        return;
    }
    _loginType = type;
    _delegate = delegate;
//    NSAssert(type, @"");
    
    switch (type) {
        case UM_qq:
        {
            [self qqlogin];
        }
            break;
        case UM_sina: {
            [self sinaLogin];
        }
            break;
        case Um_wx: {
            [self wxlogin];
        }
            break;
            
        default:
            break;
    }
#if !TARGET_IPHONE_SIMULATOR
//    [self loginWithUsername:@"22" password:@"111"];
#else
//    [self loginWithUsername:@"11" password:@"111"];
#endif
    
}

/**
 *  qq 登陆
 */

- (void)qqlogin {

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(_delegate,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self loginSuccess];
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            DLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            NTUser *user = [self setUserWithUMSocialAccountEntity:snsAccount thirdPlatform:@"qq"];
            [self loginWithUser:user];
        }});
}

/**
 *  新浪微博登陆
 */

- (void)sinaLogin {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(_delegate,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
//            [self loginSuccess];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            DLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            NTUser *user = [self setUserWithUMSocialAccountEntity:snsAccount thirdPlatform:@"weibo"];
            [self loginWithUser:user];
        }});
    
}

/**
 *  微信登陆
 */

- (void)wxlogin {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(_delegate,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self loginSuccess];
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            NTUser *user = [self setUserWithUMSocialAccountEntity:snsAccount thirdPlatform:@"weixin"];
            [self loginWithUser:user];
        }
        
    });
}

/**
 *  登陆成功后发送登陆成功通知
 */

- (void)loginSuccess {
    
    if (_delegate && [_delegate respondsToSelector:@selector(signInAndUpHelper:isSuccess:)]) {
        [_delegate signInAndUpHelper:self isSuccess:YES];
    }
    
//     [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
}

- (void)loginWithUser:(NTUser *)user  {


    NSDictionary *para = @{@"usid": user.usid, @"accessToken": user.accessToken, @"deviceType": @"iOS", @"userType": user.thirdPlatform};
    
    [NTNetworkHelper postWithURLString:api_user_login parameters:para success:^(id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
            return ;
        }
        
        if ([response[@"code"] intValue] == 1) {
            //登陆成功
        }
        
        NSString *uid = response[@"uid"];
        user.status = response[@"status"];
        user.uid = uid;
        DLog(@"user:%@",user)
        [NSKeyedArchiver archiveRootObject:user toFile:userFile];
        if ([user.status isEqualToString:@"4"]) {
            //已填写基本信息
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:loginChangeDic(1, YES)];
           
        } else {
            [self loginSuccess];
        }
        DLog(@"response:%@",response)
    } failure:^(NSError *error) {
        DLog(@"error: %@",error)
    }];
}

- (void)login {

}

- (NTUser *)setUserWithUMSocialAccountEntity:(UMSocialAccountEntity *)snsAccount thirdPlatform:(NSString *)thirdPlatform{
    NTUser *user = [[NTUser alloc]init];
    user.userName = snsAccount.userName;
    user.usid = snsAccount.usid;
    user.thirdPlatform = thirdPlatform;
    user.iconURL = snsAccount.iconURL;
    user.accessToken = snsAccount.accessToken;
    return user;
}
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [_delegate showHudInView:_delegate.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
//    __weak typeof(self) weakself = _delegate;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate hideHud];
            if (!error) {
                //设置是否自动登录
//                [[EMClient sharedClient].options setIsAutoLogin:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] dataMigrationTo3];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
                        [[ChatDemoHelper shareHelper] asyncPushOptions];
//                        [MBProgressHUD hideAllHUDsForView:_delegate.view animated:YES];
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
//                        [weakself saveLastLoginUsername];
                    });
                });
            } else {
                switch (error.code)
                {
                    case EMErrorNetworkUnavailable:
                        DLog( @"No network connection!");
                        break;
                    case EMErrorServerNotReachable:
                        DLog(@"Connect to the server failed!");
                        break;
                    case EMErrorUserAuthenticationFailed:
                        DLog(@"%@",error.errorDescription);
                        break;
                    case EMErrorServerTimeout:
                        DLog( @"Connect to the server timed out!");
                        break;
                    default:
                        DLog(@"Login failure");
                        break;
                }
            }
        });
    });
}



@end



