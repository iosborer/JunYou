//
//  TFJunYou_XMPP.m
//  WeChat
//
//  Created by Reese on 13-8-10.
//  Copyright (c) 2013年 Reese. All rights reserved.
//
// Log levels: off, error, warn, info, verbose

#import "TFJunYou_XMPP.h"
#import "GCDAsyncSocket.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "SBJsonWriter.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "TFJunYou_emojiViewController.h"
#import "TFJunYou_RoomPool.h"
#import "TFJunYou_MainViewController.h"
#import "TFJunYou_FriendObject.h"
#import "TFJunYou_FileInfo.h"
#import "TFJunYou_GroupViewController.h"
#import "TFJunYou_RoomObject.h"
#import "TFJunYou_RoomRemind.h"
#import "TFJunYou_BlogRemind.h"
#import "TFJunYou_FriendObject.h"
#import "GCDAsyncSocket.h"
#import "TFJunYou_SynTask.h"
#import "AppleReachability.h"

//#if DEBUG
//static const DDLogLevel ddLogLevel = DDLogLevelOff;
//#else
//static const DDLogLevel ddLogLevel = DDLogLevelOff;
//#endif




#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define CACHES_PATH NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

#define SameResource [g_myself.multipleDevices intValue] > 0 ? @"ios" : @"youjob"

@interface TFJunYou_XMPP ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) ATMHud *wait;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *pingTimer;
@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (nonatomic, weak) TFJunYou_RoomObject *roomDelegate;
@property (nonatomic, assign) NSInteger reconnectTimerCount;


@property (nonatomic, strong) NSMutableArray * poolRoomIQ;

//批量回执属性
@property (nonatomic, assign) BOOL enableMsgIQ;// YES:已开启批量回执  NO:未开启批量回执
@property (nonatomic, strong) NSTimer *IQTimer;
@property (nonatomic, assign) NSInteger IQNum;
@property (nonatomic, strong) NSMutableArray * poolSendIQ;

@property (nonatomic, strong) NSData *lastData;
@property (nonatomic, strong) NSMutableArray *receiptArray;
@property (nonatomic, strong) NSTimer *receiptTimer;
@property (nonatomic, assign) NSInteger receiptTimerNum;

@property (nonatomic, strong) TFJunYou_FriendObject* friend;

@end

@implementation TFJunYou_XMPP
@synthesize isLogined,roomPool,poolSend=_poolSend,blackList;




static TFJunYou_XMPP *sharedManager;

+(TFJunYou_XMPP*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[TFJunYou_XMPP alloc]init];
    });
    
    return sharedManager;
}

-(id)init{
    self = [super init];
    _poolSend = [[NSMutableDictionary alloc]init];
    _poolSendRead = [[NSMutableArray alloc]init];
    blackList = [[NSMutableSet alloc]init];
    _poolSendIQ = [[NSMutableArray alloc] init];
    _poolRoomIQ = [[NSMutableArray alloc] init];
    isLogined = login_status_no;
    _chatingUserIds = [[NSMutableArray alloc]init];
//    _isEncryptAll = [[NSUserDefaults standardUserDefaults] boolForKey:kMESSAGE_isEncrypt];
    [g_notify addObserver:self selector:@selector(readDelete:) name:kCellReadDelNotification object:nil];
    self.newMsgAfterLogin = 0;
    self.reconnectTimerCount = 10;
    _IQNum = 0;
    _wait = [ATMHud sharedInstance];
    self.isReconnect = YES;
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.roomPool = [[TFJunYou_RoomPool alloc] init];
    
    _receiptArray = [NSMutableArray array];
    _receiptTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(receiptTimerAction:) userInfo:nil repeats:YES];
    
    return self;
}

- (void)dealloc
{
    [blackList removeAllObjects];
	[self teardownStream];
    [_poolSend removeAllObjects];
    [_IQTimer invalidate];
    _IQTimer = nil;
//    [_poolSend release];
//    [password release];
//    [super dealloc];
    [g_notify removeObserver:self name:kCellReadDelNotification object:nil];
}


-(void)login{
    
    NSLog(@"XMPPLogin ---");
    AppleReachability *reach = [AppleReachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reach currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable:{
            if (self.isLogined != login_status_no) {
                [self logout];
            }
        }
            break;
            
        default:{
            
            self.isReconnect = YES;
            pingTimeoutCount = 0;
            if(isLogined == login_status_yes)
                return;
            
            self.isLogined = login_status_ing;
            [self notify];
            NSError *error = nil;
            [self.socket connectToHost:g_config.XMPPHost onPort:5666 viaInterface:nil withTimeout:-1 error:&error];
            NSLog(@"XMPPHost---%@",g_config.XMPPHost);
        }
            break;
    }
    
}

-(void)doLogin{
    
    NSLog(@"xmpp ---- doLogin");
    self.newMsgAfterLogin = 0; //重新登陆后，新消息要置0
    pingTimeoutCount = 0;
    self.isCloseStream = NO;
    [TFJunYou_FileInfo createDir:myTempFilePath];
    self.isLogined = login_status_yes;
    _pingTimer = [NSTimer scheduledTimerWithTimeInterval:g_config.XMPPPingTime target:self selector:@selector(pingTimerAction:) userInfo:nil repeats:YES];
    
    [self notify];
}
  
