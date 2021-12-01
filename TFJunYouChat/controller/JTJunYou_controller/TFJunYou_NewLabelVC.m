//
//  TFJunYou_NewLabelVC.m
//  TFJunYouChat
//
//  Created by p on 2018/6/21.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_NewLabelVC.h"
#import "TFJunYou_SelFriendVC.h"
#import "TFJunYou_SelectFriendsVC.h"
#import "TFJunYou_Cell.h"
#import "BMChineseSort.h"
#import "TFJunYou_UserInfoVC.h"
#import "TFJunYou_ChatViewController.h"

#define HEIGHT 54

@interface TFJunYou_NewLabelVC ()

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) UITextField *labelName;
@property (nonatomic, strong) UILabel *labelUserNum;
@end

@implementation TFJunYou_NewLabelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isShowFooterPull = NO;
    self.isGotoBack   = YES;
    [self createHeadAndFoot];
    
//    self.tableView.backgroundColor = HEXCOLOR(0xf0eff4);
    
    _array = [NSMutableArray array];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 3.f;
    [doneBtn setBackgroundColor:THEMECOLOR];
    [doneBtn.titleLabel setFont:SYSFONT(15)];
    doneBtn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 51 - 15, TFJunYou__SCREEN_TOP - 8 - 29, 51, 29);
    [doneBtn setTitle:Localized(@"JX_Confirm") forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeader addSubview:doneBtn];
    
    [self createTableHeaderView];
}

- (void)createTableHeaderView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, TFJunYou__SCREEN_WIDTH, 15)];
    label.text = Localized(@"JX_LabelName");
    label.textColor = HEXCOLOR(0x333333);
    label.font = SYSFONT(15);
    [view addSubview:label];
    
    UIView *fieldView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+9, TFJunYou__SCREEN_WIDTH-30, 40)];
    fieldView.backgroundColor = HEXCOLOR(0xF5F5F5);
    fieldView.layer.masksToBounds = YES;
    fieldView.layer.cornerRadius = 7.f;
    [view addSubview:fieldView];
    self.labelName = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, fieldView.frame.size.width - 24, fieldView.frame.size.height)];
    self.labelName.backgroundColor = [UIColor clearColor];
    self.labelName.font = [UIFont systemFontOfSize:16.0];
    self.labelName.placeholder = Localized(@"JX_LabelForExample");
    if (self.labelObj.groupName.length > 0) {
        self.labelName.text = self.labelObj.groupName;
    }
    [fieldView addSubview:self.labelName];
    
    self.labelUserNum = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(fieldView.frame) + 20, TFJunYou__SCREEN_WIDTH-30, 15)];
    self.labelUserNum.text = [NSString stringWithFormat:@"%@(0)",Localized(@"JX_LabelMembers")];
    self.labelUserNum.textColor = HEXCOLOR(0x333333);
    self.labelUserNum.font = SYSFONT(15);
    
    [view addSubview:self.labelUserNum];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-101-15, CGRectGetMaxY(fieldView.frame) + 20, 101, 15)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 15, 15)];
    imageView.center = CGPointMake(imageView.center.x, btn.frame.size.height / 2);
    imageView.image = [[UIImage imageNamed:@"person_add_green"] imageWithTintColor:THEMECOLOR];
    [btn addSubview:imageView];
    label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, btn.frame.size.width, btn.frame.size.height)];
    label.textColor = THEMECOLOR;
    label.text = Localized(@"JX_AddMembers");
    label.font = SYSFONT(15);
    [btn addSubview:label];
    [view addSubview:btn];
    
    view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, CGRectGetMaxY(btn.frame) + 10);
    
    self.tableView.tableHeaderView = view;
    
    NSString *userIdStr = self.labelObj.userIdList;
    NSArray *userIds = [userIdStr componentsSeparatedByString:@","];
    if (userIdStr.length <= 0) {
        userIds = nil;
    }
    [_array removeAllObjects];
    
    for (NSInteger i = 0; i < userIds.count; i ++) {
        TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
        user.userId = userIds[i];
//        NSString *userName = [TFJunYou_UserObject getUserNameWithUserId:userIds[i]];
//        user.userNickname = userName;
        
        [_array addObject:user];
    }
    self.labelUserNum.text = [NSString stringWithFormat:@"%@(%ld)",Localized(@"JX_LabelMembers"),_array.count];
    [self.tableView reloadData];
}

