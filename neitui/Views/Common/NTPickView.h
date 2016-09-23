//
//  NTPickView.h
//  neitui
//
//  Created by hzf on 16/7/25.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^pickViewBlock) (id data);

@interface NTPickView : UIView

@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) pickViewBlock selectBlock;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger numberOfComponents;
@property (nonatomic, assign) NSInteger rowHeight;

- (void)show;
- (void)hide;

@end
