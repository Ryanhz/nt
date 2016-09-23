//
//  NTReferee_ResumeSubViewController.h
//  neitui
//
//  Created by hzf on 16/8/9.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTBaseViewController.h"
#import "NTRecieveCondidateModel.h"

/*
 uid
 登陆用户编号
 type
 简历类型（0：未读，1: 已查看；3：已内推；4：已通知面试；-1：不通过）
 */

typedef NS_ENUM(NSInteger, NTResumeType) {
    NTResumeType_unread = 0, //0：未读，
    NTResumeType_finishedRead = NTResumeType_unread, //1: 已查看；
    NTResumeType_referenced = 3, //3：已内推；
    NTResumeType_interview = 4, //4：已通知面试；
    NTResumeType_noPass = -1, //-1：不通过
};


@protocol NTReferee_ResumeSubViewControllerDelegate <NSObject>

- (void)selectedModel:(NTRecieveCondidateModel *)model indexPath:(NSIndexPath *)indexPath type:(NTResumeType)type;

@end

@interface NTReferee_ResumeSubViewController : NTBaseViewController

@property (nonatomic, weak) id <NTReferee_ResumeSubViewControllerDelegate>delegate;
- (instancetype)initWithType:(NTResumeType)Type;

@end
