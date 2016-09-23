//
//  MessageViewController.m
//  Neitui
//
//  Created by hzf on 16/6/30.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTMessageViewController.h"
#import "NTMessageModel1.h"
#import "NTMessageModel2.h"
#import "NTMessageTableVeiwCell1.h"
#import "NTMessageTableVeiwCell2.h"

#define kMessageCell1Indentifier @"messageCell1"
#define kMessageCell2Indentifier @"messageCell2"

@interface NTMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *conversations;

@end

@implementation NTMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.hidesBottomBarWhenPushed = NO;
    [self refreshDataSource];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
  
    [self setupSubviews];
    
}

- (void)getConversations {
    
    _conversations = [[NSMutableArray alloc] init];
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    DLog(@"conversations:%@",_conversations)
   
    for (EMConversation *conversation in conversations) {
        EaseMessageModel *model = nil;
        model = [[EaseMessageModel alloc] initWithMessage:conversation.latestMessage];
        //防止添加空白会话
        if (!model.message.from && !model.message.to) {
            break;
        }
        NTMessageModel2 *model2 = [[NTMessageModel2 alloc] init];
        model2.icon = @"res7.jpg";
    
        model2.messageModel = model;
        [_conversations addObject:model2];
    }
}

- (void)refreshDataSource {
    [self getConversations];
    [self.tableView reloadData];
}

- (void)setupSubviews {
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.backgroundColor = NTBGGreyColor;
    _tableView.dataSource = self;
    [_tableView registerClass:[NTMessageTableVeiwCell1 class] forCellReuseIdentifier:kMessageCell1Indentifier];
    [_tableView registerClass:[NTMessageTableVeiwCell2 class] forCellReuseIdentifier:kMessageCell2Indentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.separatorColor = NTBGGreyColor;
    [self.view addSubview:_tableView];
    
    FEWeakSelf(weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}
#pragma mark------
#pragma mark------ UITableViewDataSource  UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NTMessageTableVeiwCell1 *cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell1Indentifier forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NTMessageModel1 *model1 = [[NTMessageModel1 alloc]init];
        model1.icon = @"res7.jpg";
        model1.postTime = @"1";
        model1.message = @"34";
        [cell setCell:model1];
        return cell;
    } else {
        NTMessageTableVeiwCell2 *cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell2Indentifier forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.model = _conversations[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectedIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 11;
    }
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 11)];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 69;
    } else {
        return 68;
    }
}

- (void)selectedIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         [self jumpTochatwithChatter:@"22"];
        
    } else if (indexPath.section == 1) {
        NTMessageModel2 *model = _conversations[indexPath.row];
        NSString *chatter = model.from;
        [self jumpTochatwithChatter:chatter];
    }
}


- (void)jumpTochatwithChatter:(NSString *)chatter {
    ChatViewController *chatController = [[ChatViewController alloc]initWithConversationChatter:chatter conversationType:EMConversationTypeChat];
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
}



@end
