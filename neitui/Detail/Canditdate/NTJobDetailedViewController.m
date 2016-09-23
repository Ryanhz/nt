//
//  NTJobDetailedViewController.m
//  neitui
//
//  Created by hzf on 16/7/21.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTJobDetailedViewController.h"
#import "NSDictionary+Job.h"
#import "NTMarkView.h"
#import "NTJobDetailModel.h"
#import "NTJobRefereeModel.h"
#import "NSString+FEExtend.h"
#import "NTReferenceDetailsVC.h"


@interface NTJobDetailedViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) NTJobDetailModel *jobDetailModel;
@property (nonatomic, strong) NTJobRefereeModel *jobRefereeModel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *jobBGVeiw;
@property (nonatomic, strong) UILabel *jobNameLabel;
@property (nonatomic, strong) UILabel *postTimeLabel;
@property (nonatomic, strong) UILabel *jobInfoLabel;
@property (nonatomic, strong) NTMarkView *markView;

@property (nonatomic, strong) UIView *detailBGVeiw;
@property (nonatomic, strong) UILabel *detailTitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIView *publisherBGVeiw;
@property (nonatomic, strong) UILabel *publisherTitleLabel;
@property (nonatomic, strong) UIButton *publisherNameBtn;
@property (nonatomic, strong) UIImageView *publisherAvatar;
@property (nonatomic, strong) UILabel *publisherDepartment;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *linkBtn;
@property (nonatomic, strong) UIButton *postResumeBtn;
//@property (nonatomic, copy) NSString *text;


@end

@implementation NTJobDetailedViewController
- (void)dealloc {
    [_followButton removeObserver:self forKeyPath:@"selected"];
}

- (instancetype)initWithjobId:(NSString *)jobId {
    self = [super init];
    if (self) {
        _jobId = jobId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.scrollView.contentSize = self.contentView.frame.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职位详情";
    [self setDefaultBackBarItem];
  
    [self setRightBarItems];
    FEWeakSelf(weakSelf)
    [NTNetHelper getjobDetailWithJobId:_jobId Success:^(id data) {
        NSArray *array = data;
        weakSelf.jobDetailModel = data[0];
        weakSelf.jobRefereeModel = data[1];
        [weakSelf setupSubviews];
        [weakSelf config:array];
    } failure:^(NSError *error) {
        DLog(@"error%@",error)
    }];
    
    
    // Do any additional setup after loading the view.
}

- (void)setRightBarItems {
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    share.frame =CGRectMake(0, 0, 32, 20);
    share.titleLabel.font = [UIFont systemFontOfSize:NTFontSize_10];
    share.layer.borderColor = NTBlueColor.CGColor;
    share.layer.borderWidth = 1;
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share setTitleColor:NTBlueColor forState:UIControlStateNormal];
    [share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *storeUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    storeUp.frame =CGRectMake(0, 0, 32, 20);
    storeUp.titleLabel.font = [UIFont systemFontOfSize:NTFontSize_10];
    storeUp.layer.borderColor = NTBlueColor.CGColor;
    storeUp.layer.borderWidth = 1;
    [storeUp setTitle:@"收藏" forState:UIControlStateNormal];
    [storeUp setTitleColor:NTBlueColor forState:UIControlStateNormal];
    [storeUp addTarget:self action:@selector(storeUp:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:share];
    
    UIBarButtonItem *storeUpItem = [[UIBarButtonItem alloc] initWithCustomView:storeUp];
    
    self.navigationItem.rightBarButtonItems = @[storeUpItem, shareItem];
}

- (void)config:(id)data{
    
   
    NSNumber *follow = data[2];
    if ([follow isEqual:@1]) {
        _followButton.selected = YES;
    }
    
    _jobNameLabel.text = self.jobDetailModel.position;
    
    NSString *sr = [NSString stringWithFormat:@"%@k~%@k",_jobDetailModel.beginsalary,_jobDetailModel.endsalary];
    _jobInfoLabel.text = [NSString stringWithFormat:@"%@·%@·%@·%@",_jobDetailModel.city,_jobDetailModel.cpname,[NSDictionary getWork_ExperienceStringWithKey:_jobDetailModel.experience],sr];
    
    NSString *update = [_jobDetailModel.updatetime timeStringTransformToTimedescription];
    _postTimeLabel.text = update;
    
    _detailLabel.attributedText = [_jobDetailModel.detail attributedStringWithFontSize:NTFontSize_10 lineSpacing:8];
    [_publisherAvatar sd_setImageWithURL:[NSURL URLWithString:_jobRefereeModel.avatar] placeholderImage:[UIImage imageNamed:@"placeholderHead"]] ;
    [_publisherNameBtn setTitle:_jobRefereeModel.name forState:UIControlStateNormal];
    _publisherDepartment.text = _jobRefereeModel.department;
    
}

#pragma mark-------------------------observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selected"]) {
        //followBtn selected state change
        NSNumber *new = change[@"new"];
        NSNumber *old = change[@"old"];
        if ([new isEqual:old]) {
            return;
        }
         _followButton.layer.borderColor = [new isEqual:@1] ? NTBlueColor.CGColor : NTGreyColor.CGColor;
    }
}

