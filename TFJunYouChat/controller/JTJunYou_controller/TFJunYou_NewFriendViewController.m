//
//  TFJunYou_NewFriendViewController.h.m
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_NewFriendViewController.h"
#import "TFJunYou_ChatViewController.h"
#import "AppDelegate.h"
#import "TFJunYou_Label.h"
#import "TFJunYou_ImageView.h"
#import "TFJunYou_FriendCell.h"
#import "TFJunYou_RoomPool.h"
#import "TFJunYou_FriendObject.h"
#import "UIFactory.h"
#import "TFJunYou_InputVC.h"
#import "TFJunYou_UserInfoVC.h"

@interface TFJunYou_NewFriendViewController ()<TFJunYou_FriendCellDelegate>

@end

@implementation TFJunYou_NewFriendViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack   = YES;
        self.title = Localized(@"JXNewFriendVC_NewFirend");
        //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
        [self createHeadAndFoot];
        self.isShowFooterPull = NO;
        
        self.tableView.backgroundColor = HEXCOLOR(0xF2F2F2);

        [g_notify addObserver:self selector:@selector(newRequest:) name:kXMPPNewRequestNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(newReceipt:) name:kXMPPReceiptNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(onSendTimeout:) name:kXMPPSendTimeOutNotifaction object:nil];

        poolCell = [[NSMutableDictionary alloc]init];
        current_chat_userId = FRIEND_CENTER_USERID;
    }
    return self;
}

- (void)dealloc {
//    NSLog(@"TFJunYou_NewFriendViewController.dealloc");
//    [super dealloc];
}

-(void)free{
    current_chat_userId = nil;
    [_array removeAllObjects];
//    [_array release];
    [poolCell removeAllObjects];
//    [poolCell release];
    
    [g_notify  removeObserver:self name:kXMPPNewRequestNotifaction object:nil];
    [g_notify  removeObserver:self name:kXMPPSendTimeOutNotifaction object:nil];
    [g_notify  removeObserver:self name:kXMPPReceiptNotifaction object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _array   = [[NSMutableArray alloc]init];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TFJunYou_FriendCell *cell=nil;
    NSString* cellName = [NSString stringWithFormat:@"msg_%d_%ld",_refreshCount,indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        TFJunYou_FriendObject *user=_array[indexPath.row];
        cell = [TFJunYou_FriendCell alloc];
        [_table addToPool:cell];
        cell.tag   = indexPath.row;
        cell.delegate = self;
        cell.title = user.remarkName.length > 0 ? user.remarkName : user.userNickname;
        cell.subtitle = user.userId;
        cell.bottomTitle = [TimeUtil formatDate:user.timeCreate format:@"MM-dd HH:mm"];
        cell.user        = user;
        cell.target      = self;
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        user = nil;
    }
    
    if (indexPath.row == _array.count - 1) {
        cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width, 0);
    }else {
        cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width, LINE_WH);
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_FriendObject *friend=_array[indexPath.row];
    TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
    user.userNickname = friend.userNickname;
    user.userId = friend.userId;
    
    TFJunYou_ChatViewController *sendView=[TFJunYou_ChatViewController alloc];
    sendView.isHiddenFooter = YES;
    sendView.title = friend.userNickname;
    sendView.chatPerson = user;
    sendView = [sendView init];
    [g_navigation pushViewController:sendView animated:YES];
}

- (void)friendCell:(TFJunYou_FriendCell *)friendCell headImageAction:(NSString *)userId {
    
//    [g_server getUser:userId toView:self];
    
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId       = userId;
    vc.fromAddType = 6;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}

-(void)refresh{
    [self stopLoading];
    _refreshCount++;
//    [_array release];
    _array=[[TFJunYou_FriendObject sharedInstance] fetchAllFriendsFromLocal];
    [_table reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.row);
    TFJunYou_FriendObject *user = _array[indexPath.row];
    [_array removeObjectAtIndex:indexPath.row];
    [user delete];
    [_table reloadData];
}

-(void)scrollToPageUp{
    [self refresh];
}

-(void)onSendTimeout:(NSNotification *)notifacation//超时未收到回执
{
    [_wait stop];
    TFJunYou_MessageObject *msg     = (TFJunYou_MessageObject *)notifacation.object;
    if(msg==nil)
        return;
    TFJunYou_FriendCell* cell = [poolCell objectForKey:msg.messageId];
    if(cell){
//        [g_App showAlert:Localized(@"JXAlert_SendFilad")];
        [TFJunYou_MyTools showTipView:Localized(@"JXAlert_SendFilad")];
        [poolCell removeObjectForKey:msg.messageId];
    }
}

