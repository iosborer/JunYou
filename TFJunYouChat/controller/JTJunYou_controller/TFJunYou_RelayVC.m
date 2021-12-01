//
//  TFJunYou_RelayVC.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/6/27.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_RelayVC.h"
#import "TFJunYou_ChatViewController.h"
#import "TFJunYou_RoomPool.h"
#import "TFJunYou_RoomObject.h"
#import "TFJunYou_Cell.h"
#import "TFJunYou_addMsgVC.h"
#import "QCheckBox.h"

typedef enum : NSUInteger {
    RelayType_msg = 1,
    RelayType_myFriend,
    RelayType_myGroup,
} RelayType;

@interface TFJunYou_RelayVC ()<QCheckBoxDelegate>

@property (nonatomic, strong) NSMutableArray *msgArray;
@property (nonatomic, strong) NSMutableArray *myFriendArray;
@property (nonatomic, strong) NSMutableArray *myGroupArray;
@property (nonatomic, assign) RelayType type;
@property (nonatomic, strong) TFJunYou_RoomObject *chatRoom;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) NSMutableArray *checkBoxs;
@property (nonatomic, strong) NSMutableArray *selectArr;

@end

@implementation TFJunYou_RelayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack = YES;
    //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT-TFJunYou__SCREEN_BOTTOM);
    [self createHeadAndFoot];
    self.title = Localized(@"JX_SelectTheSendingObject");
    _msgArray = [NSMutableArray array];
    _myFriendArray = [NSMutableArray array];
    _myGroupArray = [NSMutableArray array];
    _checkBoxs = [NSMutableArray array];
    _selectArr = [NSMutableArray array];
    
    self.type = RelayType_msg;
    
    [self getLocData];
    
    if (self.isMoreSel) {
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, TFJunYou__SCREEN_TOP - 34, 34, 24)];
        [self.cancelBtn setTitle:Localized(@"JX_Cencal") forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:THESIMPLESTYLE ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelBtn.hidden = YES;
        [self.tableHeader addSubview:self.cancelBtn];
        
        self.doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH - 60-10, TFJunYou__SCREEN_TOP - 34, 60, 24)];
        [self.doneBtn setTitle:Localized(@"JX_Multiselect") forState:UIControlStateNormal];
        [self.doneBtn setTitle:Localized(@"JX_Finish") forState:UIControlStateSelected];
        [self.doneBtn setTitleColor:THESIMPLESTYLE ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
        self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableHeader addSubview:self.doneBtn];
        
        [self setDoneBtnFrame];
    }
}


- (void)setDoneBtnFrame {
    CGSize size = [self.doneBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.doneBtn.titleLabel.font}];
    
    self.doneBtn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-size.width-15, self.doneBtn.frame.origin.y, size.width, self.doneBtn.frame.size.height);
}

- (void)doneBtnAction:(UIButton *)btn {
    
    
    if (self.cancelBtn.hidden) {
        self.gotoBackBtn.hidden = YES;
        self.cancelBtn.hidden = NO;
        [self.tableView reloadData];
    }else {
        
        BOOL flag = NO;
        for (NSInteger i = 0; i < _selectArr.count; i ++) {
            
            TFJunYou_MsgAndUserObject *p = _selectArr[i];
            p.user.msgsNew = [NSNumber numberWithInt:0];
            [p.user update];
            [p.message updateNewMsgsTo0];
            
            if ([p.user.talkTime intValue] > 0) {
                
                memberData *member = [[memberData alloc] init];
                member = [member getCardNameById:MY_USER_ID];
                
                if ([member.role intValue] !=2 && [member.role intValue] !=1) {
                    if (_selectArr.count == 1) {
                        [g_App showAlert:Localized(@"HAS_BEEN_BANNED")];
                        return;
                    }
                    [TFJunYou_MyTools showTipView:[NSString stringWithFormat:@"%@被禁言",p.user.userNickname]];
                    continue;
                }
            }
            
            for (NSInteger j = 0; j < _relayMsgArray.count; j ++) {
                TFJunYou_MessageObject *msg = _relayMsgArray[j];
                [self relay:msg withUserObj:p];
            }
            
            if ([p.user.userId isEqualToString:self.chatPerson.userId]) {
                flag = YES;
            }
        }
        
//        [g_notify postNotificationName:kRefreshChatLogNotif object:nil];
        [g_server showMsg:Localized(@"JX_SendComplete")];
        [self actionQuit];
    }
    
    self.doneBtn.selected = !self.doneBtn.selected;
    
    [self setDoneBtnFrame];
}

