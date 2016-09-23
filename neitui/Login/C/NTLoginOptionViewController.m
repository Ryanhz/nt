//
//  loginOption.m
//  neitui
//
//  Created by hzf on 16/7/1.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTLoginOptionViewController.h"
#import "NTRefereeBaseInfoViewController.h"
#import "NTCandidateInfoVC.h"
#import "NTLoginOptionVeiw.h"

@interface NTLoginOptionViewController ()

@property (nonatomic, strong) NTLoginOptionVeiw *refereeView;
@property (nonatomic, strong) NTLoginOptionVeiw *candidateView;

@end

@implementation NTLoginOptionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _refereeView.userInteractionEnabled = YES;
    _candidateView.userInteractionEnabled = YES;
    [self.navigationController.navigationBar showBottomHairline];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    [self setupSubviews];
}

- (void)referee {
     DLog(@"")
    _refereeView.userInteractionEnabled = NO;
    
    NTRefereeBaseInfoViewController *vc = [[NTRefereeBaseInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)candidate {
//    DLog(@"")
    _candidateView.userInteractionEnabled = NO;
    NTCandidateInfoVC *candidate = [[NTCandidateInfoVC alloc]init];
    [self.navigationController pushViewController:candidate animated:YES];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupSubviews {
    _refereeView = [[NTLoginOptionVeiw alloc]initWithImage:[UIImage imageNamed:@"referee"] title:@"我要找人才" targe:self action:@selector(referee)];
    
    _candidateView = [[NTLoginOptionVeiw alloc]initWithImage:[UIImage imageNamed:@"set_candidate"] title:@"我在看机会" targe:self action:@selector(candidate)];
    
    [self.view addSubview:_candidateView];
    [self.view addSubview:_refereeView];
    
    [self setupLayoutSubviews];
}

- (void)setupLayoutSubviews {
    FEWeakSelf(weakSelf)

    [_candidateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(74);
        make.centerX.width.equalTo(weakSelf.view);
        make.height.equalTo(@(120));
    }];
    
    [_refereeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.candidateView.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.view);
        make.height.width.equalTo(weakSelf.candidateView);
      
    }];
}

@end
