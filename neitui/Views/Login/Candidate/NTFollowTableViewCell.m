//
//  NTAttentionTableViewCell.m
//  neitui
//
//  Created by hzf on 16/7/7.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTFollowTableViewCell.h"


@interface NTFollowTableViewCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation NTFollowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
    
}

- (void)setModel:(NTFollowModel *)model {
    _model = model;
    _nameLabel.text = model.realname;
    _positionLabel.text = [NSString stringWithFormat:@"%@  %@",model.company, model.department];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"placeholderHead"]];
}


- (void)isButtonSelected:(BOOL)selected {
    _button.selected = selected;
    _btnSelected = selected;
    if (selected) {
        _button.backgroundColor = UIColorFromRGB(0x30739e);
        _button.layer.borderColor = UIColorFromRGB(0x30739e).CGColor;
    } else {
        _button.backgroundColor = UIColorFromRGB(0xffffff);
        _button.layer.borderColor = UIColorFromRGB(0xd8d8d8).CGColor;
    }
}

- (void)btnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self isButtonSelected:sender.selected];
    
    if (_delegate && [_delegate respondsToSelector:@selector(cell:btnSelected:indexPath:)]) {
        [_delegate cell:self btnSelected:sender.selected indexPath:_indexPath];
    }
}

- (void)setupSubviews {
    _iconView = [[UIImageView alloc] init];
    _iconView.layer.cornerRadius = 16 ;
    _iconView.layer.masksToBounds = YES;
    _iconView.image = [UIImage imageNamed:@"placeholderHead"];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = UIColorFromRGB(0x3c3c3c);
    _nameLabel.font = [UIFont systemFontOfSize:NTFontSize_14];
    
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.textColor = UIColorFromRGB(0xbfbfbf);
    _positionLabel.font = [UIFont systemFontOfSize:NTFontSize_12];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *normalString = [[NSAttributedString alloc]initWithString:@"关注" attributes:@{
                                                                                                    NSFontAttributeName: [UIFont systemFontOfSize:NTFontSize_12],
                                                                                                    NSForegroundColorAttributeName: UIColorFromRGB(0xd8d8d8)}];
    NSAttributedString *selectedString = [[NSAttributedString alloc]initWithString:@"已关注" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:NTFontSize_12],
                                                                                                      NSForegroundColorAttributeName: UIColorFromRGB(0xffffff)}];
    [_button setAttributedTitle:normalString forState:UIControlStateNormal];
    [_button setAttributedTitle:selectedString forState:UIControlStateSelected];
    _button.layer.borderColor = UIColorFromRGB(0xd8d8d8).CGColor;
    _button.layer.borderWidth = 1;
    [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_positionLabel];
    [self.contentView addSubview:_button];
    [self setupLayouts];
}

- (void)setupLayouts {
    FEWeakSelf(weakSelf)
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(24 * k_h_Scale);
        make.width.height.equalTo(@32);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(16);
        make.left.equalTo(weakSelf.iconView.mas_right).offset(20);
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
        make.left.equalTo(weakSelf.nameLabel);
        make.height.equalTo(@17);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.height.equalTo(@22);
        make.width.equalTo(@48);
        make.left.equalTo(weakSelf.positionLabel.mas_right);
    }];
    
    
    
    
}

@end
