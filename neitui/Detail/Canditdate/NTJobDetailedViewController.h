//
//  NTJobDetailedViewController.h
//  neitui
//
//  Created by hzf on 16/7/21.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTJobDetailedViewController : NTBaseViewController

@property (nonatomic, copy) NSString *jobId;

- (instancetype)initWithjobId:(NSString *)jobId;


@end