#pragma mark-------------------------button Action

- (void)share:(UIButton *)sender {
    DLog(@"%@",sender)
}

- (void)storeUp:(UIButton *)sender {
    
    NSDictionary *param = @{@"jid" : _jobDetailModel.id ,@"uid" : @"1", @"status" : @"1"};
    
    [NTNetHelper jobcollectWithParam:param Success:^(id data) {
        DLog(@"%@",data);
    } failure:^(NSError *error) {
        DLog(@"error:%@", error)
    }];
}

- (void)follow:(UIButton *)sender {
     static  BOOL canClick = YES;
    if (!canClick) {
        return;
    }
    canClick = NO;
    NSString *type = !sender.selected ? @"2" : @"1";
    
    NSString *title = nil;
    if ([type isEqualToString:@"2"]) {
        title = @"成功添加关注";
        
    } else {
        title = @"已取消关注";
    }
    
    FEWeakSelf(weakSelf)
    [NTNetHelper followRefereesWithId:_jobRefereeModel.uid type:type Success:^(id data) {
        canClick = YES;
         sender.selected = !sender.selected;
        DLog(@"%@",data);
         [weakSelf.view makeToast:title duration:1 position:CSToastPositionCenter];
    } failure:^(NSError *error) {
        canClick = YES;
        DLog(@"error:%@",error);
         [weakSelf.view makeToast:@"操作失败" duration:1 position:CSToastPositionCenter];
    }];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"%ld",buttonIndex)
    
    if (buttonIndex>=2) {
        return;
    }
        NSDictionary *param = @{@"uid" : @"1",
                                @"jid" : _jobDetailModel.id,
                                @"touid" : _jobRefereeModel.uid,
                                @"type" : [NSString stringWithFormat:@"%ld", buttonIndex]};
    
        [NTNetHelper deliveryWithParam:param Success:^(id data) {
             DLog(@"%@",data);
        } failure:^(NSError *error) {
            DLog(@"error:%@",error);
        }];
}

- (void)link{
    
}

- (void)postResume {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择要投递的简历" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"在线简历" otherButtonTitles:@"附件简历", nil];
    [actionSheet showInView:self.view];
    

}

- (void)reference:(UIButton *)sender {
    DLog(@"")
    
    NTReferenceDetailsVC *referenceDetailsVC = [[NTReferenceDetailsVC alloc] initWithUid:_jobRefereeModel.uid];
    
    [self.navigationController pushViewController:referenceDetailsVC animated:YES];
    
}