- (void)cancelBtnAction:(UIButton *)btn {
    
    self.gotoBackBtn.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.doneBtn.selected = NO;
    [_selectArr removeAllObjects];
    [self.tableView reloadData];
    
    [self setDoneBtnFrame];
}

- (void) relay:(TFJunYou_MessageObject *)msg withUserObj:(TFJunYou_MsgAndUserObject *)userObj{
    
    if (msg.content.length > 0) {
        TFJunYou_MessageObject *msg1 = [[TFJunYou_MessageObject alloc]init];
        msg1 = [msg copy];
        msg1.messageId = nil;
        msg1.timeSend     = [NSDate date];
        msg1.fromId = nil;
        msg1.fromUserId   = MY_USER_ID;
        msg1.fromUserName = g_myself.userNickname;
        if([userObj.user.roomFlag boolValue]){
            msg1.isGroup = YES;
        }
        else{
            msg1.isGroup = NO;
        }
        msg1.toUserId = userObj.user.userId;
        //        msg.content      = relayMsg.content;
        //        msg.type         = relayMsg.type;
        msg1.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg1.isRead       = [NSNumber numberWithBool:NO];
        msg1.isReadDel    = [NSNumber numberWithInt:NO];
        
        
        NSString *roomJid = nil;
        if ([userObj.user.roomFlag boolValue]) {
            roomJid = userObj.user.userId;
        }
        //发往哪里
        [msg1 insert:roomJid];
        [g_xmpp sendMessage:msg1 roomName:roomJid];//发送消息
        
        if ([userObj.user.userId isEqualToString:self.chatPerson.userId]) {
            [self.chatVC showOneMsg:msg1];
        }
    }

}

- (void) getLocData {
    NSMutableArray* p = [[TFJunYou_MessageObject sharedInstance] fetchRecentChat];
    //    if (p.count>0 || _page == 0) {
    if (p.count>0) {
        for(NSInteger i = 0; i < p.count; i ++) {
            TFJunYou_MsgAndUserObject *obj = p[i];
            if ([obj.user.userId isEqualToString:FRIEND_CENTER_USERID]) {
                continue;
            }
            
            [_msgArray addObject:obj];
        }
        //让数组按时间排序
        [self sortArrayWithTime];
        [_table reloadData];
        self.isShowFooterPull = p.count>=PAGE_SHOW_COUNT;
    }
    [p removeAllObjects];
    
    NSMutableArray *array = [[TFJunYou_UserObject sharedInstance] fetchAllFriendsFromLocal];
    for(NSInteger i = 0; i < array.count; i ++) {
        TFJunYou_UserObject *user = array[i];
        if ([user.userId isEqualToString:FRIEND_CENTER_USERID]) {
            continue;
        }
        TFJunYou_MsgAndUserObject *obj = [[TFJunYou_MsgAndUserObject alloc] init];
        obj.user = user;
        
        [_myFriendArray addObject:obj];
    }
    
    [g_server listHisRoom:0 pageSize:1000 toView:self];
    
    [self.tableView reloadData];
}


