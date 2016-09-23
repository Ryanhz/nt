//
//  UILabel+FEExtend.m
//  neitui
//
//  Created by hzf on 16/7/18.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "UILabel+FEExtend.h"

@implementation UILabel (FEExtend)


- (void)configFontSize:(CGFloat)size textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment {
    
    self.font = [UIFont systemFontOfSize:size];
    self.textColor = textColor;
    self.textAlignment = textAlignment;
}

@end
