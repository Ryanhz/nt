//
//  JobViewController.m
//  Neitui
//
//  Created by hzf on 16/6/30.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTPositionViewController.h"
#import "NTPositionTableViewCell.h"
#import "NTSelectView.h"
#import "NTSelectTableView.h"
#import "NTJobPreferenceViewController.h"
#import "NTCityViewController.h"
#import "NTJobDetailedViewController.h"
#import "NTSearchJobParaModel.h"
#import "UIButton+FEExtend.h"


#define kPositionCellIdentifier @"positionCell"

@interface NTPositionViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,NTSelectViewDelegate,NTSelectItemDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)  NTSelectView *selectView;
@property (nonatomic, strong) NTSelectTableView *selectTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isShowSelectTableView;
@property (nonatomic, strong) MASConstraint *selectTableViewHeight;
@property (nonatomic, strong) UIButton *barButton;
@property (nonatomic, strong) NTSearchJobParaModel *paraModel;
@property (nonatomic, strong) NSArray *job_experienceKeys;
@property (nonatomic, strong) NSArray *job_experienceValues;
@property (nonatomic, strong) NSArray *job_salaryKeys;
@property (nonatomic, strong) NSArray *job_salaryValues;
@property (nonatomic, strong) NSArray *scale_typeKeys;
@property (nonatomic, strong) NSArray *scale_typeValues;

@end

@implementation NTPositionViewController

- (void)dealloc {
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataSource = [NSMutableArray array];
    _paraModel = [[NTSearchJobParaModel alloc] init];
//    _paraModel.city = @"上海";
    _paraModel.page = 1;
    _paraModel.everypage = 15;
    [self startSearch];
    
    _isShowSelectTableView = NO;

    
    [self setupSubviews];
    
}



- (void)chooseCity:(UIButton *)button {
    NTCityViewController *preference = [[NTCityViewController alloc]init];
    preference.hidesBottomBarWhenPushed = YES;
    FEWeakSelf(weakSelf)
    preference.cityBlock = ^(id city){
        [weakSelf.barButton setTitle:city forState:UIControlStateNormal];
        weakSelf.paraModel.city = city;
    };
    
    [self.navigationController pushViewController:preference animated:YES];
    DLog(@"")
}