#pragma mark-------------------------setupSubviews
- (void)setupSubviews {
    //
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    //
    UIView *line1 = [UIView new];
    line1.backgroundColor = NTBGGreyColor;
    
    _markView = [[NTMarkView alloc]initWithTitles:_jobDetailModel.wtagnames];
    CGFloat markView_height = _markView.height;
    [self.contentView addSubview:self.jobBGVeiw];
    [self.jobBGVeiw addSubview:self.jobNameLabel];
    [self.jobBGVeiw addSubview:line1];
    [self.jobBGVeiw addSubview:self.jobInfoLabel];
    [self.jobBGVeiw addSubview:self.postTimeLabel];
    [self.jobBGVeiw addSubview:_markView];
    
    //
    UIView *line2 = [UIView new];
    line2.backgroundColor = NTBGGreyColor;
    
    [self.contentView addSubview:self.detailBGVeiw];
    [self.detailBGVeiw addSubview:self.detailTitleLabel];
    [self.detailBGVeiw addSubview:line2];
    [self.detailBGVeiw addSubview:self.detailLabel];
    
    CGFloat detailLabel_height = 0;
    
    
    detailLabel_height = [_jobDetailModel.detail newlineStringHeightWithFontOfSize:NTFontSize_10 lineSpacing:8 maxSize:CGSizeMake(KSCREEN_WIDTH - 40, CGFLOAT_MAX)];
    //
    UIView *line3 = [UIView new];
    line3.backgroundColor = NTBGGreyColor;
    
    [self.contentView addSubview:self.publisherBGVeiw];
    [self.publisherBGVeiw addSubview:self.publisherTitleLabel];
    [self.publisherBGVeiw addSubview:line3];
    [self.publisherBGVeiw addSubview:self.publisherAvatar];
    [self.publisherBGVeiw addSubview:self.publisherNameBtn];
    [self.publisherBGVeiw addSubview:self.publisherDepartment];
    [self.publisherBGVeiw addSubview:self.followButton];
    
    [self.view addSubview:self.linkBtn];
    [self.view addSubview:self.postResumeBtn];
    
    FEWeakSelf(weakSelf)
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.bottom.right.equalTo(weakSelf.view);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollView);
//        make.height.equalTo(weakSelf.scrollView);
    }];
    //
    [_jobBGVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.left.right.equalTo(weakSelf.contentView);
    }];
    
    [_jobNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.jobBGVeiw).offset(20);
        make.left.equalTo(weakSelf.jobBGVeiw).offset(20);
        make.height.equalTo(@20);
        make.right.equalTo(weakSelf.postTimeLabel.mas_left);
    }];
    
    [_jobInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.jobNameLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.jobNameLabel);
        make.height.equalTo(@15);
        make.right.equalTo(weakSelf.jobBGVeiw).offset(-20);
    }];
    
    [_postTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.jobNameLabel);
        make.right.equalTo(weakSelf.jobBGVeiw).offset(-20);
        make.height.equalTo(@15);
        make.width.equalTo(@80);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.jobBGVeiw);
        make.height.equalTo(@3);
        make.top.equalTo(weakSelf.jobInfoLabel.mas_bottom).offset(18);
    }];
    
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.jobBGVeiw);
        make.top.equalTo(line1.mas_bottom);
        make.bottom.equalTo(weakSelf.jobBGVeiw);
        make.height.equalTo(@(markView_height));
    }];
    
    //
    [_detailBGVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.jobBGVeiw.mas_bottom).offset(10);
        make.left.right.equalTo(weakSelf.contentView);
    }];
    
    [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detailBGVeiw).offset(6);
        make.left.equalTo(weakSelf.detailBGVeiw).offset(20);
        make.height.equalTo(@17);
        make.width.equalTo(@80);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detailTitleLabel.mas_bottom).offset(6);
        make.left.right.equalTo(weakSelf.detailBGVeiw);
        make.height.equalTo(@3);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.detailBGVeiw).offset(20);
        make.right.equalTo(weakSelf.detailBGVeiw).offset(-20);
        make.height.equalTo(@(detailLabel_height));
        make.bottom.equalTo(weakSelf.detailBGVeiw).offset(-10);
    }];
    
    //
    [_publisherBGVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detailBGVeiw.mas_bottom).offset(10);
        make.left.right.equalTo(weakSelf.contentView);
    }];
    
    [_publisherTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.publisherBGVeiw).offset(6);
        make.left.equalTo(weakSelf.publisherBGVeiw).offset(20);
        make.height.equalTo(@17);
        make.width.equalTo(@80);
    }];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.publisherTitleLabel.mas_bottom).offset(6);
        make.left.right.equalTo(weakSelf.publisherBGVeiw);
        make.height.equalTo(@3);
    }];
    
    [_publisherAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.publisherBGVeiw).offset(50);
        make.left.equalTo(weakSelf.publisherBGVeiw).offset(20);
        make.width.height.equalTo(@44);
        make.bottom.equalTo(weakSelf.publisherBGVeiw).offset(-50);
    }];
    
    [_publisherNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.publisherAvatar);
        make.left.equalTo(weakSelf.publisherAvatar.mas_right).offset(20);
        make.height.equalTo(@20);
