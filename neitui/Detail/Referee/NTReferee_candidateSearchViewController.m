//
//  NTReferee_candidateSearchViewController.m
//  neitui
//
//  Created by hzf on 16/8/9.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTReferee_candidateSearchViewController.h"
#import "NTPositionMarkCollectionViewCell.h"
#import "NTCityViewController.h"
#import "UIButton+FEExtend.h"

static NSString *kCollectionViewCellID = @"kCollectionViewCellID";

@interface NTReferee_candidateSearchViewController ()<UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *barButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *textLengthArray;

@property (nonatomic, strong) NSString *keyword;


@end

@implementation NTReferee_candidateSearchViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavSubViews];
    [self getHotSearch];
}

- (void)getHotSearch {
    FEWeakSelf(weakSelf)
    [NTNetHelper getHotSearchWithSuccess:^(id data) {
        DLog(@"%@",data);
        NSArray *array = data[@"HotSearch"];
        if ([array isKindOfClass:[NSArray class]]) {
            weakSelf.dataArray = array;
           weakSelf.textLengthArray = [weakSelf textLengthS];
            [weakSelf.collectionView reloadData];
            [self setupSubviews];
        }
        
        
    } failure:^(NSError *error) {
        DLog(@"error:%@",error)
    }];
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
        weakSelf.city = city;
    };
    
    [self.navigationController pushViewController:preference animated:YES];
    DLog(@"")
}

- (void)cancel:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setCity:(NSString *)city {
    if (_city == city) {
        return;
    }
    _city = city;
    
    [self.barButton setTitle:city forState:UIControlStateNormal];
}

- (void)actionBlock {
      self.param(_keyword, _city);
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark--------------- UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    DLog(@"")
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    //    _paraModel.keyword = searchBar.text;
    //    [self startSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.keyword = searchBar.text;
    [self actionBlock];
}

#pragma mark-------------------------UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NTPositionMarkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
    cell.label.text = _dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _keyword = _dataArray[indexPath.row];
    [self actionBlock];
}

#pragma mark-------------------------UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((KSCREEN_WIDTH - 15 * 2 - 8 * 3)/4, 28);
//    return CGSizeMake([_textLengthArray[indexPath.row] floatValue], 28);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets ed = UIEdgeInsetsMake(15, 15, 100, 15);
    return ed;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (NSArray *)textLengthS {
    NSMutableArray *textLengths = [NSMutableArray arrayWithCapacity:_dataArray.count];
    [_dataArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat textLength = [obj sizeWithFontOfSize:12 maxSize:CGSizeMake(CGFLOAT_MAX, 28)].width + 20;
        [textLengths addObject:@(textLength)];
    }];
    return textLengths;
}


#pragma mark-------------------------setNavSubViews

- (void)setNavSubViews {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270 * k_h_Scale, 44)];
    self.navigationItem.titleView = view;
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectZero];
    _searchBar.delegate = self;
    UITextField *searchTF = [_searchBar getTextFiled];
    _searchBar.backgroundImage = [[UIImage alloc] init];
    if (searchTF) {
        searchTF.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        searchTF.layer.borderWidth = 1;
        searchTF.backgroundColor = UIColorFromRGB(0xeef3f6);
        searchTF.layer.cornerRadius = 2;
        searchTF.attributedPlaceholder = [@"搜索" attributedPlaceholderWithString];
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
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:NTFontSize_12];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NTBlackColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = right;
}

- (void)setupSubviews {
    
    [self.view addSubview: self.collectionView];
    
    FEWeakSelf(weakSelf)
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 50, 0));
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = NTBGGreyColor;
        [_collectionView registerClass:[NTPositionMarkCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellID];
    }
    return _collectionView;
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
