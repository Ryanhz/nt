//
//  NTCityViewController.m
//  neitui
//
//  Created by hzf on 16/7/18.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTCityViewController.h"
#import "NTCityCollectionViewCell.h"
#import "NTCityCollectionReusableView.h"

static NSString *kCityCollectionCellIdentifier  = @"CellIdentifier";
static NSString *kCityCollectionReusableID = @"reuseableID";

@interface NTCityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NTCityModel *defaultModel;

@end

@implementation NTCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    
    _defaultModel = [[NTCityModel alloc] init];
    _defaultModel.name = @"上海";
    
    [self setDefaultBackBarItem];
    FEWeakSelf(weakSelf)
    [NTNetHelper getCityListSuccess:^(id data) {
        weakSelf.dataArray = data;
        [weakSelf setupSubviews];
//        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark-------------------------UICollectionViewDataSource, UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return NO;
    }
    DLog(@"%@",indexPath);
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    DLog(@"%@",indexPath);
    NTCityCollectionViewCell *cell = (NTCityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *String = cell.model.name;
    self.cityBlock(String);
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArray.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return ((NSArray *) _dataArray[section-1]).count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NTCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCityCollectionCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.model = _defaultModel;
        cell.selected = YES;
    } else {
        cell.model = _dataArray[indexPath.section -1][indexPath.row];
    }
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NTCityCollectionReusableView *reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCityCollectionReusableID forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            reuseableView.label.text = @"期望工作的城市";
        }
            break;
        case 1:
        {
            reuseableView.label.text = @"热门城市";
        }
            break;
        case 2:
        {
            reuseableView.label.text = @"ABCDEF";
        }
            /* 2    3       4   5   6   7
             abcdef ghij klmn opqr stuv wxyz
             */
            break;
        case 3:
        {
            reuseableView.label.text = @"GHIJ";
        }
            break;
        case 4:
        {
            reuseableView.label.text = @"KLMN";
        }
            break;
        case 5:
        {
            reuseableView.label.text = @"OPQR";
        }
            break;
        case 6:
        {
            reuseableView.label.text = @"STUV";
        }
            break;
        case 7:
        {
            reuseableView.label.text = @"WXYZ";
        }
            break;
            
        default:
            break;
    }
    return reuseableView;
}

#pragma mark-------------------------UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(k_h_Scale * 79, 34);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 16 * k_h_Scale, 20, 16 * k_h_Scale);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 22 * k_h_Scale;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(KSCREEN_WIDTH, 30);
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(0, 0);
//}



- (void)setupSubviews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[NTCityCollectionViewCell class] forCellWithReuseIdentifier:kCityCollectionCellIdentifier];
    [_collectionView registerClass:[NTCityCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCityCollectionReusableID];
    [self.view addSubview:_collectionView];
    
    FEWeakSelf(weakSelf)
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
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
