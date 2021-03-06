//
//  NTReferee_candidateDetailViewController.m
//  neitui
//
//  Created by hzf on 16/8/12.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTReferee_candidateDetailViewController.h"
#import "NTResumePreviewHeaderTableViewCell.h"
#import "NTResumePreviewTableViewCell.h"
#import "NTResumePreviewSectionHeaderCell.h"
#import "NTResumePreviewProjectTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *kResumePreview_MyHeaderID =        @"kResumePreview_MyHeaderID";
static NSString *kResumePreview_SectionHeaderID =   @"kResumePreview_SectionID";
static NSString *kResumePreview_cellID =            @"kResumePreview_cellID";
static NSString *kResumePreview_ProjectCellID =     @"kResumePreview_ProjectCellID";

@interface NTReferee_candidateDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NTResumeModel *model;
@property (nonatomic, strong) NSString *uid;

@end

@implementation NTReferee_candidateDetailViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithUid:(NSString *)uid {
    self = [super init];
    if (self) {
        _uid = uid;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"简历预览";
    [self setDefaultBackBarItem];
    [self setupSubviews];
    
    if (_uid) {
        [self getResume];
    }
}

- (void)getResume{
    FEWeakSelf(weakSelf)
    
    [NTNetHelper getCandidateInfosWithuid:_uid Success:^(id data) {
                DLog(@"data:%@",data)
        weakSelf.model = data;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        DLog(@"error:%@",error);
    }];
}


- (void)postMessage:(UIButton *)sender {
    DLog(@"")
}

- (void)call:(UIButton *)sender {
    DLog(@"")
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",@"10010"]]];
}

- (void)collect:(UIButton *)sender {
    DLog(@"")
}

#pragma mark-------------------------UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
        {
            number = 1;
        }
            break;
        case 1: //工作经验
        {
            number = _model.candidate_expses.count;
        }
            break;
        case 2: // 项目经历
        {
            number = _model.candidate_projects.count;
        }
            break;
        case 3: //教育经历
        {
            number = _model.candidate_edus.count;
        }
            break;
            
        default:
            break;
    }
    
    return number;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tableViewCell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            NTResumePreviewHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResumePreview_MyHeaderID forIndexPath:indexPath];
            cell.model = _model;
            tableViewCell = cell;
        }
            break;
        case 1://工作经历
        {
            NTResumePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResumePreview_cellID forIndexPath:indexPath];
            cell.model = _model.candidate_expses[indexPath.row];
            tableViewCell = cell;
        }
            break;
        case 2://项目经历
        {
            NTResumePreviewProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResumePreview_ProjectCellID forIndexPath:indexPath];
            NTCandidate_projectsModel *model = _model.candidate_projects[indexPath.row];
            
            cell.model = model;
            
            tableViewCell = cell;
        }
            break;
        case 3: //教育经历
        {
            NTResumePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResumePreview_cellID forIndexPath:indexPath];
            cell.model = _model.candidate_edus[indexPath.row];
            tableViewCell = cell;
        }
            break;
            
        default:
            break;
    }
    
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tableViewCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 10)];
    footerView.backgroundColor = NTBGGreyColor;
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if (section == 0) {
        return [UIView new];
    }
    
    NTResumePreviewSectionHeaderCell *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kResumePreview_SectionHeaderID];
    switch (section) {
        case 1:
        {
            headerView.label.text = @"工作经验";
        }
            break;
        case 2:
        {
            headerView.label.text = @"项目经历";
        }
            break;
        case 3:
        {
            headerView.label.text = @"教育经历";
        }
            break;
        default:
            break;
    }
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow = 0;
    switch (indexPath.section) {
        case 0:
        {
            heightForRow = 140;
        }
            break;
        case 1:
        {
            heightForRow = 60;
        }
            break;
        case 2:{
            heightForRow = [tableView fd_heightForCellWithIdentifier:kResumePreview_ProjectCellID cacheByIndexPath:indexPath configuration:^(id cell) {
                
                NTCandidate_projectsModel *model = _model.candidate_projects[indexPath.row];
                ((NTResumePreviewProjectTableViewCell *)cell).model = model;
            }];
        }
            break;
        case 3: {
            heightForRow = 60;
        }
            break;
            
        default:
            break;
    }
    
    return heightForRow;
}


#pragma mark-------------------------setupSubviews

- (void)setupSubviews {
    FEWeakSelf(weakSelf)
    
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [UIView new];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [messageBtn setTitle:@"私信" forState:UIControlStateNormal];
    [messageBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [messageBtn setBackgroundColor:NTBlueColor];
    [messageBtn addTarget:self action:@selector(postMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [callBtn setTitle:@"电话" forState:UIControlStateNormal];
     [callBtn setBackgroundColor:[UIColor orangeColor]];
    [callBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [callBtn setBackgroundColor:[UIColor lightGrayColor]];
    [collectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:messageBtn];
    [bottomView addSubview:callBtn];
    [bottomView addSubview:collectBtn];
    [self.view addSubview:bottomView];
    
    NSArray *bottomBtns = @[messageBtn, callBtn, collectBtn];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 44, 0));
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.equalTo(@44);
    }];
    
    [bottomBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:KSCREEN_WIDTH/3 leadSpacing:0 tailSpacing:0];
    [bottomBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(bottomView);
    }];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = NTBGGreyColor;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[NTResumePreviewHeaderTableViewCell class] forCellReuseIdentifier:kResumePreview_MyHeaderID];
        [_tableView registerClass:[NTResumePreviewSectionHeaderCell class] forHeaderFooterViewReuseIdentifier:kResumePreview_SectionHeaderID];
        [_tableView registerClass:[NTResumePreviewTableViewCell class] forCellReuseIdentifier:kResumePreview_cellID];
        [_tableView registerClass:[NTResumePreviewProjectTableViewCell class] forCellReuseIdentifier:kResumePreview_ProjectCellID];
    }
    
    
    return _tableView;
}



@end
