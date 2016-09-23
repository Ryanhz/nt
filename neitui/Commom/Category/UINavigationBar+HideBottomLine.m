//
//  UINavigationBar+HideBottomLine.m
//  neitui
//
//  Created by hzf on 16/7/9.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "UINavigationBar+HideBottomLine.h"

@implementation UINavigationBar (HideBottomLine)


- (void)hideBottomHairline {
    UIImageView *imageVeiw = [self hairlineImageViewInNavigationBarWithView:self];
    imageVeiw.hidden = YES;
}

- (void)showBottomHairline {
    UIImageView *imageVeiw = [self hairlineImageViewInNavigationBarWithView:self];
    imageVeiw.hidden = NO;
}

- (UIImageView *)hairlineImageViewInNavigationBarWithView:(UIView *)view {
    if ([view isKindOfClass:[UIImageView class]] && view.frame.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subView in view.subviews) {
        
        UIImageView *imageView = [self hairlineImageViewInNavigationBarWithView:subView];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end

/*
 
 func hideHairline() {
 let navigationBarImageView = hairlineImageViewInToolbar(self)
 navigationBarImageView!.hidden = true
 }
 
 func showHairline() {
 let navigationBarImageView = hairlineImageViewInToolbar(self)
 navigationBarImageView!.hidden = false
 }
 
 private func hairlineImageViewInToolbar(view: UIView) -> UIImageView? {
 if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
 return (view as UIImageView)
 }
 
 let subviews = (view.subviews as [UIView])
 for subview: UIView in subviews {
 if let imageView: UIImageView = hairlineImageViewInToolbar(subview)? {
 return imageView
 }
 }
 
 return nil
 }

 */