-(void)logout{
    if(!isLogined)
        return;
    
    NSLog(@"XMPPLogout ---");
    NSLog(@"isLogined = %d", self.isLogined);
    if (self.isLogined == login_status_yes) {
        g_server.lastOfflineTime = [[NSDate date] timeIntervalSince1970];
        [g_default setObject:[NSNumber numberWithLongLong:g_server.lastOfflineTime] forKey:kLastOfflineTime];
        [g_default synchronize];
    }
    
    self.isLogined = login_status_no;
    [self notify];
    self.newMsgAfterLogin = 0;
	isXmppConnected = NO;
    [self disconnect];
    [roomPool deleteAll];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma  mark ------------发消息------------
- (void)sendMessage:(TFJunYou_MessageObject*)msg roomName:(NSString*)roomName {
    if (self.isLogined != login_status_yes) {
        return;
    }
    
    // 普通消息设置重发次数
    if (msg.isVisible && msg.sendCount <= 0) {
        msg.sendCount = 5;
    }
    //采用SBjson将params转化为json格式的字符串
    //    msg.roomJid = roomName;
    if([msg.messageId length]<=0)//必须有
        [msg setMsgId];
    if ([g_myself.isEncrypt intValue] == 1) {
        msg.isEncrypt = [NSNumber numberWithInt:YES];
    }else{
        msg.isEncrypt = [NSNumber numberWithInt:NO];
    }
    
    // 消息发送时间更新
    NSTimeInterval time = [msg.timeSend timeIntervalSince1970];
    msg.timeSend = [NSDate dateWithTimeIntervalSince1970:(time *1000 + g_server.timeDifference)/1000];
    
    if (roomName.length > 0) {
        msg.chatType = kWCChatTypeGroupChat;
    }else {
        msg.chatType = kWCChatTypeChat;
    }
    
    ChatMessage *message = [msg getPbobjcObjWithMsg:msg];
    
    // 直接发给此账号的其他端
    if (IS_OTHER_DEVICE(msg.toUserId)) {
        message.toUserId = MY_USER_ID;
        
        NSRange range = [msg.toUserId rangeOfString:@"_"];
        NSString *relayType = [msg.toUserId substringFromIndex:range.location + 1];
        message.messageHead.to = [NSString stringWithFormat:@"%@/%@",message.toUserId,relayType];
    }
    
    NSData *data = message.data;

    data = [self getWriteDataWithCmd:kWCCommandTypeChat data:data];
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.socket writeData:data withTimeout:- 1 tag:0];
    
    //判断消息是否为已读类型
    if ([msg.type intValue] == kWCMessageTypeIsRead) {
        bool found = NO;
        //不重复添加
        for (TFJunYou_MessageObject * msgObj in _poolSendRead){
            if ([msgObj.messageId isEqualToString: msg.messageId]){
                found = YES;
                break;
            }
        }
        if (!found) {
            [_poolSendRead addObject:msg];
        }
    }else{
        // 排除发送正在输入
        if ([msg.type intValue] != kWCMessageTypeRelay)
            [_poolSend setObject:msg forKey:msg.messageId];
    }
    AppleReachability *reach = [AppleReachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reach currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable:{
            
            [msg updateIsSend:transfer_status_no];
            if (![msg.fromUserId isEqualToString:msg.toUserId]) {
                if ([msg.type intValue] != kWCMessageTypeAVPing) {
                    [msg notifyTimeout];//重发次数为0,才发超时通知
                }
            }
        }
            break;
            
        default:
            
            [self performSelector:@selector(onSendTimeout:) withObject:msg afterDelay:[msg getMaxWaitTime]];
            break;
    }
    
//    from = nil;
}

// 获取消息验参Mac
- (NSString *)getMessageMac:(NSMutableDictionary *)params{
    NSMutableString *macStr = [NSMutableString string];
    NSString *paramStr = [self getParamStr:params];
    [macStr appendString:paramStr];
    
    
    
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:g_server.messageKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *macData = [g_securityUtil getHMACMD5:[macStr dataUsingEncoding:NSUTF8StringEncoding] key:keyData];

    NSString *mac = [macData base64EncodedStringWithOptions:0];

    return mac;
}


