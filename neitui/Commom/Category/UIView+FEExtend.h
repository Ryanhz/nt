//
//  UIView+FEExtend.h
//  neitui
//
//  Created by hzf on 16/7/9.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FEExtend)

/**
 *  设置view的圆角
 *
 *  @param corner UIRectCorner
 *  @param size   左右的cornerRadii
 */
- (void)fe_addCorner:(UIRectCorner)corner size:(CGSize)size;

@end

@interface UIView (FELayout)

- (void)setupSubViews;

- (void)setupLayouts;

@end