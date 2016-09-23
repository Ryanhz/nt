//
//  NTRefereeBaseInfoViewController.m
//  neitui
//
//  Created by hzf on 16/8/8.
//  Copyright © 2016年 neitui. All rights reserved.
//

#import "NTRefereeBaseInfoViewController.h"
#import "NTTextFieldTableViewCell.h"

static NSString *kBasicInformationTableViewCell = @"kBasicInformationTableViewCell";

@interface NTRefereeBaseInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, weak) UITextField *activeTF;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, assign) BOOL isCanPush;

@end

@implementation NTRefereeBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本信息";
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    _dataSource = @[@"姓      名：", @"公      司：", @"职      位：", @"公司邮箱：", @"毕业院校：", @"家      乡："];
    [self setupSubviews];
}

#pragma  mark------------ UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.textAlignment = NSTextAlignmentLeft;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL boo = YES;
    [textField endEditing:YES];
    
    return boo;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.textAlignment = NSTextAlignmentRight;
    switch (textField.tag) {
        case 1000:
        {
            //name
            if ([NSString checkUserName:textField.text]) {
//                _baseMessageModel.realname = textField.text;
            } else {
                textField.text = @"";
                [self.view makeToast:@"用户名只支持汉字和英文字母" duration:2 position:CSToastPositionCenter];
            }
        }
            break;
        case 1001:
        {
            //sex
            //            _baseMessageModel.sex = textField.text;
        }
            break;
        case 1002:
        {
            //workyear
            //            _baseMessageModel.workyear = textField.text;
        }
            break;
        case 1003:
        {
            //exppos
//            _baseMessageModel.exppos = textField.text;
        }
            break;
        default:
            break;
    }
}

- (BOOL)isOptionCompleted {
//    if (_baseMessageModel.realname && _baseMessageModel.sex &&_baseMessageModel.workyear &&_baseMessageModel.exppos) {
//        return YES;
//    }
//    
//    [self showAlertTitle:@"提示" message:@"你有选项没完成"];
    return YES;
}

- (void)nextSetp {
    _nextBtn.enabled = NO;
    if ([self isOptionCompleted]) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:loginChangeDic(user_referee, YES)];
        return;
    }
    _nextBtn.enabled = YES;
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark------- UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NTTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBasicInformationTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    cell.textField.returnKeyType = UIReturnKeyDone;
    cell.textField.tag = indexPath.row + 1000;
    cell.textField.textAlignment = NSTextAlignmentRight;
    [cell title:_dataSource[indexPath.row] targe:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak NTTextFieldTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FEWeakSelf(weakSelf)
    switch (indexPath.row) {
        case 0: //name
        case 3: // exppos
        {
            [cell.textField becomeFirstResponder];
            return;
        }
            break;
        case 1: //sex
        {
           
        }
            break;
        case 2://workyear
        {
           
        }
            break;
        default:
            break;
    }
    
    if (_isCanPush) {
        _isCanPush = NO;
//        [self.navigationController pushViewController:optionsVC animated:YES];
    }
}

- (void)setupSubviews {
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _tableView.backgroundColor = NTBGGreyColor;
    _tableView.scrollEnabled = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.rowHeight = 48;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[NTTextFieldTableViewCell class] forCellReuseIdentifier:kBasicInformationTableViewCell];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"完成" forState: UIControlStateNormal];
    [_nextBtn setBackgroundColor:UIColorFromRGB(0x30739e)];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextSetp) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:_tableView];
    
    [self.view addSubview:_nextBtn];
    
    
    FEWeakSelf(weakSelf)
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(64, 0, 44, 0));
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(@44);
    }];
    
    [self setupLayoutSubviews];
}

- (void)setupLayoutSubviews {
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view resignFirstResponder];
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
