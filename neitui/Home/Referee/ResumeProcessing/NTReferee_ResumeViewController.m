//
//  NTReferee_ResumeViewController.m
//  neitui
//
//  Created by hzf on 16/8/8.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTReferee_ResumeViewController.h"
#import "NTSildeView.h"
#import "NTReferee_recieveCondidateView.h"
#import "NTReferee_ResumeSubViewController.h"
#import "NTReferee_candidateDetailViewController.h"

@interface NTReferee_ResumeViewController ()<UIScrollViewDelegate,NTSildeViewDelegate, NTReferee_ResumeSubViewControllerDelegate>

@property (nonatomic, strong) NTSildeView *silderView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NTReferee_ResumeSubViewController *subVC0; //未读已查看
@property (nonatomic, strong) NTReferee_ResumeSubViewController *subVC1; //已内推
@property (nonatomic, strong) NTReferee_ResumeSubViewController *subVC2; //已通知面试
@property (nonatomic, strong) NTReferee_ResumeSubViewController *subVC3; // 不通过

@end

@implementation NTReferee_ResumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收到的简历";
    [self setupSubviews];
    
//    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 uid
 登陆用户编号
 type
 简历类型（0：未读，1: 已查看；3：已内推；4：已通知面试；-1：不通过）
 */
- (void)getData {
    
    NSDictionary *param = @{
                            @"uid" : @"2",
                            @"type" : @"0"
                            };
    
    [NTNetHelper recieveCondidatesWithParam:param success:^(id data) {
        DLog(@"data:%@",data);
    } failure:^(NSError *error) {
        DLog(@"error:%@",error);
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    DLog(@"%f",scrollView.contentOffset.x);
    _silderView.offsetX = scrollView.contentOffset.x;
}


- (void)NTSildeView:(NTSildeView *)sildeView selectIndex:(NSUInteger)index {
    [_scrollView setContentOffset:CGPointMake(KSCREEN_WIDTH * index, 0)];
}

- (void)selectedModel:(NTRecieveCondidateModel *)model indexPath:(NSIndexPath *)indexPath type:(NTResumeType)type {
    
    NTReferee_candidateDetailViewController *resumePreviewViewController = [[NTReferee_candidateDetailViewController alloc]initWithUid:model.uid];
    resumePreviewViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resumePreviewViewController animated:YES];
}

- (void)setupSubviews {
    
    _silderView = [[NTSildeView alloc]initWithTitles:@[@"未处理", @"以内推", @"已通知面试", @"未通过"]];
    _silderView.delegate = self;
        
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.alwaysBounceHorizontal = YES;
    
    _contentView = [UIView new];
    _contentView.backgroundColor = NTBGGreyColor;

    _subVC0 = [[NTReferee_ResumeSubViewController alloc] initWithType:NTResumeType_unread];
//    _subVC0.view.backgroundColor = [UIColor grayColor];
    _subVC0.delegate = self;
    
    _subVC1 = [[NTReferee_ResumeSubViewController alloc] initWithType:NTResumeType_referenced];
//    _subVC1.view.backgroundColor = [UIColor yellowColor];
    _subVC1.delegate = self;
    
    _subVC2 = [[NTReferee_ResumeSubViewController alloc] initWithType:NTResumeType_interview];
//   _subVC2.view.backgroundColor = [UIColor blueColor];
    _subVC2.delegate = self;
    
    _subVC3 = [[NTReferee_ResumeSubViewController alloc] initWithType:NTResumeType_noPass];
//    _subVC3.view.backgroundColor = [UIColor orangeColor];
    _subVC3.delegate = self;
    
    NSArray *array = @[_subVC0.view , _subVC1.view, _subVC2.view, _subVC3.view];
 
    [self.scrollView addSubview:_contentView];
    [_contentView addSubview:_subVC0.view];
    [_contentView addSubview:_subVC1.view];
    [_contentView addSubview:_subVC2.view];
    [_contentView addSubview:_subVC3.view];

    
    [self.view addSubview:_silderView];
    [self.view addSubview:_scrollView];
 
    FEWeakSelf(weakSelf)
    
    [_silderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@34);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64 + 34, 0, 50, 0));
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollView);
        make.height.equalTo(weakSelf.view).offset(-(64 + 34 + 50));
        make.width.equalTo(weakSelf.view).multipliedBy(4);
    }];
    
    
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:KSCREEN_WIDTH leadSpacing:0 tailSpacing:0];
    
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.view).offset(-(64 + 34 + 50));
        make.top.equalTo(weakSelf.view).offset(64+34);
        make.bottom.equalTo(weakSelf.contentView);
    }];
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
