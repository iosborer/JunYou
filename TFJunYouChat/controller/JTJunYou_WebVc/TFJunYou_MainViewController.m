//
//  TFJunYou_MainViewController.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/15.
//  Copyright © 2020 zengwOS. All rights reserved.
//


#import "TFJunYou_MainViewController.h"
#import "TFJunYou_TabMenuView.h"
#import "TFJunYou_MsgViewController.h"
#import "TFJunYou_FriendViewController.h"
#import "AppDelegate.h"
#import "TFJunYou_NewFriendViewController.h"
#import "TFJunYou_FriendObject.h"
#import "TFJunYou_PSMyViewController.h"
 
#import "TFJunYou_WeiboVC.h"
#import "TFJunYou_SquareViewController.h"
#import "TFJunYou_ProgressVC.h"
#import "TFJunYou_GroupViewController.h"
#import "OrganizTreeViewController.h"
#import "TFJunYou_LabelObject.h"
#import "TFJunYou_BlogRemind.h"
#import "TFJunYou_RoomPool.h"
#import "TFJunYou_DeviceAuthController.h"
#import "CYWebAddPointVC.h"
#import "CYWebBettingVC.h"
//#import "BrowserViewController.h"

#import "TFJunYou_PublishVc.h"

#import "TFJunYou_AddrBookVc.h"
#import "TFJunYou_FriendCirleVc.h"

#import "WKWebViewController.h"

@interface TFJunYou_MainViewController()

@end
@implementation TFJunYou_MainViewController{
    NSString * _linkName1;
    NSString * _linkName2;
    NSString * _linkURL1;
    NSString * _linkURL2;
    NSString * _imgUrl1;
    NSString * _imgUrl2;
}

@synthesize btn=_btn,mainView=_mainView;
@synthesize IS_HR_MODE;
@synthesize psMyviewVC=_psMyviewVC;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isLoadFriendAndGroup = [g_server.myself fetchAllFriends].count < 6;
        self.view.backgroundColor = [UIColor clearColor];
        if(AppStore == 1){
        } else {
            self.vcnum = (int)g_App.linkArray.count;
        }
        if (self.vcnum < 0 || self.vcnum >2) {
            self.vcnum = 0;
        }else{
            for (int i = 0; i < self.vcnum; i++) {
                if (i == 0) {
                    _linkName1 = g_App.linkArray[i][@"desc"];
                    _linkURL1 = g_App.linkArray[i][@"link"];
                    _imgUrl1 = g_App.linkArray[i][@"imgUrl"];
                    if (_linkName1.length < 1) {
                        _linkName1 = @"百度";
                    }
                    if (_linkURL1.length < 1) {
                        _linkURL1 = @"http://www.baidu.com";
                    }
                }else if (i == 1){
                    _linkName2 = g_App.linkArray[i][@"desc"];
                    _linkURL2 = g_App.linkArray[i][@"link"];
                    _imgUrl2 = g_App.linkArray[i][@"imgUrl"];
                    if (_linkName2.length < 1) {
                        _linkName2 = @"百度";
                    }
                    if (_linkURL2.length < 1) {
                        _linkURL2 = @"http://www.baidu.com";
                    }
                }
            }
        }
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_TOP)];
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT)];
        [self.view addSubview:_mainView];
        _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_HEIGHT-TFJunYou__SCREEN_BOTTOM, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_BOTTOM)];
        _bottomView.userInteractionEnabled = YES;
        _bottomView.backgroundColor = HEXCOLOR(0xF1F1F1);
        [self.view addSubview:_bottomView];
        [self buildTop];
        
#ifdef IS_SHOW_MENU
        _squareVC = [[TFJunYou_SquareViewController alloc] init];