- (void)addFriendAction {
    
    TFJunYou_SelectFriendsVC *vc = [[TFJunYou_SelectFriendsVC alloc] init];
    vc.type = TFJunYou_SelectFriendTypeSelFriends;
    vc.delegate = self;
    vc.didSelect = @selector(selectFriendsDelegate:);
    
    NSMutableSet *set = [NSMutableSet set];
    for (NSInteger i = 0; i < self.array.count; i ++) {
        TFJunYou_UserObject *user = self.array[i];
        [set addObject:user.userId];
    }
    
    NSMutableArray *friends = [[TFJunYou_UserObject sharedInstance] fetchAllUserFromLocal];
    __block NSMutableArray *letterResultArr = [NSMutableArray array];
    //排序 Person对象
    [BMChineseSort sortAndGroup:friends key:@"userNickname" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        if (isSuccess) {
            letterResultArr = unGroupArr;
        }
    }];
//    NSMutableArray *letterResultArr = [BMChineseSort sortObjectArray:friends Key:@"userNickname"];
    NSMutableSet *numSet = [NSMutableSet set];
    for (NSInteger i = 0; i < letterResultArr.count; i ++) {
        NSMutableArray *arr = letterResultArr[i];
        for (NSInteger j = 0; j < arr.count; j ++) {
            TFJunYou_UserObject *user = arr[j];
            if ([set containsObject:user.userId]) {
                [numSet addObject:[NSNumber numberWithInteger:(i + 1) * 100000 + j + 1]];
            }
        }

    }
    if (numSet.count > 0) {
        vc.set = numSet;
    }
    vc.existSet = set;
    
    [g_navigation pushViewController:vc animated:YES];
}

- (void)selectFriendsDelegate:(TFJunYou_SelectFriendsVC *)vc {
    
    [_array removeAllObjects];
    
    for (NSInteger i = 0; i < vc.userIds.count; i ++) {
        TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
        user.userId = vc.userIds[i];
        user.userNickname = vc.userNames[i];
        
        [_array addObject:user];
    }
    self.labelUserNum.text = [NSString stringWithFormat:@"%@(%ld)",Localized(@"JX_LabelMembers"),_array.count];
    [self.tableView reloadData];
}

