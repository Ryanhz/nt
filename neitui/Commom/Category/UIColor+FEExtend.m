//
//  UIColor+FEExtend.m
//  neitui
//
//  Created by hzf on 16/7/20.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "UIColor+FEExtend.h"

@implementation UIColor (FEExtend)

- (BOOL)isEqualToColor:(UIColor *)color {
    if (CGColorEqualToColor(self.CGColor, color.CGColor)) {
        return YES;
    }
    return NO;
}

@end