- (NSString *)getParamStr:(NSMutableDictionary *)params {
    NSMutableString *paramStr = [NSMutableString string];
    NSArray *keys = [[params allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSInteger i = 0; i < keys.count; i ++) {
        NSString *key = keys[i];
        NSString *value = params[key];
        if ([params[key] isKindOfClass:[NSNumber class]]) {
            
            if (strcmp([params[key] objCType], @encode(double)) == 0){
                
                NSNumber *num = [NSNumber numberWithLong:(long)[params[key] doubleValue]];
                value = [num stringValue];
                
            }else {
                
                NSNumber *num = params[key];
                value = [num stringValue];
            }
        }
        [paramStr appendString:value];
    }
    return paramStr;
}


-(void)sendMessageInvite:(TFJunYou_MessageObject *)msg{
    [_poolSend setObject:msg forKey:msg.messageId];
    [self performSelector:@selector(onSendTimeout:) withObject:msg afterDelay:[msg getMaxWaitTime]];
}

-(void)onSendTimeout:(TFJunYou_MessageObject *)p{//超时未收到回执
    if(p){
        if([p.isSend isEqualToNumber:[NSNumber numberWithInt:transfer_status_yes]])
            return;
        [p updateIsSend:transfer_status_ing];
        if(p.sendCount>0){//一般只重发3次，在发之前赋值3
            NSLog(@"autoSend:%d",p.sendCount);
            [self login];
            NSString* roomJid=nil;
            if(p.isGroup)
                roomJid = p.toUserId;
            [self sendMessage:p roomName:roomJid];
            p.sendCount--;//重发次数减1
        }else{
            
            [p updateIsSend:transfer_status_no];
            if (![p.fromUserId isEqualToString:p.toUserId]) {
                if ([p.type intValue] != kWCMessageTypeAVPing) {
                    [p notifyTimeout];//重发次数为0,才发超时通知
                }
            }
        }
    }
}

#pragma mark -- terminate
/**
 *  申请后台更多的时间来完成关闭流的任务
 */
-(void)applicationWillTerminate
{
    UIApplication *app=[UIApplication sharedApplication];
    UIBackgroundTaskIdentifier taskId;
    taskId=[app beginBackgroundTaskWithExpirationHandler:^(void){
        [app endBackgroundTask:taskId];
    }];

}

-(void)notify{
    [g_notify  postNotificationName:kXmppLoginNotifaction object:nil];
    if (self.isLogined == login_status_yes) {
        // 上线发送消息通知其他端
        [g_multipleLogin sendOnlineMessage];
    }else {
    }
    [self loginChanged];
    if (self.isLogined != login_status_ing) {
        [_wait stop];
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)disconnect
{
    // 离线前发送消息通知其他端
    [g_multipleLogin sendOfflineMessage];
    
    self.isReconnect = NO;
    
    [self.socket disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
//	DDLogError(@"The iPhone simulator does not process background network traffic. "  @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif

	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			//DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

-(void)fetchUser:(NSString*)userId
{
    [g_server getUser:userId toView:self];
}

-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if ([aDownload.action isEqualToString:act_readDelMsg]) {
        NSLog(@"删除成功");
    }
    if([dict count]>0){
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user userFromDictionary:user dict:dict];
        [user insert];
//        [user release];
    }
    
    if ([aDownload.action isEqualToString:act_EmptyMsg]) {
        
        [g_notify postNotificationName:kRefreshChatLogNotif object:nil];
    }
    
}

- (FMDatabase*)openUserDb:(NSString*)userId{
    userId = [userId uppercaseString];
    if([_userIdOld isEqualToString:userId]){
        if(_db && [_db goodConnection])
            return _db;
    }
    _userIdOld = userId;
    NSString* t =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* s = [NSString stringWithFormat:@"%@/%@.db",t,userId];
    
    _db = [[FMDatabase alloc] initWithPath:s];
    if (![_db open]) {
//        NSLog(@"数据库打开失败");
        return nil;
    };
    NSLog(@"dataPath:%@",_db.databasePath);
    
    if (userId.length > 0) {
        [self getBlackList];
    }
    return _db;
}

-(void)getBlackList{
    [blackList removeAllObjects];
    NSMutableArray* a = [[TFJunYou_UserObject sharedInstance] fetchAllBlackFromLocal];
    for(int i=0;i<[a count];i++){
        TFJunYou_UserObject* p = [a objectAtIndex:i];
        [blackList addObject:p.userId];
//        [p release];
    }
    a = nil;
}

-(NSString*)getUserId:(NSString*)s{
    NSRange range = [s rangeOfString:@"@"];
    if(range.location != NSNotFound)
        s = [s substringToIndex:range.location];
    return s;
}

-(void)saveToUser:(TFJunYou_MessageObject*)msg{
    TFJunYou_UserObject *user=[[TFJunYou_UserObject alloc]init];
    user.userId = msg.toUserId;
    if (![user haveTheUser]) {
        user.userNickname = msg.toUserName;
        user.userDescription = msg.toUserName;
        [user insert];
    }
//    [user release];
}

-(void)saveFromUser:(TFJunYou_MessageObject*)msg{
    TFJunYou_UserObject *user=[[TFJunYou_UserObject alloc]init];
    user.userId = msg.fromUserId;
    if (![user haveTheUser]) {
        user.userNickname = msg.fromUserName;
        user.userDescription = msg.fromUserName;
        [user insert];
    }
//    [user release];
}
#pragma mark-----阅后即焚删除本地数据
- (void)readDelete:(NSNotification *)notification{
    TFJunYou_MessageObject *msg = notification.object;
    [msg delete];
//    if (!msg.isGroup || !msg.isMySend) {//群聊不删除服务器消息
//        [g_server readDeleteMsg:msg toView:self];
//    }
}

-(void)notifyNewMsg{
    //    NSLog(@"收到新消息：%f",g_xmpp.lastNewMsgTime);
    //    double n = [[NSDate date] timeIntervalSince1970]-g_xmpp.lastNewMsgTime;
    //    if(n>0.5){//假如0.5秒之内没有新消息到达，则认为收取完毕，一次性刷新
    //        NSLog(@"刷新聊天记录：%f",n);
    ////        self.newMsgAfterLogin = 1;
    //        [g_notify postNotificationName:kXMPPAllMsgNotifaction object:nil userInfo:nil];
    //    }
    
    if (g_xmpp.lastMsgTime > 0.7) {
        NSLog(@"刷新聊天记录：%f",g_xmpp.lastMsgTime);
        [g_notify postNotificationName:kXMPPAllMsgNotifaction object:nil userInfo:nil];
        if (g_xmpp.msgTimer) {
            dispatch_cancel(g_xmpp.msgTimer);
            g_xmpp.msgTimer = nil;
            g_xmpp.lastMsgTime = 0.00;
        }
    }
}

-(void)doReceiveFriendRequest:(TFJunYou_MessageObject*)msg{
    if(![msg isAddFriendMsg])
        return;
    if([msg.type intValue] == XMPP_TYPE_SAYHELLO || [msg.type intValue] == XMPP_TYPE_FEEDBACK){
        int n = [msg.type intValue];
        msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
        msg.isRead = [NSNumber numberWithInt:1];
        [msg insert:nil];
        msg.type = [NSNumber numberWithInt:n];
    }
    
    self.friend = [[TFJunYou_FriendObject alloc]init];
    [self.friend loadFromMessageObj:msg];
    [self.friend doWriteDb];
    
    [self.friend updateNewFriendLastContent];
    
    [self.friend notifyNewRequest];
    
    TFJunYou_FriendObject *user = [[TFJunYou_FriendObject sharedInstance] getFriendById:self.friend.userId];
    msg.content = [self.friend getLastContent:user.userId];
    if ([user.msgsNew intValue] > 0) {
        [msg updateLastSend:UpdateLastSendType_None];
    }else {
        [user updateNewMsgUserId:user.userId num:1];
        [msg updateLastSend:UpdateLastSendType_Add];
    }
    
    [msg notifyNewMsg];
}

-(void)doSendFriendRequest:(TFJunYou_MessageObject*)msg{
    if(![msg isAddFriendMsg])
        return;
    if(!msg.isMySend)
        return;
    if([msg.type intValue] == XMPP_TYPE_SAYHELLO || [msg.type intValue] == XMPP_TYPE_FEEDBACK){
        int n = [msg.type intValue];
        msg.timeReceive = [NSDate date];
        msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
        msg.isSend = [NSNumber numberWithInt:transfer_status_yes];
        msg.isRead = [NSNumber numberWithInt:1];
        [msg insert:nil];
        msg.type = [NSNumber numberWithInt:n];
    }
    
    self.friend = [[TFJunYou_FriendObject alloc]init];
    [self.friend loadFromMessageObj:msg];
    [self.friend doWriteDb];
    [self.friend updateNewFriendLastContent];
    
    msg.content = [self.friend getLastContent:self.friend.userId];
    [msg updateLastSend:UpdateLastSendType_None];
    [msg notifyNewMsg];
}


// xmpp掉线后提示
- (void) showXmppOfflineAlert {
    
    [g_App showAlert:Localized(@"JX_Reconnect") delegate:self];
}

- (void) timerAction:(NSTimer *)timer{
    [_wait stop];
    // 连接失败
    [TFJunYou_MyTools showTipView:Localized(@"JX_ConnectFailed")];
    [timer invalidate];
    self.timer = nil;
}

#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        AppleReachability *reach = [AppleReachability reachabilityWithHostName:@"www.apple.com"];
        NetworkStatus internetStatus = [reach currentReachabilityStatus];
        switch (internetStatus) {
            case NotReachable:{
                if (self.isLogined != login_status_no) {
                    [self logout];
                }
//                [g_App showAlert:Localized(@"JX_NetWorkError")];
                [TFJunYou_MyTools showTipView:Localized(@"JX_NetWorkError")];
            }
                break;
                
            default:{
                //        if (alertView.tag == 10000) { // XMPP掉线
                _isShowLoginChange = YES;
                //            [_wait start:Localized(@"JX_Connection")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.isLogined != 1) {
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
                        //                    self.loginStatus = YES;
                        NSLog(@"XMPP --- alert");
                        [self logout];
                        [_wait start:Localized(@"JX_Connection")];
                        [self login];
                    }
                });
                //        }
            }
                break;
        }
    }
}

