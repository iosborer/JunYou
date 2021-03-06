//
//  TFJunYou_PublicNumberVC.m
//  TFJunYouChat
//
//  Created by p on 2018/6/4.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_PublicNumberVC.h"
#import "TFJunYou_Cell.h"
#import "TFJunYou_ChatViewController.h"
#import "TFJunYou_SearchUserVC.h"
#import "TFJunYou_TransferNoticeVC.h"
#import "TFJunYou_UserInfoVC.h"

@interface TFJunYou_PublicNumberVC ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation TFJunYou_PublicNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    self.isShowHeaderPull = NO;
    self.isShowFooterPull = NO;
    _array = [NSMutableArray array];
    self.title = Localized(@"JX_PublicNumber");
    [self createHeadAndFoot];
    [self setupSearchPublicNumber];

    [self getServerData];
    
    [g_notify addObserver:self selector:@selector(newReceipt:) name:kXMPPReceiptNotifaction object:nil];
}

-(void)newReceipt:(NSNotification *)notifacation{//新回执
    //    NSLog(@"newReceipt");
    TFJunYou_MessageObject *msg     = (TFJunYou_MessageObject *)notifacation.object;
    if(msg == nil)
        return;
    if(![msg isAddFriendMsg])
        return;
    [_wait stop];
    
    if([msg.type intValue] == XMPP_TYPE_DELALL){//删除好友
        [self getServerData];
        [g_notify postNotificationName:kXMPPNewFriendNotifaction object:nil];

    }
}

- (void)setupSearchPublicNumber {
    if ([g_config.enableMpModule boolValue]) {
        UIButton *moreBtn = [UIFactory createButtonWithImage:@"search_publicNumber_black"
                                                   highlight:nil
                                                      target:self
                                                    selector:@selector(searchPublicNumber)];
        moreBtn.custom_acceptEventInterval = 1.0f;
        moreBtn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 18-15, TFJunYou__SCREEN_TOP - 18-15, 18, 18);
        [self.tableHeader addSubview:moreBtn];
    }
}


- (void)searchPublicNumber {
    TFJunYou_SearchUserVC *searchUserVC = [TFJunYou_SearchUserVC alloc];
    searchUserVC.type = TFJunYou_SearchTypePublicNumber;
    searchUserVC = [searchUserVC init];
    [g_navigation pushViewController:searchUserVC animated:YES];
}

- (void)getServerData {
    
    self.array = [[TFJunYou_UserObject sharedInstance] fetchSystemUser];

    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_UserObject *user = _array[indexPath.row];
    
    
    
    TFJunYou_Cell *cell=nil;
    NSString* cellName = @"TFJunYou_Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(cell==nil){
        
        cell = [[TFJunYou_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        [_table addToPool:cell];
        
    }
    
    cell.title = user.userNickname;
    
    cell.index = (int)indexPath.row;
    cell.delegate = self;
//    cell.didTouch = @selector(onHeadImage:);
    [cell setForTimeLabel:[TimeUtil formatDate:user.timeCreate format:@"MM-dd HH:mm"]];
    cell.timeLabel.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 115-15, 59/2-10, 115, 20);
    cell.userId = user.userId;
    [cell.lbTitle setText:cell.title];
    
    cell.dataObj = user;
    //    cell.headImageView.tag = (int)indexPath.row;
    //    cell.headImageView.delegate = cell.delegate;
    //    cell.headImageView.didTouch = cell.didTouch;
    
    cell.isSmall = YES;
    [cell headImageViewImageWithUserId:nil roomId:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TFJunYou_Cell* cell = (TFJunYou_Cell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;
    TFJunYou_UserObject *user = _array[indexPath.row];
    
    if ([user.userId intValue] == [SHIKU_TRANSFER intValue]) {
        TFJunYou_TransferNoticeVC *noticeVC = [[TFJunYou_TransferNoticeVC alloc] init];
        [g_navigation pushViewController:noticeVC animated:YES];
        return;
    }
    
    if([user.userType intValue] == 2 && [user.status intValue] != 2){
        TFJunYou_UserInfoVC* userVC = [TFJunYou_UserInfoVC alloc];
        userVC.userId = user.userId;
        userVC.user = user;
        userVC.fromAddType = 6;
        userVC = [userVC init];
        
        [g_navigation pushViewController:userVC animated:YES];
        return;
    }
    
    TFJunYou_ChatViewController *sendView=[TFJunYou_ChatViewController alloc];
    
    sendView.scrollLine = 0;
    sendView.title = user.userNickname;
    sendView.chatPerson = user;
    sendView = [sendView init];
    [g_navigation pushViewController:sendView animated:YES];
    sendView.view.hidden = NO;
}



// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TFJunYou_UserObject *user = _array[indexPath.row];
         _currentIndex = indexPath.row;
        [g_server delAttention:user.userId toView:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    TFJunYou_UserObject *user = _array[indexPath.row];

    if ([user.userId intValue] == 10000) {
        return NO;
    }
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Localized(@"JX_Delete");
}

//服务器返回数据
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    
    if ([aDownload.action isEqualToString:act_AttentionDel]) {
        [_wait stop];
        
        TFJunYou_UserObject *user = _array[_currentIndex];
        [_array removeObject:user];
        [_table deleteRow:(int)_currentIndex section:0];
        
        [user doSendMsg:XMPP_TYPE_DELALL content:nil];

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


@end