- (void)doneBtnAction:(UIButton *)btn {
    if (self.labelName.text.length <= 0) {
        [g_App showAlert:Localized(@"JX_EnterLabelName")];
        return;
    }
    
    self.labelName.text = [self.labelName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.labelName.text.length <= 0) {
        [TFJunYou_MyTools showTipView:@"请输入有效的标签名"];
        return;
    }

//    if (self.array.count <= 0) {
//        [g_App showAlert:Localized(@"JX_AddMember")];
//        return;
//    }
    
    if (self.labelObj.groupId.length > 0) {
        if (![self.labelName.text isEqualToString:self.labelObj.groupName]) {
            [g_server friendGroupUpdate:self.labelObj.groupId groupName:self.labelName.text toView:self];
        }
        
        NSMutableString *userIdListStr = [NSMutableString string];
        for (NSInteger i = 0; i < self.array.count; i ++) {
            TFJunYou_UserObject *user = self.array[i];
            if (i == 0) {
                [userIdListStr appendFormat:@"%@", user.userId];
            }else {
                [userIdListStr appendFormat:@",%@", user.userId];
            }
        }
        
        TFJunYou_LabelObject *label = [[TFJunYou_LabelObject alloc] init];
        label.userId = self.labelObj.userId;
        label.groupId = self.labelObj.groupId;
        label.groupName = self.labelName.text;
        label.userIdList = userIdListStr;
        [label insert];
        [g_server friendGroupUpdateGroupUserList:label.groupId userIdListStr:userIdListStr toView:self];
        
    }else {
        [g_server friendGroupAdd:self.labelName.text toView:self];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TFJunYou_UserObject *user = _array[indexPath.row];
    
    TFJunYou_Cell *cell=nil;
    NSString* cellName = @"TFJunYou_Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(cell==nil){
        
        cell = [[TFJunYou_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        [_table addToPool:cell];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = [TFJunYou_UserObject getUserNameWithUserId:user.userId];
    cell.index = (int)indexPath.row;
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.didTouch = @selector(onHeadImage:);
    cell.timeLabel.hidden = YES;
    cell.userId = user.userId;
    [cell.lbTitle setText:cell.title];
    
    cell.headImageView.tag = indexPath.row;
    cell.headImageView.delegate = cell.delegate;
    cell.headImageView.didTouch = cell.didTouch;
    
    cell.dataObj = user;
    cell.isSmall = YES;
    [cell headImageViewImageWithUserId:nil roomId:nil];
    return cell;
}

-(void)onHeadImage:(UIView*)sender{
    NSMutableArray *array;

    array = _array;
    TFJunYou_UserObject *user = [array objectAtIndex:sender.tag];
    if([user.userId isEqualToString:FRIEND_CENTER_USERID] || [user.userId isEqualToString:CALL_CENTER_USERID])
        return;
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId       = user.userId;
    vc.fromAddType = 6;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TFJunYou_UserObject *userObj = [_array objectAtIndex:indexPath.row];
    
    userObj = [[TFJunYou_UserObject sharedInstance] getUserById:userObj.userId];
    
    if ([userObj.status intValue] == -1) {

        [TFJunYou_MyTools showTipView:@"此用户已被拉入黑名单"];
        return;
    }
    
    TFJunYou_ChatViewController *sendView=[TFJunYou_ChatViewController alloc];
    
    sendView.scrollLine = 0;
    sendView.title = userObj.userNickname;

    sendView.chatPerson = userObj;
    sendView = [sendView init];
    //    [g_App.window addSubview:sendView.view];
    [g_navigation pushViewController:sendView animated:YES];
    sendView.view.hidden = NO;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:Localized(@"JX_Delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TFJunYou_UserObject *user = _array[indexPath.row];
        [_array removeObject:user];
        
        [_table reloadData];
        
    }];

    
    return @[deleteBtn];
    
}


//服务器返回数据
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_FriendGroupAdd] || [aDownload.action isEqualToString:act_FriendGroupUpdate]) {
        
        NSMutableString *userIdListStr = [NSMutableString string];
        for (NSInteger i = 0; i < self.array.count; i ++) {
            TFJunYou_UserObject *user = self.array[i];
            if (i == 0) {
                [userIdListStr appendFormat:@"%@", user.userId];
            }else {
                [userIdListStr appendFormat:@",%@", user.userId];
            }
        }
        
        
        TFJunYou_LabelObject *label = [[TFJunYou_LabelObject alloc] init];
        if (dict) {
            label.userId = dict[@"userId"];
            label.groupId = dict[@"groupId"];
            label.groupName = dict[@"groupName"];
        }else {
            label.userId = self.labelObj.userId;
            label.groupId = self.labelObj.groupId;
            label.groupName = self.labelName.text;
        }
        label.userIdList = userIdListStr;
        [label insert];
        
        [g_server friendGroupUpdateGroupUserList:label.groupId userIdListStr:userIdListStr toView:self];
        
    }
    
    if ([aDownload.action isEqualToString:act_FriendGroupUpdateGroupUserList]) {
    
        [g_notify postNotificationName:kLabelVCRefreshNotif object:nil];
        
        [self actionQuit];
    }
}



-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    
    return show_error;
}

-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait hide];
    return show_error;
}

-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
