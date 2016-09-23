//
//  NTCompanyHomeViewController.h
//  neitui
//
//  Created by hzf on 16/7/27.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTBaseViewController.h"
#import "NTCompanymodel.h"
@interface NTCompanyHomeViewController : NTBaseViewController

- (instancetype)initWithCid:(NSString *)cid;

@property (nonatomic, copy) NSString *cid;

@end
