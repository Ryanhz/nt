//
//  FEProtocol.h
//  neitui
//
//  Created by hzf on 16/7/9.
//  Copyright © 2016年 neitui. All rights reserved.
//



#import <Foundation/Foundation.h>

@protocol NTAttentionTableViewCellDelegate <NSObject>

@optional
- (void)cell:(UITableViewCell *)cell btnSelected:(BOOL)selected indexPath:(NSIndexPath *)indexPath;

@end

@protocol NTCellToolselegate <NSObject>

@optional

- (void)cell:(UITableViewCell *)cell tools:(id)sender;
- (void)cell:(UITableViewCell *)cell textEndEditingWithText:(NSString *)text IndexPath:(NSIndexPath *)indexPath;
- (void)cell:(UITableViewCell *)cell tools:(id)sender indexPath:(NSIndexPath *)indexPath;


@end

@protocol NTSelectedIndexDelegate <NSObject>

- (void)cell:(id)cell selectedIndex:(int)index;

@end



typedef enum : NSUInteger {
    follow_company_model,
    follow_referee_model,
    fans_referee_model,
    fans_candidate_model
} myfollowModel;

@protocol NTMyFollowDelegate <NSObject>

- (void)tableView:(UITableView *)tableView selectedModel:(id)model modelType:(myfollowModel)type;

@end