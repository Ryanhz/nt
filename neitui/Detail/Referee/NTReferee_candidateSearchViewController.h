//
//  NTReferee_candidateSearchViewController.h
//  neitui
//
//  Created by hzf on 16/8/9.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTBaseViewController.h"
typedef void(^MyBlock) (NSString *keyword, NSString *city);
@interface NTReferee_candidateSearchViewController : NTBaseViewController

@property (nonatomic, copy) MyBlock param;
@property (nonatomic, strong) NSString *city;

@end
