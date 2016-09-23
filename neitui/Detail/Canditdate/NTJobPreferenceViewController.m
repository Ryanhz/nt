//
//  NTPositionPreferenceViewController.m
//  neitui
//
//  Created by hzf on 16/7/13.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTJobPreferenceViewController.h"

#define kJobPreferenceCell @"jobPreference"

@interface NTJobPreferenceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation NTJobPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"求职偏好";
    
    _dataSource = @[@"工作地点：", @"兴趣岗位：", @"公司规模：", @"领      域："];
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-------------------------UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJobPreferenceCell forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x4e4e4e);
    cell.textLabel.font = [UIFont systemFontOfSize:NTFontSize_14];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 44)];
    label.text = @"我们会根据你的偏好进行推荐";
    label.font = [UIFont systemFontOfSize:NTFontSize_12];
    label.textColor = NTGreyColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = NTBGGreyColor;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kJobPreferenceCell];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = NTBGGreyColor;
    _tableView.rowHeight = 48;
    _tableView.contentInset = UIEdgeInsetsMake(9, 0, 0, 0);
    [self.view addSubview:_tableView];
    [self setuplayouts];
}

- (void)setuplayouts {
    FEWeakSelf(weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
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
