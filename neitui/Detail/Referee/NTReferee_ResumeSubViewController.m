//
//  NTReferee_ResumeSubViewController.m
//  neitui
//
//  Created by hzf on 16/8/9.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTReferee_ResumeSubViewController.h"
#import "NTReferee_recieveCondidateTableViewCell.h"

static NSString *kTableViewCell = @"kTableViewCell";

@interface NTReferee_ResumeSubViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NTResumeType resumeType;

@end

@implementation NTReferee_ResumeSubViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    DLog(@"");
}


- (instancetype)initWithType:(NTResumeType)Type {
    self = [super init];
    if (self) {
        _resumeType = Type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self getData];
}

- (void)getData {
    NSDictionary *param = @{
                            @"uid" : @"2",
                            @"type" : @(_resumeType)
                            };
    DLog(@"param:%@",param);
    FEWeakSelf(weakSelf)
    [NTNetHelper recieveCondidatesWithParam:param success:^(id data) {
//        DLog(@"data:%@",data);
        weakSelf.dataArray = data;
    } failure:^(NSError *error) {
        DLog(@"error:%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [_tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NTReferee_recieveCondidateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    cell.markText = [self cellMark];
    if (indexPath.row == _dataArray.count -1) {
        cell.isShowSeparator = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(selectedModel:indexPath:type:)]) {
        [_delegate selectedModel:_dataArray[indexPath.row] indexPath:indexPath type:_resumeType];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = NTBGGreyColor;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSString *)cellMark{
    NSString *markStr = nil;
    switch (_resumeType) {
        case NTResumeType_unread:
        {
            markStr = @"未处理";
        }
            break;
        case NTResumeType_referenced:
        {
            markStr = @"已内推";
        }
            break;
        case NTResumeType_interview:
        {
            markStr = @"已通知面试";
        }
            break;
        case NTResumeType_noPass:
        {
            markStr = @"未通过";
        }
            break;
            
        default:
            break;
    }
    return markStr;
}

#pragma mark-------------------------setupSubViews
- (void)setupSubViews {
    
    [self.view addSubview:self.tableView];
    
    FEWeakSelf(weakSelf)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.backgroundColor = NTBGGreyColor;
        //        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[NTReferee_recieveCondidateTableViewCell class] forCellReuseIdentifier:kTableViewCell];
        
    }
    return _tableView;
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