//数据（CELL）按时间顺序重新排列
- (void)sortArrayWithTime{
    
    for (int i = 0; i<[_msgArray count]; i++)
    {
        
        for (int j=i+1; j<[_msgArray count]; j++)
        {
            TFJunYou_MsgAndUserObject * dicta = (TFJunYou_MsgAndUserObject*) [_msgArray objectAtIndex:i];
            NSDate * a = dicta.message.timeSend ;
            //            NSLog(@"a = %d",[dicta.user.msgsNew intValue]);
            TFJunYou_MsgAndUserObject * dictb = (TFJunYou_MsgAndUserObject*) [_msgArray objectAtIndex:j];
            NSDate * b = dictb.message.timeSend ;
            //                NSLog(@"b = %d",b);
            
            if ([[a laterDate:b] isEqualToDate:b])
            {
                //                - (NSDate *)earlierDate:(NSDate *)anotherDate;
                //                与anotherDate比较，返回较早的那个日期
                //
                //                - (NSDate *)laterDate:(NSDate *)anotherDate;
                //                与anotherDate比较，返回较晚的那个日期
                //                TFJunYou_MsgAndUserObject * dictc = dicta;
                
                [_msgArray replaceObjectAtIndex:i withObject:dictb];
                [_msgArray replaceObjectAtIndex:j withObject:dicta];
            }
            
        }
        
    }
    
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    
    NSMutableArray *array = [NSMutableArray array];
    switch (self.type) {
        case RelayType_msg:
            array = _msgArray;
            break;
        case RelayType_myFriend:
            array = _myFriendArray;
            break;
        case RelayType_myGroup:
            array = _myGroupArray;
            
            break;
        default:
            break;
    }
    TFJunYou_MsgAndUserObject *p;
    p =[array objectAtIndex:checkbox.tag % 100000-1];
    if(checked){
        BOOL flag = NO;
        for (NSInteger i = 0; i < _selectArr.count; i ++) {
            TFJunYou_MsgAndUserObject *selUser = _selectArr[i];
            if ([selUser.user.userId isEqualToString:p.user.userId]) {
                flag = YES;
                return;
            }
        }
        
        [_selectArr addObject:p];
    }
    else{
        for (NSInteger i = 0; i < _selectArr.count; i ++) {
            TFJunYou_MsgAndUserObject *selUser = _selectArr[i];
            if ([selUser.user.userId isEqualToString:p.user.userId]) {
                
                [_selectArr removeObject:selUser];
                break;
            }
        }
    }
    NSString *str =[NSString stringWithFormat:@"%@(%ld)",Localized(@"JX_Finish"),_selectArr.count];
    [self.doneBtn setTitle:str forState:UIControlStateSelected];

    [self setDoneBtnFrame];
}