-(BOOL)deleteMessageWithUserId:(NSString *)userId messageId:(NSString *)msgId{//删除一条聊天记录
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return NO;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *queryString=[NSString stringWithFormat:@"delete from msg_%@ where messageId=?",userId];
    
    BOOL worked=[db executeUpdate:queryString,msgId];
    return worked;
}

-(TFJunYou_MessageObject*)findMessageWithUserId:(NSString *)userId messageId:(NSString *)msgId{//搜索一条记录
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ where messageId=?",userId];
    
    FMResultSet *rs=[db executeQuery:queryString,msgId];
    TFJunYou_MessageObject *p=nil;
    while ([rs next]) {
        p = [[TFJunYou_MessageObject alloc]init];
        [p fromRs:rs];
        break;
    }
    return p;
}

- (void)loginChanged {
    // 弹登录提示
    if (_isShowLoginChange) {
        _isShowLoginChange = NO;
        switch (self.isLogined){
            case login_status_ing:
                // 连接失败
//                [TFJunYou_MyTools showTipView:Localized(@"JX_ConnectFailed")];
                break;
            case login_status_no:
                
                g_server.lastOfflineTime = [[NSDate date] timeIntervalSince1970];
                // 连接失败
//                [TFJunYou_MyTools showTipView:Localized(@"JX_ConnectFailed")];
                break;
            case login_status_yes:
                // 连接成功
                [TFJunYou_MyTools showTipView:Localized(@"JX_ConnectSuccessfully")];
                break;
        }
    }
    
    // 定时检测XMPP登录状态，实现重连机制
    if (!self.isReconnect) {
        self.isReconnect = YES;
        return;
    }
    if(self.isLogined != login_status_yes) {
        [_reconnectTimer invalidate];
        _reconnectTimer = nil;
        if (self.reconnectTimerCount <= 30) {
            _reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:self.reconnectTimerCount target:self selector:@selector(xmppTimerAction:) userInfo:nil repeats:NO];
            NSLog(@"login-开始登陆 - %d",self.isLogined);
        }
    }else {
        [_reconnectTimer invalidate];
        _reconnectTimer = nil;
    }
}

- (void)xmppTimerAction:(NSTimer *)timer {
    NSLog(@"login-timerAction - %d",self.isLogined);
    if (self.isLogined != login_status_yes){
        self.reconnectTimerCount ++;
        [self logout];
        [self login];
    }else {
        self.reconnectTimerCount = 10;
        [_reconnectTimer invalidate];
        _reconnectTimer = nil;
    }
}






#pragma  mark ------------新版socket------------


// 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    
    // 连接后,可读取服务端的数据
    [self.socket readDataWithTimeout:- 1 tag:0];
    //    [self doLogin];
    
    AuthMessage *message = [[AuthMessage alloc] init];
    message.messageHead.from = [NSString stringWithFormat:@"%@/%@",g_myself.userId,SameResource];
    message.token = g_server.access_token;
    message.password = g_myself.password;
    message.messageHead.chatType = 5;
    message.messageHead.messageId = [self getMessageId];
    NSData *data = message.data;
    
    data = [self getWriteDataWithCmd:kWCCommandTypeAuthReq data:data];
    
    [self.socket writeData:data withTimeout:-1 tag:0];
}


