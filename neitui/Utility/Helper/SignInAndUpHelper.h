//
//  SignInAndUpHelper.h
//  Neitui
//
//  Created by hzf on 16/6/30.
//  Copyright © 2016年 neitui. All rights reserved.
//


typedef NS_ENUM(NSInteger){
    UM_qq = 0,
    UM_sina,
    Um_wx
}UMLoginType;

#import <Foundation/Foundation.h>
#import "NTSignInViewController.h"

@protocol SignInAndUpDelegate;


@interface SignInAndUpHelper : NSObject

@property (nonatomic, weak) UIViewController <SignInAndUpDelegate> *delegate;

/**
 *  获取一个登陆注册单例对象
 *
 *  @return 单例对象
 */
+ (instancetype)shareHelper;

/**
 *  友盟第三方登陆
 *
 *  @param type  第三方平台
 *  @param targe 点击后弹出的分享页面或者授权页面所在的UIViewController对象
 */
- (void)loginWithType:(UMLoginType)type delegate:(UIViewController<SignInAndUpDelegate> *)delegate;

- (void)loginSuccess;

- (void)login;

@end

@protocol SignInAndUpDelegate <NSObject>

- (void)signInAndUpHelper:(SignInAndUpHelper *)helper isSuccess:(BOOL)isSuccess;

@end
