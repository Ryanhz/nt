//
//  NTPickDateView.h
//  neitui
//
//  Created by hzf on 16/8/3.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^pickViewBlock) (id data);

@interface NTPickDateView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) pickViewBlock selectBlock;

- (void)show;
- (void)hide;

@end