//        make.width.equalTo(@200);
        
    }];
    
    [_publisherDepartment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.publisherNameBtn.mas_bottom).offset(7);
        make.left.equalTo(weakSelf.publisherNameBtn);
        make.height.equalTo(@15);
        make.right.equalTo(weakSelf.followButton.mas_left);
    }];
    
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.publisherBGVeiw);
        make.right.equalTo(weakSelf.publisherBGVeiw).offset(-20);
        make.height.equalTo(@22);
        make.width.equalTo(@50);
    }];
    
    //
    [_linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.equalTo(weakSelf.view);
        make.height.equalTo(@43);
        make.width.equalTo(@87);
//        make.bottom.equalTo(weakSelf.contentView).offset(-100).priorityLow();
    }];
    
    [_postResumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.height.equalTo(weakSelf.linkBtn);
        make.right.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.linkBtn.mas_right);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.bottom.equalTo(weakSelf.publisherBGVeiw).offset(100);
        make.width.equalTo(weakSelf.view);
    }];
}

#pragma mark-------------------------s

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
        
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIView *)jobBGVeiw {
    if (!_jobBGVeiw) {
        _jobBGVeiw = [UIView new];
        _jobBGVeiw.backgroundColor = [UIColor whiteColor];
    }
    return _jobBGVeiw;
}

- (UILabel* )jobNameLabel {
    if (!_jobNameLabel) {
        _jobNameLabel = [UILabel new];
        [_jobNameLabel configFontSize:NTFontSize_14 textColor:NTBlackColor textAlignment:0];
    }
    return _jobNameLabel;
}

- (UILabel *)jobInfoLabel {
    if (!_jobInfoLabel) {
        _jobInfoLabel = [UILabel new];
        [_jobInfoLabel configFontSize:NTFontSize_10 textColor:NTBlackColor textAlignment:0];
    }
    return _jobInfoLabel;
}

- (UILabel *)postTimeLabel {
    if (!_postTimeLabel) {
        _postTimeLabel = [UILabel new];
        [_postTimeLabel configFontSize:NTFontSize_10 textColor:NTGreyColor textAlignment:NSTextAlignmentRight];
    }
    return _postTimeLabel;
}

//职位详情
- (UIView *)detailBGVeiw {
    if (!_detailBGVeiw) {
       _detailBGVeiw = [UIView new];
        _detailBGVeiw.backgroundColor = [UIColor whiteColor];
    }
    return _detailBGVeiw;
}

- (UILabel *)detailTitleLabel {
    if (!_detailTitleLabel) {
        _detailTitleLabel = [UILabel new];
        _detailTitleLabel.text = @"职位详情：";
        [_detailTitleLabel configFontSize:NTFontSize_12 textColor:NTBlackColor textAlignment:0];
    }
    return _detailTitleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
         _detailLabel = [UILabel new];
        _detailLabel.numberOfLines = 0;
        
         [_detailLabel configFontSize:NTFontSize_10 textColor:NTGreyColor textAlignment:0];
    }
    return _detailLabel;
}

