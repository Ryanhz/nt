//
//  UIButton+FEExtend.m
//  neitui
//
//  Created by hzf on 16/7/21.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "UIButton+FEExtend.h"

@implementation UIButton (FEExtend)


- (void)setImageRight {
//    DLog(@"imageView:%@",NSStringFromCGRect(self.imageView.frame))
//    DLog(@"titleLabel:%@",NSStringFromCGRect(self.titleLabel.frame))
    
    // left 向左偏移 - （self.imageView.frame.size.width + self.imageView.frame.origin.x）
    // right 向左偏移 (self.imageView.frame.size.width + self.imageView.frame.origin.x)
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width - self.imageView.frame.origin.x, 0, self.imageView.frame.size.width + self.imageView.frame.origin.x);
    
    
    // left 向右偏移 (self.frame.size.width - self.imageView.frame.size.width - self.imageView.frame.origin.x)
    
    // right 向右偏移 - (self.frame.size.width - self.imageView.frame.size.width - self.imageView.frame.origin.x)
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.frame.size.width - self.imageView.frame.size.width - self.imageView.frame.origin.x, 0, self.imageView.frame.size.width + self.imageView.frame.origin.x - self.frame.size.width);
    
//    DLog(@"imageView:%@",NSStringFromCGRect(self.imageView.frame))
//    
//    DLog(@"titleLabel:%@",NSStringFromCGRect(self.titleLabel.frame))
}

@end
