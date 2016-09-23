//
//  HomeViewController.m
//  Neitui
//
//  Created by hzf on 16/6/30.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTHomeViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"

#import "NTHomeInfo1TableViewCell.h"
#import "NTHomeInfo2TableViewCell.h"

#import "NTJob_NewsModel.h"
#import "NTCompany_NewsModel.h"

#import "NTJobDetailedViewController.h"
#import "NTCompanyHomeViewController.h"

static NSString *kPositonInfoCellID = @"kPositonInfoCellID";
static NSString *kCompanyInfoCellID = @"CompanyInfoCellID";



@interface NTHomeViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSInteger _page;
    NSInteger _everypage;
    BOOL _haveMore;
}
@property (nonatomic, assign) BOOL isSuccessLoad;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation NTHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_isSuccessLoad) {
         [self.tableView.mj_header beginRefreshing];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    _everypage = 10;
    _haveMore = YES;
    
    [self setupSubviews];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)config{
    _isSuccessLoad = NO;
}


- (void)refresh {
    [self getData];
}

- (void)loadMore {
    
    if (!_haveMore) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    _page  = _page + 1;
    NSDictionary *param = @{
                            @"uid" : @"3",
                            @"page" : @(_page),
                            @"everypage" : @(_everypage)
                            };
    FEWeakSelf(weakSelf)
    [NTNetHelper follownewsWithParam:param Success:^(NSArray *data) {
        //        DLog(@"%@",data)
        if (data.count == 0) {
            _haveMore = NO;
            _page  = _page -1;
            return ;
        }
        
        [weakSelf.dataSource addObjectsFromArray:data];
        weakSelf.isSuccessLoad = YES;
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        DLog(@"error: %@",error)
        if (error.code == 0) {
            _haveMore = NO;
            _page  = _page -1;
            return ;
        }
         [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.isSuccessLoad = YES;
    }];
}

/**
 *  page
 第几页
 everypage
 每页有几组数据

 */
- (void)getData {
    _page = 1;
    NSDictionary *param = @{
                            @"uid" : @"3",
                            @"page" : @(_page),
                            @"everypage" : @(_everypage)
                            };
    FEWeakSelf(weakSelf)
    [NTNetHelper follownewsWithParam:param Success:^(id data) {
//        DLog(@"%@",data)
        weakSelf.dataSource = [NSMutableArray arrayWithArray:data];
        weakSelf.isSuccessLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        DLog(@"error: %@",error)
         [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.isSuccessLoad = YES;
    }];
}

- (void)add{
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    [self getData];
}

- (void)resetData {
    
}

- (NSArray *)gif {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i<4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gif%d",i + 1]];
        [array addObject:image];
    }
    return array;
}



#pragma mark---------------
#pragma mark--------------- UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    DLog(@"")
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    DLog(@"")
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

#pragma mark------
#pragma mark------ UITableViewDataSource  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id model = _dataSource[indexPath.row];
    
    if ([model isKindOfClass:[NTJob_NewsModel class]]) {
        NTHomeInfo1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPositonInfoCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    } else {
        NTHomeInfo2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompanyInfoCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        cell.fd_enforceFrameLayout = NO;
        
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   id model = _dataSource[indexPath.row];
    if ([model isKindOfClass:[NTJob_NewsModel class]]) {
        return 92;
    } else {

        return [tableView fd_heightForCellWithIdentifier:kCompanyInfoCellID cacheByIndexPath:indexPath configuration:^(id cell) {
            ((NTHomeInfo2TableViewCell *)cell).model = _dataSource[indexPath.row];
        }];
//        return 120;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = _dataSource[indexPath.row];
    if ([model isKindOfClass:[NTJob_NewsModel class]]) {
        
        
        NTJobDetailedViewController *jobVC = [[NTJobDetailedViewController alloc]initWithjobId:((NTJob_NewsModel *)model).id];
        jobVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jobVC animated:YES];
    } else {
        NTCompanyHomeViewController *companyVC = [[NTCompanyHomeViewController alloc] initWithCid:((NTCompany_NewsModel*)model).cid];
        companyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:companyVC animated:YES];
    }
}

- (void)setupSubviews {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270 * k_h_Scale, 44)];
    self.navigationItem.titleView = view;
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    _searchBar.delegate = self;
    UITextField *searchTF = [_searchBar getTextFiled];
    _searchBar.backgroundImage = [[UIImage alloc] init];
    if (searchTF) {
        searchTF.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        searchTF.layer.borderWidth = 1;
        searchTF.layer.cornerRadius = 2;
        searchTF.backgroundColor = UIColorFromRGB(0xeef3f6);
        searchTF.attributedPlaceholder = [@"搜索的职位" attributedPlaceholderWithString];
    }
    [self.navigationItem.titleView addSubview:_searchBar];
    FEWeakSelf(weakSelf)
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(weakSelf.navigationItem.titleView);
        make.left.equalTo(weakSelf.navigationItem.titleView.mas_left).offset(10);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem.tintColor = NTGreyColor;
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.backgroundColor = NTBGGreyColor;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[NTHomeInfo1TableViewCell class] forCellReuseIdentifier:kPositonInfoCellID];
    [_tableView registerClass:[NTHomeInfo2TableViewCell class] forCellReuseIdentifier:kCompanyInfoCellID];
    //    [_tableView registerClass:[NTHomeTableViewCell class] forCellReuseIdentifier:kUerCellIdentifier];
    //    [_tableView registerClass:[NTHomeTableViewCompanyCell class] forCellReuseIdentifier:kCompanyCellIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 50, 0));
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view resignFirstResponder];
}

@end
