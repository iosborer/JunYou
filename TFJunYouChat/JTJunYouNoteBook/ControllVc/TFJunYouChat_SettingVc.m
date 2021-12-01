//
//  TFJunYouChat_SettingVc.m
//  P-Note
//  设置页面
//  Created by yaxiongfang on 4/9/16.
//  Copyright © 2016 yxfang. All rights reserved.
//

#import "TFJunYouChat_SettingVc.h"
#import "AboutViewController.h"
#import "NoteFolderHelper.h"
#import "UserDefaultsUtils.h"
#import "StringUtils.h"
#import "Tools.h"

@implementation TFJunYouChat_SettingVc {
    UITableView *_tableView;

    // 开关按钮
    UISwitch *switchBtn;
    // 是否开启私密保护
    BOOL switchValue;
    // 是否设置密码
    BOOL hasPwd;

    // 已经保存过的密码
    NSString *savedPwd;

    // 保存第一次输入的密码
    NSString *_tempPwd;
    // 统计输入次数
    int inputCount;

    // 标识是否验证通过
    BOOL checkPass;
}
- (void)backButtonClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
 
    
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"设置";
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 20)];
     [backButton setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
     [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
     self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    [self initTableView];

    switchValue = [UserDefaultsUtils getAppInfoForKeyBool:@"p_switch"];
    savedPwd = [UserDefaultsUtils getAppInfoForKey:@"pwd"];
    if (![StringUtils isEmpty:savedPwd]) {
        hasPwd = YES;
    }
}

/**
 * 初始化tableview
 */
- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return switchValue ? 2 : 1;
    }
    else if (section == 1) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textLabel.text = @"开启私密保护";
            switchBtn = [[UISwitch alloc] initWithFrame:CGRectZero];

            [switchBtn setOn:switchValue];

            cell.accessoryView = switchBtn;
            [switchBtn addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"设置密码";
            if (hasPwd) {
                cell.detailTextLabel.text = @"已设置";
            }
            else {
                cell.detailTextLabel.text = @"未设置";
            }
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"清空数据";
        }
    }
    else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"当前版本";
            cell.detailTextLabel.text = [Tools getAppVersion];
        }
        else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"关于";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (hasPwd && !checkPass) {
                [self checkOldPwd];
            }
            else {
                [self showSetPwdDialog];
            }
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self clearData];
        }
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        
        AboutViewController *vc=[AboutViewController new];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AboutViewController *aboutViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [self.navigationController pushViewController:aboutViewController animated:true];
    }
}

/**
 * 判断是否设置私密开关 清空数据
 */
- (void)clearData {
    // 私密开关开启 并且 设置过密码
    if (switchValue && hasPwd) {
        [self openPwdInputDialog:@"" andOnClicked:nil andCompletion:^(NSString *pwd) {
            if ([pwd isEqualToString:self->savedPwd]) {
                [self doClearData];
            }
            else {
                [Tools showTip:self andMsg:@"密码不正确"];
            }
        }];
    }
    else {
        [self doClearData];
    }
}

/**
 * 执行清空数据
 */
- (void)doClearData {
    [super openAlertDialog:@"确定清空所有数据?" onClick:^(void) {
        @try {
            [[[NoteFolderHelper alloc] init] deleteAll];
            [Tools showTip:self andMsg:@"数据清空成功"];
            // 成功 发送更新列表通知
            [self postNotification:NOTIFICATION_UPDATE_FOLDER obj:nil];
        }
        @catch (NSException *exception) {
            [Tools showTip:self andMsg:@"数据清空失败"];
            NSLog(@"Exception occurred: %@, %@", exception, [exception userInfo]);
        }
    }];
}

- (void)checkOldPwd {
    [self openPwdInputDialog:@"请输入旧密码" andOnClicked:nil andCompletion:^(NSString *pwd) {
        if (![pwd isEqualToString:savedPwd]) {
            [Tools showTip:self andMsg:@"旧密码输入不正确,无法修改"];
        }
        else {
            [self showSetPwdDialog];
        }
    }];
}

/**
 * 弹出设置密码对话框
 */
- (void)showSetPwdDialog {

    [self openPwdInputDialog:@"" andOnClicked:^(void) {
        self->inputCount = 0;
        self->_tempPwd = @"";
    }          andCompletion:^(NSString *pwd) {
        self->inputCount++;
        if (self->inputCount == 1) {
            self->_tempPwd = pwd;
            [Tools showTip:self andMsg:@"请再次输入密码"];
        }
        else {
            DebugLog(@"%@ %@", self->_tempPwd, pwd);

            if (![pwd isEqualToString:self->_tempPwd]) {
                self->inputCount = 0;
                self->_tempPwd = @"";
                [Tools showTip:self andMsg:@"两次输入密码不一致"];
            }
            else {
                self->inputCount = 0;
                self->_tempPwd = @"";
                self->hasPwd = YES;
                [self->_tableView reloadData];
                [Tools showTip:self andMsg:@"密码设置成功"];
                [UserDefaultsUtils saveAppInfoForObject:@"pwd" andValue:pwd];
                [self postNotification:NOTIFICATION_UPDATE_SETTING obj:nil];
            }
        }
        DebugLog(@"andCompletion");
    }];
}

- (IBAction)onSwitchValueChanged:(id)sender {
    UISwitch *switchBtn = (UISwitch *) sender;

    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 1; i < 2; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }

    [_tableView beginUpdates];
    if (switchBtn.isOn) {
        [UserDefaultsUtils saveAppInfoForBool:@"p_switch" andValue:YES];
        switchValue = YES;
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    else {
        [UserDefaultsUtils saveAppInfoForBool:@"p_switch" andValue:NO];
        switchValue = NO;
        [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }

    [self postNotification:NOTIFICATION_UPDATE_SETTING obj:nil];

    [_tableView endUpdates];
}

@end
