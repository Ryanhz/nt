//
//  NTBasicInformationTableViewCell.m
//  neitui
//
//  Created by hzf on 16/7/11.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTBasicInformationTableViewCell.h"

@interface NTBasicInformationTableViewCell ()

@property (nonatomic, weak)id targe;
@property (nonatomic, strong) UILabel *separator;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation NTBasicInformationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}


- (void)title:(NSString *)title isShowArrowhead:(BOOL)ishow targe:(id)targe {
    _label.text = title;
    _targe = targe;
    _textField.delegate = targe;
    self.arrow.hidden = !ishow;
    if (ishow) {
        _textField.enabled = NO;
    }
}

- (void)setupSubviews {
    _label = [[UILabel alloc]init];
    _label.textColor = UIColorFromRGB(0x4e4e4e);
    _label.font = [UIFont systemFontOfSize:NTFontSize_14];
    _label.textAlignment = NSTextAlignmentJustified;
    
    _textField = [[UITextField alloc] init];
    _textField.font = [UIFont systemFontOfSize:NTFontSize_14];
    _textField.textColor = UIColorFromRGB(0x2D2D2D);
    _textField.textAlignment = NSTextAlignmentRight;
    
    _separator = [[UILabel alloc] init];
    _separator.backgroundColor = NTBGGreyColor;
    
    [self.contentView addSubview:_label];
    [self.contentView addSubview:_textField];
    [self.contentView addSubview:_separator];
    [self setuplayouts];
}

- (void)setuplayouts {
    FEWeakSelf(weakSelf)
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(@20);
        make.width.equalTo(@70);
        make.height.equalTo(@20);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.label.mas_right);
        make.centerY.equalTo(weakSelf.label);
        make.right.equalTo(weakSelf.contentView).offset(-37);
        make.height.equalTo(weakSelf.label);
    }];
    [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@1);
    }];
}

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        _arrow.image = [UIImage imageNamed:@"arrowhead"];
        [self.contentView addSubview:_arrow];
        FEWeakSelf(weakSelf)
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.label);
            make.right.equalTo(weakSelf.contentView).offset(-20);
            make.height.equalTo(@10);
            make.width.equalTo(@7);
        }];
    }
    return _arrow;
}


@end
