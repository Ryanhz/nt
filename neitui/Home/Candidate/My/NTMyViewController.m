//
//  NTMyViewController.m
//  neitui
//
//  Created by hzf on 16/7/18.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTMyViewController.h"
#import "NTMyHeaderTableViewCell.h"
#import "NTMyTableViewCell.h"
#import "NTMyInfoViewController.h"
#import "NTMyPostRecordViewController.h"
#import "NTMyAttentionViewController.h"
#import "NTMyResumeViewController.h"
#import "NTPositionCollectViewController.h"
#import "NTCompanyHomeViewController.h"
#import "NTResumeModel.h"

static NSString *kMyheaderCellID = @"kMyheaderCellID";
static NSString *kMyCellID = @"kMyCellID";

@interface NTMyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *headerBgImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NTResumeModel *model;

@end

@implementation NTMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    _dataArray = @[@"基本信息",@"我的简历",@"职位收藏",@"投递记录"];
    [self setupSubviews];
    [self getResume];
}

- (void)getResume{
    FEWeakSelf(weakSelf)
    [NTNetHelper getCandidateInfosWithuid:@"1" Success:^(id data) {
        weakSelf.model = data;
        [weakSelf.tableView reloadData];
        DLog(@"data:%@",[weakSelf.model toJSONString])
    } failure:^(NSError *error) {
        DLog(@"error:%@",error);
    }];

}

- (void)didSelectRowAtIndex:(NSUInteger )index {
    switch (index) {
        case 0:
        {   //基本信息
            NTMyInfoViewController *infoVC = [[NTMyInfoViewController alloc]initWithResumeModel:_model];
             infoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoVC animated:YES];
        }
            break;
        case 1:
        {   //我的简历
            NTMyResumeViewController *resumeVC = [[NTMyResumeViewController alloc]initWithResumeModel:_model];
            resumeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:resumeVC animated:YES];
        }
            break;
   
        case 2:
        {   //职位收藏
            NTPositionCollectViewController *positionCollect = [[NTPositionCollectViewController alloc]init];
            positionCollect.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:positionCollect animated:YES];
        }
            break;
        case 3:
        {   //投递记录
            NTMyPostRecordViewController *myPostRecordVC = [[NTMyPostRecordViewController alloc]init];
            myPostRecordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myPostRecordVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark-------------------------UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
        {
            number = 1;
        }
            break;
        case 1:
        {
            number = _dataArray.count;
        }
            break;
        case 2:
        {
            number = 1;
        }
            break;
            
        default:
            break;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tableViewCell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            NTMyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyheaderCellID forIndexPath:indexPath];
            [cell.headerView sd_setImageWithURL:[_model.userinfos.avatar transformURLWithUTF8Encoding]  placeholderImage:[UIImage imageNamed:@"placeholderHead"]];
            cell.label.text = _model.candidate.realname;
            tableViewCell = cell;
        }
            break;
        case 1:
        {
            NTMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyCellID forIndexPath:indexPath];
            cell.isShowArrow = YES;
            cell.label.text = _dataArray[indexPath.row];
            tableViewCell = cell;
        }
            break;
        case 2:
        {
             NTMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyCellID forIndexPath:indexPath];
            cell.isShowArrow = NO;
            cell.label.text = @"切换内推人模式";
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 10)];
    view.backgroundColor = NTBGGreyColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat heightForFooter = 0;
    switch (section) {
        case 0:
        {
            heightForFooter = 1;
        }
            break;
        case 1:
        {
            heightForFooter = 10;
        }
            break;
        case 2:
        {
            heightForFooter = 0.1;
        }
            break;
            
        default:
            break;
    }
    return heightForFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heightForRow = 0;
    switch (indexPath.section) {
        case 0:
        {
            heightForRow = 150;
        }
            break;
        case 1:
        {
            heightForRow = 48;
        }
            break;
        case 2:
        {
            heightForRow = 48;
        }
            break;
            
        default:
            break;
    }
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        [self didSelectRowAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 2) { //切换内推人
//        DLog(@"")
//        NTCompanyHomeViewController *companyHomeVC = [[NTCompanyHomeViewController alloc]init];
//        [self.navigationController pushViewController:companyHomeVC animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:loginChangeDic(user_referee, YES)];
    }
}


#pragma mark-------------------------setupSubviews
- (void)setupSubviews {
    _headerBgImageView = [[UIImageView alloc]init];
    _headerBgImageView.image = [UIImage imageNamed:@"res1.jpg"];
    _headerBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.separatorColor = NTBGGreyColor;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_tableView registerClass:[NTMyHeaderTableViewCell class] forCellReuseIdentifier:kMyheaderCellID];
    [_tableView registerClass:[NTMyTableViewCell class] forCellReuseIdentifier:kMyCellID];
    
    [self.view addSubview:_headerBgImageView];
    [self.view addSubview:_tableView];
    [self setupLayouts];
}

- (void)setupLayouts {
    
    FEWeakSelf(weakSelf)
    [_headerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@140);
    }];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 44, 0));
    }];
}

- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
