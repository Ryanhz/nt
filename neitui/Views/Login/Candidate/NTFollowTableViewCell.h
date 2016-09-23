//
//  NTAttentionTableViewCell.h
//  neitui
//
//  Created by hzf on 16/7/7.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEProtocol.h"
#import "NTFollowModel.h"

@interface NTFollowTableViewCell : UITableViewCell

@property (nonatomic, strong) NTFollowModel *model;
@property (nonatomic, weak) id <NTAttentionTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign, setter=isButtonSelected:) BOOL btnSelected;


@end

