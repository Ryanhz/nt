//
//  NTReference_MyViewController.m
//  neitui
//
//  Created by hzf on 16/7/26.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTReferee_MyViewController.h"
#import "NTReferee_infoViewController.h"
#import "NTMyTableViewCell.h"
#import "NTReferee_MyHeaderTableViewCell.h"
#import "NTReferee_CollectCandidateViewController.h"
#import "NTReferee_ManagePositionViewController.h"
#import "NTReferee_DetailModel.h"


static NSString *kMyheaderCellID = @"kMyheaderCellID";
static NSString *kMyCellID = @"kMyCellID";

@interface NTReferee_MyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NTReferee_DetailModel *model;

@end

@implementation NTReferee_MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    _dataArray = @[@"我发布的职位",@"人才收藏"];
    [self setupSubviews];
    
    [self getData];
}

- (void)getData{
    //para
//    uid 登陆用户编号 refereeid 内推人用户编号

    NSDictionary *dic = @{
                          @"refereeid" : @"1"
                          };
    FEWeakSelf(weakSelf)
    [NTNetHelper getRefereeinfoWithPara:dic Success:^(id data) {
        DLog(@"%@",data);
        weakSelf.model = data;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        DLog(@"error: %@",error);
    }];
}

#pragma mark-------------------------UITableViewDataSource, UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: //头像，基本信息
        {
            if (indexPath.row == 1) { //基本信息
                NTReferee_infoViewController *vc = [[NTReferee_infoViewController alloc]initWithModel:_model];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1: // 发布的职位 ， 人才收藏
        {
            if(indexPath.row == 0) { //发布的职位
                
                NTReferee_ManagePositionViewController *vc = [[NTReferee_ManagePositionViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else { //人才收藏
                NTReferee_CollectCandidateViewController *vc = [[NTReferee_CollectCandidateViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2: // 切换人才模式
        {
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:loginChangeDic(user_candidate, YES)];
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
        {
            number = 2;
        }
            break;
        case 1:
        {
            number = 2;
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
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) { // 头像
            NTReferee_MyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyheaderCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.headerView sd_setImageWithURL:[_model.refereeinfo.avatar transformURLWithUTF8Encoding] placeholderImage:[UIImage imageNamed:DefaultAvatar]];
            cell.label.text = _model.refereeinfo.realname;
            return cell;
        }
    }
    
    NTMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyCellID forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            cell.isShowArrow = YES;
            cell.label.text = @"基本信息";
        }
            break;
        case 1:
        {
            cell.isShowArrow = YES;
            cell.label.text = _dataArray[indexPath.row];
        }
            break;
        case 2:
        {
            cell.isShowArrow = NO;
            cell.label.text = @"切换人才模式";
        }
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 10)];
    view.backgroundColor = NTBGGreyColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 0 && indexPath.row == 0) {
            return 137;
        }
    return 48;
}


#pragma mark-------------------------<#(^ 0 - o - 0^)#>
- (void)setupSubviews {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.backgroundColor = NTBGGreyColor;
    _tableView.dataSource = self;
    _tableView.separatorColor = NTBGGreyColor;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_tableView registerClass:[NTReferee_MyHeaderTableViewCell class] forCellReuseIdentifier:kMyheaderCellID];
    [_tableView registerClass:[NTMyTableViewCell class] forCellReuseIdentifier:kMyCellID];
    
    [self.view addSubview:_tableView];
    [self setupLayouts];
}

- (void)setupLayouts {
    
    FEWeakSelf(weakSelf)

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 50, 0));
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
