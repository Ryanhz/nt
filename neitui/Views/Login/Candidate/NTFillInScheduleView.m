//
//  NTFillInScheduleView.m
//  neitui
//
//  Created by hzf on 16/7/11.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTFillInScheduleView.h"

@interface NTFillInScheduleView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger progress;

@end

@implementation NTFillInScheduleView

- (instancetype)initWithProgress:(NSInteger)progress {
    self = [super init];
    if (self) {
        _progress = progress;
        [self setupSubviews];
    }
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setupSubviews {
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"progress%ld",_progress]];
    _imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_imageView];
    [self setupLayouts];
}

- (void)setupLayouts {
    FEWeakSelf(weakSelf)
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.width.equalTo(@190);
        make.height.equalTo(@20);
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
