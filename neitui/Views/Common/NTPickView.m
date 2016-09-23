//
//  NTPickView.m
//  neitui
//
//  Created by hzf on 16/7/25.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTPickView.h"
#import "AppDelegate.h"

@interface NTPickView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *pickContentView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UILabel *pickTitle;
@property (nonatomic, strong) UIPickerView *pickView;


@end

@implementation NTPickView

- (instancetype)init {
    self = [super init];
    if (self) {
        _numberOfComponents = 1;
        _rowHeight = 42;
        [self setupSubViews];
    }
    return self;
}


- (void)cancel:(UIButton *)button {
    [self hide];
}

- (void)ok:(UIButton *)button {
    
    NSInteger selectedIndex = [_pickView selectedRowInComponent:0];
    self.selectBlock(_dataArray[selectedIndex]);
    [self hide];
}

- (void)show {
    [_pickView reloadAllComponents];
    UIWindow *keyWindow = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
//    [self showLayouts];
}

- (void)hide {
//    [self hidelayout];
    [self removeFromSuperview];
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _pickTitle.text = title;
}


#pragma mark-------------------------UIPickerViewDataSource, UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return KSCREEN_WIDTH / _numberOfComponents;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return _rowHeight;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    if(view == nil) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH / _numberOfComponents, _rowHeight)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH / _numberOfComponents, _rowHeight)];
        label.tag = 10001;
        [label configFontSize:NTFontSize_16 textColor:NTBlackColor textAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        DLog(@"——————————创建%ld", (long)row)
    } else {
        DLog(@"——————————重用 %ld", (long)row)
    }
    
    UILabel *label = (UILabel *)[view viewWithTag:10001];
    label.text = _dataArray[row];
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    DLog(@"%@", _dataArray[row]);
//    self.selectBlock(_dataArray[row]);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _numberOfComponents;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArray.count;
}

- (void)setupSubViews {
    
    _backgroundView = [UIView new];
    _backgroundView.backgroundColor = UIColorFromRGB(0x979797);
    _backgroundView.alpha = 0.34;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    
    [_backgroundView addGestureRecognizer:tap];
    
    _pickContentView = [UIView new];
    _pickContentView.backgroundColor = [UIColor whiteColor];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    _pickTitle = [UILabel new];
    [_pickTitle configFontSize:NTFontSize_14 textColor:NTGreyColor textAlignment:NSTextAlignmentCenter];
    
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_okBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
    
    _pickView = [[UIPickerView alloc]init];
    _pickView.delegate = self;
    _pickView.showsSelectionIndicator = YES;
    _pickView.dataSource = self;
    
    FEWeakSelf(weakSelf)
    
    [self addSubview:_backgroundView];
    [self addSubview:_pickContentView];
    [_pickContentView addSubview:_cancelBtn];
    [_pickContentView addSubview:_pickTitle];
    [_pickContentView addSubview:_okBtn];
    [_pickContentView addSubview:_pickView];

    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [_pickContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.width.equalTo(weakSelf);
        make.height.equalTo(@200);
        make.centerX.equalTo(weakSelf);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pickContentView);
        make.left.equalTo(weakSelf.pickContentView);
        make.height.width.equalTo(@40);
    }];
    
    [_pickTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pickContentView);
        make.left.equalTo(weakSelf.cancelBtn.mas_right);
        make.right.equalTo(weakSelf.okBtn.mas_left);
        make.height.equalTo(weakSelf.cancelBtn);
    }];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.pickContentView);
        make.top.height.width.equalTo(weakSelf.cancelBtn);
    }];
    
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pickTitle.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.pickContentView);
    }];
}

- (void)showLayouts {
    FEWeakSelf(weakSelf)
    [_pickContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
    }];
    
    [UIView animateWithDuration:0.75 animations:^{
        [weakSelf layoutIfNeeded];
    }];
    
}

- (void)hidelayout {
    FEWeakSelf(weakSelf)
    [_pickContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(165);
    }];
    [UIView animateWithDuration:0.75 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