/**
 客户端socket断开
 
 @param sock 客户端socket
 @param err 错误描述
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err && self.isReconnect) {
        self.isLogined = login_status_no;
        g_server.lastOfflineTime = [[NSDate date] timeIntervalSince1970];
        [self login];
    }
    
}


// 发送ping消息
- (void)pingTimerAction:(NSTimer *)timer {
    
    PingMessageProBuf *ping = [[PingMessageProBuf alloc] init];
    ping.messageHead.messageId = [self getMessageId];
    ping.messageHead.chatType = kWCChatTypeReceipt;
    ping.messageHead.from = [NSString stringWithFormat:@"%@/%@",g_myself.userId,SameResource];
    
    
    NSData *data = [self getWriteDataWithCmd:kWCCommandTypePingReq data:ping.data];
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.socket writeData:data withTimeout:- 1 tag:0];
    
}

//byteBuffer的总长度是 = 1byte协议版本号+1byte消息标志位+2byte命令码+4byte消息的长度+消息体
- (NSData *)getWriteDataWithCmd:(int)cmd data:(NSData *)data {
    NSMutableData *da = [NSMutableData data];
    
    // 协议版本号 固定1个字节：1
    Byte version[1] = {100};
    NSData *da1 = [NSData dataWithBytes:version length:1];
    [da appendData:da1];
    
    // 消息标志位 固定1个字节：81
    Byte flag[1] = {81};
    da1 = [NSData dataWithBytes:flag length:1];
    [da appendData:da1];
    
    // 密令码 2个字节
    short scmd = (short)cmd;
    HTONS(scmd);
    da1 = [NSData dataWithBytes:&scmd length:sizeof(scmd)];
    [da appendData:da1];
    
    // 消息长度 4个字节
    int len = (int)data.length;
    HTONL(len);
    da1 = [NSData dataWithBytes:&len length:sizeof(len)];
    [da appendData:da1];
    
    // 消息体
    [da appendData:data];
    
    return da;
}


/**
 读取数据
 
 @param sock 客户端socket
 @param data 读取到的数据
 @param tag 本次读取的标记
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self readData:data];
    
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
  
    //    [self showMessageWithStr:text];
    // 读取到服务端数据值后,能再次读取
    [self.socket readDataWithTimeout:- 1 tag:0];
}

- (void)readData:(NSData *)data {
    
    if (self.lastData.length > 0) {
        NSMutableData *mData = [[NSMutableData alloc] init];
        [mData appendData:self.lastData];
        [mData appendData:data];
        data = [mData copy];
    }
    
    if (data.length < 8) {
        self.lastData = data;
        return;
    }
    
    // 取出协议版本号
    NSData *da = [data subdataWithRange:NSMakeRange(0, 1)];
    Byte bversion[1];
    [da getBytes:bversion length:sizeof(bversion)];
    int version = bversion[0];
    
    //取出消息标志位
    da = [data subdataWithRange:NSMakeRange(1, 1)];
    Byte bflag[1];
    [da getBytes:bflag length:sizeof(bflag)];
    int flag = bflag[0];
    
    // 取出密令码
    da = [data subdataWithRange:NSMakeRange(2, 2)];
    short cmd;
    [da getBytes:&cmd length:sizeof(cmd)];
    NTOHS(cmd);
    
    // 取出消息长度
    da = [data subdataWithRange:NSMakeRange(4, 4)];
    int len;
    [da getBytes:&len length:sizeof(len)];
    NTOHL(len);
    
    if (len > data.length-8) {
        self.lastData = data;
        return;
    }
    
    self.lastData = nil;
    // 取出消息体
    da = [data subdataWithRange:NSMakeRange(8, len)];
    
    NSLog(@"dataLength == %ld", data.length);
    
    if (data.length - 8 > len) {
        [self readData:[data subdataWithRange:NSMakeRange(8 + len, data.length - (8 + len))]];
    }
    
    //二进制数据反序列化为对象
    switch (cmd) {
        case kWCCommandTypeAuthResp:    // 登录结果
            [self authResult:da];
            break;
        case kWCCommandTypeChat:        // 聊天消息
            [self chatResult:da];
            break;
        case kWCCommandTypeTypeSuccess: // 请求成功
            [self chatReceipt:da];
            break;
        case kWCCommandTypeRoomRequestResult:   // 群组请求结果
            [self roomRequestResult:da];
            break;
        case kWCCommandTypePullMessageResp: // 请求群离线消息结果
            [self roomPullMessageResp:da];
            break;
        case kWCCommandTypeLoginConflict:   // 被挤下线
            [self loginConflict:da];
            break;
        case kWCCommandTypeError:       // 错误消息
            [self messageError:da];
            break;
        default:{
            NSString *text = [[NSString alloc]initWithData:da encoding:NSUTF8StringEncoding];
            NSLog(@"0========================================");
            NSLog(@"%@", text);
            NSLog(@"1========================================");
            break;
        }
    }
}


// 挤下线
- (void)loginConflict:(NSData *)data {
 
    self.isReconnect = NO;
    [_reconnectTimer invalidate];
    _reconnectTimer = nil;
    [self logout];
    [g_notify postNotificationName:kXMPPLoginOtherNotification object:nil];
}

// 错误消息
- (void)messageError:(NSData *)data {
    NSError *error;
    CommonErrorProBuf *message = [CommonErrorProBuf parseFromData:data extensionRegistry:nil error:&error];
    if (message.code == -2) {
        TFJunYou_MessageObject *msg = [_poolSend objectForKey:message.messageHead.messageId];
        msg.sendCount = 0;
        [self onSendTimeout:msg];
        
        [TFJunYou_MyTools showTipView:[NSString stringWithFormat:@"%@为敏感词，不允许发送", message.arg]];
    }
}

// 请求群离线消息结果
- (void)roomPullMessageResp:(NSData *)data {
    NSError *error;
    PullGroupMessageRespProBuf *message = [PullGroupMessageRespProBuf parseFromData:data extensionRegistry:nil error:&error];
    
    TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
    user = [user getUserById:message.jid];
    
    TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
    
    NSString *msgsNewStr=[NSString stringWithFormat:@"%@",user.msgsNew];
    int allCount = (int)message.count + [msgsNewStr intValue];
    [msg updateNewMsgCount:allCount withUserId:message.jid];
    
    for (NSInteger i = 0; i < message.messageListArray.count; i ++) {
        ChatMessage *chatMessage = message.messageListArray[i];
        
        TFJunYou_MessageObject *chatMsg = [TFJunYou_MessageObject getMsgObjWithPbobjc:chatMessage];
        [chatMsg insert:message.jid];
        
        [chatMsg updateLastSend:UpdateLastSendType_None];
        [chatMsg notifyNewMsg];
        if (i == 0) {
            msg = chatMsg;
        }
        
        if ([msg.timeSend timeIntervalSince1970] > [chatMsg.timeSend timeIntervalSince1970]) {
            msg = chatMsg;
            if (msg.isGroupSend) {
                [g_notify postNotificationName:kKeepOnSendGroupSendMessage object:msg];
            }
        }
        
    }
    
    if (message.count > message.messageListArray.count) {
        
        NSArray *taskList = [[TFJunYou_SynTask sharedInstance] getTaskWithUserId:message.jid];
        TFJunYou_SynTask *task = taskList.firstObject;
        task.endTime = msg.timeSend;
        task.endMsgId = msg.messageId;
        [task update];
        
    }else {
        
        NSArray *taskList = [[TFJunYou_SynTask sharedInstance] getTaskWithUserId:message.jid];
        TFJunYou_SynTask *task = taskList.firstObject;
        [task delete];
    }
    
    
    [g_notify postNotificationName:kXMPPAllMsgNotifaction object:nil userInfo:nil];
}

// 群组请求结果
- (void)roomRequestResult:(NSData *)data {
    
    NSError *error;
    GroupMessageRespProBuf *message = [GroupMessageRespProBuf parseFromData:data extensionRegistry:nil error:&error];
    
    [self.roomDelegate roomRequestResultWithStatus:message.status isExit:message.isExit];
    
}


// 单聊消息回执
- (void)chatReceipt:(NSData *)data {
    NSError *error;
    CommonSuccessProBuf *message = [CommonSuccessProBuf parseFromData:data extensionRegistry:nil error:&error];
    NSString *msgId = message.messageHead.messageId;
    
    [self msgReceiptWithMsgId:msgId];
    
}

// 消息回执处理
- (void)msgReceiptWithMsgId:(NSString *)msgId {
    //正常消息回执
    TFJunYou_MessageObject *msg   = (TFJunYou_MessageObject*)[_poolSend objectForKey:msgId];
    
    if([msg.isSend intValue] != transfer_status_yes &&msg.messageId != nil){
        [self doSendFriendRequest:msg];
        if ([msg.type intValue] == kWCMessageTypeWithdraw) {
            msg.content = Localized(@"JX_AlreadyWithdraw");
        }
        [msg updateLastSend:UpdateLastSendType_Add];
        [msg updateIsSend:transfer_status_yes];
        [msg notifyReceipt];
        [msg notifyMyLastSend];
        [_poolSend removeObjectForKey:msg.messageId];
    }
    
    //已读消息的回执
    if (msg == nil) {
        for (int i = 0; i < [_poolSendRead count]; i++) {
            TFJunYou_MessageObject * p = _poolSendRead[i];
            if ([p.messageId isEqualToString:msgId]) {
                //对方已收到已读消息的回执
                [p updateIsReadWithContent];
                [g_notify postNotificationName:kXMPPMessageReadTypeReceiptNotification object:p];//接收方收到已读消息的回执，改变标志避免重复发
                [_poolSendRead removeObject:p];
                p =nil;
                break;
            }
        }
    }
}

// 登录认证成功
- (void)authResult:(NSData *)data {
    
    NSError *error;
    AuthRespMessageProBuf *message = [AuthRespMessageProBuf parseFromData:data extensionRegistry:nil error:&error];
    
    if (message.status == 1) {
        [self doLogin];
    }
    
    NSArray *resources = [message.resources componentsSeparatedByString:@","];
    [g_server.multipleLogin upDateOtherOnlineWithResources:resources];
    
}

#pragma  mark ------------ 收消息 ------------
// 聊天消息
- (void)chatResult:(NSData *)data {
    NSError *error;
    ChatMessage *message = [ChatMessage parseFromData:data extensionRegistry:nil error:&error];
    TFJunYou_MessageObject *msg = [TFJunYou_MessageObject getMsgObjWithPbobjc:message];
    [_receiptArray addObject:msg];
    
    if (_receiptArray.count >= 100) {
        [self receiptTimerAction:nil];
    }
    
//    [self sendMessageReceipt:msg];
    
    // 如收到自己发的群聊消息 判定为群聊回执
    if (msg.chatType == 2 && [msg.fromId isEqualToString:[NSString stringWithFormat:@"%@/%@",g_myself.userId,SameResource]]) {
        
        [self msgReceiptWithMsgId:msg.messageId];
        
        return;
    }
    
    
    NSString *fromUserId = msg.fromId;
    NSString *toUserId = msg.toId;
    int type = msg.chatType;
    
    NSLog(@"收消息  = %@",msg);
    
    if(![blackList containsObject:fromUserId] && ![blackList containsObject:toUserId]){ //排除黑名单，未对黑名单处理
        
        if(type == kWCChatTypeChat || type == kWCChatTypeGroupChat){
            //创建message对象
            
            if ([fromUserId isEqualToString:MY_USER_ID]) {
                msg.isMultipleRelay = YES;
            }else {
                msg.isMultipleRelay = NO;
            }
            
            if ([msg.content isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)msg.content;
                NSError *error;
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
                
                NSString *jsonString;
                if (!jsonData) {
                    NSLog(@"%@",error);
                }else{
                    jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                if (jsonString.length > 0) {
                    msg.content = jsonString;
                }
            }
            if (![msg.content isKindOfClass:[NSString class]]) {
                msg.content = [NSString stringWithFormat:@"%@", msg.content];
            }
            
            // 已过期的消息不处理
            if (([msg.deleteTime timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970]) && [msg.deleteTime timeIntervalSince1970] > 0) {
                return;
            }
            
            if (type == kWCChatTypeChat && msg.fromUserId && msg.toUserId && [msg.fromUserId isEqualToString:msg.toUserId]) {
                NSString *from = msg.fromId;
                NSRange range = [from rangeOfString:@"/"];
                NSString *device = [from substringFromIndex:range.location + 1];
                if ([device isEqualToString:@"android"]) {
                    msg.fromUserId = ANDROID_USERID;
                    fromUserId  = ANDROID_USERID;
                }
                if ([device isEqualToString:@"pc"]) {
                    msg.fromUserId = PC_USERID;
                    fromUserId  = PC_USERID;
                }
                if ([device isEqualToString:@"mac"]) {
                    msg.fromUserId = MAC_USERID;
                    fromUserId  = MAC_USERID;
                }
                if ([device isEqualToString:@"web"]) {
                    msg.fromUserId = WEB_USERID;
                    fromUserId  = WEB_USERID;
                }
            }
            
            if ([msg.fromUserName isKindOfClass:[NSString class]]) {
                if([msg.fromUserName length]>0 && type == kWCChatTypeChat && ![msg.fromUserId isEqualToString:MY_USER_ID]){//保存陌生人信息：
                    [self saveFromUser:msg];
                }
            }
            
            if (type == kWCChatTypeGroupChat) {
                msg.isGroup = YES;
            }else {
                msg.isGroup = NO;
            }
            
            if ([msg.type intValue] == KWCMessageTypeAuthLogin) {
                [g_notify postNotificationName:kDeviceAuthNotification object:msg];
                return;
            }
            
            //判断是否为已读类型
            if ([msg.type intValue] == kWCMessageTypeIsRead){
//                [self sendMsgReceipt:message];//收到已读消息后，发回执，确认收到
                BOOL isHave = [msg haveTheMessage];
                BOOL inserted = NO;
                if (type == kWCChatTypeChat) {
                    inserted = [msg insert:nil];
                }else {
                    msg.isGroup  = YES;
//                    msg.toUserId = fromUserId;
                    if ([msg.fromUserId isEqualToString:MY_USER_ID]) {
                        return;
                    }
                    inserted = [msg insert:msg.toUserId];
                }
                if (inserted) {
                    //                    if(![msg.fromUserId isEqualToString:MY_USER_ID]){//假如是我发送的，则以收到回执为准
                    if (isHave) {
                        return;
                    }
                    [msg updateIsReadWithContent];
                    [g_notify postNotificationName:kXMPPMessageReadTypeNotification object:msg];//发送方收到已读类型，改变消息图片为已读
                    //                        if (!msg.isGroup) {
                    
                    // 阅后即焚：对方查看了我发送的阅后即焚消息，收到已读回执后删除阅后即焚消息
                    NSString *fetchUserId;
                    if ([msg.fromUserId isEqualToString:MY_USER_ID]) {
                        fetchUserId = msg.toUserId;
                    }else {
                        fetchUserId = msg.fromUserId;
                    }
                    NSMutableArray *arr = [[TFJunYou_MessageObject sharedInstance] fetchAllMessageListWithUser:fetchUserId];
                    for (NSInteger i = 0; i < arr.count; i ++) {
                        TFJunYou_MessageObject * p = [arr objectAtIndex:i];
                        if ([p.messageId isEqualToString:msg.content]) {
                            if ([p.isReadDel boolValue]) {
                                if ([p.type intValue] == kWCMessageTypeImage|| [p.type intValue] == kWCMessageTypeCustomFace|| [p.type intValue] == kWCMessageTypeEmoji || [p.type intValue] == kWCMessageTypeVoice || [p.type intValue] == kWCMessageTypeVideo || [p.type intValue] == kWCMessageTypeText) {
                                    
                                    if ([p.fromUserId isEqualToString:MY_USER_ID]) {
                                        TFJunYou_MessageObject *newMsg = [[TFJunYou_MessageObject alloc] init];
                                        newMsg.isShowTime = NO;
                                        newMsg.messageId = msg.content;
                                        if(type != kWCChatTypeChat){
                                            newMsg.isGroup = YES;
                                            msg.toUserId = fromUserId;
                                        }else {
//                                            [self sendMsgReceipt:message];
                                        }
                                        newMsg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
                                        newMsg.content = Localized(@"JX_OtherLookedYourReadingMsg");
                                        newMsg.fromUserId = msg.fromUserId;
                                        newMsg.toUserId = msg.toUserId;
                                        [newMsg update];
                                        [newMsg updateLastSend:UpdateLastSendType_None];
                                        msg = nil;
                                    }else {
                                        [p delete];
                                    }
                                    
                                }
                            }
                        }
                        //                            }
                        
                    }
                    
                    //                    }
                }
                return;
            }
            
            if(msg.type != nil ){
                // 判断是否是撤回消息
                if ([msg.type intValue] == kWCMessageTypeWithdraw) {
                    
                    TFJunYou_MessageObject *newMsg = [[TFJunYou_MessageObject alloc] init];
                    newMsg.isShowTime = NO;
                    newMsg.messageId = msg.content;
                    if(type != kWCChatTypeChat){
                        newMsg.isGroup = YES;
//                        msg.toUserId = fromUserId;
                    }else {
//                        [self sendMsgReceipt:message];
                    }
                    newMsg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
                    newMsg.fromUserId = msg.fromUserId;
                    newMsg.toUserId = msg.toUserId;
                    newMsg.timeSend = msg.timeSend;
                    TFJunYou_MessageObject *msg1 = [newMsg getMsgWithMsgId:msg.content];
                    if ([msg.fromUserId isEqualToString:MY_USER_ID]) {
                        newMsg.content = Localized(@"JX_AlreadyWithdraw");
                    }
                    else if ([msg.fromUserId isEqualToString:msg1.fromUserId]) {
                        newMsg.content = [NSString stringWithFormat:@"%@%@",msg.fromUserName, Localized(@"JX_OtherWithdraw")];
                    }
                    else {
                        newMsg.content = @"管理员撤回了一条成员消息";
                    }
                    
                    
                    if (msg1 && [msg1.type integerValue] != kWCMessageTypeRemind) {
                        [newMsg updateLastSend:UpdateLastSendType_None];
                        [g_notify postNotificationName:kXMPPMessageWithdrawNotification object:newMsg];
                    }
                    [newMsg update];
                    msg = nil;
                    return;
                }
                
                // 分享消息
                if ([msg.type intValue] == kWCMessageTypeShare) {
                    msg.content = [NSString stringWithFormat:@"[%@]",Localized(@"JXLink")];
                }
                // 转账已被领取消息
                if ([msg.type intValue] == kWCMessageTypeTransferReceive) {
                    [g_notify postNotificationName:kXMPPMessageTransferReceiveNotification object:msg];
                }
                // 转账已被退回消息
                if ([msg.type intValue] == kWCMessageTypeTransferBack) {
                    [g_notify postNotificationName:kXMPPMessageTransferBackNotification object:msg];
                }
                // 扫码支付款
                if ([msg.type intValue] == kWCMessageTypePaymentOut || [msg.type intValue] == kWCMessageTypeReceiptOut ||[msg.type intValue] == kWCMessageTypePaymentGet ||[msg.type intValue] == kWCMessageTypeReceiptGet) {
                    [g_notify postNotificationName:kXMPPMessageQrPaymentNotification object:msg];
                }
                // 修改密码/首次设置支付密码/隐私设置/标签的增删改查
                if ([msg.type intValue] == kWCMessageTypeUpadtePassword) {
                    if ([msg.objectId isEqualToString:SYNC_LOGIN_PASSWORD] && !msg.isDelay) {
                        [g_server otherUpdatePassword];
                    }
                    else if ([msg.objectId isEqualToString:SYNC_LOGIN_PASSWORD]) {
                        g_server.myself.isPayPassword = @1;
                    }
                    else{
                        [g_notify postNotificationName:kXMPPMessageUpadtePasswordNotification object:msg];
                    }
                }
                // 编辑自己的基本资料/用户
                if ([msg.type intValue] == kWCMessageTypeUpadteUserInfo) {
                    [g_notify postNotificationName:kXMPPMessageUpadteUserInfoNotification object:msg];
                }
                // 编辑群组资料
                if ([msg.type intValue] == kWCMessageTypeUpadteGroup) {
                    [g_notify postNotificationName:kXMPPMessageUpadteGroupNotification object:msg];
                }
                
                if(type != kWCChatTypeGroupChat){
                    //单聊发送回执：
                    if (![fromUserId isEqualToString:MY_USER_ID]) {
//                        [self sendMsgReceipt:message];
                    }
                    // 判断是否是正在输入
                    if ([msg.type intValue] == kWCMessageTypeRelay) {
                        [g_notify postNotificationName:kXMPPMessageEnteringNotification object:msg];
                        msg = nil;
                        return;
                    }
                    // 点赞 & 评论
                    if ([msg.type intValue] == kWCMessageTypeWeiboPraise || [msg.type intValue] == kWCMessageTypeWeiboComment || [msg.type intValue] == kWCMessageTypeWeiboRemind || [msg.type intValue] == kWCMessageTypeWeiboCancelPraise) {
                        TFJunYou_BlogRemind *br = [[TFJunYou_BlogRemind alloc] init];
                        [br fromObject:msg];
                        [br insertObj];
                        [g_notify postNotificationName:kXMPPMessageWeiboRemind object:msg];
                        msg = nil;
                        return;
                    }
                    // 加好友消息
                    if([msg isAddFriendMsg] && ![msg haveTheMessage]){
                        if ([msg.type intValue] == XMPP_TYPE_CONTACTREGISTER) {
                            [g_notify postNotificationName:kMsgComeContactRegister object:msg];
                        }else {
                            [self doReceiveFriendRequest:msg];
                        }
                        return;
                    }
                    
                    
                    // 面对面建群通知
                    if ([msg.type integerValue] == kRoomRemind_FaceRoomSearch) {
                        [g_notify postNotificationName:kMsgRoomFaceNotif object:msg];
                        return;
                    }
                    
                    //群文件：
                    if([msg.type intValue] == kWCMessageTypeGroupFileUpload || [msg.type intValue] == kWCMessageTypeGroupFileDelete || [msg.type intValue] == kWCMessageTypeGroupFileDownload){
                        [msg doGroupFileMsg];
                        return;
                    }
                    //清空双方聊天记录
                    if ([msg.type intValue] == kWCMessageTypeDelMsgTwoSides) {
                        TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:msg.fromUserId];
                        TFJunYou_MessageObject *msg1 = [[TFJunYou_MessageObject alloc] init];
                        msg1.toUserId = msg.fromUserId;
                        [msg1 deleteAll];
                        msg1.type = [NSNumber numberWithInt:1];
                        if (user.content.length > 0) {
                            msg1.content = @" ";
                        }else {
                            msg1.content = @"";
                        }
                        [msg1 updateLastSend:UpdateLastSendType_None];
                        [msg1 updateNewMsgsTo0];
                        //                        [msg1 notifyMyLastSend];
                        [g_server emptyMsgWithTouserId:msg1.fromUserId type:[NSNumber numberWithInt:0] toView:self];
                        if (user.content.length > 0) {
                            
                            [msg notifyNewMsg];//在显示时检测MessageId是否已显示
                        }
                        return;
                    }

                    if (![msg haveTheMessage]) {
                        BOOL isRoomControlMsg = msg.isRoomControlMsg;
                        BOOL isInsert = [msg insert:nil];//在保存时检测MessageId是否已存在记录
//                        if (!isRoomControlMsg && !isInsert) {
//                            return;
//                        }
                        
                        [msg updateLastSend:UpdateLastSendType_Add];
                        [msg notifyNewMsg];//在显示时检测MessageId是否已显示
                    }
                }else{
                    
                    //群文件：
                    if([msg.type intValue] == kWCMessageTypeGroupFileUpload || [msg.type intValue] == kWCMessageTypeGroupFileDelete || [msg.type intValue] == kWCMessageTypeGroupFileDownload){
                        [msg doGroupFileMsg];
                        return;
                    }
                    if ([msg.type intValue] == kWCMessageTypeRedPacketReceive && ![msg.toUserId isEqualToString:MY_USER_ID]) {
                        // 如果83消息接收者不是自己，则return
                        return;
                    }
                    
                    
                    msg.isGroup  = YES;
                    BOOL isRoomControlMsg = msg.isRoomControlMsg;

                    if(![msg insert:msg.toUserId]){ //在保存时检测MessageId是否已存在记录
                        if (isRoomControlMsg) {
                            return;
                        }
                        msg.isRepeat = YES;
                    }else {
                        [msg updateLastSend:UpdateLastSendType_Add];
                    }
                    [msg notifyNewMsg];
                    
                }
            }
        }
        
        msg = nil;
    }
    
}

- (void)receiptTimerAction:(NSNotification *)notif {
    _receiptTimerNum ++;
    if (_receiptTimerNum >= 5 || _receiptArray.count >= 100) {
        _receiptTimerNum = 0;
        NSMutableString *msgIds = [NSMutableString string];
        for (NSInteger i = 0; i < _receiptArray.count; i ++) {
            TFJunYou_MessageObject *msg = _receiptArray[i];
            if (i != _receiptArray.count - 1) {
                [msgIds appendString:msg.messageId];
                [msgIds appendString:@","];
            }else {
                [msgIds appendString:msg.messageId];
            }
        }
        
        if (msgIds.length > 0) {
            TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
            msg.messageId = [msgIds copy];
            [self sendMessageReceipt:msg];
        }
        [_receiptArray removeAllObjects];
    }
}

// 发送消息回执
- (void)sendMessageReceipt:(TFJunYou_MessageObject *)msg {
    MessageReceiptStatusProBuf *message = [[MessageReceiptStatusProBuf alloc] init];
    message.messageHead.messageId = [self getMessageId];
    message.messageHead.chatType = 1;
    message.messageHead.from = [NSString stringWithFormat:@"%@/%@",g_myself.userId,SameResource];
//    message.messageHead.to = msg.toId;
    
    message.status = 2;
    message.messageId = msg.messageId;
    
    NSData *data = [self getWriteDataWithCmd:kWCCommandTypeReceipt data:message.data];
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.socket writeData:data withTimeout:- 1 tag:0];
    
}

- (NSString *)getMessageId {
    
    return [[[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}


// 加入群组
- (void)addRoomWithJid:(NSString *)jid delegate:(TFJunYou_RoomObject *)delegate {
    self.roomDelegate = delegate;
    JoinGroupMessageProBuf *message = [[JoinGroupMessageProBuf alloc] init];
    message.messageHead.messageId = [self getMessageId];
    message.messageHead.chatType = kWCChatTypeGroupChat;
    message.messageHead.from = [NSString stringWithFormat:@"%@/%@",g_myself.userId,SameResource];
    message.jid = jid;
    
    
    NSData *data = [self getWriteDataWithCmd:kWCCommandTypeJoinGroupReq data:message.data];
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.socket writeData:data withTimeout:- 1 tag:0];
}

// 退出群组
- (void)exitRoomWithJid:(NSString *)jid delegate:(TFJunYou_RoomObject *)delegate {
    
    self.roomDelegate = delegate;
    ExitGroupMessageProBuf *message = [[ExitGroupMessageProBuf alloc] init];
    message.messageHead.messageId = [self getMessageId];
    message.messageHead.chatType = kWCChatTypeGroupChat;
    message.messageHead.from = [NSString stringWithFormat:@"%@/%@",g_myself.userId,SameResource];
    message.jid = jid;
    
    
    NSData *data = [self getWriteDataWithCmd:kWCCommandTypeExitGroupReq data:message.data];
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.socket writeData:data withTimeout:- 1 tag:0];
}

// 获取群离线消息
- (void)pullBatchGroupMessageReqWithJidListArray:(NSMutableArray *)listArr {
    
    PullBatchGroupMessageReqProBuf *message = [[PullBatchGroupMessageReqProBuf alloc] init];
    message.messageHead.messageId = [self getMessageId];
    message.messageHead.chatType = kWCChatTypeGroupChat;
    message.messageHead.from = [NSString stringWithFormat:@"%@/%@",g_myself.userId,SameResource];
    message.jidListArray = listArr;
    message.endTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSData *data = [self getWriteDataWithCmd:kWCCommandTypePullMessageReq data:message.data];
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.socket writeData:data withTimeout:- 1 tag:0];
}

@end
