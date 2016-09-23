//
//  UISearchBar+TextFiled.m
//  FESearchBarViewController
//
//  Created by hzf on 16/7/5.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "UISearchBar+TextFiled.h"

#define IS_IOS9 [[UIDevice currentDevice].systemVersion doubleValue] >= 9

@implementation UISearchBar (TextFiled)

- (UITextField *)getTextFiled {
    UITextField *searchField = [self valueForKey:@"searchField"];
    if (searchField) {
        
        return searchField;
    }
    return nil;
}

- (void)fe_setTextFont:(UIFont *)font {
    if (IS_IOS9) {
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].font = font;
    }else {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:font];
    }
}

- (void)fe_setTextColor:(UIColor *)textColor {
    
    if (IS_IOS9) {
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].textColor = textColor;
    }else {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:textColor];
    }
}

- (void)fe_setCancelButtonTitle:(NSString *)title {
    if (IS_IOS9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:title];
    }
}

@end