//发布者
- (UIView *)publisherBGVeiw {
    if (!_publisherBGVeiw) {
         _publisherBGVeiw = [UIView new];
        _publisherBGVeiw.backgroundColor = [UIColor whiteColor];
    }
    return _publisherBGVeiw;
}

- (UILabel *)publisherTitleLabel {
    if (!_publisherTitleLabel) {
        _publisherTitleLabel = [UILabel new];
        _publisherTitleLabel.text = @"职位发布者：";
        [_publisherTitleLabel configFontSize:NTFontSize_12 textColor:NTBlackColor textAlignment:0];
    }
    return _publisherTitleLabel;
}

- (UIButton *)publisherNameBtn {
    if (!_publisherNameBtn) {
         _publisherNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_publisherNameBtn setTitleColor:NTBlueColor forState:UIControlStateNormal];
        [_publisherNameBtn setTitleColor:NTGreyColor forState:UIControlStateReserved];
        _publisherNameBtn.titleLabel.font = [UIFont systemFontOfSize:NTFontSize_14];
        _publisherNameBtn.titleLabel.textAlignment = 0;
        [_publisherNameBtn addTarget:self action:@selector(reference:) forControlEvents:UIControlEventTouchUpInside];
//         [_publisherNameLabel configFontSize:NTFontSize_14 textColor:NTBlueColor textAlignment:0];
    }
    return _publisherNameBtn;
}

- (UIImageView *)publisherAvatar {
    if (!_publisherAvatar) {
        _publisherAvatar = [UIImageView new];
        _publisherAvatar.layer.cornerRadius = 22;
        _publisherAvatar.layer.masksToBounds = YES;
  
    }
    return _publisherAvatar;
}

- (UILabel *)publisherDepartment {
    if (!_publisherDepartment) {
        _publisherDepartment = [UILabel new];
        [_publisherDepartment configFontSize:NTFontSize_10 textColor:NTGreyColor textAlignment:0];
    }
    return _publisherDepartment;
}

- (UIButton *)followButton {
    if (!_followButton) {
       _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:NTFontSize_12];
        _followButton.layer.borderColor = NTGreyColor.CGColor;
        _followButton.layer.borderWidth = 1;
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
        [_followButton setTitleColor:NTGreyColor forState:UIControlStateNormal];
        [_followButton setTitleColor:NTBlueColor forState:UIControlStateSelected];
        [_followButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_followButton addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}

- (UIButton *)linkBtn {
    if (!_linkBtn) {
        _linkBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _linkBtn.titleLabel.font = [UIFont systemFontOfSize:NTFontSize_12];
        _linkBtn.layer.borderColor = NTGreyColor.CGColor;
        _linkBtn.layer.borderWidth = 1;
        _linkBtn.tintColor = NTBlueColor;
        _linkBtn.backgroundColor = NTBarTintColor;
//        [_linkBtn setTitle:@"立刻沟通" forState:UIControlStateNormal];
        [_linkBtn setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        [_linkBtn setTitleColor:NTBlueColor forState:UIControlStateNormal];
        [_linkBtn addTarget:self action:@selector(link) forControlEvents:UIControlEventTouchUpInside];
    }
    return _linkBtn;
}

- (UIButton *)postResumeBtn {
    if (!_postResumeBtn) {
        _postResumeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _postResumeBtn.titleLabel.font = [UIFont systemFontOfSize:NTFontSize_12];
        [_postResumeBtn setTitle:@"发送简历" forState:UIControlStateNormal];
        [_postResumeBtn setBackgroundColor:NTBlueColor];
        [_postResumeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postResumeBtn addTarget:self action:@selector(postResume) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postResumeBtn;
}

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
