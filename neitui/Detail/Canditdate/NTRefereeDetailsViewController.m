//
//  NTReferenceDetailsVC.m
//  neitui
//
//  Created by hzf on 16/7/9.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTRefereeDetailsViewController.h"
#import "NTJobDetailedViewController.h"
#import "NTReferenceDetailHeaderCell.h"
#import "NTPositionTableViewCell.h"
#import "NTRefereeDetailPostParaModel.h"
#import "NTReferee_DetailModel.h"
#import "NTJobListModel.h"

static NSString *kReferenceDetailHeaderCellID = @"ReferenceDetailHeaderCell";
static NSString *kNTPositionTableViewCellID = @"NTPositionTableViewCell";

@interface NTRefereeDetailsViewController ()<UITableViewDataSource, UITableViewDelegate, NTCellToolselegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NTRefereeDetailPostParaModel *postParaModel;
@property (nonatomic, strong) NTReferee_DetailModel *responseModel;
@property (nonatomic, strong) NSArray *jobs;
@property (nonatomic, strong) NSString *uid;
@end

@implementation NTRefereeDetailsViewController


- (instancetype)initWithUid:(NSString *)uid {
    self = [super init];
    if (self) {
        _postParaModel = [[NTRefereeDetailPostParaModel alloc]init];
        _postParaModel.uid = uid;
        _postParaModel.everypage = 10;
        _postParaModel.page = 1;
        _uid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self setDefaultBackBarItem];
    [self setupSubviews];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getData{
    NSDictionary *dic = [_postParaModel toDictionary];
    FEWeakSelf(weakSelf)
    NSDictionary *refereeinfoDic = @{@"uid":@"5", @"refereeid":_uid};
    [NTNetHelper getRefereeinfoWithPara:refereeinfoDic Success:^(id data) {
        weakSelf.responseModel = data;
        NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:0];
        [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        DLog(@"error:%@",error)
    }];
    
    [NTNetHelper getRefereejobsWithPara:dic Success:^(id data) {
        weakSelf.jobs = data;
        NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:1];
        [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
       DLog(@"error:%@",error)
    }];
}

#pragma mark-------------------------UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    if (_jobs && _jobs.count != 0) {
        return _jobs.count;
    }
    
    return _jobs.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tableViewCell = nil;
    if (indexPath.section == 0) {
        NTReferenceDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kReferenceDetailHeaderCellID forIndexPath:indexPath];
        cell.model = _responseModel.refereeinfo;
        cell.isFollowed = ![_responseModel.followstatus isEqualToString:@"-1"];
        cell.delegate = self;
        tableViewCell = cell;
    } else {
        NTPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNTPositionTableViewCellID forIndexPath:indexPath];
        cell.model = _jobs[indexPath.row];
        tableViewCell = cell;
        
        if (indexPath.row == (_jobs.count -1)) {
            cell.isShowSeparator = NO;
        }
    }
    
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableViewCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NTPositionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NTJobDetailedViewController *jobDetailVC = [[NTJobDetailedViewController alloc]initWithjobId:cell.model.id];
        [self.navigationController pushViewController:jobDetailVC animated:YES];
    }
}

- (void)cell:(UITableViewCell *)cell tools:(id)sender {
    UIButton *button = sender;
    NTReferenceDetailHeaderCell *hcell = (NTReferenceDetailHeaderCell *)cell;
    
    static  BOOL canClick = YES;
    if (!canClick) {
        return;
    }
    canClick = NO;
    
    
    NSString *type = !button.selected ? @"2" : @"1";
    
    NSString *title = nil;
    if ([type isEqualToString:@"2"]) {
        title = @"成功添加关注";
        
    } else {
        title = @"已取消关注";
    }
    FEWeakSelf(weakSelf)
    [NTNetHelper followRefereesWithId:hcell.model.uid type:type Success:^(id data) {
        [weakSelf.view makeToast:title duration:1 position:CSToastPositionCenter];
        canClick = YES;
        button.selected = !button.selected;
        DLog(@"%@",data);
    } failure:^(NSError *error) {
        canClick = YES;
        DLog(@"error:%@",error);
        [weakSelf.view makeToast:@"操作失败" duration:1 position:CSToastPositionCenter];
    }];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 10)];
    view.backgroundColor = NTBGGreyColor;
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        return 200;
    } else {
        return 94;
    }
}


#pragma mark-------------------------setupSubviews
- (void)setupSubviews {
    [self.view addSubview:self.tableView];
    
    FEWeakSelf(weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = NTBGGreyColor;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[NTReferenceDetailHeaderCell class] forCellReuseIdentifier:kReferenceDetailHeaderCellID];
        [_tableView registerClass:[NTPositionTableViewCell class] forCellReuseIdentifier:kNTPositionTableViewCellID];
    }
    return _tableView;
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
