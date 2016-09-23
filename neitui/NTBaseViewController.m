//
//  NTBaseViewController.m
//  neitui
//
//  Created by hzf on 16/7/11.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTBaseViewController.h"

@interface NTBaseViewController ()

@end

@implementation NTBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.extendedLayoutIncludesOpaqueBars = NO;
    [self.navigationController.navigationBar hideBottomHairline];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar showBottomHairline];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = NTBGGreyColor;
    // Do any additional setup after loading the view.
}


- (void)showAlert:(NSString *)title message:(NSString *)message leftAction:(void(^)(NSString *title))leftAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}


- (void)setDefaultBackBarItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(defaultBackBarItemAction)];
}

- (void)defaultBackBarItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)setTitle:(NSString *)title {
//    if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
//        <#statements#>
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