- (void)showSelectTableView {
    [self.view bringSubviewToFront:_selectTableView];
    CGFloat tableView_height = _tableView.bounds.size.height;
    
    [_selectTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(tableView_height));
    }];
    
    _selectTableView.isShow = YES;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hideSelectTableView {

    [_selectTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    _selectTableView.isShow = NO;
    [self.view layoutIfNeeded];
}


- (void)startSearch{
  
    FEWeakSelf(weakSelf)
    [NTNetHelper getJobWithParas:_paraModel Success:^(id data) {
        NSArray *array = data;
        if (array.count >0) {
            [weakSelf.dataSource addObjectsFromArray:data];
            if (weakSelf.tableView) {
                [weakSelf.tableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        DLog(@"error:%@",error)
    }];
}


#pragma mark-------------------------NTSelectViewDelegate,NTSelectItemDelegate

- (void)selectVeiw:(NTSelectTableView *)veiw selectModel:(NSString *)key title:(NSString *)title {
    
    switch (veiw.type) {
        case job_expericence:
        {
            _paraModel.expericence = [key intValue];
            _selectView.workButton.label.text = title;
            _selectView.workButton.selected = NO;
        }
            break;
        case job_salary:
        {
            _paraModel.salary = [key intValue];
            _selectView.wageButton.selected = NO;
            _selectView.wageButton.label.text = title;
        }
            break;
        case company_scale_type:
        {
            _paraModel.scale_type = key;
            _selectView.developButton.selected = NO;
            _selectView.developButton.label.text = title;
        }
            break;
        default:
            break;
    }
    [self hideSelectTableView];
    [self startSearch];
    
}

- (void)selectVeiw:(NTCustomButton *)sender selectIndex:(NSInteger)index isSelect:(BOOL)select {
    
    if (!select) {
        [self hideSelectTableView];
        return;
    }
    _selectTableView.targetBtn = sender;
    
    if (index == 0) {
        _selectTableView.type = job_expericence;
        _selectTableView.keys = self.job_experienceKeys;
        _selectTableView.titles = self.job_experienceValues;
    }
    if (index == 1) {
        _selectTableView.keys = self.job_salaryKeys;
        _selectTableView.titles = self.job_salaryValues;
        _selectTableView.type = job_salary;
    }  else if(index == 2) {
        _selectTableView.type = company_scale_type;
        _selectTableView.keys = self.scale_typeKeys;
        _selectTableView.titles = self.scale_typeValues;
    }
    
    [_selectTableView reloadData];
    
    [self showSelectTableView] ;
}


#pragma mark--------------- UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    DLog(@"")
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    _paraModel.keyword = searchBar.text;
    [self startSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _paraModel.keyword = searchBar.text;
    [self startSearch];
}

#pragma mark------
#pragma mark------ UITableViewDataSource  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NTPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPositionCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    [cell setCell:nil];
    cell.model = _dataSource[indexPath.row];
    
    if (indexPath.row == _dataSource.count - 1) {
        cell.isShowSeparator = NO;
    } else {
        cell.isShowSeparator = YES;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    view.backgroundColor = [UIColor whiteColor];
    
    [view fe_addCorner:UIRectCornerTopLeft| UIRectCornerTopRight size:CGSizeMake(10, 10)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    view.backgroundColor = [UIColor whiteColor];
    [view fe_addCorner:UIRectCornerBottomLeft| UIRectCornerBottomRight size:CGSizeMake(10, 10)];
   
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NTJobListModel *model = _dataSource[indexPath.row];
    NTJobDetailedViewController *detailVC = [[NTJobDetailedViewController alloc] initWithjobId:model.id];
    detailVC.hidesBottomBarWhenPushed = YES;
//    detailVC.jobId = model.id;
    
    [self presentViewController:detailVC animated:NO completion:^{
        
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark-------------------------<#(^ 0 - o - 0^)#>
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
    [_barButton setTitle:@"上海" forState:UIControlStateNormal];
//    _barButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_barButton setTitleColor:NTBlackColor forState:UIControlStateNormal];
    [_barButton setImage:[UIImage imageNamed:@"cityDown"] forState:UIControlStateNormal];
    [_barButton addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
    
    [_barButton setImageRight];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_barButton];
    
    self.navigationItem.leftBarButtonItem = item;
//    [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(setSearchPrerequisite)];
    self.navigationItem.rightBarButtonItem.tintColor = NTGreyColor;
}

- (void)setupSubviews {
    [self setNavSubViews];
    _selectView = [[NTSelectView alloc]init];
    _selectView.delegate = self;
    
    _selectTableView = [[NTSelectTableView alloc]init];
    _selectTableView.delegate = self;
    _selectTableView.backgroundColor = [UIColor clearColor];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //    _tableView.layer.cornerRadius = 20;
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 96;
    _tableView.sectionHeaderHeight = 10;
    _tableView.backgroundColor = UIColorFromRGB(0xEEF3F6);
    //    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[NTPositionTableViewCell class] forCellReuseIdentifier:kPositionCellIdentifier];
//    _tableView.clipsToBounds = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_selectView];
    
    [self.view addSubview:_selectTableView];
    [self.view addSubview:_tableView];
    FEWeakSelf(weakSelf)
    
    [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(@34);
        make.width.equalTo(weakSelf.view);
    }];
    
    [_selectTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.selectView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
//        make.bottom.equalTo(weakSelf.selectView.mas_bottom);
      weakSelf.selectTableViewHeight =  make.height.equalTo(@0);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.selectView.mas_bottom);
        make.right.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-44);
    }];
    
}



- (NSArray *)job_experienceKeys {
    if (!_job_experienceKeys) {
        _job_experienceKeys = @[@"0", @"1", @"2", @"3", @"4"];
    }
    return _job_experienceKeys;
}

- (NSArray *)job_experienceValues {
    
    if (!_job_experienceValues) {
        _job_experienceValues = @[@"不限", @"应届毕业生", @"1-3年", @"3-5年", @"5年以上"];
    }
    return _job_experienceValues;
}

- (NSArray *)job_salaryKeys {
    
    if (!_job_salaryKeys) {
        _job_salaryKeys = @[@"0", @"1", @"2", @"3", @"4", @"5"];
    }
    return _job_salaryKeys;
}

- (NSArray *)job_salaryValues {
    
    if (!_job_salaryValues) {
        _job_salaryValues = @[@"不限", @"5k以下", @"5k-10k",  @"10k-15k", @"15k-25k", @"25k-50k",];
    }
    return _job_salaryValues;
}

- (NSArray *)scale_typeKeys {
    
    if (!_scale_typeKeys) {
        _scale_typeKeys = @[  @"angle",@"nice",@"go" ,@"a",@"b",@"c" ,@"d",@"ipo" ,@"hide", @"nowant"];
    }
    return _scale_typeKeys;
}

- (NSArray *)scale_typeValues {
    
    if (!_scale_typeValues) {
        _scale_typeValues =  @[@"初创公司", @"成熟型公司",@"成长型公司",@"A轮",@"B轮",@"C轮",@"D轮",@"上市公司",@"未融资",@"无需融资"];
    }
    return _scale_typeValues;
}

- (void)setupLayout {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     [_searchBar resignFirstResponder];
}


@end
