//
//  NTReferenceViewController.m
//  neitui
//
//  Created by hzf on 16/7/1.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTFollowViewController.h"
#import "UIButton+FEExtend.h"
#import "NTOptionsView.h"
#import "NTMy_FollowedRefereeList.h"
#import "NTMy_followedCompanyList.h"
#import "NTMyFollowView.h"
#import "NTFansView.h"
#import "FEProtocol.h"
#import "NTCompanyHomeViewController.h"
#import "NTJobDetailedViewController.h"
#import "NTMy_FollowedRefereeModel.h"
#import "NTReferenceDetailsVC.h"


#define kRefereeCellIdentifier @"refereeCell"

@interface NTFollowViewController ()<NTMyFollowDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *chooseArray;
@property (nonatomic, strong) NTOptionsView *optionsView;
@property (nonatomic, strong) UIButton *tabButton;
@property (nonatomic, strong) NTMyFollowView *followView;
@property (nonatomic, strong) NTFansView *fansView;

@end

@implementation NTFollowViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注";
    FEWeakSelf(weakSelf)
    [NTNetHelper getFollowRefereeWithSuccess:^(NTMy_FollowedRefereeList *model) {
         weakSelf.followView.referee_Followsnums = model.followsnum;
        weakSelf.followView.follows = model.follows;
        [weakSelf.followView reloadData];
        
        weakSelf.fansView.referee_Followsnums = model.followsnum;
        weakSelf.fansView.referees =  model.follows;
        weakSelf.fansView.candidate_Followsnums = @"2222";
        NTMy_FollowedRefereeModel *md = model.follows[0];
        weakSelf.fansView.candidates = @[md,md,md,md,md,md,md,md,md];
        [weakSelf.fansView reloadData];
        
    } failure:^(NSError *error) {
        DLog(@"error:%@",error)
    }];

    [NTNetHelper getCompanyListWithSuccess:^(NTMy_followedCompanyList *model) {
        weakSelf.followView.companys = model.company;
        weakSelf.followView.companys_Followsnums = [NSString stringWithFormat:@"%ld", model.company.count];
        [weakSelf.followView reloadData];
    } failure:^(NSError *error) {
        DLog(@"error:%@",error)
    }];
    
    [self setupSubviews];
}

- (void)resetData {
    
}

- (void)reference {
    
}


- (void)leftSegmentedItemAction {
    DLog(@"")
}

- (void) rightSegmentedItemAction {
    DLog(@"")
}

- (void)showCustomSegmented:(UIButton *)button {
    button.selected = !button.selected;
    if (self.optionsView.isShow) {
        [self.optionsView hide];
    } else {
        [self.optionsView show];
    }
}

- (void)tableView:(UITableView *)tableView selectedModel:(id)model modelType:(myfollowModel)type {
    
    DLog(@"%ld",type)
    switch (type) {
        case follow_company_model:
        {
            NTMy_followedCompanyModel *cpmodel = (NTMy_followedCompanyModel *)model;
            NTCompanyHomeViewController *companyHomeVC = [[NTCompanyHomeViewController alloc]initWithCid:cpmodel.id];
            companyHomeVC.title = cpmodel.cnname;
            companyHomeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:companyHomeVC animated:YES];
        }
            break;
        case follow_referee_model:{
            NTMy_FollowedRefereeModel *refereeModel = model;
            NTReferenceDetailsVC *detailVC = [[NTReferenceDetailsVC alloc] initWithUid:refereeModel.uid];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case fans_candidate_model: {
            
        }
            break;
        case fans_referee_model: {
            NTMy_FollowedRefereeModel *refereeModel = model;
            NTReferenceDetailsVC *detailVC = [[NTReferenceDetailsVC alloc] initWithUid:refereeModel.uid];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark-------------------------<#(^ 0 - o - 0^)#>
- (void)setUpTitleView {
    _tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _tabButton.bounds = CGRectMake(0, 0, 85, 24);
    _tabButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_tabButton setTitleColor:NTBlackColor forState:UIControlStateNormal];
    [_tabButton setTitle:@"我的关注" forState:UIControlStateNormal];
    [_tabButton setImage:[[UIImage imageNamed:@"down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_tabButton setImage: [[UIImage imageNamed:@"up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [_tabButton addTarget:self action:@selector(showCustomSegmented:) forControlEvents:UIControlEventTouchUpInside];
    [_tabButton setImageRight];
    self.navigationItem.titleView = _tabButton;
}

- (void)setupSubviews {
    [self setUpTitleView];
    
    [self.view addSubview:self.followView];
    [self.view addSubview:self.fansView];
    
    FEWeakSelf(weakSelf)
    
    [_followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 50, 0));
    }];
    
    [_fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 50, 0));
    }];
    
}


- (NTOptionsView *)optionsView {
    if (!_optionsView) {
        _optionsView = [[NTOptionsView alloc]initWithFrame:CGRectMake(0, 56, KSCREEN_WIDTH, KSCREEN_HEIGHT - 56- 50)];
        NTOptionsItem *item1 = [[NTOptionsItem alloc]init];
        item1.title = @"我的关注";
        item1.index = 0;
        
        NTOptionsItem *item2 = [[NTOptionsItem alloc]init];
        item2.title = @"我的粉丝";
        item2.index = 1;
        _optionsView.items = @[item1, item2];
        
        FEWeakSelf(weakSelf)
        _optionsView.selectedBlock = ^(NTOptionsItem *item) {
            [weakSelf.tabButton setTitle:item.title forState:UIControlStateNormal];
            weakSelf.tabButton.selected = NO;
            
            if (item.index == 0) {
                weakSelf.followView.hidden = NO;
                weakSelf.fansView.hidden = YES;
            } else {
                weakSelf.followView.hidden = YES;
                weakSelf.fansView.hidden = NO;
            }
            
        };
    }
    return _optionsView;
}

- (NTMyFollowView *)followView {
    if (!_followView) {
        _followView = [[NTMyFollowView alloc]init];
        _followView.delegate = self;
    }
    return _followView;
}

- (NTFansView *)fansView {

    if (!_fansView) {
        _fansView = [NTFansView new];
        _fansView.hidden = YES;
        _fansView.delegate = self;
        
        
    }
    return _fansView;
}

@end
