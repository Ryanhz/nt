//
//  NTBasicInformationTableViewCell.h
//  neitui
//
//  Created by hzf on 16/7/11.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTBasicInformationTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UITextField *textField;

- (void)title:(NSString *)title isShowArrowhead:(BOOL)ishow targe:(id)targe;


@end
