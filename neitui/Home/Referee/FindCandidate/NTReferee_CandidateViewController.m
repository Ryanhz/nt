//
//  NTCandidateViewController.m
//  neitui
//
//  Created by hzf on 16/7/26.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTReferee_CandidateViewController.h"
#import "UIButton+FEExtend.h"
#import "NTCityViewController.h"
#import "NTReferee_CandidateTableViewCell.h"
#import "NTReferee_candidateSearchViewController.h"
#import "NTSearchCandidateParamModel.h"
#import "NTReferee_SearchResultModel.h"
#import "NTReferee_CandidateModel.h"
#import "NTReferee_candidateDetailViewController.h"

static NSString *kCandidateCellID = @"kCandidateCellID";

@interface NTReferee_CandidateViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *barButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NTSearchCandidateParamModel *paramModel;
@property (nonatomic, strong) NTReferee_SearchResultModel *resultModel;
@property (nonatomic, copy) NSMutableArray<NTReferee_CandidateModel*> *dataArray;

@end

@implementation NTReferee_CandidateViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _paramModel = [[NTSearchCandidateParamModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)chooseCity:(UIButton *)button {
    NTCityViewController *preference = [[NTCityViewController alloc]init];
    preference.hidesBottomBarWhenPushed = YES;
    FEWeakSelf(weakSelf)
    preference.cityBlock = ^(id city){
        if (!city) {
            return ;
        }
        [weakSelf setCity:city];
    };
    
    [self.navigationController pushViewController:preference animated:YES];
    DLog(@"")
}

- (void)workyear:(UIButton *)sender {
    DLog(@"");
    _selectedBtn.selected = NO;
    sender.selected = YES;
    _selectedBtn = sender;
}

- (void)setCity:(NSString *)city {
     [self.barButton setTitle:city forState:UIControlStateNormal];
//     self.paramModel.city = city;
}

/**
 *  click=1,,keyword,city,min(工作年龄下限),max(工作年龄上限),page
 */
- (void)search{
    
    NSDictionary *param = [_paramModel toDictionary];
    DLog(@"param:%@", param)
    FEWeakSelf(weakSelf)
    [NTNetHelper candidateSearchWithParam:param success:^(id data) {
//        DLog(@"%@",data)
        weakSelf.resultModel = data;
        weakSelf.dataArray = [NSMutableArray arrayWithArray:weakSelf.resultModel.result];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        DLog(@"error%@",error)
    }];
}

#pragma mark-------------------------UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NTReferee_CandidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCandidateCellID forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NTReferee_candidateDetailViewController *resumeVC = [[NTReferee_candidateDetailViewController alloc] initWithUid:_dataArray[indexPath.row].uid];
    resumeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resumeVC animated:YES];
}

#pragma mark--------------- UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    DLog(@"")
    
    NTReferee_candidateSearchViewController *searchVC = [[NTReferee_candidateSearchViewController alloc]init];
    FEWeakSelf(weakSelf)
    searchVC.city = _paramModel.city;
    searchVC.param = ^(NSString *keyword, NSString *city) {
        weakSelf.searchBar.text = keyword;
        weakSelf.paramModel.keyword = keyword;
        [weakSelf setCity:city];
        [weakSelf search];
    };
    
    [self.navigationController pushViewController:searchVC animated:NO];
    
    return NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
//    _paraModel.keyword = searchBar.text;
//    [self startSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    _paraModel.keyword = searchBar.text;
//    [self startSearch];
}


- (void)setNavSubViews {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270 * k_h_Scale, 44)];
    self.navigationItem.titleView = view;
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    //    _searchBar.placeholder = ;
    _searchBar.delegate = self;
    UITextField *searchTF = [_searchBar getTextFiled];
    _searchBar.backgroundImage = [[UIImage alloc] init];
    if (searchTF) {
        searchTF.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        searchTF.layer.borderWidth = 1;
        searchTF.backgroundColor = UIColorFromRGB(0xeef3f6);
        searchTF.layer.cornerRadius = 2;
        searchTF.attributedPlaceholder = [@"搜索职位/公司" attributedPlaceholderWithString];
    }
    
    [self.navigationItem.titleView addSubview:_searchBar];
    FEWeakSelf(weakSelf)
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(weakSelf.navigationItem.titleView);
        make.left.equalTo(weakSelf.navigationItem.titleView.mas_left);
    }];
    
    self.navigationItem.titleView = view;
    
    _barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _barButton.frame = CGRectMake(0, 0, 50, 30);
    _barButton.titleLabel.font = [UIFont systemFontOfSize:NTFontSize_12];
    [self setCity:@"上海"];
    //    _barButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_barButton setTitleColor:NTBlackColor forState:UIControlStateNormal];
    [_barButton setImage:[UIImage imageNamed:@"cityDown"] forState:UIControlStateNormal];
    [_barButton addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
    
    [_barButton setImageRight];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_barButton];
    
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.rightBarButtonItem.tintColor = NTGreyColor;
}

- (void)setupSubviews {
    [self setNavSubViews];
    
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"应届毕业生", @"1-3年", @"3-5年", @"5年以上"];
    NSMutableArray *btns = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:NTGreyColor forState:UIControlStateNormal];
        [button setTitleColor:NTBlueColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(workyear:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:button];
        [btns addObject:button];
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorColor = NTBGGreyColor;
    _tableView.backgroundColor = NTBGGreyColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
 
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_tableView registerClass:[NTReferee_CandidateTableViewCell class] forCellReuseIdentifier:kCandidateCellID];
    [self.view addSubview:_topView];
    [self.view addSubview:_tableView];
    
    [self.view bringSubviewToFront:_topView];
    FEWeakSelf(weakSelf)
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@34);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 50, 0));
    }];
    
    [btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:KSCREEN_WIDTH/btns.count leadSpacing:0 tailSpacing:0];
    [btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.topView);
        make.top.equalTo(weakSelf.topView);
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