#else
        if (self.vcnum == 0) {
            _weiboVC = [TFJunYou_WeiboVC alloc];
            _weiboVC.user = g_server.myself;
            _weiboVC = [_weiboVC init];
        }else if(self.vcnum == 1) {
            _weiboVC = [TFJunYou_WeiboVC alloc];
            _weiboVC.user = g_server.myself;
            _weiboVC = [_weiboVC init];
            _webAddPointVC = [[CYWebAddPointVC alloc] init];
            _webAddPointVC.name = _linkName1;
            _webAddPointVC.strURL = _linkURL1;
        }else if(self.vcnum == 2) {
            _weiboVC = [TFJunYou_WeiboVC alloc];
            _weiboVC.user = g_server.myself;
            _weiboVC = [_weiboVC init];
            _webAddPointVC = [[CYWebAddPointVC alloc] init];
            _webAddPointVC.name = _linkName1;
            _webAddPointVC.strURL = _linkURL1;
            _webBettingVC = [[CYWebBettingVC alloc] init];
            _webBettingVC.name = _linkName2;
            _webBettingVC.strURL = _linkURL2;
        }
#endif
        if (g_server.isManualLogin && self.isLoadFriendAndGroup) {
            _groupVC = [TFJunYou_GroupViewController alloc];
            [_groupVC scrollToPageUp];
        }
        _msgVc = [[TFJunYou_MsgViewController alloc] init];
        _friendVC = [[TFJunYou_FriendViewController alloc] init];
        _xinfriendVC = [[TFJunYou_AddrBookVc alloc] init];
        
        _cirleFriendVc = [[TFJunYou_FriendCirleVc alloc] init];
