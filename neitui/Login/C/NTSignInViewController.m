//
//  ViewController.m
//  Neitui
//
//  Created by hzf on 16/6/30.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTSignInViewController.h"
#import "SignInAndUpHelper.h"
#import "NTLoginOptionViewController.h"

@interface NTSignInViewController ()<SignInAndUpDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *sinaSignInBtn;
@property (nonatomic, strong) UIButton *qqSignInBtn;
@property (nonatomic, strong) UIButton *wxSignInBtn;

@end

@implementation NTSignInViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupSubviews];
}

- (void)signInAndUpHelper:(SignInAndUpHelper *)helper isSuccess:(BOOL)isSuccess {
    if (!isSuccess) {
        return;
    }
    
    NTLoginOptionViewController *optionViewController = [[NTLoginOptionViewController alloc]init];
    [self.navigationController pushViewController:optionViewController animated:YES];
}

- (void)sinaSignIn {
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//    [SignInAndUpHelper shareHelper].delegate = self;
//    [[SignInAndUpHelper shareHelper] loginSuccess];
//    [[SignInAndUpHelper shareHelper] loginWithType:UM_sina delegate:self];
    
    
//    NTUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:userFile];
//    [[SignInAndUpHelper shareHelper] :user];
    [self signInAndUpHelper:nil isSuccess:YES];
//    [self loginWithUsername:@"1" password:@"11"];
}


- (void)qqSignIn {
    [[SignInAndUpHelper shareHelper] loginWithType:UM_qq delegate:self];
}

- (void)wxSignIn {
    [[SignInAndUpHelper shareHelper] loginWithType:Um_wx delegate:self];
}

- (void)setupSubviews {
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = [UIImage imageNamed:@"Group"];
    
    _label = [[UILabel alloc] init];
    _label.text = @"选择登陆方式:";
    _label.font = [UIFont systemFontOfSize:NTFontSize_14];
    _label.textColor = UIColorFromRGB(0x3a3a3a);
    
    _sinaSignInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sinaSignInBtn setImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
//    [_sinaSignInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sinaSignInBtn addTarget:self action:@selector(sinaSignIn) forControlEvents:UIControlEventTouchUpInside];
    
    _qqSignInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_qqSignInBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
//    [_qqSignInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_qqSignInBtn addTarget:self action:@selector(qqSignIn) forControlEvents:UIControlEventTouchUpInside];
    
    _wxSignInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wxSignInBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
//    [_wxSignInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wxSignInBtn addTarget:self action:@selector(wxSignIn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_label];
    [self.view addSubview:_sinaSignInBtn];
    [self.view addSubview:_qqSignInBtn];
    [self.view addSubview:_wxSignInBtn];
    [self setupLayoutSubviews];
}

- (void)setupLayoutSubviews {
    FEWeakSelf(weakSelf)
   [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(weakSelf.view);
   }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(431 * k_v_Scale));
        make.left.equalTo(@(52 * k_h_Scale));
        make.width.equalTo(@(105 * k_h_Scale));
        make.height.equalTo(@(21 * k_v_Scale));
    }];
    
    NSArray *arr = @[_wxSignInBtn, _qqSignInBtn, _sinaSignInBtn];

//    固定等间距
//    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:22 leadSpacing:52 tailSpacing:52];
//动态间距
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 * k_v_Scale leadSpacing:52 * k_h_Scale tailSpacing:52 * k_h_Scale];
//
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(50 * k_v_Scale));
        make.bottom.equalTo(weakSelf.view).offset(- 48 * k_v_Scale);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
