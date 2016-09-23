//
//  NTPickDateView.m
//  neitui
//
//  Created by hzf on 16/8/3.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTPickDateView.h"
#import "AppDelegate.h"
#import "FEDatePickView.h"

@interface NTPickDateView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) FEDatePickView *startPicker;
@property (nonatomic, strong) FEDatePickView *endPicker;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UILabel *pickTitle;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;
@property (nonatomic, strong) UILabel *separator;

@end

@implementation NTPickDateView


- (instancetype) init {
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)cancel:(UIButton *)button {
    [self hide];
}

- (void)ok:(UIButton *)button {
    NSDate *datefrom = _startPicker.date;
    NSDate *dateend = _endPicker.date;
    NSDictionary *dic = @{@"datefrom":datefrom, @"dateend":dateend};
    
    if (self.selectBlock) {
        self.selectBlock(dic);
    }
    
    DLog(@"start:%@-------end:%@",datefrom, dateend);
    
    [self hide];
}

- (void)show {
    
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

- (void)setupSubViews {
    _backgroundView = [UIView new];
    _backgroundView.backgroundColor = UIColorFromRGB(0x979797);
    _backgroundView.alpha = 0.34;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    
    [_backgroundView addGestureRecognizer:tap];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    _pickTitle = [UILabel new];
    [_pickTitle configFontSize:NTFontSize_14 textColor:NTGreyColor textAlignment:NSTextAlignmentCenter];
    
    
    _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_okBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(ok:) forControlEvents:UIControlEventTouchUpInside];
    
    _startLabel = [UILabel new];
    [_startLabel configFontSize:12 textColor:NTGreyColor textAlignment:NSTextAlignmentCenter];
    _startLabel.text = @"开始时间";
    
    _startPicker = [[FEDatePickView alloc]init];
    [_startPicker setupMinYear:1966 maxYear:2050];
    [_startPicker selectToday];
    
    _separator = [UILabel new];
    [_separator configFontSize:12 textColor:NTBlueColor textAlignment:NSTextAlignmentCenter];
    _separator.text = @"-";
    
    _endLabel = [UILabel new];
    [_endLabel configFontSize:12 textColor:NTGreyColor textAlignment:NSTextAlignmentCenter];
    _endLabel.text = @"结束时间";
    
    _endPicker = [[FEDatePickView alloc]init];
    [_endPicker setupMinYear:1966 maxYear:2050];
    [_endPicker selectToday];
    
    FEWeakSelf(weakSelf)
    
    [self addSubview:_backgroundView];
    [self addSubview:_contentView];
    [_contentView addSubview:_cancelBtn];
    [_contentView addSubview:_pickTitle];
    [_contentView addSubview:_okBtn];
    [_contentView addSubview:_startLabel];
    [_contentView addSubview:_startPicker];
    [_contentView addSubview:_separator];
    [_contentView addSubview:_endLabel];
    [_contentView addSubview:_endPicker];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.width.equalTo(weakSelf);
        make.height.equalTo(@240);
        make.centerX.equalTo(weakSelf);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView);
        make.height.width.equalTo(@40);
    }];
    
    [_pickTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.cancelBtn.mas_right);
        make.right.equalTo(weakSelf.okBtn.mas_left);
        make.height.equalTo(weakSelf.cancelBtn);
    }];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView);
        make.top.height.width.equalTo(weakSelf.cancelBtn);
    }];
    
    [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pickTitle.mas_bottom);
        make.left.equalTo(weakSelf.contentView);
        make.height.equalTo(@17);
    }];
    
    [_startPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.startLabel.mas_bottom);
        make.left.bottom.equalTo(weakSelf.contentView);
        make.width.equalTo(weakSelf.startLabel);
        make.right.equalTo(weakSelf.separator.mas_left);
    }];
    
    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.startPicker);
        make.centerX.equalTo(weakSelf.contentView);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
    [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pickTitle.mas_bottom);
        make.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@17);
        make.left.equalTo(weakSelf.separator.mas_right);
        make.width.equalTo(weakSelf.startLabel);
    }];
    
    [_endPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.endLabel.mas_bottom);
        make.right.bottom.equalTo(weakSelf.contentView);
        make.width.equalTo(weakSelf.endLabel);
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