-(void)newRequest:(NSNotification *)notifacation{//新推送
//    NSLog(@"newRequest");
    TFJunYou_FriendObject *user     = (TFJunYou_FriendObject *)notifacation.object;
    if(user == nil)
        return;
//    if(_wait.isShowing)//正在等待，就不刷新
//        return;
    for(int i=0;i<[_array count];i++){
        TFJunYou_FriendObject* friend = [_array objectAtIndex:i];
        if([friend.userId isEqualToString:user.userId]){
            [friend loadFromObject:user];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            TFJunYou_FriendCell* cell = (TFJunYou_FriendCell*)[_table cellForRowAtIndexPath:indexPath];
            [cell update];
            cell = nil;
            return;
        }
        friend = nil;
    }
    [self refresh];
}

-(void)onSayHello:(UIButton*)sender{//打招呼
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    _cell = (TFJunYou_FriendCell*)[_table cellForRowAtIndexPath:indexPath];

    TFJunYou_InputVC* vc = [TFJunYou_InputVC alloc];
    vc.delegate = self;
    vc.didTouch = @selector(onInputHello:);
    vc.inputText = Localized(@"JXNewFriendVC_Iam");
    vc = [vc init];
    [g_window addSubview:vc.view];
}

-(void)onInputHello:(TFJunYou_InputVC*)sender{
    NSString* messageId = [_cell.user doSendMsg:XMPP_TYPE_SAYHELLO content:sender.inputText];
    [poolCell setObject:_cell forKey:messageId];
    [_wait start:nil];
}


-(void)onFeedback:(UIButton*)sender{//回话
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    _cell = (TFJunYou_FriendCell*)[_table cellForRowAtIndexPath:indexPath];
    
    TFJunYou_InputVC* vc = [TFJunYou_InputVC alloc];
    vc.delegate = self;
    vc.didTouch = @selector(onInputReply:);
    vc.inputText = Localized(@"JXNewFriendVC_Who");
    vc = [vc init];
    [g_window addSubview:vc.view];
}

-(void)onInputReply:(TFJunYou_InputVC*)sender{
    NSString* messageId = [_cell.user doSendMsg:XMPP_TYPE_FEEDBACK content:sender.inputText];
    [poolCell setObject:_cell forKey:messageId];
    [_wait start:nil];
}

-(void)onSeeHim:(UIButton*)sender{//关注他
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    TFJunYou_FriendCell* cell = (TFJunYou_FriendCell*)[_table cellForRowAtIndexPath:indexPath];
    NSString* messageId = [cell.user doSendMsg:XMPP_TYPE_NEWSEE content:nil];
    [poolCell setObject:cell forKey:messageId];
    [_wait start:nil];
}

-(void)onAddFriend:(UIButton*)sender{//加好友
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    _cell = (TFJunYou_FriendCell*)[_table cellForRowAtIndexPath:indexPath];
    _user = _cell.user;
    [g_server addAttention:_user.userId fromAddType:0 toView:self];
}

-(void)actionQuit{
    [self free];
    [super actionQuit];
}

-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_AttentionAdd]){
        int n = [[dict objectForKey:@"type"] intValue];
        if( n==2 || n==4)
            _friendStatus = 2;
//        else
//            _friendStatus = 1;

        if(_friendStatus == 2){
            NSString* messageId = [_user doSendMsg:XMPP_TYPE_PASS content:nil];
            [poolCell setObject:_cell forKey:messageId];
            [_wait start:nil];
            messageId = nil;
        }
    }
    
    //点击好友头像响应
    if( [aDownload.action isEqualToString:act_UserGet] ){
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        
        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
        vc.user       = user;
        vc.fromAddType = 6;
//        vc.isJustShow = YES;
        vc = [vc init];
//        [g_window addSubview:vc.view];
        [g_navigation pushViewController:vc animated:YES];
//        [self cancelBtnAction];
    }
}

-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    return show_error;
}

-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    return show_error;
}

-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}

-(void)newReceipt:(NSNotification *)notifacation{//新回执
    //    NSLog(@"newReceipt");
    [_wait stop];
    TFJunYou_MessageObject *msg     = (TFJunYou_MessageObject *)notifacation.object;
    if(msg == nil)
        return;
    if(![msg isAddFriendMsg])
        return;
    if(![msg.toUserId isEqualToString:_cell.user.userId])
        return;
    if([msg.type intValue] == XMPP_TYPE_PASS){//通过
        _friendStatus = friend_status_friend;
        _user.status = [NSNumber numberWithInt:_friendStatus];
        [_user update];

        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc] init];
        msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
        msg.toUserId = _user.userId;
        msg.fromUserId = MY_USER_ID;
        msg.fromUserName = g_server.myself.userNickname;
        msg.content = Localized(@"JXFriendObject_StartChat");
        msg.timeSend = [NSDate date];
        [msg insert:nil];
        [msg updateLastSend:UpdateLastSendType_None];
        [msg notifyNewMsg];
    }
    
    TFJunYou_FriendCell* cell = [poolCell objectForKey:msg.messageId];
    if(cell){
        [cell.user loadFromMessageObj:msg];
        [cell update];
        [g_App showAlert:Localized(@"JXAlert_SendOK")];
        [poolCell removeObjectForKey:msg.messageId];
    }
}

@end