#pragma mark   ---------tableView协议----------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type != RelayType_myGroup) {
        if (indexPath.section == 0) {
            UITableViewCell *cell=nil;
            //    NSString* cellName = [NSString stringWithFormat:@"msg_%d_%ld",_refreshCount,(long)indexPath.row];
            NSString* cellName = [NSString stringWithFormat:@"tableViewCell"];
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53.5, TFJunYou__SCREEN_WIDTH, LINE_WH)];
            line.backgroundColor = THE_LINE_COLOR;
            [cell.contentView addSubview:line];
            
            cell.textLabel.font = SYSFONT(15.0);
            if (self.type == RelayType_msg) {
                cell.textLabel.text = Localized(@"JXRelay_CreateNewChat");
            }else if (self.type == RelayType_myFriend) {
                cell.textLabel.text = Localized(@"JXRelay_chooseGroup");
            }
            
            
            return cell;
        }
    }
    
    if (self.type == RelayType_msg && self.isShare && indexPath.row == 0) {
        UITableViewCell *cell=nil;
        NSString* cellName = [NSString stringWithFormat:@"tableViewCell"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53.5, TFJunYou__SCREEN_WIDTH, LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [cell.contentView addSubview:line];
        
        cell.textLabel.font = SYSFONT(15.0);
        cell.textLabel.text = Localized(@"JX_ShareLifeCircle");

        return cell;
    }
    
    NSString* cellName = [NSString stringWithFormat:@"relayCell_%d",(int)indexPath.row];
    TFJunYou_Cell *relayCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!relayCell) {
        relayCell = [[TFJunYou_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    TFJunYou_MsgAndUserObject * obj = nil;
    switch (self.type) {
        case RelayType_msg:
            if (self.isShare) {
                obj = (TFJunYou_MsgAndUserObject*) [_msgArray objectAtIndex:indexPath.row - 1];
            }else {
                obj = (TFJunYou_MsgAndUserObject*) [_msgArray objectAtIndex:indexPath.row];
            }
            break;
        case RelayType_myFriend:
            obj = (TFJunYou_MsgAndUserObject*) [_myFriendArray objectAtIndex:indexPath.row];
            break;
        case RelayType_myGroup:
            obj = (TFJunYou_MsgAndUserObject*) [_myGroupArray objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    relayCell.title = obj.user.userNickname;
//    relayCell.subtitle = [NSString stringWithFormat:@"%@",obj.user.userId];
    relayCell.userId = [NSString stringWithFormat:@"%@",obj.user.userId];
    NSString * roomIdStr = obj.user.roomId;
    relayCell.roomId = roomIdStr;
    [relayCell headImageViewImageWithUserId:relayCell.userId roomId:roomIdStr];
    relayCell.isSmall = YES;
    
    if (self.doneBtn && self.doneBtn.selected) {
        QCheckBox* btn = [[QCheckBox alloc] initWithDelegate:self];
        btn.frame = CGRectMake(13, 18.5, 22, 22);
        btn.tag = (indexPath.section+1) * 100000 + (indexPath.row+1);
        [relayCell addSubview:btn];
        
        
        relayCell.headImageView.frame = CGRectMake(48, relayCell.headImageView.frame.origin.y, relayCell.headImageView.frame.size.width, relayCell.headImageView.frame.size.height);
        relayCell.lbTitle.frame = CGRectMake(CGRectGetMaxX(relayCell.headImageView.frame)+14, relayCell.lbTitle.frame.origin.y, relayCell.lbTitle.frame.size.width, relayCell.lbTitle.frame.size.height);
        
        [_checkBoxs addObject:btn];
    }else {
        for (NSInteger i = 0; i < _checkBoxs.count; i ++) {
            QCheckBox *btn = _checkBoxs[i];
            [btn removeFromSuperview];
        }
        relayCell.headImageView.frame = CGRectMake(14, relayCell.headImageView.frame.origin.y, relayCell.headImageView.frame.size.width, relayCell.headImageView.frame.size.height);
        relayCell.lbTitle.frame = CGRectMake(CGRectGetMaxX(relayCell.headImageView.frame)+14, relayCell.lbTitle.frame.origin.y, relayCell.lbTitle.frame.size.width, relayCell.lbTitle.frame.size.height);
    }
    

    return relayCell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type == RelayType_myGroup) {
        
        return 1;
    }else {
        return 2;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == RelayType_myGroup) {
        return _myGroupArray.count;
    }
    
    if (section == 0) {
        
        return 1;
    }else {
        
        switch (self.type) {
            case RelayType_msg:
                if (self.isShare) {
                    return _msgArray.count + 1;
                }else {
                    return _msgArray.count;
                }
                break;
            case RelayType_myFriend:
                return _myFriendArray.count;
                break;
            case RelayType_myGroup:
                return _myGroupArray.count;
                break;
            default:
                return 0;
                break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.doneBtn.selected) {
        
//        QCheckBox *checkBox = nil;
//        for (NSInteger i = 0; i < _checkBoxs.count; i ++) {
//            QCheckBox *btn = _checkBoxs[i];
//            if (btn.tag / 10000 == indexPath.section && btn.tag % 10000 == indexPath.row) {
//                checkBox = btn;
//                break;
//            }
//        }
        
        TFJunYou_Cell *cell = [tableView cellForRowAtIndexPath:indexPath];
        QCheckBox *checkBox = [cell viewWithTag:(indexPath.section + 1) * 100000 + (indexPath.row + 1)];
        if (checkBox) {
            checkBox.selected = !checkBox.selected;
            [self didSelectedCheckBox:checkBox checked:checkBox.selected];
            
            return;

        }
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        switch (self.type) {
            case RelayType_msg:{
                    self.type = RelayType_myFriend;
                }
                break;
            case RelayType_myFriend:{
                    self.type = RelayType_myGroup;
                }
                break;
            case RelayType_myGroup:{
                TFJunYou_MsgAndUserObject *obj = _myGroupArray[indexPath.row];
                
                self.selectIndex = indexPath.row;
                [g_server getRoom:obj.user.roomId toView:self];
            }
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    }else {
        
        if (self.type == RelayType_msg && self.isShare && indexPath.row == 0) {
            
            TFJunYou_MessageObject *msg = self.relayMsgArray.lastObject;
            NSDictionary * msgDict = [[[SBJsonParser alloc]init]objectWithString:msg.objectId];
            
            TFJunYou_addMsgVC* vc = [[TFJunYou_addMsgVC alloc] init];
            //在发布信息后调用，并使其刷新
            vc.block = ^{
//                [self scrollToPageUp];
            };
            vc.shareUr = [msgDict objectForKey:@"url"];
            vc.shareTitle = [msgDict objectForKey:@"title"];
            vc.shareIcon = [msgDict objectForKey:@"imageUrl"];
            vc.dataType = weibo_dataType_share;
            vc.delegate = self;
//            vc.didSelect = @selector(hideKeyShowAlert);
            //        [g_window addSubview:vc.view];
            [g_navigation pushViewController:vc animated:YES];
            vc.view.hidden = NO;
            
            [self actionQuit];
            
            return;
        }
        
        
        NSMutableArray *array = [NSMutableArray array];
        switch (self.type) {
            case RelayType_msg:
                array = _msgArray;
                break;
            case RelayType_myFriend:
                array = _myFriendArray;
                break;
            case RelayType_myGroup:
                array = _myGroupArray;
                
                break;
            default:
                break;
        }
        TFJunYou_MsgAndUserObject *p;
        if (self.type == RelayType_msg && self.isShare) {
            p = [array objectAtIndex:indexPath.row - 1];
        }else {
            p =[array objectAtIndex:indexPath.row];
        }
        p.user.msgsNew = [NSNumber numberWithInt:0];
        [p.user update];
        [p.message updateNewMsgsTo0];
        
        
        if ([p.user.roomFlag boolValue]) {
            
            self.selectIndex = indexPath.row;
            [g_server getRoom:p.user.roomId toView:self];
            if ([self.relayDelegate respondsToSelector:@selector(shareSuccess)]) {
                [self.relayDelegate shareSuccess];
            }
            return;
        }
        
        
        if (self.isCourse) {
            if([p.user.roomFlag boolValue]) {
                self.selectIndex = indexPath.row;
                [g_server getRoom:p.user.roomId toView:self];
            }else {
                if ([self.relayDelegate respondsToSelector:@selector(relay:MsgAndUserObject:)]) {
                    [self.relayDelegate relay:self MsgAndUserObject:p];
                    
                    [self actionQuit];
                }
            }
            
            return;
        }
        if ([self.relayDelegate respondsToSelector:@selector(shareSuccess)]) {
            [self.relayDelegate shareSuccess];
        }
        [self sendRelayMsg:p];
    }
    
}

- (void)sendRelayMsg:(TFJunYou_MsgAndUserObject *)p {
    
    [g_notify postNotificationName:kActionRelayQuitVC object:nil];
    
    TFJunYou_ChatViewController *sendView=[TFJunYou_ChatViewController alloc];
    sendView.title = p.user.userNickname;
    if([p.user.roomFlag intValue] > 0  || p.user.roomId.length > 0){
        if(g_xmpp.isLogined != 1){
            // 掉线后点击title重连
            [g_xmpp showXmppOfflineAlert];
            return;
        }
        
        
        if ([p.user.groupStatus intValue] == 1) {
            [g_server showMsg:Localized(@"JX_OutOfTheGroup1")];
            return;
        }
        
        if ([p.user.groupStatus intValue] == 2) {
            [g_server showMsg:Localized(@"JX_DissolutionGroup1")];
            return;
        }
        sendView.roomJid = p.user.userId;
        sendView.roomId   = p.user.roomId;
        sendView.chatRoom  = [[TFJunYou_XMPP sharedInstance].roomPool joinRoom:p.user.userId title:p.user.userNickname lastDate:nil isNew:NO];
        
        if (p.user.roomFlag) {
            NSDictionary * groupDict = [p.user toDictionary];
            roomData * roomdata = [[roomData alloc] init];
            [roomdata getDataFromDict:groupDict];
            sendView.room = roomdata;
        }
    }
    sendView.isShare = self.isShare;
    sendView.shareSchemes = self.shareSchemes;
    sendView.chatPerson = p.user;
    sendView = [sendView init];
    //        [g_App.window addSubview:sendView.view];
    [g_navigation pushViewController:sendView animated:YES];
    sendView.relayMsgArray = self.relayMsgArray;
    sendView.view.hidden = NO;
    
    [self actionQuit];
}

-(void)showChatView:(NSInteger)index{
    [_wait stop];
    TFJunYou_MsgAndUserObject *obj = _myGroupArray[index];
    
    if (self.isCourse) {
        self.selectIndex = index;
        [g_server getRoom:obj.user.roomId toView:self];
        return;
    }
    
    TFJunYou_ChatViewController *sendView=[TFJunYou_ChatViewController alloc];
    sendView.title = obj.user.userNickname;
    sendView.roomJid = obj.user.userId;
    sendView.roomId = obj.user.roomId;
    sendView.chatRoom = _chatRoom;
    sendView.chatPerson = obj.user;
    
    sendView = [sendView init];
//    [g_App.window addSubview:sendView.view];
    [g_navigation pushViewController:sendView animated:YES];
    sendView.relayMsgArray = self.relayMsgArray;
    
    [self actionQuit];
}

-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    
    [self stopLoading];
    if([aDownload.action isEqualToString:act_roomListHis] ){
        [_myGroupArray removeAllObjects];
        for (int i = 0; i < [array1 count]; i++) {
            NSDictionary *dict=array1[i];
            
            TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
            user.userNickname = [dict objectForKey:@"name"];
            user.userId = [dict objectForKey:@"jid"];
            user.userDescription = [dict objectForKey:@"desc"];
            user.roomId = [dict objectForKey:@"id"];
            
            TFJunYou_MsgAndUserObject *obj = [[TFJunYou_MsgAndUserObject alloc] init];
            obj.user = user;
            [_myGroupArray addObject:obj];
            
        }
        
    }
    if( [aDownload.action isEqualToString:act_roomGet] ){
        
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        
        NSDictionary * groupDict = [user toDictionary];
        roomData * roomdata = [[roomData alloc] init];
        [roomdata getDataFromDict:groupDict];
        
        [roomdata getDataFromDict:dict];
        
        memberData *data = [roomdata getMember:g_myself.userId];
        if ([user.talkTime longLongValue] > 0 && !([data.role integerValue] == 1 || [data.role integerValue] == 2)) {
            
            [g_App showAlert:Localized(@"HAS_BEEN_BANNED")];
            return;
        }
        
        if (!roomdata.allowSpeakCourse && !([data.role integerValue] == 1 || [data.role integerValue] == 2)) {
            
            [g_App showAlert:Localized(@"JX_SendLecture")];
            return;
        }
        
        if (!roomdata.allowSendCard && !([data.role integerValue] == 1 || [data.role integerValue] == 2)) {
            
            [g_App showAlert:Localized(@"JX_DisabledShowCard")];
            return;
        }

        if ([data.role integerValue] == 4) {
            
            [TFJunYou_MyTools showTipView:@"不能转发到你是隐身人的群组"];
            return;
        }
        
        NSMutableArray *array = [NSMutableArray array];
        switch (self.type) {
            case RelayType_msg:
                array = _msgArray;
                break;
            case RelayType_myFriend:
                array = _myFriendArray;
                break;
            case RelayType_myGroup:
                array = _myGroupArray;
                
                break;
            default:
                break;
        }
        TFJunYou_MsgAndUserObject *p=[array objectAtIndex:self.selectIndex];
        
        if (self.isCourse) {
            if ([data.role integerValue] == 1 || [data.role integerValue] == 2 || roomdata.allowSpeakCourse) {
                if ([user.talkTime longLongValue] > 0) {
                    
                    [g_App showAlert:Localized(@"HAS_BEEN_BANNED")];
                    return;
                }
                if ([self.relayDelegate respondsToSelector:@selector(relay:MsgAndUserObject:)]) {
                    
                    
                    
                    [self.relayDelegate relay:self MsgAndUserObject:p];
                    
                    [self actionQuit];
                }
                return;
            }
            [g_App showAlert:Localized(@"JX_SendLecture")];
        }else {
            [self sendRelayMsg:p];
        }
        
        
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

- (void)actionQuit {
    if (self.isShare) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.isUrl) {
        [self.view removeFromSuperview];
    }
    else {
        [super actionQuit];
    }
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
