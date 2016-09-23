//
//  NTCityViewController.h
//  neitui
//
//  Created by hzf on 16/7/18.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ selectedCity) (id city);

@interface NTCityViewController : NTBaseViewController

@property (nonatomic, copy) selectedCity cityBlock;

@end