//        _browserVc = [[BrowserViewController alloc] init];
        
        _psMyviewVC = [[TFJunYou_PSMyViewController alloc] init];
        
        
        _psMyviewVC = [[TFJunYou_PSMyViewController alloc] init];
        [self doSelected:0];
        [g_notify addObserver:self selector:@selector(loginSynchronizeFriends:) name:kXmppClickLoginNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(appDidEnterForeground) name:kApplicationWillEnterForeground object:nil];
        [g_notify addObserver:self selector:@selector(getUserInfo:) name:kXMPPMessageUpadteUserInfoNotification object:nil];
        [g_notify addObserver:self selector:@selector(getRoomSet:) name:kXMPPMessageUpadteGroupNotification object:nil];
        [g_notify addObserver:self selector:@selector(onXmppLoginChanged:) name:kXmppLoginNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(hasLoginOther:) name:kXMPPLoginOtherNotification object:nil];
        [g_notify addObserver:self selector:@selector(showDeviceAuth:) name:kDeviceAuthNotification object:nil];
    }
    return self;
}
- (void)appEnterForegroundNotif:(NSNotification *)noti {
    [g_server offlineOperation:(g_server.lastOfflineTime *1000 + g_server.timeDifference)/1000 toView:self];
}
- (void)getUserInfo:(NSNotification *)noti {
    TFJunYou_MessageObject *msg = noti.object;
    [g_server getUser:msg.toUserId toView:self];
}
- (void)getRoomSet:(NSNotification *)noti {
    TFJunYou_MessageObject *msg = noti.object;
    [g_server getRoom:msg.toUserId toView:self];
}
-(void)dealloc{
    [g_notify removeObserver:self name:kXmppLoginNotifaction object:nil];
    [g_notify removeObserver:self name:kSystemLoginNotifaction object:nil];
    [g_notify removeObserver:self name:kXmppClickLoginNotifaction object:nil];
    [g_notify removeObserver:self name:kXMPPLoginOtherNotification object:nil];
    [g_notify removeObserver:self name:kApplicationWillEnterForeground object:nil];
    [g_notify removeObserver:self name:kXMPPMessageUpadteUserInfoNotification object:nil];
    [g_notify removeObserver:self name:kDeviceAuthNotification object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loginSynchronizeFriends:nil];
    if (g_server.isManualLogin) {
        if (self.isLoadFriendAndGroup) {
            NSArray *array = [[TFJunYou_LabelObject sharedInstance] fetchAllLabelsFromLocal];
            if (array.count <= 0) {
                [g_server friendGroupListToView:self];
            }
        }
    }
    [g_server getCurrentTimeToView:self];
    [g_server getUser:MY_USER_ID toView:self];
}
- (void)appDidEnterForeground {
    [g_server getCurrentTimeToView:self];
}
- (void)loginSynchronizeFriends:(NSNotification*)notification{
        if (self.isLoadFriendAndGroup) {
            [g_server listAttention:0 userId:MY_USER_ID toView:self];
        }else{
            [[TFJunYou_XMPP sharedInstance] performSelector:@selector(login) withObject:nil afterDelay:2];
        }
        [[TFJunYou_XMPP sharedInstance] performSelector:@selector(login) withObject:nil afterDelay:2];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10002) {
        [g_server performSelector:@selector(showLogin) withObject:nil afterDelay:0.5];
        return;
    }else if (buttonIndex == 1) {
        [g_server listAttention:0 userId:MY_USER_ID toView:self];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)buildTop{
    _tb = [TFJunYou_TabMenuView alloc];

    if (self.vcnum == 0) {
        _tb.items = [NSArray arrayWithObjects:Localized(@"JXMainViewController_Message"),Localized(@"JX_MailList"),@"发现",Localized(@"JX_My"),nil];
        _tb.imagesNormal = [NSArray arrayWithObjects:@"news_normal",@"group_chat_normal",@"find_normal",@"me_normal",nil];
        _tb.imagesSelect = [NSArray arrayWithObjects:@"news_press_gray",@"group_chat_press_gray",@"find_press_gray",@"me_press_gray",nil];
    }else if(self.vcnum == 1){
        _tb.items = [NSArray arrayWithObjects:Localized(@"JXMainViewController_Message"),Localized(@"JX_MailList"),_linkName1,@"发现",Localized(@"JX_My"),nil];
        _tb.imagesNormal = [NSArray arrayWithObjects:@"news_normal",@"group_chat_normal",@"find_normal",@"find_normal",@"me_normal",nil];
        _tb.imagesSelect = [NSArray arrayWithObjects:@"news_press_gray",@"group_chat_press_gray",@"find_press_gray",@"find_press_gray",@"me_press_gray",nil];
    }else if (self.vcnum == 2){
        _tb.items = [NSArray arrayWithObjects:Localized(@"JXMainViewController_Message"),Localized(@"JX_MailList"),_linkName1,_linkName2,Localized(@"JX_My"),nil];
        _tb.imagesNormal = [NSArray arrayWithObjects:@"news_normal",@"group_chat_normal",@"find_normal",@"find_normal",@"me_normal",nil];
        _tb.imagesSelect = [NSArray arrayWithObjects:@"news_press_gray",@"group_chat_press_gray",@"find_press_gray",@"find_press_gray",@"me_press_gray",nil];
    }
    _tb.delegate  = self;
    _tb.onDragout = @selector(onDragout:);
    [_tb setBackgroundImageName:@"MessageListCellBkg"];
    _tb.onClick  = @selector(actionSegment:);
    _tb = [_tb initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_BOTTOM)];
    [_bottomView addSubview:_tb];
    NSMutableArray *remindArray = [[TFJunYou_BlogRemind sharedInstance] doFetchUnread];
    [_tb setBadge:2 title:[NSString stringWithFormat:@"%ld",remindArray.count]];
    
}
-(void)onDragout:(UIButton*)sender{
 
}
-(void)actionSegment:(UIButton*)sender{
    [self doSelected:(int)sender.tag];
}
-(void)doSelected:(int)n{
    if (n == 2) {
        WKWebViewController *nextVC = [WKWebViewController new];
        nextVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self showViewController:nextVC sender:nil];
        return;
    }
    
    [_selectVC.view removeFromSuperview];
    switch (n){
        case 0:
            #ifdef IS_SHOW_MENU
                        _selectVC = _squareVC;
            #else
                        if (self.vcnum == 0) {
                            _selectVC = _msgVc;
                        }else if(self.vcnum == 1){
                            _selectVC = _msgVc;
                        }else if(self.vcnum == 2){
                            _selectVC = _msgVc;
                        }
            #endif
            break;
        case 1:
            if (self.vcnum == 0) {
                _selectVC = _friendVC;
            }else if(self.vcnum == 1){
                _selectVC = _friendVC;
            }else if(self.vcnum == 2){
                _selectVC = _friendVC;
            }
            break;
        case 2:
            
            /*
            if (self.vcnum == 0) {
                _selectVC = _weiboVC;
            }else if(self.vcnum == 1){
                _selectVC = _webAddPointVC;
            }else if(self.vcnum == 2){
                _selectVC = _webAddPointVC;
            }
            */
            
           _selectVC = _cirleFriendVc;
            
            break;
        case 3:
            if (self.vcnum == 0) {
               _selectVC = _psMyviewVC;
            }else if(self.vcnum == 1){
               _selectVC = _weiboVC;
            }else if(self.vcnum == 2){
               _selectVC = _webBettingVC;
           }
            break;
        case 4:
            if (self.vcnum == 0) {
                _selectVC = _psMyviewVC;
             }else if(self.vcnum == 1){
                _selectVC = _psMyviewVC;
             }else if(self.vcnum == 2){
                _selectVC = _psMyviewVC;
            }
    }
    [_tb selectOne:n];
    [_mainView addSubview:_selectVC.view];
}
-(void)onXmppLoginChanged:(NSNumber*)isLogin{
    if([TFJunYou_XMPP sharedInstance].isLogined == login_status_yes){
        [g_server offlineOperation:(g_server.lastOfflineTime *1000 + g_server.timeDifference)/1000 toView:self];
        [self onAfterLogin];
    }
    switch (_tb.selected){
        case 0:
            _btn.hidden = [TFJunYou_XMPP sharedInstance].isLogined;
            break;
        case 1:
            _btn.hidden = ![TFJunYou_XMPP sharedInstance].isLogined;
            break;
        case 2:
            _btn.hidden = NO;
            break;
        case 3:
            _btn.hidden = ![TFJunYou_XMPP sharedInstance].isLogined;
            break;
    }
}
-(void)onAfterLogin{
}
-(void)hasLoginOther:(NSNotification *)notifcation{
    [g_App showAlert:Localized(@"JXXMPP_Other") delegate:self tag:10002 onlyConfirm:YES];
}
- (void)showDeviceAuth:(NSNotification *)notification{
    TFJunYou_MessageObject *msg = notification.object;
    TFJunYou_DeviceAuthController *authCon = [[TFJunYou_DeviceAuthController alloc] initWithMsg:msg];
    UIViewController *lastVC = (UIViewController *)g_navigation.subViews.lastObject;
    [lastVC presentViewController:authCon animated:YES completion:nil];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if ([aDownload.action isEqualToString:act_AttentionList]) {
        TFJunYou_ProgressVC * pv = [TFJunYou_ProgressVC alloc];
        pv.dbFriends = (long)[_friendArray count];
        pv.dataArray = array1;
        pv = [pv init];
        if (array1.count > 300) {
            [g_navigation pushViewController:pv animated:YES];
        }
    }
    if ([aDownload.action isEqualToString:act_FriendGroupList]) {
        for (NSInteger i = 0; i < array1.count; i ++) {
            NSDictionary *dict = array1[i];
            TFJunYou_LabelObject *labelObj = [[TFJunYou_LabelObject alloc] init];
            labelObj.groupId = dict[@"groupId"];
            labelObj.groupName = dict[@"groupName"];
            labelObj.userId = dict[@"userId"];
            NSArray *userIdList = dict[@"userIdList"];
            NSString *userIdListStr = [userIdList componentsJoinedByString:@","];
            if (userIdListStr.length > 0) {
                labelObj.userIdList = [NSString stringWithFormat:@"%@", userIdListStr];
            }
            [labelObj insert];
        }
        NSArray *arr = [[TFJunYou_LabelObject sharedInstance] fetchAllLabelsFromLocal];
        for (NSInteger i = 0; i < arr.count; i ++) {
            TFJunYou_LabelObject *locLabel = arr[i];
            BOOL flag = NO;
            for (NSInteger j = 0; j < array1.count; j ++) {
                NSDictionary * dict = array1[j];
                if ([locLabel.groupId isEqualToString:dict[@"groupId"]]) {
                    flag = YES;
                    break;
                }
            }
            if (!flag) {
                [locLabel delete];
            }
        }
    }
    if ([aDownload.action isEqualToString:act_offlineOperation]) {
        for (NSDictionary *dict in array1) {
            if ([[dict objectForKey:@"tag"] isEqualToString:@"label"]) {
                [g_notify postNotificationName:kOfflineOperationUpdateLabelList object:nil];
            }
            else if ([[dict objectForKey:@"tag"] isEqualToString:@"friend"]) {
                [g_server getUser:[dict objectForKey:@"friendId"] toView:self];
            }
            else if ([[dict objectForKey:@"tag"] isEqualToString:@"room"]) {
                [g_server getRoom:[dict objectForKey:@"friendId"] toView:self];
            }
        }
    }
    if ([aDownload.action isEqualToString:act_UserGet]) {
        TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
        [user getDataFromDict:dict];
        if ([user.userId intValue] == [MY_USER_ID intValue]) {
            [g_server doSaveUser:dict];
        }else {
            TFJunYou_UserObject *user1 = [[TFJunYou_UserObject sharedInstance] getUserById:user.userId];
            user.content = user1.content;
            user.timeSend = user1.timeSend;
            [user update];
        }
        [g_notify postNotificationName:kOfflineOperationUpdateUserSet object:user];
    }
    if ([aDownload.action isEqualToString:act_roomGet]) {
        TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
        [user getDataFromDict:dict];
        user.userId = [dict objectForKey:@"jid"];
        user.roomId = [dict objectForKey:@"id"];
        user.userNickname = [dict objectForKey:@"name"];
        if(![g_xmpp.roomPool getRoom:user.userId] || ![user haveTheUser]){
            user.userDescription = [dict objectForKey:@"desc"];
            user.showRead = [dict objectForKey:@"showRead"];
            user.showMember = [dict objectForKey:@"showMember"];
            user.allowSendCard = [dict objectForKey:@"allowSendCard"];
            user.chatRecordTimeOut = [dict objectForKey:@"chatRecordTimeOut"];
            user.talkTime = [dict objectForKey:@"talkTime"];
            user.allowInviteFriend = [dict objectForKey:@"allowInviteFriend"];
            user.allowUploadFile = [dict objectForKey:@"allowUploadFile"];
            user.allowConference = [dict objectForKey:@"allowConference"];
            user.allowSpeakCourse = [dict objectForKey:@"allowSpeakCourse"];
            user.offlineNoPushMsg = [(NSDictionary *)[dict objectForKey:@"member"] objectForKey:@"offlineNoPushMsg"];
            user.isNeedVerify = [dict objectForKey:@"isNeedVerify"];
            user.createUserId = [dict objectForKey:@"userId"];
            user.content = @" ";
            user.topTime = nil;
            [user insertRoom];
            [g_xmpp.roomPool joinRoom:user.userId title:user.userNickname lastDate:nil isNew:NO];
        }else {
            NSDictionary * groupDict = [user toDictionary];
            roomData * roomdata = [[roomData alloc] init];
            [roomdata getDataFromDict:groupDict];
            [roomdata getDataFromDict:dict];
            TFJunYou_UserObject *user1 = [[TFJunYou_UserObject sharedInstance] getUserById:roomdata.roomJid];
            user.content = user1.content;
            user.status = user1.status;
            user.offlineNoPushMsg = [NSNumber numberWithBool:roomdata.offlineNoPushMsg];
            user.msgsNew = user1.msgsNew;
            [user update];
        }
        [g_notify postNotificationName:kOfflineOperationUpdateUserSet object:user];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    return hide_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    return hide_error;
}
@end
