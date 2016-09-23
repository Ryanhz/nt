//
//  UIView+FEExtend.m
//  neitui
//
//  Created by hzf on 16/7/9.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "UIView+FEExtend.h"

@implementation UIView (FEExtend)

- (void)fe_addCorner:(UIRectCorner)corner size:(CGSize)size {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.masksToBounds = YES;
    
}

@end

@implementation UIView (FELayout)

- (void)setupSubViews {

}

- (void)setupLayouts {
    
}

@end