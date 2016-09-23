//
//  NTReference_MainTabBarViewController.h
//  neitui
//
//  Created by hzf on 16/7/26.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTReferee_ResumeViewController.h"
#import "NTMessageViewController.h"
#import "NTReferee_CandidateViewController.h"
#import "NTReferee_MyViewController.h"

@interface NTReference_MainTabBarViewController : UITabBarController
@property (nonatomic, strong) NTReferee_ResumeViewController        *resumeViewController;        // 首页
@property (nonatomic, strong) NTMessageViewController               *messageViewController;     //
@property (nonatomic, strong) NTReferee_MyViewController            *reference_MyViewController;
@property (nonatomic, strong) NTReferee_CandidateViewController     *candidateViewController;


@end
