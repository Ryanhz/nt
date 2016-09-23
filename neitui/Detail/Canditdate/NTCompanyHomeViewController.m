//
//  NTCompanyHomeViewController.m
//  neitui
//
//  Created by hzf on 16/7/27.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTCompanyHomeViewController.h"
#import "NTCompanyHeaderTableViewCell.h"
#import "NTCompanyIntroduceTableViewCell.h"
#import "NTCompanyProdouceTableViewCell.h"
#import "NTCompanyProgressTableViewCell.h"
#import "NTCompanySectionHeaderView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NTCompanyDetailModel.h"

static NSString *kCompanyHome_SectionHeaderlID     = @"kCompanyHome_SectionHeaderlID"; //Section头部
static NSString *kCompanyHome_HeaderTableViewCellID     = @"kCompanyHome_HeaderTableViewCellID"; //头部
static NSString *kCompanyHome_IntroduceTableViewCellID  = @"kCompanyHome_IntroduceTableViewCellID"; //公司介绍
static NSString *kCompanyHome_ProdouceTableViewCellID   = @"kCompanyHome_ProdouceTableViewCellID"; //公司产品
static NSString *kCompanyHome_ProgressTableViewCellID   = @"kCompanyHome_ProgressTableViewCellID"; //公司发展历程

@interface NTCompanyHomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *productArray;
@property (nonatomic, strong) NSArray *progressArray;
@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, strong) NTCompanyDetailModel *model;
@property (nonatomic, strong) NTCompanyIntroduceTableViewCell *introduceTableViewCell;

@end

@implementation NTCompanyHomeViewController

- (instancetype)initWithCid:(NSString *)cid {
    self = [super init];
    if (self) {
        _cid = cid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FEWeakSelf(weakSelf)
    [NTNetHelper getCompanyDetailWithCID:_cid success:^(NTCompanyDetailModel * model) {
        weakSelf.model = model;
        [weakSelf setupSubviews];
//        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        DLog(@"error:%@",error)
    }];
    
    [self setDefaultBackBarItem];
    
    _sectionTitleArray = @[@"", @"公司介绍：", @"公司产品：", @"公司发展历程："];
    
}

#pragma mark-------------------------UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_model) {
        return 0;
    }
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0: //头部
        {
            numberOfRows = 1;
        }
            break;
        case 1: //公司介绍
        {
            numberOfRows = 1;
        }
            break;
        case 2: //公司产品
        {
            if (_model.company_products.count == 0) {
                return 1;
            }
           numberOfRows = _model.company_products.count;
        }
            break;
        case 3: //公司发展历程
        {
            if (_model.company_milestone.count == 0) {
                return 1;
            }
            numberOfRows = _model.company_milestone.count;
        }
            break;
            
        default:
            break;
    }
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!_model) {
        return 0;
    }
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self configCellWithTableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (UITableViewCell *)configCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0://头部
        {
            NTCompanyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompanyHome_HeaderTableViewCellID forIndexPath:indexPath];
            cell.model = _model.company;
            return cell;
        }
            break;
        case 1://公司介绍
        {
            NTCompanyIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompanyHome_IntroduceTableViewCellID forIndexPath:indexPath];
            cell.intro = @"鼓起功夫偶尔发妻儿就付款了发货款了是符合会计师副科级手机号罚款是打款哈老客户。\n大海就上课都好看阿萨德好看的爱受伤的痕迹就是大的活动。";
            return cell;
        }
            break;
        case 2: //公司产品
        {
            NTCompanyProdouceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompanyHome_ProdouceTableViewCellID forIndexPath:indexPath];
            cell.model = _model.company_products[indexPath.row];
            
            if (indexPath.row == _model.company_products.count -1 ||_model.company_products.count == 0) {
                cell.isShowSeparator = NO;
            } else {
                cell.isShowSeparator = YES;
            }
            
            return cell;
        }
            break;
        case 3: //公司发展历程
        {
            NTCompanyProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCompanyHome_ProgressTableViewCellID forIndexPath:indexPath];
            cell.model = _model.company_milestone[indexPath.row];
            return cell;
        }
            break;
            
        default:
             return nil;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return [[UIView alloc]init];
    }
    
    NTCompanySectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCompanyHome_SectionHeaderlID];
    header.label.text = _sectionTitleArray[section];
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    if (section == 3) {
        return 50;
    }
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow = 0;
    
    switch (indexPath.section) {
        case 0:
        {
            heightForRow = 188;
        }
            break;
        case 1:
        {
            NTCompanyIntroduceTableViewCell *cell = self.introduceTableViewCell;
            cell.intro = @"鼓起功夫偶尔发妻儿就付款了发货款了是符合会计师副科级手机号罚款是打款哈老客户。\n大海就上课都好看阿萨德好看的爱受伤的痕迹就是大的活动。";
            heightForRow = cell.height;
        }
            break;
        case 2:
        {
            heightForRow = 68 + 34;
        }
            break;
        case 3:
        {
            heightForRow = 44;
        }
            break;
            
        default:
            break;
    }
    
    return heightForRow;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[NTCompanyHeaderTableViewCell class] forCellReuseIdentifier:kCompanyHome_HeaderTableViewCellID];
        [_tableView registerClass:[NTCompanyIntroduceTableViewCell class] forCellReuseIdentifier:kCompanyHome_IntroduceTableViewCellID];
        [_tableView registerClass:[NTCompanyProdouceTableViewCell class] forCellReuseIdentifier:kCompanyHome_ProdouceTableViewCellID];
        [_tableView registerClass:[NTCompanyProgressTableViewCell class] forCellReuseIdentifier:kCompanyHome_ProgressTableViewCellID];
        [_tableView registerClass:[NTCompanySectionHeaderView class] forHeaderFooterViewReuseIdentifier:kCompanyHome_SectionHeaderlID];
    }
    return _tableView;
}


- (NTCompanyIntroduceTableViewCell *)introduceTableViewCell {
    if (!_introduceTableViewCell) {
        _introduceTableViewCell = [_tableView dequeueReusableCellWithIdentifier:kCompanyHome_IntroduceTableViewCellID];
        
    }
    return _introduceTableViewCell;
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
