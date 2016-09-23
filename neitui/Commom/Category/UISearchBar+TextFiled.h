//
//  UISearchBar+TextFiled.h
//  FESearchBarViewController
//
//  Created by hzf on 16/7/5.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (TextFiled)

- (UITextField *)getTextFiled;

- (void)fe_setTextFont:(UIFont *)font;

- (void)fe_setCancelButtonTitle:(NSString *)title;

- (void)fe_setTextColor:(UIColor *)textColor;

@end
