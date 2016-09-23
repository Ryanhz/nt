//
//  UIViewController+NTAlert.m
//  neitui
//
//  Created by hzf on 16/7/14.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "UIViewController+NTAlert.h"

@implementation UIViewController (NTAlert)



- (void)showAlertTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    FEWeakSelf(weakSelf)
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
           [weakSelf dismissViewControllerAnimated:YES completion:^{
               
           }];
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

@end
