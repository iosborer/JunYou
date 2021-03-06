//
//  TFJunYou_ChatViewController.m
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
// ？1111

#import "TFJunYou_ChatViewController.h"
#import "ChatCacheFileUtil.h"
#import "VoiceConverter.h"
#import "Photo.h"
#import "NSData+XMPP.h"
#import "AppDelegate.h"
#import "TFJunYou_Emoji.h"
#import "TFJunYou_FaceViewController.h"
#import "TFJunYou_gifViewController.h"
#import "TFJunYou_emojiViewController.h"
#import "SCGIFImageView.h"
//#import "TFJunYou_ImageView.h"
#import "TFJunYou_SelectImageView.h"
#import "TFJunYou_emojiViewController.h"
#import "TFJunYou_TableView.h"
#import "LXActionSheet.h"
#import "TFJunYou_VolumeView.h"
#import "TFJunYou_myMediaVC.h"
#import "TFJunYou_MediaObject.h"
#import "FMDatabase.h"
#import "TFJunYou_MyTools.h"
#if TAR_IM
#ifdef Meeting_Version
#import "TFJunYou_MeetingObject.h"
#import "AskCallViewController.h"
#import "TFJunYou_AVCallViewController.h"
#endif
#endif
#ifdef Live_Version
#import "TFJunYou_LiveJidManager.h"
#endif
#import "TFJunYou_UserInfoVC.h"
#import "TFJunYou_RoomMemberVC.h"
#import "TFJunYou_RoomObject.h"
#import "TFJunYou_RoomRemind.h"
#import "TFJunYou_SelFriendVC.h"
#import "TFJunYou_MyFile.h"
#import "TFJunYou_ShareFileObject.h"
#import "TFJunYou_FileDetailViewController.h"

#import "TFJunYou_MapData.h"
#import "TFJunYou_SendRedPacketViewController.h"

#import "TFJunYou_redPacketDetailVC.h"
#import "TFJunYou_OpenRedPacketVC.h"
//添加VC转场动画
#import "DMScaleTransition.h"
//各种Cell
#import "TFJunYou_BaseChatCell.h"
#import "TFJunYou_MessageCell.h"
#import "TFJunYou_MsgStrCell.h"
#import "TFJunYou_ImageCell.h"
#import "TFJunYou_FileCell.h"
#import "TFJunYou_VideoCell.h"
#import "TFJunYou_AudioCell.h"
#import "TFJunYou_LocationCell.h"
#import "TFJunYou_CardCell.h"
#import "TFJunYou_RedPacketCell.h"
#import "TFJunYou_RemindCell.h"
#import "TFJunYou_GifCell.h"
#import "TFJunYou_SystemImage1Cell.h"
#import "TFJunYou_SystemImage2Cell.h"
#import "TFJunYou_AVCallCell.h"
#import "TFJunYou_LinkCell.h"
#import "TFJunYou_ShakeCell.h"
#import "TFJunYou_MergeRelayCell.h"
#import "TFJunYou_ShareCell.h"
#import "TFJunYou_TransferCell.h"
#import "TFJunYou_ReplyCell.h"

#import "TFJunYou_EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

#import "ImageBrowserViewController.h"
#import "TFJunYou_RelayVC.h"
#import "webpageVC.h"
#import "TFJunYou__DownListView.h"
#import "TFJunYou_ReadListVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
#import "TFJunYou_CameraVC.h"
#import "TFJunYou_ChatSettingVC.h"
#import "TFJunYou_VerifyDetailVC.h"
#import "TFJunYou_Device.h"
#import "TFJunYou_ChatLogVC.h"
#import "TFJunYou_SelectFriendsVC.h"
#import "TFJunYou_MsgViewController.h"
#import "TFJunYou_WeiboVC.h"
#import "TFJunYou_ObjUrlData.h"
#import "TFJunYou_SynTask.h"
#import "TFJunYou_GoogleMapVC.h"
#import "RITLPhotosViewController.h"
#import "RITLPhotosDataManager.h"
#import "TFJunYou_ActionSheetVC.h"
#import "TFJunYou_InputVC.h"
#import "TFJunYou_RoomPool.h"
#import "KKImageEditorViewController.h"
#import "TFJunYou_TransferViewController.h"
#import "TFJunYou_TransferDeatilVC.h"
#import "TFJunYou_SelectAddressBookVC.h"
#import "TFJunYou_InputMoneyVC.h"
#import "TFJunYou_GroupHelperListVC.h"
#import "TFJunYou_GroupHeplerModel.h"
#import "TFJunYou_AutoReplyAideVC.h"
#import "TFJunYou_LabelObject.h"
#import "TFJunYou_EmojiCell.h"
#import "TFJunYou_FaceCustomCell.h"
#import "TFJunYou_RealCerVc.h"
#import "TFJunYou_FAQCenterVC.h"
#import <XHToast/XHToast.h>

#define faceHeight (THE_DEVICE_HAVE_HEAD ? 253 : 218)
#define PAGECOUNT 50
#define NOTICE_WIDTH  120  // 调整两条公告间的距离

#define UpdateAcceptCallMsg @"UpdateAcceptCallMsg"

#define groupsend_msgType_text  1
#define groupsend_msgType_image 2
#define groupsend_msgType_video 3
#define groupsend_msgType_audio 4
#define groupsend_msgType_file 5
#define groupsend_msgType_shake 6
#define groupsend_msgType_addressbook 7
#define groupsend_msgType_card 8
#define groupsend_msgType_collect 9
#define groupsend_msgType_imagesAndVideos 10
#define groupsend_msgType_location 11

@interface TFJunYou_ChatViewController()<TFJunYou_FaceViewControllerDelegate,TFJunYou_gifViewControllerDelegate,TFJunYou_FavoritesVCDelegate,TFJunYou_ChatCellDelegate,TFJunYou_RoomMemberVCDelegate,SendRedPacketVCDelegate,UIAlertViewDelegate,TFJunYou_RelayVCDelegate,TFJunYou_CameraVCDelegate,ImageBrowserVCDelegate,weiboVCDelegate,RITLPhotosViewControllerDelegate,TFJunYou_VideoCellDelegate,TFJunYou_ActionSheetVCDelegate,UINavigationControllerDelegate,KKImageEditorDelegate,transferVCDelegate,TFJunYou_SelectAddressBookVCDelegate,TFJunYou_RoomObjectDelegate>{

    CGRect _lastFrame;
}
@property (nonatomic, assign) CGFloat deltaY;
@property (nonatomic, assign) CGFloat deltaHeight;
//@property (nonatomic, strong) DMAlphaTransition *alphaTransition;
@property (nonatomic, strong) DMScaleTransition *scaleTransition;
//@property (nonatomic, strong) DMSlideTransition *slideTransition;
@property (nonatomic,strong) NSArray  *allChatImageArr;//消息记录里所有图片
@property (nonatomic,assign) BOOL     isReadDelete;
@property (nonatomic, copy) NSMutableString *sendText;
@property (nonatomic, strong) NSMutableString *names; //群发助手标签拼接字符串
@property (nonatomic, strong) NSMutableString *names2; //群发助手群组拼接字符串

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL loginStatus;
@property (nonatomic, strong) NSTimer *enteringTimer;
@property (nonatomic, strong) NSTimer *noEnteringTimer;
@property (nonatomic, assign) BOOL isSendEntering;
@property (nonatomic, assign) BOOL isGetServerMsg;
@property (nonatomic, assign) int serverMsgPage;
@property (nonatomic, strong) NSMutableArray * atMemberArray;

@property (nonatomic, copy) NSString *userNickName;
@property (nonatomic, assign) BOOL firstGetUser;
@property (nonatomic, assign) BOOL onlinestate;

@property (nonatomic, strong) UIView *publicMenuBar;
@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, assign) NSInteger selMenuIndex;

@property (nonatomic, assign) NSInteger withdrawIndex;

@property (nonatomic, strong) NSMutableArray *recordArray;
@property (nonatomic, copy) NSString *recordName;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) NSInteger recordStarNum;

@property (nonatomic, strong) ATMHud *chatWait;
@property (nonatomic, assign) int sendIndex;

@property (nonatomic, strong) TFJunYou_LocationVC *locVC;
@property (nonatomic, strong) TFJunYou_GoogleMapVC *gooMap;

@property (nonatomic, assign) int isBeenBlack;
@property (nonatomic, assign) int friendStatus;

@property (nonatomic, copy) NSString *meetingNo;
@property (nonatomic, assign) BOOL isAudioMeeting;
@property (nonatomic, assign) BOOL isTalkMeeting;

@property (nonatomic, assign) int groupMessagesIndex;

@property (nonatomic, strong) TFJunYou_MessageObject *shakeMsg;

@property (nonatomic, strong) UIView *screenShotView;
@property (nonatomic, strong) UIImageView *screenShotImageView;

@property (nonatomic, strong) UIImageView *backGroundImageView;

@property (nonatomic, assign) BOOL isSelectMore;
@property (nonatomic, strong) NSMutableArray *selectMoreArr;
@property (nonatomic, strong) UIView *selectMoreView;

@property (nonatomic, assign) int readDelNum;

@property (nonatomic, assign) BOOL isAdmin;

@property (nonatomic, strong) UIButton *shareMore;
@property (nonatomic, strong) UILabel *talkTimeLabel;

@property (nonatomic, strong) UIButton *jumpNewMsgBtn;

@property (nonatomic, strong) WeiboData *collectionData;

@property (nonatomic, strong) NSMutableArray *taskList; // 任务列表

@property (nonatomic, strong) NSArray *imgDataArr;

@property (nonatomic, assign) int indexNum;   // 消息重发传来的cell.tag

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, assign) BOOL isMapMsg; // 发送的是不是地图消息
@property (nonatomic, strong) TFJunYou_MapData *mapData;

@property (nonatomic, strong) NSString *objToMsg;// 回复谁的消息，存json数据
@property (nonatomic, strong) NSString *hisReplyMsg; // 回复历史水印

@property (nonatomic, copy) NSString *meetUrl;

@property (nonatomic, strong) UIView *shareView;

@property (nonatomic, strong) UIView *noticeView;
@property (nonatomic, strong) UIImageView *noticeImgV;
@property (nonatomic, strong) UILabel *noticeLabel;
@property (nonatomic, strong) UIView *showNoticeView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) NSTimer *noticeTimer;
@property (nonatomic, strong) NSString *noticeStr;
@property (nonatomic, assign) CGFloat leftW;
@property (nonatomic, assign) CGFloat rightW;
@property (nonatomic, assign) CGFloat noticeStrW;
@property (nonatomic, assign) int noticeHeight;
@property (nonatomic, strong) UIButton *textViewBtn;

@property (nonatomic, assign) BOOL scrollBottom;
@property (nonatomic, assign) BOOL isGotoLast;
@property (nonatomic, assign) BOOL isSyncMsg;

@property (nonatomic, assign) BOOL isFirst; // 第一次调用GetRoom
@property (nonatomic, assign) BOOL isDisable;   // 群组是否禁用
@property (nonatomic, strong) UIImage *screenImage; // 记录一下屏幕快照

@property (nonatomic, strong) NSArray *helperArr;// 群助手数据

// 红包点击后的界面
@property (nonatomic, strong) UIView *redBaseView;
@property (nonatomic, strong) UIImageView *openImgV;
@property (nonatomic, strong) UIImageView *redBackV;
@property (nonatomic, strong) NSDictionary *redPacketDict;
@property (nonatomic, assign) BOOL isDidRedPacketRemind;
@property (nonatomic, strong) UILabel *tintLab;
@property (nonatomic, strong) UILabel *seeLab;

@property (nonatomic, assign) CGFloat lastY;
@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, strong) UIImageView *audioIcon;

@property (nonatomic, assign) BOOL isShowAT;

@property (nonatomic, assign) BOOL isSendRedPacket;

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, strong) UIView *waitGroupSendView; //群发提示窗口
@property (nonatomic, strong) UILabel *waitGroupSendLable; //群发实时更新已发送数量
@property (nonatomic, assign) NSInteger sendedNum; //群发已发送数量
@property (nonatomic, strong) NSMutableArray *groupUploadObjArray; //群发需要上传的数据
@property (nonatomic, assign) NSInteger onceSendNum; //群发每组发送的消息数量
@property (nonatomic, assign) BOOL isOriginal; //是否保存本地
@property (nonatomic, assign) NSInteger groupSendType; //群发消息类型
@property (nonatomic, strong) NSMutableArray *groupSendMsgArray; //群发的内容
@property (nonatomic, assign) NSInteger groupSendAllNum; //群发消息总数
@property (nonatomic, assign) BOOL isGroupSendCancel; //取消群发
@property (nonatomic, strong) NSDictionary *imgsAndVideosDic;//群发图册选中的图片和视频

@property (nonatomic,strong) NSString* answerContent;
@property (nonatomic, strong) NSMutableArray *arrayReport;

@end

@implementation TFJunYou_ChatViewController
@synthesize chatPerson,roomId,chatRoom;

- (id)init
{
    self = [super init];
    if (self) {
        if (!_room) {
            _room = [[roomData alloc] init];
        }
        _arrayReport = [NSMutableArray array];
        _userNickName = g_myself.userNickname;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 48;
        if (self.courseId.length > 0) {
            self.heightFooter = THE_DEVICE_HAVE_HEAD ? TFJunYou__SCREEN_BOTTOM : 56;
        }
        if (self.isHiddenFooter) {
            self.heightFooter = 0;
        }
        self.isGotoBack   = YES;
        self.isGotoLast = YES;
        _orderRedPacketArray = [[NSMutableArray alloc]init];
        _atMemberArray = [[NSMutableArray alloc] init];
        _selectMoreArr = [NSMutableArray array];
        if (self.roomJid.length > 0) {
            _taskList = [NSMutableArray array];
            NSMutableArray *list = [[TFJunYou_SynTask sharedInstance] getTaskWithUserId:self.roomJid];
            for (NSInteger i = 0; i < list.count; i ++) {
                TFJunYou_SynTask *task = list[i];
                if (task.endTime) {
                    [_taskList addObject:task];
                }else {
                    [task delete];
                }
            }

        }
        if (self.newMsgCount > 100) {
            self.newMsgCount = 100;
        }
        //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
        self.groupMessagesIndex = 0;
        _disableSay = 0;
        _serverMsgPage = 0;
        _isRecording = NO;
        _recordStarNum = 0;
        
        _pool     = [[NSMutableArray alloc]init];
        _array = [[NSMutableArray alloc]init];
        
        NSString *isOpenReadDel = [NSString stringWithFormat:@"%@",self.chatPerson.isOpenReadDel];
        _isReadDelete = [isOpenReadDel boolValue];

        _recordArray = [NSMutableArray array];
        _chatWait = [[ATMHud alloc] init];
        
        if (current_chat_userId)
            [g_xmpp.chatingUserIds addObject:current_chat_userId];
        
    }
    [g_notify addObserver:self selector:@selector(audioPlayEnd:) name:kCellVoiceStartNotifaction object:nil];//开始录音
    [g_notify addObserver:self selector:@selector(cardCellClick:) name:kCellShowCardNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(locationCellClick:) name:kCellLocationNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(onDidImage:) name:kCellImageNotifaction object:nil];//照片
    [g_notify addObserver:self selector:@selector(onDidRedPacket:) name:kcellRedPacketDidTouchNotifaction object:nil];//普通红包点击
    [g_notify addObserver:self selector:@selector(onDidTransfer:) name:kcellTransferDidTouchNotifaction object:nil];//转账点击
    [g_notify addObserver:self selector:@selector(onDidHeadImage:) name:kCellHeadImageNotification object:nil];
    [g_notify addObserver:self selector:@selector(longGesHeadImageNotification:) name:kCellLongGesHeadImageNotification object:nil];
    
    [g_notify addObserver:self selector:@selector(resendMsgNotif:) name:kCellResendMsgNotifaction object:nil];//重发消息
    [g_notify addObserver:self selector:@selector(deleteMsgNotif:) name:kCellDeleteMsgNotifaction object:nil];//删除消息
    [g_notify addObserver:self selector:@selector(showReadPersons:) name:kCellShowReadPersonsNotifaction object:nil];   // 查看已读列表
    [g_notify addObserver:self selector:@selector(hideKeyboard:) name:kHiddenKeyboardNotification object:nil];
    [g_notify addObserver:self selector:@selector(onDidSystemImage1:) name:kCellSystemImage1DidTouchNotifaction object:nil];  // 单条图文消息点击
    [g_notify addObserver:self selector:@selector(onDidSystemImage2:) name:kCellSystemImage2DidTouchNotifaction object:nil];  // 多条图文消息点击
    [g_notify addObserver:self selector:@selector(onDidAVCall:) name:kCellSystemAVCallNotifaction object:nil];  // 音视频通话
    [g_notify addObserver:self selector:@selector(onDidFile:) name:kCellSystemFileNotifaction object:nil];  // 文件点击
    [g_notify addObserver:self selector:@selector(onDidLink:) name:kCellSystemLinkNotifaction object:nil];  // 链接点击
    [g_notify addObserver:self selector:@selector(onDidShake:) name:kCellSystemShakeNotifaction object:nil];  // 戳一戳点击
    [g_notify addObserver:self selector:@selector(onDidMergeRelay:) name:kCellSystemMergeRelayNotifaction object:nil];  // 合并转发点击
    [g_notify addObserver:self selector:@selector(onDidShare:) name:kCellShareNotification object:nil]; // 分享cell点击
    
    [g_notify addObserver:self selector:@selector(onDidRemind:) name:kCellRemindNotifaction object:nil];  // 控制消息点击
    [g_notify addObserver:self selector:@selector(onDidReply:) name:kCellReplyNotifaction object:nil];  // 回复消息点击
    [g_notify addObserver:self selector:@selector(onDidMessageReadDel:) name:kCellMessageReadDelNotifaction object:nil];  // 文本消息阅后即焚点击
    [g_notify addObserver:self selector:@selector(openReadDelNotif:) name:kOpenReadDelNotif object:nil];    // 阅后即焚开关
    [g_notify addObserver:self selector:@selector(refreshChatLogNotif:) name:kRefreshChatLogNotif object:nil];

    [g_notify addObserver:self selector:@selector(reloadNotif:) name:kChatVCReloadNotif object:nil];
    
    [g_notify addObserver:self selector:@selector(clickTextNotif:) name:@"clickText" object:nil];
    
    [g_notify addObserver:self selector:@selector(onLoginChanged:) name:kXmppLoginNotifaction object:nil];
    // 监听系统截屏
    [g_notify addObserver:self selector:@selector(userDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [g_notify addObserver:self selector:@selector(onGroupHelper) name:kUpdateChatVCGroupHelperData object:nil];//更新群助手
    [g_notify addObserver:self selector:@selector(updateMsgSynTaskNotif:) name:kUpdateMsgSynTask object:nil];
    
    [g_notify addObserver:self selector:@selector(chatVCMessageSync:) name:kChatVCMessageSync object:nil];
    NSLog(@"timetime6 -- %f", [[NSDate date] timeIntervalSince1970]);
    [g_notify addObserver:self selector:@selector(updateTransferMsgFileSize:) name:kUpdateTransferMsgFileSize object:nil];
    
    [g_notify addObserver:self selector:@selector(keepOnGroupSend:) name:kKeepOnSendGroupSendMessage object:nil];
    
    [g_notify addObserver:self selector:@selector(applicationWillEnterForeground) name:kApplicationWillEnterForeground object:nil];
    
    return self;
}

- (void)applicationWillEnterForeground {
    // 获取服务器时间
//    [g_server getCurrentTimeToView:self];
//    [g_server tigaseMucMsgsWithRoomId:<#(NSString *)#> StartTime:<#(long)#> EndTime:<#(long)#> PageIndex:<#(int)#> PageSize:<#(int)#> toView:<#(id)#>];
//    [self messageSync];
}


// 设置单聊title
- (void)setChatTitle:(NSString *)userName {
    
    NSString *str = self.onlinestate ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
    
    if ([g_config.isOpenOnlineStatus boolValue]) {
        memberData *me = [self.room getMember:g_myself.userId];
        if ([me.role intValue] == 1 || [me.role intValue] == 2) {
            self.title = [NSString stringWithFormat:@"%@(%@)", self.chatPerson.userNickname, str];
        } else {
            self.title = self.chatPerson.userNickname;
        }
    }else {
        self.title = userName;
    }
    [self setAudioIconFrame];
}

// 更新离线消息任务
- (void)updateMsgSynTaskNotif:(NSNotification *)notif {
    
    NSString *userId = notif.object;
    if ([userId isEqualToString:self.chatPerson.userId]) {

        if (self.roomJid.length > 0) {
            _taskList = [[TFJunYou_SynTask sharedInstance] getTaskWithUserId:self.roomJid];
        }
    }
}

#pragma mark - 用户截屏通知事件
- (void)userDidTakeScreenshot:(NSNotification *)notification {
    //如果当前界面存在阅后即焚消息，进行截屏操作，便会通知对方
    NSArray *allDelMsg = [[TFJunYou_MessageObject sharedInstance] fetchDelMessageWithUserId:self.chatPerson.userId];
    if (allDelMsg.count > 0) {
        TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
        msg.type = [NSNumber numberWithInt:kWCMessageTypeDelMsgScreenshots];
        msg.timeSend = [NSDate date];
        msg.toUserId = self.chatPerson.userId;
        msg.fromUserId = MY_USER_ID;
        msg.content = Localized(@"JX_TheOtherTookAScreenshotOfTheConversation");
        [msg insert:nil];
        [g_xmpp sendMessage:msg roomName:nil];
    }
}

-(void)onLoginChanged:(NSNotification *)notifacation{
    
    switch ([TFJunYou_XMPP sharedInstance].isLogined){
        case login_status_ing:{
        }
            break;
        case login_status_no:{
        }
            break;
        case login_status_yes:{
            if (self.roomJid.length > 0 && [self.groupStatus integerValue] == 0) {
                [g_xmpp.roomPool.pool removeObjectForKey:chatPerson.userId];
                [g_xmpp.roomPool joinRoom:chatPerson.userId title:chatPerson.userNickname lastDate:nil isNew:NO];
                chatRoom = [[TFJunYou_XMPP sharedInstance].roomPool joinRoom:chatPerson.userId title:chatPerson.userNickname lastDate:nil isNew:NO];
            }
        }
            
            break;
    }
}

- (void)actionTitle:(TFJunYou_Label *)sender {
    if (self.isRecording) {
        [self chatCell:nil stopRecordIndexNum:(int)_array.count - 1];
    }
}

// 阅后即焚通知
- (void)openReadDelNotif:(NSNotification *)notif {
    
    BOOL isOpen = [notif.object boolValue];
    _isReadDelete = isOpen;
}

#pragma mark----阅后即焚开关
- (void)switchValueChange:(UIButton *)but{
    
    if (but.tag == 2000) {
        but.tag = 1000;
        but.selected = !but.selected;
        _isReadDelete = !_isReadDelete;
        if (_isReadDelete) {
            but.backgroundColor = [UIColor lightGrayColor];
            [g_App showAlert:Localized(@"JX_ReadDeleteTip")];
        }else{
            but.backgroundColor = [UIColor clearColor];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            but.tag = 2000;
        });
    }
}

// 重新加载
- (void)refreshChatLogNotif:(NSNotification *)notif {
    self.isGetServerMsg = NO;
    [_array removeAllObjects];
    [self refresh:nil];
    [self.tableView reloadData];
}

- (void)reloadNotif:(NSNotification *)notif {
    self.isGetServerMsg = NO;
    [_array removeAllObjects];
    [self.tableView reloadData];
}

-(void)cardCellClick:(NSNotification *) notification{
    if (recording) {
        return;
    }
    TFJunYou_MessageObject *msg = notification.object;
    NSString * objectId = msg.objectId;
    self.firstGetUser = YES;
//    [g_server getUser:objectId toView:self];
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId       = objectId;
    vc.isJustShow = self.courseId.length > 0;
    vc.fromAddType = 2;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}

-(void)locationCellClick:(NSNotification *)notification{
    if (recording) {
        return;
    }
    TFJunYou_MessageObject *msg = notification.object;
    double location_x = [msg.location_x doubleValue];
    double location_y = [msg.location_y doubleValue];
    
    TFJunYou_MapData * mapData = [[TFJunYou_MapData alloc] init];
    mapData.latitude = [NSString stringWithFormat:@"%f",location_x];
    mapData.longitude = [NSString stringWithFormat:@"%f",location_y];
    NSArray * locations = @[mapData];
    mapData.title = msg.objectId;
    if (g_config.isChina) {
        TFJunYou_LocationVC * vc = [TFJunYou_LocationVC alloc];
        vc.placeNames = msg.objectId;
        vc.locations = [NSMutableArray arrayWithArray:locations];
        vc.locationType = TFJunYou_LocationTypeShowStaticLocation;
        vc = [vc init];
        [g_navigation pushViewController:vc animated:YES];
    }else {
        _gooMap = [TFJunYou_GoogleMapVC alloc] ;
        _gooMap.locations = [NSMutableArray arrayWithArray:locations];
        _gooMap.locationType = TFJunYou_GooLocationTypeShowStaticLocation;
        _gooMap.placeNames = msg.objectId;
        _gooMap = [_gooMap init];
        [g_navigation pushViewController:_gooMap animated:YES];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (UIGestureRecognizer *gesture in self.view.window.gestureRecognizers) {
        NSLog(@"gesture = %@",gesture);
        gesture.delaysTouchesBegan = NO;
        NSLog(@"delaysTouchesBegan = %@",gesture.delaysTouchesBegan?@"YES":@"NO");
        NSLog(@"delaysTouchesEnded = %@",gesture.delaysTouchesEnded?@"YES":@"NO");
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self->_lastMsg.fromUserId isEqualToString:@"10005"]||[self->chatPerson.userId isEqualToString:@"10005"]) {
            [g_server get_act_apiAutoAnswergetIssue:@"" toView:self];
        }
    });
}

- (void)getEmojsData {
    [g_server faceClollectListType:@"0" View:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self getEmojsData];
    [g_notify addObserver:self selector:@selector(getEmojsData) name:kEmojiRefresh object:nil];
    
    self.view.backgroundColor = HEXCOLOR(0xF9F9F9);
    self.friendStatus = [self.chatPerson.status intValue];
    [self customView];
    if (self.chatRoom.roomJid.length > 0) {
        [self setupNotice];
    }
    if (self.courseId.length > 0) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(71, THE_DEVICE_HAVE_HEAD ? 13 : 10, TFJunYou__SCREEN_WIDTH-71*2, 36)];
        btn.backgroundColor = THEMECOLOR;
        [btn setTitle:Localized(@"JXUserInfoVC_SendMseeage") forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = g_factory.font16;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btn.frame.size.height/2;
        [btn addTarget:self action:@selector(sendCourseAction) forControlEvents:UIControlEventTouchUpInside];
        [self.tableFooter addSubview:btn];
        
    }else {

        [self createFooterSubViews];
    }
    
    self.screenShotView.frame = CGRectMake(self.screenShotView.frame.origin.x, self.tableFooter.frame.origin.y - self.screenShotView.frame.size.height - 10, self.screenShotView.frame.size.width, self.screenShotView.frame.size.height);
    
    
    if (!self.roomJid) {
        // 如果是自己的其他端，不调用接口
        if (chatPerson && [chatPerson.userId rangeOfString:MY_USER_ID].location != NSNotFound) {
            self.friendStatus = 10;
            for (TFJunYou_Device *device in g_multipleLogin.deviceArr) {
                if ([device.userId isEqualToString:chatPerson.userId]) {
//                    NSString *str = [device.isOnLine intValue] == 1 ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
                    self.onlinestate = [device.isOnLine boolValue];
//                    self.title = [NSString stringWithFormat:@"%@(%@)",chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname,str];
                    [self setChatTitle:chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname];
                    break;
                }
            }
            
//            if ([chatPerson.userId rangeOfString:@"android"].location != NSNotFound) {
//
//                NSString *str = [g_multipleLogin.androidUser.isOnLine intValue] == 1 ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
//                self.title = [NSString stringWithFormat:@"%@(%@)",chatPerson.userNickname,str];
//            }
//            if ([chatPerson.userId rangeOfString:@"pc"].location != NSNotFound) {
//                NSString *str = [g_multipleLogin.pcUser.isOnLine intValue] == 1 ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
//                self.title = [NSString stringWithFormat:@"%@(%@)",chatPerson.userNickname,str];
//            }
//            if ([chatPerson.userId rangeOfString:@"mac"].location != NSNotFound) {
//                NSString *str = [g_multipleLogin.macUser.isOnLine intValue] == 1 ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
//                self.title = [NSString stringWithFormat:@"%@(%@)",chatPerson.userNickname,str];
//            }
            
        }else {
            if (self.isGroupMessages) {
                self.title = Localized(@"JX_GroupHair");
                [self setAudioIconFrame];
            }else {
                [g_server getUser:chatPerson.userId toView:self];
            }
        }
    } else {
        [g_server roomGetRoom:self.roomId toView:self];
        
#if IS_AUTO_JOIN_ROOM
        // 进群组 如果没有连接，先连接一次
        if (![g_xmpp.roomPool getRoom:self.chatPerson.userId] && [self.chatPerson.groupStatus intValue] == 0) {
            [g_xmpp.roomPool joinRoom:chatPerson.userId title:chatPerson.userNickname lastDate:nil isNew:NO];
            chatRoom = [[TFJunYou_XMPP sharedInstance].roomPool joinRoom:chatPerson.userId title:chatPerson.userNickname lastDate:nil isNew:NO];
        }
#endif
    }
    
    [self refresh:nil];
    
    if (!self.roomJid || self.roomJid.length <= 0) {
        // 同步消息
        [self messageSync];
    }
    
    if (chatPerson.lastInput.length > 0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            _messageText.inputView = nil;
            [_messageText reloadInputViews];
            [self doBeginEdit];
            [_messageText becomeFirstResponder];
            [_faceView removeFromSuperview];
        });
    }
}

- (void)chatVCMessageSync:(NSNotification *)noti {
    long long timeSend = [noti.object longLongValue];
    self.chatPerson.timeSend = [NSDate dateWithTimeIntervalSince1970:timeSend];
    [self messageSync];
}

- (void)messageSync {
    
    double syncTimeLen = 0;
    NSString* s;
    if([self.roomJid length]>0){
        s = self.roomJid;
        //            syncTimeLen = [g_myself.groupChatSyncTimeLen doubleValue];
//        syncTimeLen = 0;
         syncTimeLen = [g_myself.chatSyncTimeLen doubleValue];
    }
    else{
        s = chatPerson.userId;
        syncTimeLen = [g_myself.chatSyncTimeLen doubleValue];
    }
    
    // 同步消息
    if ([self.chatPerson.downloadTime timeIntervalSince1970] < [self.chatPerson.timeSend timeIntervalSince1970] && _taskList.count<=0 && syncTimeLen != -2) {
        long long chatSyncTimeLen = 0;
           switch ([g_myself.chatSyncTimeLen integerValue]) {
                case 0: // 0.04 1小时
                   chatSyncTimeLen = 3600000;
                   break;
                case 1: //  1天
                   chatSyncTimeLen = 86400000;
                   break;
                case 7: //  7天
                   chatSyncTimeLen = 604800017;
                   break;
                case 30: // 30天
                   chatSyncTimeLen = 2629800000;
                   break;
                case 90: // 90天
                   chatSyncTimeLen = 7889400000;
                   break;
                case 365: //365天
                   chatSyncTimeLen = 31557600000;
                   break;
                case -1: // 永久(20年)
                   chatSyncTimeLen = 631152000000;
                   break;
               default:
                   break;
           }
        long endTime = [[NSDate date] timeIntervalSince1970] * 1000;
        long starTime = endTime - chatSyncTimeLen;
        
        self.isSyncMsg = YES;
        
        if([self.roomJid length]>0){
            // 获取进群时间
            NSString* myUserId = MY_USER_ID;
            double createTime = 0;
            NSArray *array = [memberData getSelfMember:self.roomId];
            for (memberData *mdata in array) {
                NSString *userId = [NSString stringWithFormat:@"%ld", mdata.userId];
                if([userId isEqualToString:myUserId]){
                    createTime = mdata.createTime * 1000;
                }
            }
            // 群组删除聊天记录时间
             NSInteger time1 = 0;
            if ([g_default valueForKey:s] && ([self.roomJid length]>0)) {
               time1 = [[g_default valueForKey:s] integerValue];
            }
             NSNumber *lastClearRecordTime = [NSNumber numberWithInteger:time1];
            // 设置删除所有聊天记录时间
             NSInteger time2 = 0;
            if ([g_default valueForKey:@"CLEARALLMSGRECORDTIME"] && ([self.roomJid length]>0)) {
                time2 = [[g_default valueForKey:@"CLEARALLMSGRECORDTIME"] integerValue];
            }
            NSNumber *CLEARALLMSGRECORDTIME = [NSNumber numberWithInteger:time2];
            // 设置漫游的时间
            NSNumber *synTime = [NSNumber numberWithLong:starTime];
            
            
            // 入群时间
            NSInteger time3 = 0;
            if(createTime > 0){
                time3 = [[NSString stringWithFormat:@"%f", createTime] integerValue];
            }
             NSNumber *joinTime = [NSNumber numberWithInteger:time3];
            // 排序四个时间 入群时间,群组删除聊天记录时间,设置删除所有聊天记录时间,设置漫游的时间
            NSArray *sortedArray = [@[joinTime,lastClearRecordTime,synTime,CLEARALLMSGRECORDTIME] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSComparisonResult result = [obj1 compare: obj2];
                return result;
            }];
            NSNumber *time = [sortedArray lastObject];
            starTime =  [time longValue];
            //                 p = [[TFJunYou_MessageObject sharedInstance] fetchMessageListWithUser:s byAllNum:_array.count pageCount:pageCount startTime:[NSDate dateWithTimeIntervalSince1970:createTime]];
            [g_server tigaseMucMsgsWithRoomId:s StartTime:starTime EndTime:endTime PageIndex:0 PageSize:PAGECOUNT toView:self];
        }else
            [g_server tigaseMsgsWithReceiver:s StartTime:starTime EndTime:endTime  PageIndex:0 toView:self];
        
        self.chatPerson.downloadTime = self.chatPerson.timeSend;
        [self.chatPerson update];
    }
    
    else {

        [self refresh:nil];
    }
}

- (void) customView {
    [self createHeadAndFoot];
    self.tableFooter.clipsToBounds = YES;
    // 设置聊天背景图片
    self.backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT - TFJunYou__SCREEN_BOTTOM)];
    self.backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.backGroundImageView belowSubview:_table];

    NSData *imageData = [g_constant.userBackGroundImage objectForKey:self.chatPerson.userId];
    UIImage *backGroundImage = [UIImage imageWithContentsOfFile:kChatBackgroundImagePath];
    if (imageData) {
        _table.backgroundColor = [UIColor clearColor];
        self.backGroundImageView.image = [UIImage imageWithData:imageData];
    }else if (backGroundImage) {
        _table.backgroundColor = [UIColor clearColor];
        self.backGroundImageView.image = backGroundImage;

    }else {
        _table.backgroundColor = HEXCOLOR(0xF2F2F2);
    }
//    _table.allowsSelection = NO;
    self.isShowFooterPull = NO;
    self.isShowHeaderPull = YES;
//    self.tableFooter.backgroundColor = HEXCOLOR(0xD0D0D0);
    
    CGFloat width = 120;
    if ([g_constant.sysLanguage isEqualToString:@"zh"]) {
        width = 80;
    }
    //        if (!self.ished) {
    
//    NSString *str = [NSString stringWithFormat:@"%@(%@)",chatPerson.userNickname,Localized(@"JX_OffLine")];
//    CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.headerTitle.font} context:nil].size;
//    CGFloat n = TFJunYou__SCREEN_WIDTH / 2 + size.width / 2;
//    CGFloat x = ((TFJunYou__SCREEN_WIDTH - n - (TFJunYou__SCREEN_WIDTH - btn.frame.origin.x)) / 2) - (width / 2) + n;
    
//    UIButton *readDelBut = [UIFactory createButtonWithImage:@"im_destroy"
//                           highlight:nil
//                              target:self
//                            selector:@selector(switchValueChange:)];
//    readDelBut.custom_acceptEventInterval = .25f;
//    readDelBut.tag = 2000;
//    readDelBut.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 42 - 32, TFJunYou__SCREEN_TOP - 33, 22, 22);
//    readDelBut.layer.cornerRadius = readDelBut.frame.size.width / 2;
//    readDelBut.layer.masksToBounds = YES;
//    readDelBut.layer.borderWidth = 1;
//    readDelBut.layer.borderColor = [UIColor whiteColor].CGColor;
//    [self.tableHeader addSubview:readDelBut];

    NSLog(@"timetime203 -- %f", [[NSDate date] timeIntervalSince1970]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        memberData *data = [self.room getMember:g_myself.userId];

        _moreView =[TFJunYou_SelectImageView alloc];
        _moreView.isDevice = [self.chatPerson.userId rangeOfString:MY_USER_ID].location != NSNotFound;
        _moreView.delegate = self;
        _moreView.isGroupMessages = self.isGroupMessages;
        _moreView.isGroup = _roomJid.length > 0;
        _moreView.isWin = [data.role intValue] == 1;
        _moreView.onImage  = @selector(pickPhoto);
        
        if (self.roomJid) {//如果是群聊
            _moreView.onGift = @selector(sendGiftToRoom);
        }else{
            _moreView.onGift = @selector(sendGift);
            _moreView.onTransfer = @selector(onTransfer);
        }
        
        _moreView.onAudioChat  = @selector(onChatSip);
        _moreView.onVideo  = @selector(pickVideo);
        _moreView.onCard  = @selector(onCard);
        _moreView.onFile  = @selector(onFile);
        _moreView.onLocation  = @selector(onLocation);
        _moreView.onCamera = @selector(onCamera);
        _moreView.onShake = @selector(onShake);
        _moreView.onCollection = @selector(onCollection);
        _moreView.onAddressBook = @selector(onAddressBook);
        _moreView.onGroupHelper = @selector(onGroupHelper);
        
        _moreView = [_moreView initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, faceHeight)];
        
        _voice = [[TFJunYou_VolumeView alloc]initWithFrame:CGRectMake(0, 0, 160, 150)];
        _voice.center = self.view.center;
    });
    [self initAudio];
    
    UIButton* btn;
    UIButton *btn1;
    if(self.roomJid){
        btn1 = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-18-BTN_RANG_UP*2, TFJunYou__SCREEN_TOP -18-BTN_RANG_UP*2, 18+BTN_RANG_UP*2, 18+BTN_RANG_UP*2)];
        [btn1 addTarget:self action:@selector(onMember) forControlEvents:UIControlEventTouchUpInside];
        [self.tableHeader addSubview:btn1];

        btn = [UIFactory createButtonWithImage:@"chat_more_black" highlight:nil target:self selector:@selector(onMember)];
        btn.custom_acceptEventInterval = 1.0f;
        btn.frame = CGRectMake(BTN_RANG_UP, BTN_RANG_UP, 18, 18);
        [btn1 addSubview:btn];
        
        [g_server getRoomMember:roomId userId:[g_myself.userId intValue] toView:self];
        
        //获取群成员：
        NSArray * memberArray = [memberData fetchAllMembers:_room.roomId];
        
        memberData *me = [self.room getMember:g_myself.userId];
        if ([me.role intValue] == 1 || [me.role intValue] == 2) {
            self.title = [NSString stringWithFormat:@"%@(%ld)", self.chatPerson.userNickname, memberArray.count];
        } else {
            self.title = self.chatPerson.userNickname;
        }
        
        [self setAudioIconFrame];
        if (memberArray.count > 0) {//本地有
            _room.roomId = roomId;
            _room.members = [memberArray mutableCopy];
            
            memberData *data = [self.room getMember:g_myself.userId];
            if ([data.role intValue] == 1 || [data.role intValue] == 2) {
                _isAdmin = YES;
            }else {
                _isAdmin = NO;
            }
        }else{
            
            self.isFirst = YES;
            [g_server getRoom:self.room.roomId toView:self];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [g_server listRoomMember:roomId page:0 toView:self];
//            });
        }
    }else {
        btn1 = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-18-BTN_RANG_UP*2, TFJunYou__SCREEN_TOP -18-BTN_RANG_UP*2, 18+BTN_RANG_UP*2, 18+BTN_RANG_UP*2)];
        [btn1 addTarget:self action:@selector(createRoom) forControlEvents:UIControlEventTouchUpInside];
        [self.tableHeader addSubview:btn1];
        
        btn = [UIFactory createButtonWithImage:@"chat_more_black"
                                     highlight:nil
                                        target:self
                                      selector:@selector(createRoom)];
        btn.custom_acceptEventInterval = 1.0f;
        btn.frame = CGRectMake(BTN_RANG_UP, BTN_RANG_UP, 18, 18);
        [btn1 addSubview:btn];

    }
    
    _audioIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP - 30, 16, 16)];
    _audioIcon.image = [UIImage imageNamed:@"audioIcon"];
    [self.tableHeader addSubview:_audioIcon];
    [self setAudioIconFrame];
    
    if (self.courseId.length > 0 || [chatPerson.userId rangeOfString:MY_USER_ID].location != NSNotFound || self.isGroupMessages || self.isHiddenFooter) {
//        readDelBut.hidden = YES;
        btn.hidden = YES;
        btn1.hidden = YES;
    }
    
    if (self.isGroupMessages) {
        self.isShowHeaderPull = NO;
        UIView *friendNamesView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y, TFJunYou__SCREEN_WIDTH, 0)];
        friendNamesView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:friendNamesView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 300, 20)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor lightGrayColor];
        label.text = [NSString stringWithFormat:Localized(@"JX_YouWillSendMessagesToFriends"),_userIds.count];
        [friendNamesView addSubview:label];
        
        NSMutableString *names = [NSMutableString string];
        for (NSInteger i = 0; i < _userNames.count; i ++) {
            NSString *str = _userNames[i];
            if (i == 0) {
                [names appendString:[NSString stringWithFormat:@"[\"%@",str]];
            }
            else if (i == _userNames.count - 1) {
                [names appendString:[NSString stringWithFormat:@",%@\"]", str]];
            }
            else {
                [names appendString:[NSString stringWithFormat:@",%@", str]];
            }
            if (_userNames.count == 1) {
                [names appendString:@"\"]"];
            }
        }
        
        CGSize size = [names boundingRectWithSize:CGSizeMake(friendNamesView.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil].size;
        
        CGFloat height = 0;
        if (size.height > 200) {
            height = 200;
        }else {
            height = size.height;
        }
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(15, CGRectGetMaxY(label.frame) + 10, friendNamesView.frame.size.width - 30, height)];
        [friendNamesView addSubview:scrollView];
        
        UILabel *namesLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, friendNamesView.frame.size.width - 30, size.height)];
        namesLabel.font = [UIFont systemFontOfSize:17.0];
        namesLabel.textColor = [UIColor blackColor];
        namesLabel.numberOfLines = 0;
        namesLabel.text = names;
        [scrollView addSubview:namesLabel];
        scrollView.contentSize = CGSizeMake(namesLabel.frame.size.width, size.height);
        
        friendNamesView.frame = CGRectMake(friendNamesView.frame.origin.x, friendNamesView.frame.origin.y, friendNamesView.frame.size.width, scrollView.frame.origin.y + scrollView.frame.size.height + 15);
        NSLog(@"%@", friendNamesView);
    }
    
    // 截屏
    self.screenShotView = [[UIView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH - 80 - 10, 100, 80, 130)];
    self.screenShotView.backgroundColor = [UIColor whiteColor];
    self.screenShotView.layer.cornerRadius = 5.0;
    self.screenShotView.layer.masksToBounds = YES;
    self.screenShotView.hidden = YES;
    [self.view addSubview:self.screenShotView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenShotViewAction:)];
    [self.screenShotView addGestureRecognizer:tap];
    
    UILabel *screenShotLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.screenShotView.frame.size.width - 10, 40)];
    screenShotLabel.font = [UIFont systemFontOfSize:11.0];
    screenShotLabel.numberOfLines = 0;
    screenShotLabel.text = Localized(@"JX_ThePhotosYouMightWantToSend");
    [self.screenShotView addSubview:screenShotLabel];
    
    self.screenShotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(screenShotLabel.frame), self.screenShotView.frame.size.width - 10, self.screenShotView.frame.size.height - screenShotLabel.frame.size.height - 5)];
    self.screenShotImageView.layer.cornerRadius = 5.0;
    self.screenShotImageView.layer.masksToBounds = YES;
//    self.screenShotImageView.image = [UIImage imageWithContentsOfFile:ScreenShotImage];
    [self.screenShotView addSubview:self.screenShotImageView];
    
    // 新消息跳转
    _jumpNewMsgBtn = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH - 105, TFJunYou__SCREEN_TOP + 20, 120, 30)];
    _jumpNewMsgBtn.backgroundColor = [UIColor whiteColor];
    _jumpNewMsgBtn.layer.cornerRadius = _jumpNewMsgBtn.frame.size.height / 2;
    _jumpNewMsgBtn.layer.masksToBounds = YES;
    [_jumpNewMsgBtn addTarget:self action:@selector(jumpNewMsgBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jumpNewMsgBtn];

    UILabel *newMsgLabel = [[UILabel alloc] initWithFrame:_jumpNewMsgBtn.bounds];
    newMsgLabel.text = [NSString stringWithFormat:@"%d%@", self.newMsgCount,Localized(@"JX_NewMessages")];
    newMsgLabel.font = [UIFont systemFontOfSize:13.0];
    newMsgLabel.textAlignment = NSTextAlignmentCenter;
    newMsgLabel.textColor = HEXCOLOR(0x4FC557);
    [_jumpNewMsgBtn addSubview:newMsgLabel];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    imageView.image = [UIImage imageNamed:@"doubleArrow_up"];
    [_jumpNewMsgBtn addSubview:imageView];

    if (self.newMsgCount > 20) {
        _jumpNewMsgBtn.hidden = NO;
    }else {
        _jumpNewMsgBtn.hidden = YES;
    }
    
}

- (void)setAudioIconFrame {
    
    CGSize size = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]} context:nil].size;
    CGFloat x = TFJunYou__SCREEN_WIDTH/2 + size.width/2 + 2;
    _audioIcon.frame = CGRectMake(x, _audioIcon.frame.origin.y, _audioIcon.frame.size.width, _audioIcon.frame.size.height);
    
    BOOL flag = [g_default boolForKey:kChatVCMessageAudioIsNotPlayback];
    _audioIcon.hidden = !flag;
}

- (void)setupMoreView:(NSArray *)array {
    if (array != nil) {
        [_recordBtnLeft setBackgroundImage:[UIImage imageNamed:@"chat_back_reply"] forState:UIControlStateNormal];
        [_recordBtnLeft removeTarget:self action:@selector(recordSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtnLeft addTarget:self action:@selector(onBackToDefault) forControlEvents:UIControlEventTouchUpInside];

        _helperArr = array;
        // 群助手事件
        _moreView.onGroupHelperList = @selector(onGroupHelperList);
        _moreView.onDidView = @selector(onDidView:);
        _moreView.helpers = array;
        _moreView.scrollView.hidden = YES;
        _moreView.helperScrollV.hidden = NO;
    }else {
        
        [_recordBtnLeft setBackgroundImage:[UIImage imageNamed:@"im_input_ptt_normal"] forState:UIControlStateNormal];
        [_recordBtnLeft setBackgroundImage:[UIImage imageNamed:@"im_input_keyboard_normal"] forState:UIControlStateSelected];
        [_recordBtnLeft removeTarget:self action:@selector(onBackToDefault) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtnLeft addTarget:self action:@selector(recordSwitch:) forControlEvents:UIControlEventTouchUpInside];

        _moreView.scrollView.hidden = NO;
        _moreView.helperScrollV.hidden = YES;
        [_moreView resetPageControl];
    }
}

- (void)onBackToDefault {
    [self setupMoreView:nil];
}

- (void)onDidView:(TFJunYou_SelectImageView *)moreView {
    TFJunYou_GroupHeplerModel *model = _helperArr[moreView.viewIndex];

    if (moreView.isDidSet) {
        TFJunYou_AutoReplyAideVC *vc = [[TFJunYou_AutoReplyAideVC alloc] init];
        vc.model = model.helperModel;
        vc.roomId = self.roomId;
        vc.roomJid = self.roomJid;
        
        [g_navigation pushViewController:vc animated:YES];

    }else {
        
        if (model.helperModel.urlScheme && model.helperModel.urlScheme.length > 0) {
            NSString *url = [NSString stringWithFormat:@"%@://roomId=%@&userId=%@",model.helperModel.urlScheme,self.roomId,g_myself.userId];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:^(BOOL success) {
                
                if (!success) {
                    [self didViewActionWithModel:model];
                }
            }];

        }else {
            [self didViewActionWithModel:model];
        }
        
        
    }

}

- (void)didViewActionWithModel:(TFJunYou_GroupHeplerModel *)model {
    if (model.helperModel.type == 1) { //自动回复
    }
    else if (model.helperModel.type == 2) {// 网页
        
        NSDictionary *dict = @{
                               @"roomId" : self.roomId,
                               @"roomJid" : self.roomJid,
                               @"userId" : g_myself.userId
                               };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json =  [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        webpageVC *webVC = [webpageVC alloc];
        webVC.isGotoBack= YES;
        webVC.isSend = YES;
        webVC.shareParam = json;
        webVC.title = model.helperModel.name;
        NSString * url = [NSString stringWithFormat:@"%@",model.helperModel.link];
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        url = [url stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        webVC.url = url;
        webVC = [webVC init];
        [g_navigation.navigationView addSubview:webVC.view];
        
    }
    else if (model.helperModel.type == 3) {// 点击发送
        NSMutableDictionary *dict = @{@"url":model.helperModel.url,
                                      @"appName":model.helperModel.appName,
                                      @"subTitle":model.helperModel.subTitle,
                                      }.mutableCopy;
        if (model.helperModel.imageUrl.length > 0) {
            [dict addEntriesFromDictionary:@{@"imageUrl":model.helperModel.imageUrl}];
        }
        if (model.helperModel.appIcon.length > 0) {
            [dict addEntriesFromDictionary:@{@"appIcon":model.helperModel.appIcon}];
        }
        if (model.helperModel.downloadUrl.length > 0) {
            [dict addEntriesFromDictionary:@{@"downloadUrl":model.helperModel.downloadUrl}];
        }
        if (model.helperModel.title.length > 0) {
            [dict addEntriesFromDictionary:@{@"title":model.helperModel.title}];
        }
        
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        NSString *content = [writer stringWithObject:dict];
        
        //            TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
        //            msg.timeSend = [NSDate date];
        //            msg.fromUserId = g_myself.userId;
        //            msg.toUserId = model.roomJid;
        //            msg.objectId = content;
        //            msg.type = [NSNumber numberWithInt:kWCMessageTypeShare];
        //            [msg insert:model.roomJid];
        //            [self showOneMsg:msg];
        //            [g_xmpp sendMessage:msg roomName:model.roomId];
        
        
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        msg.toUserId = self.roomJid;
        msg.isGroup = YES;
        msg.fromUserName = _userNickName;
        
        msg.objectId = content;
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeShare];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isReadDel    = [NSNumber numberWithInt:NO];
        
        //发往哪里
        [msg insert:self.roomJid];
        [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
        [self showOneMsg:msg];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进入界面即开启定时器
    [self.noticeTimer setFireDate:[NSDate distantPast]];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //退出界面即关闭定时器
    [self.noticeTimer setFireDate:[NSDate distantFuture]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)setupNotice {
    _noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP, TFJunYou__SCREEN_WIDTH, 36)];
    _noticeView.backgroundColor = [UIColor whiteColor];
    _noticeView.hidden = YES;
    [self.view addSubview:_noticeView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNoticeView:)];
    [_noticeView addGestureRecognizer:tap];

    _noticeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 16, 16)];
    _noticeImgV.image = [UIImage imageNamed:@"chat_notice"];
    [_noticeView addSubview:_noticeImgV];
    
    _noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_noticeImgV.frame)+4, 0, 64, 36)];
    _noticeLabel.text = Localized(@"JX_LatestAnnouncement:");
    _noticeLabel.textColor = HEXCOLOR(0x323232);
    _noticeLabel.font = SYSFONT(13);
    [_noticeView addSubview:_noticeLabel];
    
    _showNoticeView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_noticeLabel.frame)+5, 0, TFJunYou__SCREEN_WIDTH-125, 36)];
    _showNoticeView.backgroundColor = [UIColor whiteColor];
    _showNoticeView.clipsToBounds = YES;
    [_noticeView addSubview:_showNoticeView];
    
    _leftLabel = [[UILabel alloc] initWithFrame:_showNoticeView.bounds];
    _leftLabel.textColor = HEXCOLOR(0x323232);
    _leftLabel.textAlignment = NSTextAlignmentLeft;
    _leftLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _leftLabel.font = SYSFONT(13);
    [_showNoticeView addSubview:_leftLabel];

    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftLabel.frame), 0, TFJunYou__SCREEN_WIDTH-130, 36)];
    _rightLabel.textColor = HEXCOLOR(0x323232);
    _rightLabel.font = SYSFONT(13);
    _rightLabel.textAlignment = NSTextAlignmentLeft;
    _rightLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_showNoticeView addSubview:_rightLabel];
    
}

- (void)hideNoticeView:(UITapGestureRecognizer *)tap {
    _noticeView.hidden = YES;
    _noticeHeight = 0;
    _table.frame = CGRectMake(0, TFJunYou__SCREEN_TOP, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT-TFJunYou__SCREEN_TOP-TFJunYou__SCREEN_BOTTOM);
    _jumpNewMsgBtn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 105, TFJunYou__SCREEN_TOP + 20+_noticeHeight, 120, 30);
}

- (void)startNoticeTimer {
    _leftW = 0;
    _rightW = _noticeStrW+NOTICE_WIDTH;
    _noticeTimer = [NSTimer scheduledTimerWithTimeInterval:0.04f target:self selector:@selector(updateNoticeTimer:) userInfo:nil repeats:YES];

    [self.noticeTimer setFireDate:[NSDate distantPast]];
}

- (void)stopNoticeTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)updateNoticeTimer:(NSTimer *)timer {
    self.leftW --;
    self.rightW --;
    self.leftLabel.frame = CGRectMake(self.leftW, 0, _noticeStrW+NOTICE_WIDTH, 36);
    self.rightLabel.frame = CGRectMake(self.rightW, 0, _noticeStrW+NOTICE_WIDTH, 36);
    if (self.leftW <= -_noticeStrW-NOTICE_WIDTH) {
        self.leftW = _noticeStrW+NOTICE_WIDTH;
    }
    if (self.rightW <= -_noticeStrW-NOTICE_WIDTH) {
        self.rightW = _noticeStrW+NOTICE_WIDTH;
    }
}

- (void)setupNoticeWithContent:(NSString *)noticeStr time:(NSString *)noticeTime {
    CGSize size = [noticeStr sizeWithAttributes:@{NSFontAttributeName:SYSFONT(13)}];
    _leftLabel.frame = CGRectMake(0, 0, size.width, 36);
    _leftLabel.text = noticeStr;
    _rightLabel.frame = CGRectMake(CGRectGetMaxX(_leftLabel.frame), 0, size.width, 36);
    _rightLabel.text = noticeStr;
    _noticeStrW = size.width;
    if (_noticeStrW > _showNoticeView.frame.size.width) {
        _rightLabel.hidden = NO;
        [self startNoticeTimer];
    }else {
        _rightLabel.hidden = YES;
        [self stopNoticeTimer];
        [self.noticeTimer invalidate];
        self.noticeTimer = nil;
    }
    if (noticeStr.length > 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        // 公告时间超过一周即不再显示
        if (time >= 60*60*24*7+[noticeTime intValue]) {
            _noticeView.hidden = YES;
            _noticeHeight = 0;
        }else {
            _noticeView.hidden = NO;
            _noticeHeight = 36;
            _table.frame = CGRectMake(0, TFJunYou__SCREEN_TOP+_noticeHeight, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT-TFJunYou__SCREEN_TOP-TFJunYou__SCREEN_BOTTOM - _noticeHeight);
            [_table gotoLastRow:NO];
        }
    }else {
        _noticeView.hidden = YES;
        _noticeHeight = 0;
    }
    _jumpNewMsgBtn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 105, TFJunYou__SCREEN_TOP + 20+_noticeHeight, 120, 30);
}



// 跳转到新消息
- (void)jumpNewMsgBtnAction {
    NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    _jumpNewMsgBtn.hidden = YES;
}

- (void)screenShotViewAction:(UITapGestureRecognizer *)tap {
    
    if([self showDisableSay])
        return;
    
    if([self sendMsgCheck]){
        return;
    }
    KKImageEditorViewController *editor = [[KKImageEditorViewController alloc] initWithImage:self.screenImage delegate:self];
    
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:editor];
    [self presentViewController:vc animated:YES completion:nil];

}

#pragma mark- 照片编辑后的回调
- (void)imageDidFinishEdittingWithImage:(UIImage *)image asset:(PHAsset *)asset
{
    self.screenShotImageView.image = image;
    UIImage *chosedImage = self.screenShotImageView.image;
    //获取image的长宽
    int imageWidth = chosedImage.size.width;
    int imageHeight = chosedImage.size.height;
    
    self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    [self hideKeyboard:YES];
    
    
    NSString *name = @"jpg";
    if (self.isGroupMessages) {
//        for (NSInteger i = 0; i < self.userIds.count; i ++) {
//            NSString *userId = self.userIds[i];
//
//            NSString *file = [TFJunYou_TFJunYou_FileInfo getUUIDFileName:name];
//            [g_server saveImageToFile:chosedImage file:file isOriginal:NO];
//            [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:userId];
////            [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
//        }
        [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_image];
        self.groupUploadObjArray = [NSMutableArray arrayWithObject:chosedImage];
        _onceSendNum = 10;
        _isOriginal = NO;
        [self sendPhotos:self.groupUploadObjArray withOriginal:NO];
    }else {
        NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
        [g_server saveImageToFile:chosedImage file:file isOriginal:NO];
        [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:nil];
//        [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
    }
    //    NSString* file = [TFJunYou_FileInfo getUUIDFileName:name];
    //
    //    file = [TFJunYou_FileInfo getUUIDFileName:name];
    //    [g_server saveImageToFile:chosedImage file:file isOriginal:NO];
    ////    [self sendImage:file withWidth:imageWidth andHeight:imageHeight];
    //    [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut toView:self];
    
    self.screenShotView.hidden = YES;
    //    NSFileManager* fileManager=[NSFileManager defaultManager];
    //    BOOL blDele= [fileManager removeItemAtPath:ScreenShotImage error:nil];
    //    if (blDele) {
    //        NSLog(@"dele success");
    //    }else {
    //        NSLog(@"dele fail");
    //    }
}


- (void) createFooterSubViews{
    
    [inputBar removeFromSuperview];
    [_publicMenuBar removeFromSuperview];
    [_selectMoreView removeFromSuperview];
    
    //输入条
    inputBar = [[UIImageView alloc] initWithImage:nil];
    inputBar.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 49);
    inputBar.backgroundColor = HEXCOLOR(0xF9F9F9);
    inputBar.userInteractionEnabled = YES;
    inputBar.clipsToBounds = YES;
    [self.tableFooter addSubview:inputBar];
    //        [inputBar release];
    
//    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,0.5)];
//    line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//    [inputBar addSubview:line];
    //        [line release];
    
    //＋
    self.shareMore = [UIFactory createButtonWithImage:@"im_show_one_icon" highlight:nil target:self selector:@selector(shareMore:)];
    [self.shareMore setImage:[UIImage imageNamed:@"im_input_more_normal"] forState:UIControlStateSelected];
    self.shareMore.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 25-15, 15, 25, 25);
    [inputBar addSubview:self.shareMore];
    CGFloat firstX;
    if (_menuList.count > 0) {
        self.view.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIFactory createButtonWithImage:@"lashang" selected:@"lashang" target:self selector:@selector(inputBarSwitch:)];
        btn.frame = CGRectMake(10, 8+2, 32, 32);
        btn.selected = NO;
        [inputBar addSubview:btn];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(47, 0, LINE_WH, self.heightFooter)];
        v.backgroundColor = THE_LINE_COLOR;
        [inputBar addSubview:v];
        
        firstX = 52;
        
        inputBar.frame = CGRectMake(inputBar.frame.origin.x, inputBar.frame.size.height, inputBar.frame.size.width, inputBar.frame.size.height);
        
    }else {
        firstX = 10;
        inputBar.frame = CGRectMake(inputBar.frame.origin.x, 0, inputBar.frame.size.width, inputBar.frame.size.height);
    }
    
    UIButton *btn = [UIFactory createButtonWithImage:@"im_input_ptt_normal" selected:@"im_input_keyboard_normal" target:self selector:@selector(recordSwitch:)];
    btn.frame = CGRectMake(firstX, 15, 25, 25);
    btn.selected = NO;
    [inputBar addSubview:btn];
    _recordBtnLeft = btn;
    
    //eomoj
    btn = [UIFactory createButtonWithImage:@"im_input_expression_normal" selected:@"im_input_keyboard_normal" target:self selector:@selector(actionFace:)];
    btn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH -15-25-18-25, 15, 25, 25);
    btn.selected = NO;
    [inputBar addSubview:btn];
    _btnFace = btn;
    
    _messageText = [[UITextView alloc] initWithFrame:CGRectMake(firstX + 35, 8, TFJunYou__SCREEN_WIDTH-firstX - 35 -15-25-18-25-20, 33)];
    _messageText.font = SYSFONT(18);
    _messageText.delegate = self;
    _messageText.layer.cornerRadius = 2.0;
    _messageText.layer.masksToBounds = YES;
    _messageText.enablesReturnKeyAutomatically = YES;
    _messageText.returnKeyType = UIReturnKeySend;
    if (![self changeEmjoyText:chatPerson.lastInput textColor:[UIColor blackColor]]) {
        _messageText.text = chatPerson.lastInput;
    }
    [inputBar addSubview:_messageText];
    [self setTableFooterFrame:_messageText];
    
    //设置菜单
    UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:Localized(@"JX_Newline") action:@selector(selfMenu:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:[NSArray arrayWithObject:menuItem]];
    
    _textViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, _messageText.frame.size.width, 12)];
    _textViewBtn.backgroundColor = [UIColor clearColor];
    [_textViewBtn addTarget:self action:@selector(textViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _textViewBtn.hidden = YES;
    [_messageText addSubview:_textViewBtn];
    
    _talkTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _messageText.frame.size.width, _messageText.frame.size.height)];
    _talkTimeLabel.font = [UIFont systemFontOfSize:15.0];
    _talkTimeLabel.text = Localized(@"JX_TotalSilence");
    _talkTimeLabel.textColor = [UIColor lightGrayColor];
    _talkTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_messageText addSubview:_talkTimeLabel];
    _talkTimeLabel.hidden = YES;
    
    memberData *roomD = [[memberData alloc] init];
    roomD.roomId = self.room.roomId;
    memberData *roomData = [roomD getCardNameById:MY_USER_ID];
    
    if (([self.chatPerson.talkTime longLongValue] > 0 && !_isAdmin) || [roomData.role intValue] == 4) {
        if ([roomData.role intValue] == 4) {
            _talkTimeLabel.text = Localized(@"JX_ProhibitToSpeak");
        }
        _messageText.userInteractionEnabled = NO;
        _shareMore.enabled = NO;
        _recordBtnLeft.enabled = NO;
        _btnFace.enabled = NO;
        _messageText.text = nil;
    }else {
        _talkTimeLabel.hidden = YES;
        _shareMore.enabled = YES;
        _recordBtnLeft.enabled = YES;
        _btnFace.enabled = YES;
        _messageText.userInteractionEnabled = YES;
    }
    
    //点击语音图片后出现的录制语音按钮
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(_messageText.frame.origin.x, 8, _messageText.frame.size.width, 32+5.5);
    btn.backgroundColor = HEXCOLOR(0xFEFEFE);
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [[UIColor grayColor] CGColor];
    [btn setTitle:Localized(@"JXChatVC_TouchTalk") forState:UIControlStateNormal];
    [btn setTitle:Localized(@"JXChatVC_ReleaseEnd") forState:UIControlEventTouchDown];
    //    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = g_factory.font15b;
    //        [btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        [btn setTitleShadowOffset:CGSizeMake(1, 1)];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [inputBar addSubview:btn];
    [btn addTarget:self action:@selector(recordStart:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(recordStop:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(recordCancel:) forControlEvents:UIControlEventTouchUpOutside];
    // 手指在control的bounds范围内拖动的的事件
    [btn addTarget:self action:@selector(showVoice:) forControlEvents:UIControlEventTouchDragInside];
    // 当手指拖动刚好在control的bounds 范围外的事件
    [btn addTarget:self action:@selector(showCancel:) forControlEvents:UIControlEventTouchDragOutside];

    btn.selected = NO;
    _recordBtn = btn;
    _recordBtn.hidden = YES;
    
    if (_menuList.count > 0) {
        // 公众号菜单
        _publicMenuBar = [[UIView alloc] init];
        _publicMenuBar.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, inputBar.frame.size.height);
        _publicMenuBar.backgroundColor = [UIColor whiteColor];
//        _publicMenuBar.layer.borderWidth = .5;
//        _publicMenuBar.layer.borderColor = [HEXCOLOR(0xdcdcdc) CGColor];
        [self.tableFooter addSubview:_publicMenuBar];
        [self createPublicMenu:_menuList];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createSelectMoreView];
    });
    
}

- (void)showVoice:(UIButton *)button {
    _voice.isWillCancel = NO;
}
- (void)showCancel:(UIButton *)button {
    _voice.isWillCancel = YES;
}

//隐藏系统菜单的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    //允许显示
    if (action == @selector(selfMenu:)) {
        return YES;
    }
    //其他不允许显示
    return NO;
}

- (void)selfMenu:(id)sender {
    _messageText.text = [NSString stringWithFormat:@"%@\r",_messageText.text];
    [self textViewDidChange:_messageText];
    
}

- (void)textViewBtnAction:(UIButton *)btn {
    
    _messageText.inputView = nil;
    [_messageText reloadInputViews];
}

- (void) createPublicMenu:(NSArray *) array {
    // 去除左边
//    UIButton *btn = [UIFactory createButtonWithImage:@"jiangp" selected:@"jiangp" target:self selector:@selector(publicMenuSwitch:)];
//    btn.frame = CGRectMake(10, 8, 32, 32);
//    btn.selected = NO;
    
//    [_publicMenuBar addSubview:btn];
//    CGFloat btnWidth = (TFJunYou__SCREEN_WIDTH - 52) / array.count;
    CGFloat btnWidth = (TFJunYou__SCREEN_WIDTH) / array.count;
    UIButton *btn;
    for (NSInteger i = 0; i < array.count; i ++) {
        NSDictionary *dict = array[i];
        NSString *name = dict[@"name"];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 0, btnWidth, _publicMenuBar.frame.size.height)];
        btn.tag = i;
        [btn addTarget:self action:@selector(publicMenuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            CGRect frame = btn.frame;
            frame.origin.x = 0;
            btn.frame = frame;
        }
        btn.titleLabel.font = SYSFONT(15.0);
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitle:name forState:UIControlStateNormal];
        [_publicMenuBar addSubview:btn];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, 0, LINE_WH, _publicMenuBar.frame.size.height)];
        v.backgroundColor = THE_LINE_COLOR;
        [_publicMenuBar addSubview:v];
        
        CGSize size = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYSFONT(15.0)} context:nil].size;
        CGFloat imageX = (btnWidth - size.width) / 2 - 20;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, (btn.frame.size.height - 16) / 2, 15, 15)];
        imageView.image = [UIImage imageNamed:@"public_menu"];
        [btn addSubview:imageView];
    }
}

- (void)createSelectMoreView {
    
    _selectMoreView = [[UIView alloc] initWithFrame:self.tableFooter.bounds];
    _selectMoreView.hidden = YES;
    _selectMoreView.backgroundColor = [UIColor whiteColor];
    [self.tableFooter addSubview:_selectMoreView];
    
    NSArray *imageNames = @[@"msf", @"msc", @"msd", @"mse"];
    CGFloat w = 40;
    CGFloat margin = (TFJunYou__SCREEN_WIDTH - imageNames.count * w) / (imageNames.count + 1);
    CGFloat x = margin;
    for (NSInteger i = 0; i < imageNames.count; i ++) {
        NSString *imageName = imageNames[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 5, w, w)];
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(selectMoreViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectMoreView addSubview:btn];
        
        x = CGRectGetMaxX(btn.frame) + margin;
    }
}

- (void)selectMoreViewBtnAction:(UIButton *)btn {
    
    for (NSInteger i = 0; i < self.selectMoreArr.count; i ++) {
        TFJunYou_MessageObject *msg1 = self.selectMoreArr[i];
        for (NSInteger j = i + 1; j < self.selectMoreArr.count; j ++) {
            TFJunYou_MessageObject *msg2 = self.selectMoreArr[j];
            if ([msg1.timeSend timeIntervalSince1970] > [msg2.timeSend timeIntervalSince1970]) {
                TFJunYou_MessageObject *msg = msg1;
                msg1 = msg2;
                self.selectMoreArr[i] = msg2;
                msg2 = msg;
                self.selectMoreArr[j] = msg;
            }
        }
    }
    
    if (self.selectMoreArr.count <= 0) {
        [g_App showAlert:Localized(@"JX_PleaseSelectTheMessageRecord")];
        return;
    }
    
    switch (btn.tag) {
        case 0:{    // 批量转发
            
            memberData *data = [self.room getMember:g_myself.userId];
            if ([data.role integerValue] == 4) {
                [TFJunYou_MyTools showTipView:@"隐身人不能转发消息"];
                return;
            }

            TFJunYou_ActionSheetVC *actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JX_OneByOneForward"),Localized(@"JX_MergeAndForward")]];
            actionVC.tag = 2457;
            actionVC.delegate = self;
            [self presentViewController:actionVC animated:NO completion:nil];
        }
            
            break;
        case 1:{    // 批量收藏
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"JX_CollectedType") delegate:self cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Collection"), nil];
            alert.tag = 2457;
            [alert show];
        }
            break;
        case 2:{    // 批量删除
            
            NSMutableString *msgIds = [NSMutableString string];
            for (NSInteger i = 0; i < self.selectMoreArr.count; i ++) {
                TFJunYou_MessageObject *msg = self.selectMoreArr[i];
                NSInteger indexNum = -1;
                for (NSInteger j = 0; j < _array.count; j ++) {
                    TFJunYou_MessageObject *msg1 = _array[j];
                    if ([msg1.messageId isEqualToString:msg.messageId]) {
                        if (msgIds.length <= 0) {
                            [msgIds appendString:msg1.messageId];
                        }else {
                            [msgIds appendFormat:@",%@",msg1.messageId];
                        }
                        indexNum = j;
                        break;
                    }
                }
                
                NSString* s;
                if([self.roomJid length]>0)
                    s = self.roomJid;
                else
                    s = chatPerson.userId;
                
                
                if (indexNum == _array.count - 1) {
                    if (indexNum <= 0) {
                        TFJunYou_MessageObject *lastMsg = [_array firstObject];
                        self.lastMsg.content = nil;
                        [lastMsg updateLastSend:UpdateLastSendType_None];
                    }else {
                        TFJunYou_MessageObject *newLastMsg = _array[indexNum - 1];
                        self.lastMsg.content = newLastMsg.content;
                        [newLastMsg updateLastSend:UpdateLastSendType_None];
                    }
                }
                
                //删除本地聊天记录
                [_array removeObjectAtIndex:indexNum];
                [msg delete];
                
                [_table deleteRow:(int)indexNum section:0];
                
            }
            
            if (msgIds.length > 0) {
                int type = 1;
                if (self.roomJid) {
                    type = 2;
                }
                self.withdrawIndex = -1;
                [g_server tigaseDeleteMsgWithMessageId:msgIds type:type deleteType:1 roomJid:self.roomJid toView:self];
            }
            
            if (self.isSelectMore) {
                [self actionQuit];
            }
            
        }
            
            break;
        case 3:{
            TFJunYou_ActionSheetVC *actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JX_SaveToTheAlbum")]];
            actionVC.tag = 2458;
            actionVC.delegate = self;
            [self presentViewController:actionVC animated:NO completion:nil];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)inputBarSwitch:(UIButton *)btn {
    self.view.backgroundColor = [UIColor whiteColor];
    self.heightFooter = 49;
    [self hideKeyboard:YES];
    _publicMenuBar.hidden = NO;
    inputBar.hidden = YES;
    [UIView animateWithDuration:.3 animations:^{
        _publicMenuBar.frame = CGRectMake(_publicMenuBar.frame.origin.x, 0, _publicMenuBar.frame.size.width, _publicMenuBar.frame.size.height);
        inputBar.frame = CGRectMake(inputBar.frame.origin.x, self.tableFooter.frame.size.height, inputBar.frame.size.width, inputBar.frame.size.height);
    }];
}

- (void)publicMenuSwitch:(UIButton *)btn {
    [self setTableFooterFrame:_messageText];
    self.view.backgroundColor = HEXCOLOR(0xF9F9F9);
    _publicMenuBar.hidden = YES;
    inputBar.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        _publicMenuBar.frame = CGRectMake(_publicMenuBar.frame.origin.x, self.tableFooter.frame.size.height, _publicMenuBar.frame.size.width, _publicMenuBar.frame.size.height);
        inputBar.frame = CGRectMake(inputBar.frame.origin.x, 0, inputBar.frame.size.width, inputBar.frame.size.height);
    }];
}

- (void)publicMenuBtnAction:(UIButton *)btn {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect moreFrame = [self.tableFooter convertRect:btn.frame toView:window];
    
    self.selMenuIndex = btn.tag;
    
    if (self.selMenuIndex == 0) {
        // 客服
        TFJunYou_ChatViewController *sendView = [TFJunYou_ChatViewController alloc];

        
        TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
        
        user = [user getUserById:COSUMER_SERVICE_CENTER_USERID];

        sendView.chatPerson = user;
        sendView.chatPerson.userId = COSUMER_SERVICE_CENTER_USERID;
        sendView.chatPerson.userNickname = @"在线客服";
        sendView.title = @"在线客服";

        sendView = [sendView init];

        [g_navigation pushViewController:sendView animated:YES];
        
        
        
    } else {
        // 常见问题
        TFJunYou_FAQCenterVC *vc = [TFJunYou_FAQCenterVC new];
        [g_navigation pushViewController:vc animated:YES];
    }
    
    
//    NSDictionary *dict = _menuList[btn.tag];
//    NSArray *arr = dict[@"menuList"];
//
//    if (!arr || arr.count <= 0) {
//        webpageVC *webVC = [webpageVC alloc];
//        webVC.isGotoBack= YES;
//        webVC.isSend = YES;
//        webVC.title = [dict objectForKey:@"name"];
//        NSString * url = [NSString stringWithFormat:@"%@",[dict objectForKey:@"url"]];
//        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
//        url = [url stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//        webVC.url = url;
//        webVC = [webVC init];
//        [g_navigation.navigationView addSubview:webVC.view];
////        [g_navigation pushViewController:webVC animated:YES];
//        return;
//    }
    
//    CGFloat maxWidth = 0;
//    NSMutableArray *arrM = [NSMutableArray array];
//    for (NSInteger i = 0; i < arr.count; i ++) {
//        NSDictionary *dict2 = arr[i];
//        [arrM addObject:dict2[@"name"]];
//        NSString *str = dict2[@"name"];
//        CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYSFONT(15.0)} context:nil].size;
//        if (size.width > maxWidth) {
//            maxWidth = size.width;
//        }
//    }
//    TFJunYou__DownListView * downListView = [[TFJunYou__DownListView alloc] initWithFrame:self.view.bounds];
//    downListView.listContents = arrM;
//    downListView.color = HEXCOLOR(0xf3f3f3);
//    downListView.textColor = [UIColor darkGrayColor];
//    downListView.maxWidth = maxWidth;
//    downListView.showType = DownListView_Center;
//    __weak typeof(self) weakSelf = self;
//    [downListView downlistPopOption:^(NSInteger index, NSString *content) {
//        [weakSelf showPublicMenuContent:index];
//
//    } whichFrame:moreFrame animate:YES];
//    [downListView show];
}

- (void)showPublicMenuContent:(NSInteger)index {
    
    NSDictionary *dict = _menuList[self.selMenuIndex];
    NSArray *arr = dict[@"menuList"];
    NSDictionary *dict2 = arr[index];
    
    NSString *menuId = dict2[@"menuId"];
    if (menuId.length > 0) {
        NSString * url = [NSString stringWithFormat:@"%@?access_token=%@",menuId,g_server.access_token];
        [g_server requestWithUrl:url toView:self];
    }else {
        webpageVC *webVC = [webpageVC alloc];
        webVC.isGotoBack= YES;
        webVC.isSend = YES;
        webVC.title = [dict2 objectForKey:@"name"];
        NSString * url = [NSString stringWithFormat:@"%@",[dict2 objectForKey:@"url"]];
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        url = [url stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        webVC.url = url;
        webVC = [webVC init];
        [g_navigation.navigationView addSubview:webVC.view];
//        [g_navigation pushViewController:webVC animated:YES];
    }
}

-(void)initAudio{
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    //添加监听
    [g_notify addObserver:self selector:@selector(readTypeMsgCome:) name:kXMPPMessageReadTypeNotification object:nil];
    [g_notify addObserver:self selector:@selector(readTypeMsgReceipt:) name:kXMPPMessageReadTypeReceiptNotification object:nil];
    [g_notify addObserver:self selector:@selector(sendText:) name:kSendInputNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsgNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(showMsg:) name:kXMPPShowMsgNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(newReceipt:) name:kXMPPReceiptNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(onReceiveFile:) name:kXMPPReceiveFileNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(onSendTimeout:) name:kXMPPSendTimeOutNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(onQuitRoom:) name:kQuitRoomNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [g_notify addObserver:self selector:@selector(onReceiveRoomRemind:) name:kXMPPRoomNotifaction object:nil];
//    [g_notify addObserver:self selector:@selector(onLoginChanged:) name:kXmppLoginNotifaction object:nil];//登录状态改变
    // 正在输入
    [g_notify addObserver:self selector:@selector(enteringNotifi:) name:kXMPPMessageEnteringNotification object:nil];
    // 撤回消息
    [g_notify addObserver:self selector:@selector(withdrawNotifi:) name:kXMPPMessageWithdrawNotification object:nil];
    [g_notify addObserver:self selector:@selector(actionQuitChatVC:) name:kActionRelayQuitVC object:nil];
    // 删除好友
    [g_notify addObserver:self selector:@selector(delFriend:) name:kDeleteUserNotifaction object:nil];
    // 課程消息
    [g_notify addObserver:self selector:@selector(sendCourseMsg:) name:kSendCourseMsg object:nil];
    // 修改备注
    [g_notify addObserver:self selector:@selector(friendRemarkNotifi:) name:kFriendRemark object:nil];
    // 群成员更新
    [g_notify addObserver:self selector:@selector(roomMembersRefreshNotifi:) name:kRoomMembersRefresh object:nil];
    // 设置聊天背景
    [g_notify addObserver:self selector:@selector(setBackGroundImageViewNotifi:) name:kSetBackGroundImageView object:nil];
    
    [g_notify addObserver:self selector:@selector(showCallMsg:) name:UpdateAcceptCallMsg object:nil];
    
    [self.tableFooter addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)unInitAudio{
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    //移除监听
    [g_notify removeObserver:self];
    [g_notify  removeObserver:self name:kXMPPNewMsgNotifaction object:nil];
    [g_notify  removeObserver:self name:kXMPPSendTimeOutNotifaction object:nil];
    [g_notify  removeObserver:self name:kXMPPReceiptNotifaction object:nil];
    [g_notify  removeObserver:self name:kSendInputNotifaction object:nil];
    [g_notify  removeObserver:self name:kXMPPReceiveFileNotifaction object:nil];
    [g_notify  removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [g_notify  removeObserver:self name:kQuitRoomNotifaction object:nil];
    [g_notify  removeObserver:self name:kXMPPRoomNotifaction object:nil];
    [g_notify  removeObserver:self name:kXmppLoginNotifaction object:nil];
    [g_notify removeObserver:self name:kXMPPMessageEnteringNotification object:nil];
    [g_notify removeObserver:self name:kXMPPMessageWithdrawNotification object:nil];
    [g_notify removeObserver:self name:kSendCourseMsg object:nil];
    [g_notify removeObserver:self name:kFriendRemark object:nil];
    [g_notify removeObserver:self name:UpdateAcceptCallMsg object:nil];
    
    [self.tableFooter removeObserver:self forKeyPath:@"frame"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (THE_DEVICE_HAVE_HEAD) {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        CGRect newFrame = [newValue CGRectValue];
        int n = (int)newFrame.origin.y;
        int m = (int)(self.view.frame.size.height - self.heightFooter);
        
        if (fabs(n - m) < 2) {
            
            self.tableFooter.frame = CGRectMake(0, TFJunYou__SCREEN_HEIGHT-self.heightFooter - 35, TFJunYou__SCREEN_WIDTH, self.heightFooter);
            _table.frame =CGRectMake(0,self.heightHeader+_noticeHeight,self_width,TFJunYou__SCREEN_HEIGHT-self.heightHeader-self.heightFooter - 35-_noticeHeight);
        }
    }
}

- (void)setBackGroundImageViewNotifi:(NSNotification *)notif {
    UIImage *image = notif.object;
    if (image) {
        _table.backgroundColor = [UIColor clearColor];
        self.backGroundImageView.image = image;
    }else {
        self.backGroundImageView.image = nil;
        _table.backgroundColor = HEXCOLOR(0xF2F2F2);
    }
}

-(void)friendRemarkNotifi:(NSNotification *)notif {
    
    if (self.courseId.length > 0) {
        return;
    }
    TFJunYou_UserObject *user = notif.object;
    if ([user.userId isEqualToString:chatPerson.userId]) {
        [self setChatTitle:user.remarkName.length > 0 ? user.remarkName : user.userNickname];
    }
}

- (void)roomMembersRefreshNotifi:(NSNotification *)notif {
    
//    NSArray * memberArray = [memberData fetchAllMembers:_room.roomId];
    NSInteger userSize = [notif.object integerValue];
    memberData *me = [self.room getMember:g_myself.userId];
    if ([me.role intValue] == 1 || [me.role intValue] == 2) {
        self.title = [NSString stringWithFormat:@"%@(%ld)", self.chatPerson.userNickname, userSize];
    } else {
        self.title = self.chatPerson.userNickname;
    }
    
    [self setAudioIconFrame];
}

- (void)actionQuitChatVC:(NSNotification *)notif {
    self.isSelectMore = NO;
    [self actionQuit];
}

- (void)delFriend:(NSNotification *)notif {
    TFJunYou_UserObject* user = (TFJunYou_UserObject *)notif.object;

    if ([chatPerson.userId isEqualToString:user.userId]) {
        [self actionQuit];
    }
}


- (void)sendCourseMsg:(NSNotification *)notif {
    TFJunYou_MessageObject *msg = (TFJunYou_MessageObject *)notif.object;
    if ([msg.toUserId isEqualToString:chatPerson.userId]) {
        [self showOneMsg:msg];
    }
}

-(void)refresh:(TFJunYou_MessageObject*)msg {
    _isRefreshing = YES;
    if (self.courseId.length > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in self.courseArray) {
            [arr addObject:dict[@"message"]];
        }
        _array = arr;
        [_table gotoLastRow:NO];
        self.isShowHeaderPull = NO;
        return;
    }
    
    if (self.chatLogArray.count > 0) {
        _array = self.chatLogArray;
        [self.tableView reloadData];
        self.isShowFooterPull = NO;
        return;
    }
    
    [_messageText setInputView:nil];
    [_messageText resignFirstResponder];
    BOOL b=YES;
    BOOL bPull=NO;
    NSInteger firstNum = 1;
    if([_array count]>0)
        firstNum = _array.count;
    
    
    CGFloat allHeight = 0;
    if(msg == nil){
        NSString* s;
        if([self.roomJid length]>0)
            s = self.roomJid;
        else
            s = chatPerson.userId;
        NSMutableArray* p;
        if (self.isGetServerMsg) {
           // 获取漫游聊天记录
            [_wait start];
            long starTime;
            long endTime;
            long chatSyncTimeLen = 0;
            switch ([g_myself.chatSyncTimeLen integerValue]) {
                case 0: // 0.04 1小时
                    chatSyncTimeLen = 3600000;
                    break;
                case 1: //  1天
                    chatSyncTimeLen = 86400000;
                    break;
                case 7: //  7天
                    chatSyncTimeLen = 604800017;
                    break;
                case 30: // 30天
                    chatSyncTimeLen = 2629800000;
                    break;
                case 90: // 90天
                    chatSyncTimeLen = 7889400000;
                    break;
                case 365: //365天
                    chatSyncTimeLen = 31557600000;
                    break;
                case -1: // 永久(20年)
                    chatSyncTimeLen = 631152000000;
                    break;
                default:
                    break;
            }
            endTime = [[NSDate date] timeIntervalSince1970] * 1000;
            starTime = endTime - chatSyncTimeLen;
            
            // 群组删除聊天记录时间
            NSInteger time1 = 0;
            if ([g_default valueForKey:s] && ([self.roomJid length]>0)) {
                time1 = [[g_default valueForKey:s] integerValue];
            }
            NSNumber *lastClearRecordTime = [NSNumber numberWithInteger:time1];
            // 设置删除所有聊天记录时间
            NSInteger time2 = 0;
            if ([g_default valueForKey:@"CLEARALLMSGRECORDTIME"] && ([self.roomJid length]>0)) {
                time2 = [[g_default valueForKey:@"CLEARALLMSGRECORDTIME"] integerValue];
            }
            NSNumber *CLEARALLMSGRECORDTIME = [NSNumber numberWithInteger:time2];
            // 设置漫游的时间
            NSNumber *synTime = [NSNumber numberWithLong:starTime];
            // 排序四个时间 入群时间,群组删除聊天记录时间,设置删除所有聊天记录时间,设置漫游的时间
                     NSArray *sortedArray = [@[lastClearRecordTime,synTime,CLEARALLMSGRECORDTIME] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                         NSComparisonResult result = [obj1 compare: obj2];
                         return result;
                     }];
                     NSNumber *time = [sortedArray lastObject];
                     starTime =  [time longValue];
                      
                      if([self.roomJid length]>0)
                          [g_server tigaseMucMsgsWithRoomId:s StartTime:starTime EndTime:endTime PageIndex:0 PageSize:PAGECOUNT toView:self];
                      else
                          [g_server tigaseMsgsWithReceiver:s StartTime:starTime EndTime:endTime  PageIndex:0 toView:self];
        }else {
            //获取本地聊天记录
            if (self.scrollLine == 0) {
                int pageCount = 20;
                if (self.newMsgCount > 20) {
                    pageCount = self.newMsgCount;
                    self.newMsgCount = 0;
                }
                
                TFJunYou_SynTask *task = _taskList.firstObject;
                if (self.roomJid.length > 0 && task) {
                    
                    p = [[TFJunYou_MessageObject sharedInstance] fetchMessageListWithUser:s byAllNum:_array.count pageCount:pageCount startTime:task.endTime];
                    
                    
                }else {
                    NSString* myUserId = MY_USER_ID;
                    double createTime = 0;
                    NSArray *array = [memberData getSelfMember:self.roomId];
                    for (memberData *mdata in array) {
                        NSString *userId = [NSString stringWithFormat:@"%ld", mdata.userId];
                        if([userId isEqualToString:myUserId]){
                            createTime = mdata.createTime;
                        }
                    }
                    p = [[TFJunYou_MessageObject sharedInstance] fetchMessageListWithUser:s byAllNum:_array.count pageCount:pageCount startTime:[NSDate dateWithTimeIntervalSince1970:createTime]];
                }
                if (_array.count <= 0 &&(!p || p.count <= 0) && (!self.roomJid || self.roomJid.length <= 0)) {
                    self.isGetServerMsg = YES;
                    [self refresh:nil];
                    return;
                }

                bPull = (p && p.count > 0);
            }else {
                p = [[TFJunYou_MessageObject sharedInstance] fetchAllMessageListWithUser:s];
                [_array removeAllObjects];
                bPull = NO;
            }
            
        }
        
        for (TFJunYou_MessageObject *msg in p) {
            allHeight += [msg.chatMsgHeight floatValue];
        }
        
        self.isGetServerMsg = !bPull;
        
        //获取口令红包记录
        [_orderRedPacketArray removeAllObjects];
        [_orderRedPacketArray addObjectsFromArray:[self fetchRedPacketListWithType:3]];
        
        b = p.count>0;
        bPull = p.count>=PAGE_SHOW_COUNT;
//        if(_page == 0 || self.scrollLine>0)//如果
//            [_array removeAllObjects];
        if(b){
            NSMutableArray* temp = [[NSMutableArray alloc]init];
            [temp addObjectsFromArray:p];
            [temp addObjectsFromArray:_array];
            [_array removeAllObjects];
            [_array addObjectsFromArray:temp];
            [temp removeAllObjects];
//            [temp release];
        }
        [p removeAllObjects];
//        [p release];
    }else
        [_array addObject:msg];
    
    
    TFJunYou_MessageObject *lastMsg = _array.lastObject;
    if (lastMsg && lastMsg.isVisible) {
        if (self.roomJid.length > 0) {
            lastMsg.isGroup = YES;
        }
        if (lastMsg.isMySend) {
            if ([lastMsg.isSend boolValue]) {
                [lastMsg updateLastSend:UpdateLastSendType_None];
            }
        }else {
            [lastMsg updateLastSend:UpdateLastSendType_None];
        }
        
        self.lastMsg.content = [lastMsg getLastContent];
    }
    
    
    [self setIsShowTime];
    
    if (b) {
        [_pool removeAllObjects];
        _refreshCount++;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //刷新完成
            if (self.scrollLine > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [_table reloadData];
                    [self scrollToCurrentLine];
                    _isRefreshing = NO;
                });
            }else {
                if(msg || _page == 0){
                    
                    [_table reloadData];
                    if (self.isSyncMsg || self.isGotoLast) {
                        [_table gotoLastRow:NO];
                    }
                }
                else{
                    if([_array count]>0){
                        
                        [_table reloadData];
                        //                        [_table gotoRow: (int)(_array.count - firstNum + 2)];
                        //                        [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(int)(_array.count - firstNum) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        _table.contentOffset = CGPointMake(0, allHeight);
                        
                    }
                }
                
                
                _isRefreshing = NO;
            }
            
        });
        
    }else {
        _isRefreshing = NO;
    }
    
}

- (void) scrollToCurrentLine {
    [_table gotoRow:self.scrollLine];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.scrollLine - 1 inSection:0];
//    [_table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [g_notify removeObserver:self];
    [g_notify removeObserver:self name:kCellShowCardNotifaction object:nil];
    [g_notify removeObserver:self name:kCellLocationNotifaction object:nil];
    [g_notify removeObserver:self name:kCellImageNotifaction object:nil];
    [g_notify removeObserver:self name:kcellRedPacketDidTouchNotifaction object:nil];
    
    [g_notify removeObserver:self name:kCellHeadImageNotification object:nil];
    [g_notify removeObserver:self name:kHiddenKeyboardNotification object:nil];
    [g_notify removeObserver:self name:kUpdateChatVCGroupHelperData object:nil];
    
    [g_notify removeObserver:self name:kKeepOnSendGroupSendMessage object:nil];
    
    NSLog(@"TFJunYou_ChatViewController.dealloc");
    [g_xmpp.chatingUserIds removeObject:current_chat_userId];
    current_chat_userId = nil;

    [self hideKeyboard:NO];
    [self unInitAudio];

    [self free:_pool];
    [_pool removeAllObjects];
//    [_pool release];
    _pool = nil;

    [_array removeAllObjects];
//    [_array release];
    
    
//    [_messageConent release];
    _faceView.delegate = nil;
//    [_table release];
//    [_moreView release];
    _moreView=nil;
    
//    [_voice release];
//    _poolSend = nil;

    _locationVC = nil;
    self.chatPerson = nil;
//    [super dealloc];
    
    [self.enteringTimer invalidate];
    self.enteringTimer = nil;
    [self.noEnteringTimer invalidate];
    self.noEnteringTimer = nil;
    
}

-(void)free:(NSMutableArray*)array{
    for(int i=(int)[array count]-1;i>=0;i--){
        id p = [array objectAtIndex:i];
        [array removeObjectAtIndex:i];
        p = nil;
    }
}

// 正在输入
- (void)enteringNotifi:(NSNotification *) notif {
    TFJunYou_MessageObject *msg = notif.object;
    if ([chatPerson.userId isEqualToString:msg.fromUserId]) {
        if(msg==nil)
            return;
        if (self.roomJid || msg.isGroup) {
            return;
        }
        self.title = Localized(@"JX_Entering");
        
        [self setAudioIconFrame];
        self.noEnteringTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(noEnteringTimerAction:) userInfo:nil repeats:NO];
    }
}

- (void) noEnteringTimerAction:(NSNotification *)notif {
    [self.noEnteringTimer invalidate];
    self.noEnteringTimer = nil;
    if (self.courseId.length > 0) {
        return;
    }
    if([chatPerson.userId intValue]<10100 && [chatPerson.userId intValue]>=10000) {
        self.title = chatPerson.userNickname;
        [self setAudioIconFrame];
    }else {
//        NSString *str = self.onlinestate ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
//        self.title = [NSString stringWithFormat:@"%@(%@)",chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname,str];
        [self setChatTitle:chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname];
    }
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}


#pragma mark ----键盘高度变化------
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    
    self.shareMore.selected = YES;

    id view = g_navigation.subViews.lastObject;
    if (![view isEqual:self]) {
        return;
    }
    
    if (!_messageText.isFirstResponder) {
        return;
    }

//    return;
    //获取到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect endRect=[keyboardEndBounds CGRectValue];
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    self.deltaY = deltaY;
    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
    deltaY=-endRect.size.height;
    self.deltaHeight = deltaY;
//    NSLog(@"deltaY:%f",deltaY);
    [CATransaction begin];
    [UIView animateWithDuration:0.4f animations:^{
//        [_table setFrame:CGRectMake(0, 0, _table.frame.size.width, self.view.frame.size.height+deltaY-self.heightFooter)];
//        [_table gotoLastRow:NO];
        self.tableFooter.frame = CGRectMake(0, self.view.frame.size.height+deltaY-self.heightFooter, TFJunYou__SCREEN_WIDTH, self.heightFooter);
        
        self.screenShotView.frame = CGRectMake(self.screenShotView.frame.origin.x, self.tableFooter.frame.origin.y - self.screenShotView.frame.size.height - 10, self.screenShotView.frame.size.width, self.screenShotView.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    [CATransaction commit];
    
    if ((_table.contentSize.height > (self.view.frame.size.height + deltaY - self.heightFooter - 64 - 40)) || self.deltaY > 0) {
        
        [CATransaction begin];//创建显式事务
        [UIView animateWithDuration:0.1f animations:^{
            //            self.tableFooter.frame = CGRectMake(0, self.view.frame.size.height+deltaY-self.heightFooter, TFJunYou__SCREEN_WIDTH, self.heightFooter);
            [_table setFrame:CGRectMake(0, 0+_noticeHeight, _table.frame.size.width, self.view.frame.size.height+deltaY-self.heightFooter-_noticeHeight)];
            [_table gotoLastRow:NO];
        } completion:^(BOOL finished) {
        }];
        [CATransaction commit];
    }
}

- (BOOL)theTextAllSpace:(NSString *)text {
    NSString *string = [text copy];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (string.length <= 0) {
        return YES;
    }
    return NO;
}

- (void)sendIt:(id)sender {
    if([self showDisableSay])
        return;

    if([self sendMsgCheck]){
        return;
    }
    
    NSString *userId = self.userIds[self.groupMessagesIndex];
//    NSString *userName = self.userNames[self.groupMessagesIndex];
    
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for (memberData * member in _atMemberArray) {
        if (member.idStr){
            [tempArray addObject:[NSString stringWithFormat:@"%@",member.idStr]];
        }else{
            [tempArray addObject:[NSString stringWithFormat:@"%ld",member.userId]];
        }
    }
    NSString * ObjectIdStr = [tempArray componentsJoinedByString:@" "];

    if (self.objToMsg.length > 0) {
        ObjectIdStr = self.objToMsg;
    }
    
//    NSString *message = messageText.text;
    NSString *message = [_messageText.textStorage getPlainString];
    if ([self theTextAllSpace:message]) {
        // txt全是空格
        _messageText.text = @"";
        [self doEndEdit];
        //不能发送空白消息
        [g_App showAlert:Localized(@"JX_CannotSendBlankMessage")];
        return;
    }
    if (message.length > 0) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg.toUserId = self.roomJid;
            msg.isGroup = YES;
            msg.fromUserName = _userNickName;
        }
        else{
            if (self.isGroupMessages) {
                if (_isGroupSendCancel) {
                    return;
                }
                msg.toUserId = userId;
                msg.isGroupSend = YES;
                if ((self.groupMessagesIndex + 1) % _onceSendNum == 0) {
                    msg.isLastGroupSend = YES;
                }
            }else {
                msg.toUserId     = chatPerson.userId;
            }
            msg.isGroup = NO;
        }
        msg.content      = message;
        if (self.objToMsg.length > 0) {
            msg.type         = [NSNumber numberWithInt:kWCMessageTypeReply];
        }else {
            msg.type         = [NSNumber numberWithInt:kWCMessageTypeText];
        }
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];
        if (ObjectIdStr.length > 0){
            msg.objectId = ObjectIdStr;
        }
        //发往哪里
        [msg insert:self.roomJid];
        [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
        
        if (self.isGroupMessages) {
            self.groupMessagesIndex ++;
            if (msg.isLastGroupSend) {
                return;
            }
            if (self.groupMessagesIndex < self.userIds.count) {
                [self sendIt:nil];
            }else if (self.userIds){
                self.groupMessagesIndex = 0;
                _messageText.text = nil;
                [self hideKeyboard:YES];
                [g_App showAlert:Localized(@"JX_SendComplete")];
                [g_navigation popToRootViewController];
                return;
            }
            return;
        }
        
        [self showOneMsg:msg];
        
        if (_table.contentSize.height > (TFJunYou__SCREEN_HEIGHT + self.deltaHeight - self.heightFooter - 64 - 40 - 20)) {
            if (self.deltaY >= 0) {
                
            }else {
                
                if (self.tableFooter.frame.origin.y != TFJunYou__SCREEN_HEIGHT-self.heightFooter) {
                    [CATransaction begin];
                    [UIView animateWithDuration:0.1f animations:^{
                        //            self.tableFooter.frame = CGRectMake(0, self.view.frame.size.height+deltaY-self.heightFooter, TFJunYou__SCREEN_WIDTH, self.heightFooter);
                        [_table setFrame:CGRectMake(0, 0+_noticeHeight, _table.frame.size.width, self.view.frame.size.height+self.deltaHeight-self.heightFooter-_noticeHeight)];
                        //                [_table gotoLastRow:NO];
                    } completion:^(BOOL finished) {
                    }];
                    [CATransaction commit];
                }
            }
        }
    }
         
    //检查是否有口令红包
    for (TFJunYou_MessageObject * msg in _orderRedPacketArray) {
        if ([msg.content caseInsensitiveCompare:_messageText.text] == NSOrderedSame &&[msg.fileSize intValue] != 2) {
            if (self.roomJid.length > 0 || ![msg.fromUserId isEqualToString:MY_USER_ID]) {
                [g_server getRedPacket:msg.objectId toView:self];
                break;
            }
        }
    }
    [_atMemberArray removeAllObjects];
    [_messageText.textStorage removeAttribute:NSBackgroundColorAttributeName range:NSMakeRange(0,_messageText.text.length)];
//    [_messageText.textStorage removeAttribute:NSFontAttributeName range:NSMakeRange(0,_messageText.text.length)];
    [_messageText setText:nil];
    [_messageText setAttributedText:nil];

    chatPerson.lastInput = _messageText.text;
    [chatPerson updateLastInput];
    
    //发送消息后重置底部控件
    [self onBackForRecordBtnLeft];
}

- (void)clickTextNotif:(NSNotification *)notif{
    
    NSString *dict = notif.object;
    
    [self reportMess:dict objectIdSt:@"6f74f59e3e384d29962307ef3d842734"];
    
    
}
- (void)reportMess:(NSString *)message objectIdSt:(NSString *)ObjectIdStr{
    
    [_arrayReport enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          
        if ([obj[@"issue"] isEqualToString:message] ||[message isEqualToString:obj[@"sort"]]) {
             
            TFJunYou_MessageObject *msgUser=[[TFJunYou_MessageObject alloc]init];
           
            msgUser.content      = obj[@"answer"];
            msgUser.type         = [NSNumber numberWithInt:kWCMessageTypeReport];
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            msgUser.messageId = [NSString stringWithFormat:@"%f",a];
            msgUser.changeMySend = 0;
            msgUser.chatMsgHeight = @"0";
            msgUser.chatType = 0;
            msgUser.deleteTime = [NSDate date];
            msgUser.fileSize = 0;
            msgUser.fromUserId = _lastMsg.fromUserId;
            msgUser.fromUserName = _lastMsg.fromUserName;;
            msgUser.index = 0;
             
            msgUser.isDelay = 0;
            msgUser.isGroup = 0;
            msgUser.isGroupSend = 0;
            msgUser.isLastGroupSend = 0;
            msgUser.isMultipleRelay = 0;
            msgUser.isMySend = 0;
            msgUser.isNotUpdateHeight = 0;
            msgUser.isRead = @1;
            msgUser.isReadDel = 0;
            msgUser.isReceive = @1;
            msgUser.isRepeat = 1;
            msgUser.isSend = @1;
            msgUser.isShowRemind = 0;
            msgUser.isShowTime = 0;
            msgUser.isShowWait = 0;
            msgUser.isUpload = @1;
            msgUser.messageNo = @1;
            msgUser.progress = 0;
            msgUser.readTime = [NSDate date];
            msgUser.sendCount = 0;
            msgUser.showRead = 0;
            msgUser.timeReceive = [NSDate date];
            msgUser.timeSend = _lastMsg.timeSend;;
            msgUser.toUserId = _lastMsg.toUserId;
            msgUser.updateLastContent = 1;
         
            if (ObjectIdStr.length > 0){
                msgUser.objectId = ObjectIdStr;
            }
            //发往哪里
            //[msgUser insert:self.roomJid];
            //[g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
            [_array addObject:msgUser];
            [_table reloadData];
            [_table gotoLastRow:YES];
        }
    }];
}

//图片piker选择完成后调用
-(void)sendImage:(NSString *)file withWidth:(int) width andHeight:(int) height userId:(NSString *)userId
{
    
//    NSString *userId = self.userIds[self.groupMessagesIndex];
//    NSString *userName = self.userNames[self.groupMessagesIndex];
    
    if ([file length]>0) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg.toUserId = self.roomJid;
            msg.isGroup = YES;
            msg.fromUserName = _userNickName;
        }
        else{
            if (self.isGroupMessages) {
                msg.toUserId = userId;
            }else {
                msg.toUserId     = chatPerson.userId;
            }
            msg.isGroup = NO;
        }
        msg.fileName     = file;
        msg.content      = [[file lastPathComponent] stringByDeletingPathExtension];
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeImage];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isUpload     = [NSNumber numberWithBool:NO];
        //新添加的图片宽高
        msg.location_x = [NSNumber numberWithInt:width];
        msg.location_y = [NSNumber numberWithInt:height];
        
        msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];
        
        [msg insert:self.roomJid];
        
        [self showOneMsg:msg];
//        if (self.isGroupMessages) {
//            self.groupMessagesIndex ++;
//            if (self.groupMessagesIndex < self.userIds.count) {
//                [self sendImage:file withWidth:width andHeight:height];
//            }else if (self.userIds){
//                self.groupMessagesIndex = 0;
//
//                return;
//            }
//            return;
//        }
//        [msg release];
        [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:msg.messageId toView:self];
    }
}
//发送视频，以后要改视频长宽
-(void)sendMedia:(TFJunYou_MediaObject*)p userId:(NSString *)userId
{
    NSString* file = p.fileName;
    if ([file length]>0) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg.toUserId = self.roomJid;
            msg.isGroup = YES;
            msg.fromUserName = _userNickName;
        }
        else{
            if (self.isGroupMessages) {
                msg.toUserId = userId;
            }else {
                msg.toUserId     = chatPerson.userId;
            }
            msg.isGroup = NO;
        }
        msg.fileName     = file;
        msg.content      = [[file lastPathComponent] stringByDeletingPathExtension];
        if(p.isVideo)
            msg.type         = [NSNumber numberWithInt:kWCMessageTypeVideo];
        else
            msg.type         = [NSNumber numberWithInt:kWCMessageTypeAudio];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isUpload     = [NSNumber numberWithBool:NO];
        msg.location_x = [NSNumber numberWithInt:100];
        msg.location_y = [NSNumber numberWithInt:100];
//        NSLog(@"hh%hhd",_isReadDelete);
        msg.isReadDel    = [NSNumber numberWithInt:_isReadDelete];
            
        [msg insert:self.roomJid];
        [self showOneMsg:msg];
        [g_server uploadFile:p.fileName validTime:self.chatPerson.chatRecordTimeOut messageId:msg.messageId toView:self];
//        [msg release];
    }
}

- (void)shareMore:(UIButton*)sender {
//    [messageText setInputView:messageText.inputView?nil: _moreView];
    if([self showDisableSay])
        return;
    if (!_moreView) {
        return;
    }
//    sender.selected = !sender.selected;
    if(_messageText.inputView != _moreView){
        _messageText.inputView = _moreView;
        [_messageText reloadInputViews];
        [_messageText becomeFirstResponder];
        _textViewBtn.hidden = NO;
        
        if (self.screenShotView.hidden) {
            ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
            
            [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (group) {
                    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                    [group enumerateAssetsWithOptions:NSEnumerationReverse/*遍历方式*/ usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if (result) {
                            int photoIndex = [[g_default objectForKey:LastPhotoIndex] intValue];
                            if (photoIndex == index) {
                                *stop = YES;
                                return;
                            }
                            [g_default setObject:[NSNumber numberWithInteger:index] forKey:LastPhotoIndex];
                            NSString *type = [result valueForProperty:ALAssetPropertyType];
                            if ([type isEqual:ALAssetTypePhoto]){
                                UIImage *needImage = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                                if (needImage) {
                                    self.screenImage = needImage;
                                    self.screenShotImageView.image = needImage;
                                    self.screenShotView.hidden = NO;
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        self.screenShotView.hidden = YES;
                                        
                                    });
                                }else {
                                    [self hideKeyboard:YES];
                                }
                            }
                            *stop = YES;
                        }
                    }];
                    *stop = YES;
                    
                }
            } failureBlock:^(NSError *error) {
                if (error) {
                    
                }
            }];
        }
        
        
        
        
//        if (self.screenShotView.hidden) {
//            UIImage *image = [UIImage imageWithContentsOfFile:ScreenShotImage];
//            if (image) {
//                self.screenShotImageView.image = image;
//                self.screenShotView.hidden = NO;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    self.screenShotView.hidden = YES;
//                     NSFileManager* fileManager=[NSFileManager defaultManager];
//                    BOOL blDele= [fileManager removeItemAtPath:ScreenShotImage error:nil];
//                    if (blDele) {
//                        NSLog(@"dele success");
//                    }else {
//                        NSLog(@"dele fail");
//                    }
//                });
//            }
//        }
    }
    else{
        [self hideKeyboard:YES];
    }
}
//遍历消息，添加时间
- (void)setIsShowTime{
    if([_array count]<=0)
        return;
    TFJunYou_MessageObject *firstMsg=[_array objectAtIndex:0];
    if (!firstMsg.isShowTime) {
        
        firstMsg.isShowTime = YES;
        [firstMsg updateIsShowTime];
        firstMsg.chatMsgHeight = [NSString stringWithFormat:@"0"];
        [firstMsg updateChatMsgHeight];
    }
    
    
    for (int i = 0; i < [_array count] -1 ; i++) {
        TFJunYou_MessageObject *firstMsg=[_array objectAtIndex:i];
        TFJunYou_MessageObject *secondMsg=[_array objectAtIndex:(i+1)];

        if(([secondMsg.timeSend timeIntervalSince1970]-[firstMsg.timeSend timeIntervalSince1970]>15*60)){
            if (!secondMsg.isShowTime) {
                secondMsg.isShowTime = YES;
                [secondMsg updateIsShowTime];
                secondMsg.chatMsgHeight = [NSString stringWithFormat:@"0"];
                [secondMsg updateChatMsgHeight];
            }
        }else {
            if (secondMsg.isShowTime) {
                secondMsg.isShowTime = NO;
                [secondMsg updateIsShowTime];
                secondMsg.chatMsgHeight = [NSString stringWithFormat:@"0"];
                [secondMsg updateChatMsgHeight];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard:NO];
}

//新来的消息是否需要展示时间
- (void)setNewShowTime:(TFJunYou_MessageObject *)msg{
    TFJunYou_MessageObject *lastMsg=[_array lastObject];
    NSLog(@"%f",[msg.timeSend timeIntervalSince1970]-[lastMsg.timeSend timeIntervalSince1970]);

    if(([msg.timeSend timeIntervalSince1970]-[lastMsg.timeSend timeIntervalSince1970]>15*60)){
        if (!msg.isShowTime) {
            msg.isShowTime = YES;
            [msg updateIsShowTime];
            msg.chatMsgHeight = [NSString stringWithFormat:@"0"];
            [msg updateChatMsgHeight];
        }
    }else {
        if (msg.isShowTime) {
            msg.isShowTime = NO;
            [msg updateIsShowTime];
            msg.chatMsgHeight = [NSString stringWithFormat:@"0"];
            [msg updateChatMsgHeight];
        }
    }
}

- (void)viewDidLayoutSubviews {
    
    if (!self.scrollBottom) {
        if (_table.contentSize.height > _table.bounds.size.height) {
            NSLog(@"tableScroll -----  1");
            self.isGotoLast = NO;
            [_table setContentOffset:CGPointMake(0, _table.contentSize.height - _table.bounds.size.height) animated:NO];
        }
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        self.scrollBottom = YES;
    });
}

#pragma mark   ---------tableView协议----------------
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    TFJunYou_MessageObject *msg=[_array objectAtIndex:indexPath.row];
//    
////    bool isContent = NO;
////    //判断消息池里面是否含有此消息
////    for (TFJunYou_MessageObject * obj in g_xmpp.poolSendRead) {
////        //含有，直接跳过
////        if ([obj.content isEqualToString:msg.messageId]) {
////            isContent = YES;
////            break;
////        }
////    }
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _array.count) {
        return [[TFJunYou_BaseChatCell alloc] init];
    }
    
    TFJunYou_MessageObject *msg=[_array objectAtIndex:indexPath.row];
    
    NSString *showRead = [NSString stringWithFormat:@"%@",self.chatPerson.showRead];
    msg.showRead = [showRead boolValue];
    
    NSLog(@"indexPath.row:%ld,%ld",indexPath.section,indexPath.row);
    
    if (self.roomJid){
        msg.isGroup = YES;
//        msg.roomJid = self.roomJid;
    }
    
    //如果是新来的未读消息，回执通知
    if ([msg.type intValue] != kWCMessageTypeVoice && [msg.type intValue] != kWCMessageTypeVideo && [msg.type intValue] != kWCMessageTypeFile && [msg.type intValue] != kWCMessageTypeLocation && [msg.type intValue] != kWCMessageTypeCard && [msg.type intValue] != kWCMessageTypeLink && [msg.type intValue] != kWCMessageTypeMergeRelay && [msg.type intValue] != kWCMessageTypeShare && [msg.type intValue] != kWCMessageTypeIsRead) {
        memberData *member = [[memberData alloc] init];
        member.roomId = roomId;
        memberData *roleM = [member getCardNameById:MY_USER_ID];
        // 隐身人不发回执（已读列表不显示）
        if (![msg.isReadDel boolValue] && [roleM.role intValue] !=4) {
            [msg sendAlreadyReadMsg];
        }
    }
    
    
    //返回对应的Cell
    TFJunYou_BaseChatCell * cell = [self getCell:msg indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isSelectMore = self.isSelectMore;
    cell.room = self.room;
//    memberData *data = [self.room getMember:g_myself.userId];
//    BOOL flag = [data.role intValue] == 1 || [data.role intValue] == 2;
//    if (!flag && ![self.chatPerson.allowSpeakCourse boolValue]) {
//        cell.isShowRecordCourse = NO;
//    }else {
//        cell.isShowRecordCourse = YES;
//    }
    
    if ([chatPerson.userId rangeOfString:MY_USER_ID].location == NSNotFound) {
        cell.isShowRecordCourse = YES;
    }else {
        cell.isShowRecordCourse = NO;
    }
    
    cell.msg = msg;
    cell.isCourse = self.courseId.length > 0;
    cell.indexNum = (int)indexPath.row;
    cell.delegate = self;
    cell.chatCellDelegate = self;
    cell.checkBox.selected = NO;
    for (TFJunYou_MessageObject *selMsg in self.selectMoreArr) {
        if ([selMsg.messageId isEqualToString:msg.messageId]) {
            cell.checkBox.selected = YES;
            break;
        }
    }
    cell.readDele = @selector(readDeleWithUser:);
    if ([msg.type intValue] == kWCMessageTypeShake) {
        if (![msg.fileName isEqualToString:@"1"]) {
            self.shakeMsg = msg;
        }
    }
    if (self.roomJid.length > 0) {
        cell.isShowHead = [self.chatPerson.allowSendCard boolValue] || _isAdmin;
        
        BOOL isWithdraw = NO;
        memberData *myData = [self.room getMember:g_myself.userId];
        if ([myData.role intValue] == 1) {
            isWithdraw = YES;
        }else if ([myData.role intValue] == 2) {
            memberData *msgData = [self.room getMember:msg.fromUserId];
            if ([msgData.role intValue] == 1 || [msgData.role intValue] == 2) {
                isWithdraw = NO;
            }else {
                isWithdraw = YES;
            }
        }
        
        cell.isWithdraw = msg.isMySend || isWithdraw;
    }else {
        cell.isShowHead = YES;
        cell.isWithdraw = msg.isMySend;
    }
    [cell setHeaderImage];
    [cell setCellData];
    [cell setBackgroundImage];
    [cell isShowSendTime];
    
    // 多选状态下取消cell内控件的点击事件
    cell.bubbleBg.userInteractionEnabled = !self.isSelectMore;

    //转圈等待
    if ([msg.isSend intValue] == transfer_status_ing) {
        
        BOOL flag = NO;
        for (NSInteger i = 0; i < g_xmpp.poolSend.allKeys.count; i ++) {
            NSString *msgId = g_xmpp.poolSend.allKeys[i];
            if ([msgId isEqualToString:msg.messageId]) {
                flag = YES;
                break;
            }
        }
        
        if (flag || msg.isShowWait) {
            [cell drawIsSend];
        }else {
            [msg updateIsSend:transfer_status_no];
            cell.sendFailed.hidden = NO;
        }
    }
    
    if (indexPath.row == _array.count - 1) {
        // 戳一戳
        if (self.shakeMsg) {
            int value = 0;
            if (self.shakeMsg.isMySend) {
                value = -50;
            }else {
                value = 50;
            }
            
            self.shakeMsg = nil;
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///横向移动
            
            animation.toValue = [NSNumber numberWithInt:value];
            
            animation.duration = .5;
            
            animation.removedOnCompletion = YES;//yes的话，又返回原位置了。
            
            animation.repeatCount = 2;
            
            animation.fillMode = kCAFillModeForwards;
            
            [_messageText.inputView.superview.layer addAnimation:animation forKey:nil];
            [g_window.layer addAnimation:animation forKey:nil];

        }
        
    }
    msg = nil;

    NSLog(@"lastIndex === %ld", indexPath.row);
    if (self.isRefresh && _array.count > 1) {
        [self doAutoScroll:indexPath];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= _array.count) {
        return 0;
    }
    TFJunYou_MessageObject *msg=[_array objectAtIndex:indexPath.row];
    if (self.roomJid){
        msg.isGroup = YES;
        NSArray * memberArr = [memberData fetchAllMembers:_room.roomId];
        
        NSInteger from = msg.fromUserId.integerValue;
        BOOL exist = NO;
        for (int j=0; j<memberArr.count; j++) {
            memberData *mem = memberArr[j];
            if (mem.userId == from) {
                exist = YES;
                break;
            }
        }
        
        if (!exist) {
            return 0;
        }
    }
    switch ([msg.type intValue]) {
        case kWCMessageTypeText:
            return [TFJunYou_MessageCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeReport:
             return [TFJunYou_MsgStrCell getChatCellHeight:msg]+5;
            break;
        case kWCMessageTypeImage:
            return [TFJunYou_ImageCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeCustomFace:
            return [TFJunYou_FaceCustomCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeEmoji:
            return [TFJunYou_EmojiCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeVoice:
            return [TFJunYou_AudioCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeLocation:
            return [TFJunYou_LocationCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeGif:
            return [TFJunYou_GifCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeVideo:
            return [TFJunYou_VideoCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeAudio:
            return [TFJunYou_VideoCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeCard:
            return [TFJunYou_CardCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeFile:
            return [TFJunYou_FileCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeRemind: {
            if ((msg.type.intValue == 202 || [msg.content containsString:@"取消了禁言"] || [msg.content containsString:@"设置了禁言"] || [msg.content containsString:@"撤回了一条消息"] || [msg.content containsString:@"管理员撤回了一条成员消息"] || [msg.content containsString:@"退出群组"] || [msg.content containsString:@"移除成员"]) && !_isAdmin) {
                return 0;
            }
            
            return [TFJunYou_RemindCell getChatCellHeight:msg];
        }
        case kWCMessageTypeRedPacket:
            return [TFJunYou_RedPacketCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeTransfer:
            return [TFJunYou_TransferCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeSystemImage1:
            return [TFJunYou_SystemImage1Cell getChatCellHeight:msg];
            break;
        case kWCMessageTypeSystemImage2:
            return [TFJunYou_SystemImage2Cell getChatCellHeight:msg];
            break;
        case kWCMessageTypeAudioMeetingInvite:
        case kWCMessageTypeVideoMeetingInvite:
        case kWCMessageTypeAudioChatCancel:
        case kWCMessageTypeAudioChatEnd:
        case kWCMessageTypeVideoChatCancel:
        case kWCMessageTypeVideoChatEnd:
        case kWCMessageTypeAVBusy:
            return [TFJunYou_AVCallCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeLink:
            return [TFJunYou_LinkCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeShake:
            return [TFJunYou_ShakeCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeMergeRelay:
            return [TFJunYou_MergeRelayCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeShare:
            return [TFJunYou_ShareCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeReply:
            return [TFJunYou_ReplyCell getChatCellHeight:msg];
            break;
        default:
            return [TFJunYou_BaseChatCell getChatCellHeight:msg];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self hideKeyboard:NO];
    if (self.isSelectMore) {
        //获取第几个Cell被点击
        
        _selCell = (TFJunYou_BaseChatCell*)[_table cellForRowAtIndexPath:indexPath];
        _selCell.checkBox.selected = !_selCell.checkBox.selected;
        NSLog(@"indexNum = %d, isSelect = %d",_selCell.indexNum, _selCell.checkBox.selected);
        [self chatCell:_selCell checkBoxSelectIndexNum:_selCell.indexNum isSelect:_selCell.checkBox.selected];
    }else {
        
//        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        
        self.jumpNewMsgBtn.hidden = YES;
    }
    
    if (scrollView.contentOffset.y < self.lastY) {
        self.isRefresh = YES;
    }else {
        self.isRefresh = NO;
    }
    
    self.lastY = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self hideKeyboard:NO];
}

#pragma mark -----------------获取对应的Cell-----------------
- (TFJunYou_BaseChatCell *)getCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    TFJunYou_BaseChatCell * cell = nil;
    switch ([msg.type intValue]) {
        case kWCMessageTypeText:
            cell = [self creatMessageCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeImage:
            cell = [self creatImageCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeCustomFace:
            cell = [self creatFaceCustomCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeEmoji:
            cell = [self creatEmojiCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeVoice:
            cell = [self creatAudioCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeReport:
            cell = [self creatMsgStrCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeLocation:
            cell = [self creatLocationCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeGif:
            cell = [self creatGifCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeVideo:
            cell = [self creatVideoCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeAudio:
            cell = [self creatVideoCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeCard:
            cell = [self creatCardCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeFile:
            cell = [self creatFileCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeRemind:
            cell = [self creatRemindCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeRedPacket:
            cell = [self creatRedPacketCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeTransfer:
            cell = [self createTransferCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeSystemImage1:
            cell = [self creatSystemImage1Cell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeSystemImage2:
            cell = [self creatSystemImage2Cell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeAudioMeetingInvite:
        case kWCMessageTypeVideoMeetingInvite:
        case kWCMessageTypeAudioChatCancel:
        case kWCMessageTypeAudioChatEnd:
        case kWCMessageTypeVideoChatCancel:
        case kWCMessageTypeVideoChatEnd:
        case kWCMessageTypeAVBusy:
            cell = [self creatAVCallCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeLink:
            cell = [self creatLinkCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeShake:
            cell = [self creatShakeCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeMergeRelay:
            cell = [self creatMergeRelayCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeShare:
            cell = [self createShareCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeReply:
            cell = [self createReplyCell:msg indexPath:indexPath];
            break;
        default:
            cell = [[TFJunYou_BaseChatCell alloc] init];
            break;
    }
    return cell;
}

#pragma  mark -----------------------创建对应的Cell---------------------
//文本
- (TFJunYou_BaseChatCell *)creatMessageCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_MessageCell";
    if ([msg.isReadDel boolValue]) {
        identifier = [NSString stringWithFormat:@"TFJunYou_MessageCell_%ld",indexPath.row];
    }
    TFJunYou_MessageCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    }
    return cell;
}

//文本
- (TFJunYou_BaseChatCell *)creatMsgStrCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_MsgStrCell";
    if ([msg.isReadDel boolValue]) {
        identifier = [NSString stringWithFormat:@"TFJunYou_MsgStrCell_%ld",indexPath.row];
    }
    TFJunYou_MsgStrCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_MsgStrCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    }
    cell.contentAswer = _answerContent;
    cell.msgAnswerArr = _arrayReport;
    return cell;
}


//图片
- (TFJunYou_BaseChatCell *)creatImageCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_ImageCell";
    TFJunYou_ImageCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_ImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.chatImage.delegate = self;
//        cell.chatImage.didTouch = @selector(onCellImage:);
    }
    return cell;
}

// 自定义表情
- (TFJunYou_BaseChatCell *)creatFaceCustomCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_FaceCustomCell";
    TFJunYou_FaceCustomCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_FaceCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //        cell.chatImage.delegate = self;
        //        cell.chatImage.didTouch = @selector(onCellImage:);
    }
    return cell;
}

// 表情包
- (TFJunYou_BaseChatCell *)creatEmojiCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_EmojiCell";
    TFJunYou_EmojiCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_EmojiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //        cell.chatImage.delegate = self;
        //        cell.chatImage.didTouch = @selector(onCellImage:);
    }
    return cell;
}

//视频
- (TFJunYou_BaseChatCell *)creatVideoCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_VideoCell";
    TFJunYou_VideoCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_VideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.videoDelegate = self;
    cell.indexTag = indexPath.row;

    return cell;
}
//音频
- (TFJunYou_BaseChatCell *)creatAudioCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_AudioCell";
    TFJunYou_AudioCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_AudioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.indexNum = (int)indexPath.row;
    return cell;
}
//文件
- (TFJunYou_BaseChatCell *)creatFileCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_FileCell";
    TFJunYou_FileCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_FileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
//位置
- (TFJunYou_BaseChatCell *)creatLocationCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_LocationCell";
    TFJunYou_LocationCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_LocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
//名片
- (TFJunYou_BaseChatCell *)creatCardCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_CardCell";
    TFJunYou_CardCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_CardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
//红包
- (TFJunYou_BaseChatCell *)creatRedPacketCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_RedPacketCell";
    TFJunYou_RedPacketCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_RedPacketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
//动画
- (TFJunYou_BaseChatCell *)creatGifCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_GifCell";
    TFJunYou_GifCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_GifCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
//系统提醒
- (TFJunYou_BaseChatCell *)creatRemindCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_RemindCell";
    TFJunYou_RemindCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_RemindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ((msg.type.intValue == 202 || [msg.content containsString:@"取消了禁言"] || [msg.content containsString:@"设置了禁言"] || [msg.content containsString:@"撤回了一条消息"] || [msg.content containsString:@"管理员撤回了一条成员消息"] || [msg.content containsString:@"退出群组"] || [msg.content containsString:@"移除成员"]) && !_isAdmin) {
        cell.hidden = YES;
    }else {
        cell.hidden = NO;
    }
    return cell;
}

// 单条图文
- (TFJunYou_BaseChatCell *)creatSystemImage1Cell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_SystemImage1Cell";
    TFJunYou_SystemImage1Cell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_SystemImage1Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

// 多条图文
- (TFJunYou_BaseChatCell *)creatSystemImage2Cell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_SystemImage2Cell";
    TFJunYou_SystemImage2Cell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_SystemImage2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

// 音视频通话
- (TFJunYou_BaseChatCell *)creatAVCallCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_AVCallCell";
    TFJunYou_AVCallCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_AVCallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

// 链接
- (TFJunYou_BaseChatCell *)creatLinkCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_LinkCell";
    TFJunYou_LinkCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_LinkCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

// 戳一戳
- (TFJunYou_BaseChatCell *)creatShakeCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_ShakeCell";
    TFJunYou_ShakeCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_ShakeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

// 合并转发消息
- (TFJunYou_BaseChatCell *)creatMergeRelayCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_MergeRelayCell";
    TFJunYou_MergeRelayCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_MergeRelayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
//分享
- (TFJunYou_BaseChatCell *)createShareCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath {
    NSString * identifier = @"TFJunYou_ShareCell";
    TFJunYou_ShareCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_ShareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
// 转账
- (TFJunYou_BaseChatCell *)createTransferCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath {
    NSString * identifier = @"TFJunYou_TransferCell";
    TFJunYou_TransferCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_TransferCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
// 回复
- (TFJunYou_BaseChatCell *)createReplyCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath {
    NSString * identifier = @"TFJunYou_ReplyCell";
    TFJunYou_ReplyCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_ReplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

// 显示全屏视频播放
- (void)showVideoPlayerWithTag:(NSInteger)tag {
    [self hideKeyboard:NO];
    self.indexNum = (int)tag;
    
    _player= [TFJunYou_VideoPlayer alloc];
    _player.type = TFJunYou_VideoTypeChat;
    _player.isShowHide = YES; //播放中点击播放器便销毁播放器
    _player.isStartFullScreenPlay = YES; //全屏播放
    _player.didVideoPlayEnd = @selector(didVideoPlayEnd);
    _player.delegate = self;
    TFJunYou_MessageObject *msg = [_array objectAtIndex:tag];
    if(msg.isMySend && isFileExist(msg.fileName))
        _player.videoFile = msg.fileName;
    else
        _player.videoFile = msg.content;
    _player.isReadDel = [msg.isReadDel boolValue];
    _player = [_player initWithParent:self.view];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_player switch];
    });
}


//销毁播放器
- (void)didVideoPlayEnd {
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    TFJunYou_VideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexNum inSection:0]];
    if (!cell.msg.isMySend) {
        [cell deleteMsg];
    }
}


-(void)showOneMsg:(TFJunYou_MessageObject*)msg{
    for(int i=0; i<[_array count]; i++){
        TFJunYou_MessageObject* p = _array[i];
        
        if([p.messageId isEqualToString:msg.messageId]) return;
    }
    
    
    //判断是否展示时间
    [self setNewShowTime:msg];
    CGFloat height = 0;
    if (_array.count > 0) {
        height = [self tableView:_table heightForRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count - 1 inSection:0]];
    }
    
    BOOL flag = NO;
    if (fabs(_table.contentOffset.y + _table.frame.size.height - _table.contentSize.height) < height) {
        flag = YES;
    }
    msg.isShowWait = YES;
    [_array addObject:msg];
//    NSLog(@"_array:%d",msg.retainCount);
    if (self.isGroupMessages) {
        return;
    }
    if ([msg.type intValue] == kWCMessageTypeRedPacket) {
        if (![_orderRedPacketArray containsObject:msg]) {
            [_orderRedPacketArray addObject:msg];
        }
    }
    
    if (_isRefreshing) {
        return;
    }
    @try {
        [_table insertRow:(int)[_array count]-1 section:0];
    } @catch (NSException *exception) {

    }
    
    if ((flag || msg.isMySend) && !self.isSyncMsg) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_table gotoLastRow:NO];
//        });
    }

}

//上传完成后，发消息
-(void)doSendAfterUpload:(NSDictionary*)dict{
    
    NSString* msgId = [dict objectForKey:@"oUrl"];
    msgId = [[msgId lastPathComponent] stringByDeletingPathExtension];
    NSString* oFileName = [dict objectForKey:@"oFileName"];

//    NSString *userId = self.userIds[self.groupMessagesIndex];
//    NSString *userName = self.userNames[self.groupMessagesIndex];
    
    TFJunYou_MessageObject* p=nil;
    int found=-1;
    for(int i=(int)[_array count]-1;i>=0;i--){
        p = [_array objectAtIndex:i];
        if([p.type intValue]==kWCMessageTypeLocation)
            if([[p.fileName lastPathComponent] isEqualToString:[oFileName lastPathComponent]]){
                found = i;
                break;
            }
        if([p.type intValue]==kWCMessageTypeFile && ![p.isUpload boolValue])
            if([[p.fileName lastPathComponent] isEqualToString:[oFileName lastPathComponent]]){
                found = i;
                break;
            }
        if (p.content.length > 0) {
            if ([oFileName rangeOfString:p.content].location != NSNotFound) {
                found = i;
                break;
            }
        }
//        if([p.content isEqualToString:msgId]){
//            found = i;
//            break;
//        }
        p = nil;
    }
    if(found>=0){//找到消息体
        if([[dict objectForKey:@"status"] intValue] != 1){
            NSLog(@"doUploadFaire");
            [p updateIsSend:transfer_status_no];
            TFJunYou_BaseChatCell* cell = [self getCell:found];
            [cell drawIsSend];
            cell = nil;
            return;
        }
        NSLog(@"doSendAfterUpload");
        p.content  = [dict objectForKey:@"oUrl"];
//        if (self.isGroupMessages) {
//            p.toUserId = userId;
//        }
        [p updateIsUpload:YES];
        [g_xmpp sendMessage:p roomName:self.roomJid];//发送消息
//        [self.tableView reloadData];
    }
    
    p = nil;
//    if (self.isGroupMessages) {
//
//        self.groupMessagesIndex ++;
//        if (self.userIds && self.groupMessagesIndex >= self.userIds.count) {
//
//            self.groupMessagesIndex = 0;
//            [TFJunYou_MyTools showTipView:Localized(@"JX_SendComplete")];
////            [g_App showAlert:Localized(@"JX_SendComplete")];
//        }
    
//        if (self.groupMessagesIndex < self.userIds.count) {
//            [self doSendAfterUpload:dict];
//        }else if (self.userIds){
//            self.groupMessagesIndex = 0;
//            [g_App showAlert:Localized(@"JX_SendComplete")];
//            return;
//        }
//    }
}

//上传完成后，发消息
-(void)doUploadError:(TFJunYou_Connection*)downloader{
    NSString* msgId = downloader.userData;
    msgId = [[msgId lastPathComponent] stringByDeletingPathExtension];
    
    for(int i=(int)[_array count]-1;i>=0;i--){
        TFJunYou_MessageObject* p = [_array objectAtIndex:i];
        if([p.content isEqualToString:msgId]){
            [p updateIsSend:transfer_status_no];
            [[self getCell:i] drawIsSend];
            return;
        }
        p = nil;
    }
}

-(void)onSendTimeout:(NSNotification *)notifacation//超时未收到回执
{
    TFJunYou_MessageObject *msg     = (TFJunYou_MessageObject *)notifacation.object;
    if(msg==nil)
        return;

    if ([msg.type intValue] == kWCMessageTypeWithdraw) {
        [_wait stop];
//        [g_App showAlert:Localized(@"JX_WithdrawFailed")];
        [TFJunYou_MyTools showTipView:Localized(@"JX_WithdrawFailed")];
        return;
    }
    
    for(int i=(int)[_array count]-1;i>=0;i--){
        TFJunYou_MessageObject* p = [_array objectAtIndex:i];
        if(p == msg){
//            NSLog(@"receive:onSendTimeout");
            [[self getCell:i] drawIsSend];
            break;
        }
        p = nil;
    }
}


-(void)onReceiveFile:(NSNotification *)notifacation//收到下载状态
{
    TFJunYou_MessageObject *msg     = (TFJunYou_MessageObject *)notifacation.object;
    if(msg==nil)
        return;
    
    for(int i=(int)[_array count]-1;i>=0;i--){
        TFJunYou_MessageObject* p = [_array objectAtIndex:i];
        if(p == msg){
//            NSLog(@"onReceiveFile");
            [[self getCell:i] drawIsReceive];
            break;
        }
        p = nil;
    }
}

-(void)showMsg:(NSNotification *)notifacation{
    TFJunYou_MessageObject *msg = (TFJunYou_MessageObject *)notifacation.object;
    if(msg==nil)
        return;
    if ([[msg getTableName] isEqualToString:chatPerson.userId] && msg.isMySend)
            [self showOneMsg:msg];
}

#pragma mark  接受新消息广播
-(void)newMsgCome:(NSNotification *)notifacation{
    //10000127
    NSString *userid = g_myself.userId;
    
    TFJunYou_MessageObject *msg = (TFJunYou_MessageObject *)notifacation.object;
    if(!msg) return;
    
    // 更新title 在线状态
    if (!self.roomJid && !self.onlinestate && ![msg.fromUserId isEqualToString:MY_USER_ID]) {
        self.onlinestate = YES;
        if (self.isGroupMessages) {
            self.title = Localized(@"JX_GroupHair");
            
            [self setAudioIconFrame];
        }else {
            if (self.courseId.length > 0) {
                
            }else {
                
                if([chatPerson.userId intValue]<10100 && [chatPerson.userId intValue]>=10000) {
                    self.title = chatPerson.userNickname;
                    [self setAudioIconFrame];
                }else {
//                    NSString *str = self.onlinestate ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
//                    self.title = [NSString stringWithFormat:@"%@(%@)",chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname,str];
                    [self setChatTitle:chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname];
                }
            }
        }
    }
    
#ifdef Live_Version
    if([[TFJunYou_LiveJidManager shareArray] contains:msg.toUserId] || [[TFJunYou_LiveJidManager shareArray] contains:msg.fromUserId])
        return;
#endif
    
    if ([msg.type intValue] == XMPP_TYPE_NOBLACK) {
        if ([msg.fromUserId isEqualToString:self.chatPerson.userId]) {
            self.isBeenBlack = 0;
        }
    }
    
    if(!msg.isVisible)
        return;
    
    if (self.roomJid || msg.isGroup) {//是房间
        if (msg.isRepeat) {
            return;
        }
        if ([msg.toUserId isEqualToString:chatPerson.userId]||[msg.toUserId isEqualToString:self.roomJid]) {//第一个判断时从MsgView进入，第二个从GroupView进入
            [self showOneMsg:msg];
        }else{
            if ([msg.fromId isEqualToString:chatPerson.userId]||[msg.fromId isEqualToString:self.roomJid])//第一个判断时从MsgView进入，第二个从GroupView进入
                [self showOneMsg:msg];
        }
    }else{
        if ([msg.type integerValue] == kWCMessageTypeRemind && !msg.isShowRemind) {
            return;
        }
        if ([msg.fromUserId isEqualToString:MY_USER_ID] && [msg.type intValue] == kWCMessageTypeWithdraw) {
            
            TFJunYou_MessageObject *newMsg;
            NSInteger index = 0;
            for (NSInteger i = 0; i < _array.count; i ++) {
                TFJunYou_MessageObject *withDrawMsg = _array[i];
                if ([msg.content isEqualToString:withDrawMsg.messageId]) {
                    newMsg = withDrawMsg;
                    index = i;
                    break;
                }
            }
            if (!newMsg) {
                return;
            }
            newMsg.isShowTime = NO;
            newMsg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
            newMsg.content = Localized(@"JX_AlreadyWithdraw");
            NSString* s;
            if([self.roomJid length]>0)
                s = self.roomJid;
            else
                s = chatPerson.userId;
            newMsg.fromUserId = MY_USER_ID;
            newMsg.toUserId = s;
            if (self.withdrawIndex == _array.count - 1) {
                self.lastMsg.content = newMsg.content;
            }
            [newMsg updateLastSend:UpdateLastSendType_None];
            [newMsg update];
            [newMsg notifyNewMsg];
            [_wait stop];
            [_table reloadRow:(int)index section:0];
            return;
        }
        
        if ([msg.fromUserId isEqualToString:chatPerson.userId] || ([msg.fromUserId isEqualToString:MY_USER_ID] && [msg.toUserId isEqualToString:chatPerson.userId]))
            [self showOneMsg:msg];
    }
    msg = nil;
}

-(void)newReceipt:(NSNotification *)notifacation{//新回执
//    NSLog(@"newReceipt");
    TFJunYou_MessageObject *msg     = (TFJunYou_MessageObject *)notifacation.object;
    if(msg == nil)
        return;
    if ([msg.type intValue] == kWCMessageTypeWithdraw) {
        TFJunYou_MessageObject *msg1 = _array[self.withdrawIndex];
        msg1.isShowTime = NO;
        msg1.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
        msg1.content = Localized(@"JX_AlreadyWithdraw");
        NSString* s;
        if([self.roomJid length]>0)
            s = self.roomJid;
        else
            s = chatPerson.userId;
        msg1.fromUserId = MY_USER_ID;
        msg1.toUserId = s;
        if (self.withdrawIndex == _array.count - 1) {
            self.lastMsg.content = msg1.content;
        }
        [msg1 updateLastSend:UpdateLastSendType_None];
        [msg1 update];
        [msg1 notifyNewMsg];
        [_wait stop];
        [_table reloadRow:(int)self.withdrawIndex section:0];
        return;
    }

    if([chatPerson.userId rangeOfString: msg.fromUserId].location != NSNotFound || [chatPerson.userId rangeOfString: msg.toUserId].location != NSNotFound || [msg.toUserId isEqualToString:self.roomJid] ){
        for(int i=(int)[_array count]-1;i>=0;i--){
            TFJunYou_MessageObject* p = [_array objectAtIndex:i];
            if([p.messageId isEqualToString:msg.messageId]){
                
                TFJunYou_BaseChatCell* cell = [self getCell:i];
                if (p != msg) {
                    cell.msg = msg;
                }
                if(cell)
                    [cell drawIsSend];
                break;
            }
            p = nil;
        }
    }
}

#pragma mark sharemore按钮组协议
//照片选择器
-(void)pickPhoto
{
    
    
     
    [self hideKeyboard:YES];
    if([self showDisableSay])
        return;
    if([self sendMsgCheck]){
        return;
    }
    RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
    photoController.configuration.maxCount = 9;//最大的选择数目
    photoController.configuration.containVideo = YES;//选择类型，目前只选择图片不选择视频
    
    photoController.photo_delegate = self;
    photoController.thumbnailSize = CGSizeMake(320, 320);//缩略图的尺寸
//    photoController.defaultIdentifers = self.saveAssetIds;//记录已经选择过的资源
    
    [self presentViewController:photoController animated:true completion:^{}];

//    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
//    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    [imgPicker setDelegate:self];
//    [imgPicker setAllowsEditing:NO];
////    [g_App.window addSubview:imgPicker.view];
//
//    [self presentViewController:imgPicker animated:YES completion:^{}];
}

- (void)sendPhotos:(NSArray <id> *)datas withOriginal:(BOOL)isOriginal{
        if (_isGroupSendCancel) {
            return;
        }
        NSString *userId = self.userIds[self.groupMessagesIndex];
        NSString *name = @"jpg";
        for (NSInteger i = 0; i < datas.count; i ++) {
            UIImage *chosedImage = datas[i];
            int imageWidth = chosedImage.size.width;
            int imageHeight = chosedImage.size.height;
            NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
            [g_server saveImageToFile:chosedImage file:file isOriginal:isOriginal];
            [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:userId];
        }
        self.groupMessagesIndex ++;
        if (self.groupMessagesIndex < self.userIds.count) {
            if (self.groupMessagesIndex % _onceSendNum == 0) {
                return;
            }else{
                [self sendPhotos:datas withOriginal:isOriginal];
            }
        }else if (self.userIds){
            self.groupMessagesIndex = 0;
            return;
        }
        return;
    
}

- (void)photosViewController:(UIViewController *)viewController assets:(NSArray <PHAsset *> *)assets {
    self.imgDataArr = assets;
    
}

#pragma mark - 发送图片
- (void)photosViewController:(UIViewController *)viewController datas:(NSArray <id> *)datas; {
    if (self.isGroupMessages) {
        return;
//        if (datas.count == 0) {
//            return;
//        }
    }else{
        for (int i = 0; i < datas.count; i++) {
            BOOL isGif = [datas[i] isKindOfClass:[NSData class]];
            
            if (isGif) {
                // GIF
                NSString *file = [TFJunYou_FileInfo getUUIDFileName:@"gif"];
                [g_server saveDataToFile:datas[i] file:file];
                [self sendImage:file withWidth:0 andHeight:0 userId:nil];
                
            }else {
                // 普通图片
                UIImage *chosedImage = datas[i];
                //获取image的长宽
                int imageWidth = chosedImage.size.width;
                int imageHeight = chosedImage.size.height;
                NSString *name = @"jpg";
                NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
                [g_server saveImageToFile:chosedImage file:file isOriginal:YES];
                [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:nil];
            }
        }
    }
}

#pragma mark - 发送视频
- (void)photosViewController:(UIViewController *)viewController media:(TFJunYou_MediaObject *)media {
    if (self.isGroupMessages) {
        return;
//        for (NSInteger i = 0; i < self.userIds.count; i ++) {
//            NSString *userId = self.userIds[i];
//
//            [self sendMedia:media userId:userId];
////            [g_server uploadFile:media.fileName validTime:self.chatPerson.chatRecordTimeOut messageId:self.curMessageId toView:self];
//        }
    }else {
        [self sendMedia:media userId:nil];
//        [g_server uploadFile:media.fileName validTime:self.chatPerson.chatRecordTimeOut messageId:self.curMessageId toView:self];
    }
}

- (void)photosViewController:(UIViewController *)viewController imageAndVideos:(NSDictionary *)imageAndVideosDic{
    if (!self.isGroupMessages) {
        return;
    }
    NSArray *imageArr = [imageAndVideosDic objectForKey:@"images"];
    NSArray *mediaArr = [imageAndVideosDic objectForKey:@"videos"];
    NSInteger num = imageArr.count + mediaArr.count;
    [self addWaitGroupSendViewWithMsgNum:num withType:groupsend_msgType_imagesAndVideos];
    self.groupUploadObjArray = [NSMutableArray arrayWithArray:imageArr];
    [self.groupUploadObjArray addObjectsFromArray:mediaArr];
    _onceSendNum = 20;
    if (imageArr.count + mediaArr.count > 1) {
        _onceSendNum = 1;
    }
    if (mediaArr.count > 0) {
        _onceSendNum = 1;
    }
    self.imgsAndVideosDic = imageAndVideosDic;
    [self sendImagesAndVideos:imageAndVideosDic];
}

- (void)sendMedias:(NSArray *)mediaArray isSave:(BOOL)isSave{
    if (_isGroupSendCancel) {
        return;
    }
    NSString *userId = self.userIds[self.groupMessagesIndex];
    TFJunYou_MediaObject *media = mediaArray.lastObject;
    [self sendMedia:media userId:userId];
    if (isSave) {
        [self saveVideo:media.fileName];
    }
    self.groupMessagesIndex ++;
    if (self.groupMessagesIndex < self.userIds.count) {
        if (self.groupMessagesIndex % _onceSendNum == 0) {
            return;
        }else{
            [self sendMedias:mediaArray isSave:isSave];
        }
    }else if (self.userIds){
        self.groupMessagesIndex = 0;
        return;
    }
}

- (void)sendImagesAndVideos:(NSDictionary *)imageAndVideosDic{
    if (_isGroupSendCancel) {
        return;
    }
    NSString *userId = self.userIds[self.groupMessagesIndex];
    NSArray *imageArr = [imageAndVideosDic objectForKey:@"images"];
    NSArray *mediaArr = [imageAndVideosDic objectForKey:@"videos"];
    if (imageArr.count > 0) {
        NSString *name = @"jpg";
        for (NSInteger i = 0; i < imageArr.count; i++) {
            BOOL isGif = [imageArr[i] isKindOfClass:[NSData class]];
            if (isGif) {
                NSString *file = [TFJunYou_FileInfo getUUIDFileName:@"gif"];
                [g_server saveDataToFile:imageArr[i] file:file];
                [self sendImage:file withWidth:0 andHeight:0 userId:nil];
            }else{
                UIImage *chosedImage = imageArr[i];
                int imageWidth = chosedImage.size.width;
                int imageHeight = chosedImage.size.height;
                NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
                [g_server saveImageToFile:chosedImage file:file isOriginal:YES];
                [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:userId];
            }
        }
    }
    if (mediaArr.count > 0) {
        for (NSInteger i = 0; i < mediaArr.count; i++) {
            TFJunYou_MediaObject *media = mediaArr[i];
            [self sendMedia:media userId:userId];
        }
    }
    self.groupMessagesIndex ++;
    if (self.groupMessagesIndex < self.userIds.count) {
        if (_onceSendNum == 1 || self.groupMessagesIndex % _onceSendNum == 0) {
            return;
        }else{
            [self sendImagesAndVideos:imageAndVideosDic];
        }
    }else if (self.userIds){
        self.groupMessagesIndex = 0;
        return;
    }
}

-(void)onCamera{
    [self hideKeyboard:YES];
    
    if (![self checkCameraLimits]) {
        return;
    }
    if([self showDisableSay])
        return;
    if([self sendMsgCheck]){
        return;
    }
    
    TFJunYou_CameraVC *vc = [[TFJunYou_CameraVC alloc] init];
    vc.cameraDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
//    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
//    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    [imgPicker setDelegate:self];
//    [imgPicker setAllowsEditing:NO];
//    //    [g_App.window addSubview:imgPicker.view];
//    
//    [self presentViewController:imgPicker animated:YES completion:^{}];
    
}

// 戳一戳动画
- (void)onShake {
    if([self showDisableSay])
        return;
    if([self sendMsgCheck]){
        return;
    }
    
    if (self.roomJid.length > 0) {
        [TFJunYou_MyTools showTipView:@"群组暂不支持该功能！"];
        return;
        
    }
    if (self.isGroupMessages) {
        if (_isGroupSendCancel) {
            return;
        }
        if (self.groupMessagesIndex == 0) {
            [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_shake];
            _onceSendNum = 20;
        }
    }
    
    NSString *userId = self.userIds[self.groupMessagesIndex];
//    NSString *userName = self.userNames[self.groupMessagesIndex];
    TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    if([self.roomJid length]>0){
        msg.toUserId = self.roomJid;
        msg.isGroup = YES;
        msg.fromUserName = _userNickName;
    }
    else{
        if (self.isGroupMessages) {
            msg.toUserId = userId;
            msg.isGroupSend = YES;
            if ((self.groupMessagesIndex + 1) % _onceSendNum == 0) {
                msg.isLastGroupSend = YES;
            }
        }else {
            msg.toUserId     = chatPerson.userId;
        }
        msg.isGroup = NO;
    }
//    msg.content      = message;
    msg.type         = [NSNumber numberWithInt:kWCMessageTypeShake];
    msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
    msg.isRead       = [NSNumber numberWithBool:NO];
    msg.isReadDel    = [NSNumber numberWithInt:NO];

    //发往哪里
    [msg insert:self.roomJid];
    [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
    
    if (self.isGroupMessages) {
        _groupSendType = groupsend_msgType_shake;
        self.groupMessagesIndex ++;
        if (msg.isLastGroupSend) {
            return;
        }
        if (self.groupMessagesIndex < self.userIds.count) {
            [self onShake];
        }else if (self.userIds){
            self.groupMessagesIndex = 0;
            return;
        }
        return;
    }
    [self showOneMsg:msg];
}

// 发送收藏
- (void)onCollection {
    if([self showDisableSay])
        return;
    if([self sendMsgCheck]){
        return;
    }
    TFJunYou_WeiboVC * collection = [[TFJunYou_WeiboVC alloc] initCollection];
    collection.delegate = self;
    collection.isSend = YES;
    [g_navigation pushViewController:collection animated:YES];
}

// 发送手机联系人
- (void)onAddressBook {
    TFJunYou_SelectAddressBookVC *vc = [[TFJunYou_SelectAddressBookVC alloc] init];
    vc.delegate = self;
    [g_navigation pushViewController:vc animated:YES];
}

// 群助手
- (void)onGroupHelper {
    [g_server queryGroupHelper:self.roomId toView:self];
}

//跳转群助手列表
- (void)onGroupHelperList {
    TFJunYou_GroupHelperListVC *vc = [[TFJunYou_GroupHelperListVC alloc] init];
    vc.roomJid = self.roomJid;
    vc.roomId = self.roomId;
    [g_navigation pushViewController:vc animated:YES];
}

- (void)selectAddressBookVC:(TFJunYou_SelectAddressBookVC *)selectVC doneAction:(NSArray *)array {
    
    NSString *userId = self.userIds[self.groupMessagesIndex];
//    NSString *userName = self.userNames[self.groupMessagesIndex];
    if (self.isGroupMessages) {
        if (_isGroupSendCancel) {
            return;
        }
        if (self.groupMessagesIndex == 0) {
            [self addWaitGroupSendViewWithMsgNum:array.count withType:groupsend_msgType_addressbook];
            _onceSendNum = 20;
            self.groupSendMsgArray = [NSMutableArray arrayWithArray:array];
            self.groupUploadObjArray = [NSMutableArray arrayWithObject:selectVC];
        }
    }
    
    BOOL isLastGroupSend = NO;
    for(NSInteger i = 0;i < array.count;i++){
        TFJunYou_AddressBook *address = array[i];
        
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg.toUserId = self.roomJid;
            msg.isGroup = YES;
            msg.fromUserName = _userNickName;
        }
        else{
            if (self.isGroupMessages) {
                msg.toUserId = userId;
                msg.isGroupSend = YES;
                if ((self.groupMessagesIndex + 1) % _onceSendNum == 0) {
                    if (i == array.count - 1) {
                        msg.isLastGroupSend = YES;
                        isLastGroupSend = YES;
                    }
                }
            }else {
                msg.toUserId     = chatPerson.userId;
            }
            msg.isGroup = NO;
        }
        msg.content      = [NSString stringWithFormat:@"%@\n%@", address.addressBookName, address.toTelephone];
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeText];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isReadDel    = [NSNumber numberWithInt:NO];
        
        [msg insert:self.roomJid];
        [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
        [self showOneMsg:msg];
    }
    
    if (self.isGroupMessages) {
         _groupSendType = groupsend_msgType_addressbook;
       self.groupMessagesIndex ++;
       if (isLastGroupSend) {
           return;
       }
        if (self.groupMessagesIndex < self.userIds.count) {
            [self selectAddressBookVC:selectVC doneAction:array];
        }else if (self.userIds){
            self.groupMessagesIndex = 0;
            return;
        }
        return;
    }
}

- (void) weiboVC:(TFJunYou_WeiboVC *)weiboVC didSelectWithData:(WeiboData *)data {
        if (data.type == 1) {
                
                NSString *userId = self.userIds[self.groupMessagesIndex];
        //        NSString *userName = self.userNames[self.groupMessagesIndex];
                if (self.isGroupMessages) {
                    if (_isGroupSendCancel) {
                        return;
                    }
                    if (self.groupMessagesIndex == 0) {
                        [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_collect];
                        self.groupSendMsgArray = [NSMutableArray arrayWithObject:data];
                        _onceSendNum = 20;
                    }
                }
                
                TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
                msg.timeSend     = [NSDate date];
                msg.fromUserId   = MY_USER_ID;
                if([self.roomJid length]>0){
                    msg.toUserId = self.roomJid;
                    msg.isGroup = YES;
                    msg.fromUserName = _userNickName;
                }
                else{
                    if (self.isGroupMessages) {
                        msg.toUserId = userId;
                        msg.isGroupSend = YES;
                        if (self.groupMessagesIndex % _onceSendNum == 0) {
                            msg.isLastGroupSend = YES;
                        }
                    }else {
                        msg.toUserId     = chatPerson.userId;
                    }
                    msg.isGroup = NO;
                }
                msg.content      = data.content;
                msg.type         = [NSNumber numberWithInt:kWCMessageTypeText];
                msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
                msg.isRead       = [NSNumber numberWithBool:NO];
                msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];

                //发往哪里
                [msg insert:self.roomJid];
                [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
                
                if (self.isGroupMessages) {
                    self.groupMessagesIndex ++;
                    if (msg.isLastGroupSend) {
                        return;
                    }
                    if (self.groupMessagesIndex < self.userIds.count) {
                        [self weiboVC:weiboVC didSelectWithData:data];
                    }else if (self.userIds){
                        self.groupMessagesIndex = 0;
                        return;
                    }
                    return;
                }
                [self showOneMsg:msg];
            }else {
                NSString *url;
                NSMutableArray *imgArr = [NSMutableArray array];
                switch (data.type) {
                    case 2:{
                        for (TFJunYou_ObjUrlData *dict in data.larges) {
                            NSString *imgUrl = dict.url;
                            [imgArr addObject:imgUrl];
                        }
        //                url = ((TFJunYou_ObjUrlData *)data.larges.firstObject).url;
                    }
                        break;
                    case 3:
                        url = ((TFJunYou_ObjUrlData *)data.audios.firstObject).url;
                        break;
                    case 4:
                        url = ((TFJunYou_ObjUrlData *)data.videos.firstObject).url;
                        break;
                    case 5:
                        url = ((TFJunYou_ObjUrlData *)data.files.firstObject).url;
                        break;
                        
                    default:
                        break;
                }
                _collectionData = data;
                
                if (self.isGroupMessages) {
                    if (_isGroupSendCancel) {
                        return;
                    }
                    NSInteger i = 0;
                    NSMutableArray *allArray = [NSMutableArray array];
                    if (data.content && data.content.length > 0) {
                        i = i + 1;
                        [allArray addObject:data.content];
                    }
                    if (imgArr.count > 0) {
                        i = i + imgArr.count;
                        [allArray addObjectsFromArray:imgArr];
                    }else{
                        i = i + 1;
                    }
                    [self addWaitGroupSendViewWithMsgNum:i withType:groupsend_msgType_collect];
                    _onceSendNum = 20;
                    if (imgArr.count > 0) {
                        self.groupSendMsgArray = allArray;
                        [self collectionMsgSendAll:allArray];
                    }else{
                        
                        [g_server uploadCopyFileServlet:url validTime:g_config.fileValidTime toView:self];
                    }
                }else{
                
                    // 如果收藏的文件有文本，先发送文本消息
                    if (data.content && data.content.length > 0) {
                        [self collectionMsgSend:data.content isFile:NO];
                    }
                    
                    if (imgArr.count > 0) {
                        for (int i = 0; i < imgArr.count; i++ ) {
                            [self collectionMsgSend:imgArr[i] isFile:YES];
                        }
                    }else {
                        [g_server uploadCopyFileServlet:url validTime:g_config.fileValidTime toView:self];
                    }
                }
            }
    
}

- (void)collectionMsgSendAll:(NSArray *)allArray{
    if (_isGroupSendCancel) {
        return;
    }
    NSString *userId = self.userIds[self.groupMessagesIndex];
    for (NSInteger i = 0; i < allArray.count; i++) {
        NSString *content = allArray[i];
        if (i == 0 && _collectionData.content && _collectionData.content.length > 0) {
            [self collectionMsgSendOne:content withUserId:userId isText:YES isLast:NO];
        }else{
            if ((self.groupMessagesIndex+1) % _onceSendNum == 0 && i == allArray.count - 1) {
                [self collectionMsgSendOne:content withUserId:userId isText:NO isLast:YES];
            }else{
                [self collectionMsgSendOne:content withUserId:userId isText:NO isLast:NO];
            }
        }
    }
    self.groupMessagesIndex ++;
    if (self.groupMessagesIndex < self.userIds.count) {
        if (self.groupMessagesIndex % _onceSendNum == 0) {
            return;
        }else{
            [self collectionMsgSendAll:allArray];
        }
    }else if (self.userIds){
        self.groupMessagesIndex = 0;
        return;
    }
    return;
}

- (void)collectionMsgSendOne:(NSString *)content withUserId:(NSString *)userId isText:(BOOL)isText isLast:(BOOL)isLast{

    TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    msg.toUserId = userId;
    msg.isGroupSend = YES;
    msg.isLastGroupSend = isLast;
    msg.isGroup = NO;
    msg.content      = content;
    msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
    msg.isRead       = [NSNumber numberWithBool:NO];
    msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];
    if (isText) {
        msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
    }else{
       switch (_collectionData.type) {
            case 2:
                msg.type = [NSNumber numberWithInt:kWCMessageTypeImage];
                break;
            case 3:{
                msg.type = [NSNumber numberWithInt:kWCMessageTypeVoice];
                TFJunYou_ObjUrlData *obj = _collectionData.audios.firstObject;
                msg.timeLen = obj.timeLen;
            }
                break;
            case 4:
                msg.type = [NSNumber numberWithInt:kWCMessageTypeVideo];
                break;
            case 5:{
                msg.fileName = ((TFJunYou_ObjUrlData *)_collectionData.files.firstObject).name;
                msg.type = [NSNumber numberWithInt:kWCMessageTypeFile];
            }
                break;
                
            default:
                break;
        }
    }
        
    //发往哪里
    [msg insert:self.roomJid];
    [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
}

- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithImage:(UIImage *)image {
    [self hideKeyboard:YES];
    //获取image的长宽
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    
    self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    NSString *name = @"jpg";
    if (self.isGroupMessages) {
//        for (NSInteger i = 0; i < self.userIds.count; i ++) {
//            NSString *userId = self.userIds[i];
//
//            NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
//            [g_server saveImageToFile:image file:file isOriginal:NO];
//            [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:userId];
////            [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
//        }
        [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_image];
        self.groupUploadObjArray = [NSMutableArray arrayWithObject:image];
        _onceSendNum = 10;
        _isOriginal = NO;
        [self sendPhotos:self.groupUploadObjArray withOriginal:NO];
    }else {
        NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
        [g_server saveImageToFile:image file:file isOriginal:NO];
        [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:nil];
//        [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
    }
    
//    NSString* file = [TFJunYou_FileInfo getUUIDFileName:name];
//
//    [g_server saveImageToFile:image file:file isOriginal:NO];
////    [self sendImage:file withWidth:imageWidth andHeight:imageHeight];
//    [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut toView:self];
}

#pragma mark ----------图片选择完成-------------
//UIImagePickerController代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage  * chosedImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //获取image的长宽
    int imageWidth = chosedImage.size.width;
    int imageHeight = chosedImage.size.height;
    [self dismissViewControllerAnimated:NO completion:^{
        self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
        [self hideKeyboard:YES];
        
        
        NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSString *urlStr = [url absoluteString];
        NSString *name = [urlStr substringFromIndex:urlStr.length - 3];
        name = [name lowercaseString];
        
        NSString* file = [TFJunYou_FileInfo getUUIDFileName:name];
        
        
        if ([name isEqualToString:@"gif"]) {    // gif不能按照image取data存储
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            
            void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *) = ^(ALAsset *asset) {
                
                if (asset != nil) {
                    
                    ALAssetRepresentation *rep = [asset defaultRepresentation];
                    Byte *imageBuffer = (Byte*)malloc(rep.size);
                    NSUInteger bufferSize = [rep getBytes:imageBuffer fromOffset:0.0 length:rep.size error:nil];
                    NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
                    
                    if (self.isGroupMessages) {
                        for (NSInteger i = 0; i < self.userIds.count; i ++) {
                            NSString *userId = self.userIds[i];
                            
                            NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
                            [g_server saveDataToFile:imageData file:file];
                            [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:userId];
//                            [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
                        }
                    }else {
                        NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
                        [g_server saveDataToFile:imageData file:file];
                        [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:nil];
//                        [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
                    }
//                    [g_server saveDataToFile:imageData file:file];
////                    [self sendImage:file withWidth:imageWidth andHeight:imageHeight];
//                    [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut toView:self];
                    
                }
                else {
                }
            };
            
            [assetLibrary assetForURL:url
                          resultBlock:ALAssetsLibraryAssetForURLResultBlock
                         failureBlock:^(NSError *error) {
                             
                         }];
        }else {
            
            name = @"jpg";
            if (self.isGroupMessages) {
//                for (NSInteger i = 0; i < self.userIds.count; i ++) {
//                    NSString *userId = self.userIds[i];
//
//                    NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
//                    [g_server saveImageToFile:chosedImage file:file isOriginal:NO];
//                    [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:userId];
////                    [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
//                }
                [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_image];
                self.groupUploadObjArray = [NSMutableArray arrayWithObject:chosedImage];
                _onceSendNum = 10;
                _isOriginal = NO;
                [self sendPhotos:self.groupUploadObjArray withOriginal:NO];
            }else {
                NSString *file = [TFJunYou_FileInfo getUUIDFileName:name];
                [g_server saveImageToFile:chosedImage file:file isOriginal:NO];
                [self sendImage:file withWidth:imageWidth andHeight:imageHeight userId:nil];
//                [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
            }
//            file = [TFJunYou_FileInfo getUUIDFileName:name];
//            [g_server saveImageToFile:chosedImage file:file isOriginal:NO];
////            [self sendImage:file withWidth:imageWidth andHeight:imageHeight];
//            [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut toView:self];
        }
        
        
//        [picker release];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:^{
        self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
        [self hideKeyboard:YES];
//        [picker release];
    }];
}

#pragma mark - 录制语音
- (void)recordStart:(UIButton *)sender {
    NSLog(@"recordStart-------");
    if([self showDisableSay])
        return;
    if(recording)
        return;
    if([self sendMsgCheck]){
        return;
    }
    if (![self canRecord]) {
        [g_App showAlert:Localized(@"JX_CanNotOpenMicr")];
        return;
    }
    
//    _recordBtn.layer.borderColor = [[UIColor blueColor] CGColor];
    _recordBtn.backgroundColor = HEXCOLOR(0xB8B9BD);

    [g_notify postNotificationName:kAllAudioPlayerPauseNotifaction object:self userInfo:nil];
    [g_notify postNotificationName:kAllVideoPlayerPauseNotifaction object:self userInfo:nil];

    [self hideKeyboard:YES];
    recording=YES;
    
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            nil];
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: &error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];

    NSURL *url = [NSURL fileURLWithPath:[TFJunYou_FileInfo getUUIDFileName:@"wav"]];
    pathURL = url;
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:settings error:&error];
    audioRecorder.delegate = self;
    
    peakTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updatePeak:) userInfo:nil repeats:YES];
    [peakTimer fire];
    BOOL flag = NO;
    flag = [audioRecorder prepareToRecord];
    [audioRecorder setMeteringEnabled:YES];
    flag = [audioRecorder peakPowerForChannel:1];
    flag = [audioRecorder record];
    
    _voice.center = self.view.center;
    [_voice show];
}

- (void)updatePeak:(NSTimer*)timer
{
    _timeLen = audioRecorder.currentTime;
    if(_timeLen>=60)
        [self recordStop:nil];

    [audioRecorder updateMeters];
    const double alpha=0.5;
    NSLog(@"peakPowerForChannel = %f,%f", [audioRecorder peakPowerForChannel:0],[audioRecorder peakPowerForChannel:1]);
    double peakPowerForChannel=pow(10, (0.05)*[audioRecorder peakPowerForChannel:0]);
    lowPassResults=alpha*peakPowerForChannel+(1.0-alpha)*lowPassResults;
    _voice.volume = lowPassResults;
    
/*    for (int i=1; i<8; i++) {
        if (lowPassResults>1.0/7.0*i){
            [[talkView viewWithTag:i] setHidden:NO];
        }else{
            [[talkView viewWithTag:i] setHidden:YES];
        }
    }*/
}

- (void)recordStop:(UIButton *)sender {
    
    [_voice hide];
    [peakTimer invalidate];
    peakTimer = nil;
    recording = NO;
    
//    if(!recording)
//        return;
    
    _recordBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    _recordBtn.backgroundColor = HEXCOLOR(0xFEFEFE);
    _timeLen = audioRecorder.currentTime;
    [audioRecorder pause];
    [audioRecorder stop];
//    [audioRecorder release];
//    if (_timeLen<1) {
//        [g_App showAlert:@"录的时间过短
//    "];
//        return;
//    }

    if (_timeLen<1)
        _timeLen = 1;
    NSString *amrPath = [VoiceConverter wavToAmr:pathURL.path];
    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:pathURL.path];
    _lastRecordFile = [[amrPath lastPathComponent] copy];
    
//    NSLog(@"音频文件路径:%@\n%@",pathURL.path,amrPath);
    if(amrPath == nil){
//        [g_App showAlert:Localized(@"JXChatVC_TimeLess")];
        [g_server showMsg:Localized(@"JXChatVC_TimeLess") delay:1.0];
        return;
    }
    if (self.isGroupMessages) {
//        for (NSInteger i = 0; i < self.userIds.count; i ++) {
//            NSString *userId = self.userIds[i];
//
//            [self sendVoice:amrPath userId:userId];
//            [g_server uploadFile:amrPath validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
//        }
        [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_audio];
        _onceSendNum = 15;
        self.groupUploadObjArray = [NSMutableArray arrayWithObject:amrPath];
        [self sendVoices:self.groupUploadObjArray];
    }else {
        [self sendVoice:amrPath userId:nil];
        [g_server uploadFile:amrPath validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
    }
}

- (void)sendVoices:(NSArray *)voicesArray{
    NSString *userId = self.userIds[self.groupMessagesIndex];
    NSString *amrPath = voicesArray.lastObject;
    [self sendVoice:amrPath userId:userId];
    [g_server uploadFile:amrPath validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
    self.groupMessagesIndex ++;
    if (self.groupMessagesIndex < self.userIds.count) {
        if (self.groupMessagesIndex % _onceSendNum == 0) {
            return;
        }else{
            [self sendVoices:voicesArray];
        }
    }else if (self.userIds){
        self.groupMessagesIndex = 0;
        return;
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [_voice hide];
    [peakTimer invalidate];
    peakTimer = nil;
    recording = NO;
}

- (void)recordCancel:(UIButton *)sender
{
    if(!recording)
        return;
    _recordBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    _recordBtn.backgroundColor = HEXCOLOR(0xFEFEFE);
    [audioRecorder stop];
    audioRecorder = nil;
    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:pathURL.path];
}

-(void)sendVoice:(NSString*)file userId:(NSString *)userId{
    
    //生成消息对象
    TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    if([self.roomJid length]>0){
        msg.toUserId = self.roomJid;
        msg.isGroup = YES;
        msg.fromUserName = _userNickName;
    }
    else{
        if (self.isGroupMessages) {
            msg.toUserId = userId;
        }else {
            msg.toUserId     = chatPerson.userId;
        }
        msg.isGroup = NO;
    }

    msg.fileName     = file;
    msg.content      = [[file lastPathComponent] stringByDeletingPathExtension];
    msg.type         = [NSNumber numberWithInt:kWCMessageTypeVoice];
    msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
    msg.isUpload     = [NSNumber numberWithBool:NO];
    msg.isRead       = [NSNumber numberWithBool:NO];
    msg.timeLen      = [NSNumber numberWithInt:_timeLen];
    
    msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];
    [msg insert:self.roomJid];
    [self showOneMsg:msg];
//    [msg release];
}

- (void)sendGif:(NSString *)str {
    if([self sendMsgCheck]){
        return;
    }
    
    NSString *message = str;
    if (message.length > 0) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg.toUserId = self.roomJid;
            msg.isGroup = YES;
            msg.fromUserName = _userNickName;
        }
        else{
            msg.toUserId     = chatPerson.userId;
            msg.isGroup = NO;
        }
        msg.fileData     = nil;
//        msg.fileName      = message;
        msg.content      = message;
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeGif];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isReadDel    = [NSNumber numberWithInt:NO];
        
        [msg insert:self.roomJid];
        [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
        [self showOneMsg:msg];
//        [msg release];
    }
//    [_messageText setText:nil];
}


#pragma mark - 输入TextField代理

-(void)doBeginEdit{
	_table.frame = CGRectMake(0, self.heightHeader+_noticeHeight, TFJunYou__SCREEN_WIDTH, self.view.frame.size.height-faceHeight-self.heightHeader-self.heightFooter-_noticeHeight);
	self.tableFooter.frame = CGRectMake(0, _table.frame.origin.y+_table.frame.size.height, TFJunYou__SCREEN_WIDTH, self.heightFooter);
    [_table gotoLastRow:NO];
}

-(void)doEndEdit{
    _textViewBtn.hidden = YES;
    
    if (_messageText.isFirstResponder) {
        
        _table.frame =CGRectMake(0,self.heightHeader+_noticeHeight,self_width,TFJunYou__SCREEN_HEIGHT-self.heightHeader-self.heightFooter-_noticeHeight);
        self.tableFooter.frame = CGRectMake(0, TFJunYou__SCREEN_HEIGHT-self.heightFooter, TFJunYou__SCREEN_WIDTH, self.heightFooter);
        _btnFace.selected = NO;
        [_messageText resignFirstResponder];
        _messageText.inputView = nil;
        self.deltaHeight = 0;
        self.screenShotView.frame = CGRectMake(self.screenShotView.frame.origin.x, self.tableFooter.frame.origin.y - self.screenShotView.frame.size.height - 10, self.screenShotView.frame.size.width, self.screenShotView.frame.size.height);
        [_table gotoLastRow:NO];
    }
    
    if (_faceView && !_faceView.hidden) {
        _table.frame =CGRectMake(0,self.heightHeader+_noticeHeight,self_width,TFJunYou__SCREEN_HEIGHT-self.heightHeader-self.heightFooter-_noticeHeight);
        self.tableFooter.frame = CGRectMake(0, TFJunYou__SCREEN_HEIGHT-self.heightFooter, TFJunYou__SCREEN_WIDTH, self.heightFooter);
        _faceView.hidden = YES;
        [_faceView removeFromSuperview];
        [_table gotoLastRow:NO];
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	[self doBeginEdit];
    _btnFace.selected = NO;
//    if([[NSDate date] timeIntervalSince1970] <= _disableSay)
//        return NO;
//    else
//        return YES;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	[self doEndEdit];
	return YES;
}

- (BOOL) hideKeyboard:(BOOL)gotoLastRow{
    if(gotoLastRow)
        [_table gotoLastRow:NO];
    _btnFace.selected = NO;
    [_messageText resignFirstResponder];
    _messageText.inputView = nil;
    self.deltaHeight = 0;
    [self doEndEdit];
    self.shareMore.selected = NO;
    self.screenShotView.frame = CGRectMake(self.screenShotView.frame.origin.x, self.tableFooter.frame.origin.y - self.screenShotView.frame.size.height - 10, self.screenShotView.frame.size.width, self.screenShotView.frame.size.height);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyboard:YES];
    if(textField.tag == kWCMessageTypeGif)
        [self sendGif:textField.text];
    else {
        [self sendIt:textField];
    }
	return YES;
}

-(void)actionFace:(UIButton*)sender{
    if([self showDisableSay])
        return;
    
    self.shareMore.selected = YES;
    _messageText.inputView = nil;
    [_messageText reloadInputViews];
    
    [self offRecordBtns];
    if(sender.selected){
        [self doBeginEdit];
        [_messageText becomeFirstResponder];
        [_faceView removeFromSuperview];
        _faceView.hidden = YES;
        sender.selected = NO;
    }else{
        if(_faceView==nil){
            _faceView = g_App.faceView;
            _faceView.delegate = self;
        }
        [_messageText resignFirstResponder];
        [self.view addSubview:_faceView];
        _faceView.hidden = NO;
        sender.selected = YES;
//        [_faceView selectType:0];
        [self doBeginEdit];
        self.deltaHeight = -faceHeight;
        [self setTableFooterFrame:_messageText];
    }
//	[self doBeginEdit];
}

- (void) selectImageNameString:(NSString*)imageName ShortName:(NSString *)shortName isSelectImage:(BOOL)isSelectImage {
    //如果不是delete响应,当前是提示信息，修改其属性
    if (![shortName isEqualToString:@""] && _messageText.textColor == [UIColor lightGrayColor]) {
        _messageText.text = @"";//置空
        _messageText.textColor = [UIColor blackColor];
    }

    TFJunYou_EmojiTextAttachment *attachment = [[TFJunYou_EmojiTextAttachment alloc] init];
    attachment.emojiTag = shortName;
    attachment.image = [UIImage imageNamed:imageName];
    attachment.bounds = CGRectMake(0, -4, _messageText.font.lineHeight, _messageText.font.lineHeight);
    //    attachment.emojiSize = CGSizeMake(_messageText.font.lineHeight, _messageText.font.lineHeight);
    
    NSRange newRange = NSMakeRange(_messageText.selectedRange.location + 1, 0);
    
    if (_messageText.selectedRange.length > 0) {
        [_messageText.textStorage deleteCharactersInRange:_messageText.selectedRange];
    }
    [_messageText.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:_messageText.selectedRange.location];
    
    _messageText.selectedRange = newRange;
    _messageText.font = SYSFONT(18);
    
    [_messageText scrollRangeToVisible:NSMakeRange(_messageText.text.length, 1)];
    if (isSelectImage) {
        self.deltaHeight = -faceHeight;
    }
    [self setTableFooterFrame:_messageText];
}

- (void)faceViewDeleteAction {
    [_messageText deleteBackward];
}

- (void)selectGifWithString:(NSString *)str {
//    _messageText.text = str;
    [self sendGif:str];
}

// 发送表情包表情
- (void)selectEmojiPackgeWithString:(NSString *)str {
    
    UIImage  * chosedImage=[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:str];
    //获取image的长宽
    int imageWidth = chosedImage.size.width;
    int imageHeight = chosedImage.size.height;
    NSString *s = [str pathExtension];
    NSString* file = [TFJunYou_FileInfo getUUIDFileName:s];
    
    if(self.isCYMSGgroupANDFriendy) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        for (NSInteger i = 0; i < self.userIds.count; i ++) {
            NSString *userId = self.userIds[i];
            
            if ([file length]>0) {
                
                msg.timeSend     = [NSDate date];
                msg.fromUserId   = MY_USER_ID;
                msg.toUserId     = userId;
                // 群
                if([userId length]>10){
                    msg.isGroup = YES;
                    msg.fromUserName = _userNickName;
                }
                else{
                    msg.isGroup = NO;
                }
                msg.fileName     = file;
                msg.content      = str;
                //        msg.type         = [NSNumber numberWithInt:kWCMessageTypeImage];
                // 改成 kWCMessageTypeEmoji=12,自定义的表情消息
                msg.type         = [NSNumber numberWithInt:kWCMessageTypeEmoji];
                //        msg.remindType   = [NSNumber numberWithInt:kWCMessageTypeCustomFace];
                msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
                msg.isRead       = [NSNumber numberWithBool:NO];
                msg.isUpload     = [NSNumber numberWithBool:YES];
                //新添加的图片宽高
                msg.location_x = [NSNumber numberWithInt:imageWidth];
                msg.location_y = [NSNumber numberWithInt:imageHeight];
                
                msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];
                
                [msg insert:userId];
                
                if([userId length]>10){
                    [g_xmpp sendMessage:msg roomName:userId];//发送消息
                }else {
                     [g_xmpp sendMessage:msg roomName:nil];//发送消息
                }

                [self showOneMsg:msg];
            }
        }
        
        // 写入数据库
        NSArray *array = self.userIds;
        NSString *userIdsString = [array componentsJoinedByString:@","];
        array = self.userNames;
        NSString *userNamesString = [array componentsJoinedByString:@","];
        array = self.userNamesWithGroup;
        NSString *userNamesWithGroupString = [array componentsJoinedByString:@","];
        NSString *sendTime = [NSString stringWithFormat:@"%@", msg.dictionary[@"timeSend"]];
        
        array = self.userNmaesWithFriend;
        NSString *userNmaesWithFriendString = [array componentsJoinedByString:@","];
        
        TFJunYou_LabelObject *obj = TFJunYou_LabelObject.sharedInstance;
        obj.userId  = msg.fromUserId;
        obj.userIds = userIdsString;
        obj.text1 = _names;
        obj.text2 = _names2;
        obj.userNames = userNamesString;
        obj.userNamesWithGroup = userNamesWithGroupString;
        obj.message = @"[表情]";
        obj.sendTime = sendTime;
        obj.userNmaesWithFriend = userNmaesWithFriendString;
        BOOL succeed = [obj insertRecord];
        if (succeed) {
            [g_App showAlert:Localized(@"JX_SendComplete")];
            [g_notify postNotificationName:kGroupHelperRefreshNotif object:nil];
            // TODO:群发助手
//            [g_navigation popToViewController:[CYGroupSendHelperViewController class] animated:YES];
        }
        
        
    }else {
         // 单聊,群聊
        if ([file length]>0) {
            TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
            msg.timeSend     = [NSDate date];
            msg.fromUserId   = MY_USER_ID;
            if([self.roomJid length]>0){
                msg.toUserId = self.roomJid;
                msg.isGroup = YES;
                msg.fromUserName = _userNickName;
            }
            else{
                msg.toUserId     = chatPerson.userId;
                msg.isGroup = NO;
            }
            msg.fileName     = file;
            msg.content      = str;
            //        msg.type         = [NSNumber numberWithInt:kWCMessageTypeImage];
            // 改成 kWCMessageTypeEmoji=12,表情包表情消息
            msg.type         = [NSNumber numberWithInt:kWCMessageTypeEmoji];
            msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
            msg.isRead       = [NSNumber numberWithBool:NO];
                    msg.isUpload     = [NSNumber numberWithBool:YES];
            //新添加的图片宽高
            msg.location_x = [NSNumber numberWithInt:imageWidth];
            msg.location_y = [NSNumber numberWithInt:imageHeight];
            
            msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];
//            msg.remindType = [NSNumber numberWithInt:kWCMessageTypeEmoji];
            
            [msg insert:self.roomJid];
            [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
            [self showOneMsg:msg];
            //        [msg release];
        }
    }

    
}


// 发送收藏表情
- (void)selectFavoritWithString:(NSString *)str {

    UIImage  * chosedImage=[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:str];
    //获取image的长宽
    int imageWidth = chosedImage.size.width;
    int imageHeight = chosedImage.size.height;
    NSString *s = [str pathExtension];
    NSString* file = [TFJunYou_FileInfo getUUIDFileName:s];
    
    // 群发助手
    if(self.isCYMSGgroupANDFriendy) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        for (NSInteger i = 0; i < self.userIds.count; i ++) {
            NSString *userId = self.userIds[i];
            
            if ([file length]>0) {
                msg.timeSend     = [NSDate date];
                msg.fromUserId   = MY_USER_ID;
                msg.toUserId     = userId;
                // 群
                if([userId length]>10){
                    msg.isGroup = YES;
                    msg.fromUserName = _userNickName;
                }
                else{
                    msg.isGroup = NO;
                }
                msg.fileName     = file;
                msg.content      = str;
                //        msg.type         = [NSNumber numberWithInt:kWCMessageTypeImage];
                // 改成 kWCMessageTypeCustomFace=11,自定义的表情消息
                msg.type         = [NSNumber numberWithInt:kWCMessageTypeCustomFace];
                //        msg.remindType   = [NSNumber numberWithInt:kWCMessageTypeCustomFace];
                msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
                msg.isRead       = [NSNumber numberWithBool:NO];
                msg.isUpload     = [NSNumber numberWithBool:YES];
                //新添加的图片宽高
                msg.location_x = [NSNumber numberWithInt:imageWidth];
                msg.location_y = [NSNumber numberWithInt:imageHeight];
                
                msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];
                
                [msg insert:userId];
                if([userId length]>10){
                    [g_xmpp sendMessage:msg roomName:userId];//发送消息
                }else {
                    [g_xmpp sendMessage:msg roomName:nil];//发送消息
                }
                
            }
        }
        // 写入数据库
        NSArray *array = self.userIds;
        NSString *userIdsString = [array componentsJoinedByString:@","];
        array = self.userNames;
        NSString *userNamesString = [array componentsJoinedByString:@","];
        array = self.userNamesWithGroup;
        NSString *userNamesWithGroupString = [array componentsJoinedByString:@","];
        NSString *sendTime = [NSString stringWithFormat:@"%@", msg.dictionary[@"timeSend"]];
        
        array = self.userNmaesWithFriend;
        NSString *userNmaesWithFriendString = [array componentsJoinedByString:@","];
        
        TFJunYou_LabelObject *obj = TFJunYou_LabelObject.sharedInstance;
        obj.userId  = msg.fromUserId;
        obj.userIds = userIdsString;
        obj.text1 = _names;
        obj.text2 = _names2;
        obj.userNames = userNamesString;
        obj.userNamesWithGroup = userNamesWithGroupString;
        obj.message = @"[图片]";
        obj.sendTime = sendTime;
        obj.userNmaesWithFriend = userNmaesWithFriendString;
        BOOL succeed = [obj insertRecord];
        if (succeed) {
            [g_App showAlert:Localized(@"JX_SendComplete")];
            [g_notify postNotificationName:kGroupHelperRefreshNotif object:nil];
            // TODO:群发助手
//            [g_navigation popToViewController:[CYGroupSendHelperViewController class] animated:YES];
        }
        
    } else {
        // 单聊,群聊
        if ([file length]>0) {
            TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
            msg.timeSend     = [NSDate date];
            msg.fromUserId   = MY_USER_ID;
            if([self.roomJid length]>0){
                msg.toUserId = self.roomJid;
                msg.isGroup = YES;
                msg.fromUserName = _userNickName;
            }
            else{
                msg.toUserId     = chatPerson.userId;
                msg.isGroup = NO;
            }
            msg.fileName     = file;
            msg.content      = str;
            //        msg.type         = [NSNumber numberWithInt:kWCMessageTypeImage];
            // 改成 kWCMessageTypeCustomFace=11,自定义的表情消息
            msg.type         = [NSNumber numberWithInt:kWCMessageTypeCustomFace];
            //        msg.remindType   = [NSNumber numberWithInt:kWCMessageTypeCustomFace];
            msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
            msg.isRead       = [NSNumber numberWithBool:NO];
            msg.isUpload     = [NSNumber numberWithBool:YES];
            //新添加的图片宽高
            msg.location_x = [NSNumber numberWithInt:imageWidth];
            msg.location_y = [NSNumber numberWithInt:imageHeight];
            
            msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];
            
            [msg insert:self.roomJid];
            [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
            [self showOneMsg:msg];
            //        [msg release];
        }
        
    }
    
   
}

// 取消收藏
- (void)deleteFavoritWithString:(NSString *)str {
//    [g_server userEmojiDeleteWithId:str toView:self];
    [g_server faceClollectDeleteFaceClollect:str View:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 只有水印时，不能send
    if ([text isEqualToString:@"\n"] && textView.textColor == [UIColor lightGrayColor]) {
        return NO;
    }
    //如果不是delete响应,当前是提示信息，修改其属性
    if (![text isEqualToString:@""] && textView.textColor == [UIColor lightGrayColor]) {
        textView.text = @"";//置空
        textView.textColor = [UIColor blackColor];
    }

    NSMutableArray *arr = [NSMutableArray array];
    [self getImageRange:text array:arr];
    if (arr.count > 1) {
        for (NSInteger i = 0; i < arr.count; i ++) {
            NSString *str = arr[i];
            NSInteger n;

            _messageText.font = SYSFONT(18);
            if ([str hasPrefix:@"["]&&[str hasSuffix:@"]"] && [g_faceVC.shortNameArrayE containsObject:str]) {
                n = [g_faceVC.shortNameArrayE indexOfObject:str];
                NSDictionary *dic = [g_constant.emojiArray objectAtIndex:n];
                [self selectImageNameString:dic[@"filename"] ShortName:str isSelectImage:NO];
                NSLog(@"");
            }else {
//                NSMutableString *textViewStr = [_messageText.text mutableCopy];
//                [textViewStr insertString:str atIndex:_messageText.selectedRange.location];
//                _messageText.text = textViewStr;
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                NSRange newRange = NSMakeRange(_messageText.selectedRange.location + str.length, 0);
                [_messageText.textStorage insertAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:SYSFONT(18)}] atIndex:_messageText.selectedRange.location];

                _messageText.selectedRange = newRange;

                [_messageText scrollRangeToVisible:NSMakeRange(_messageText.text.length, 1)];
            }
        }
        [self setTableFooterFrame:textView];
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        //        if(textView.tag == kWCMessageTypeGif)
        //            [self sendGif:textView];
        //        else
        if (self.isGroupMessages) {
            [self hideKeyboard:YES];
            _onceSendNum = 20;
//            [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_text];
        }
        [self sendIt:textView];
        [self setTableFooterFrame:textView];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }else if ([text isEqualToString:@"@"] && [self.roomJid length]>0){
        if (!self.isShowAT) {
            self.isShowAT = YES;
            //@群成员
            [self performSelector:@selector(showAtSelectMemberView) withObject:nil afterDelay:0.35];
        }
    }
    
    return YES;
}


#pragma mark - 有表情的txt 转换成 含图片的txt
- (BOOL)changeEmjoyText:(NSString *)text textColor:(UIColor *)textColor {
    NSMutableArray *arr = [NSMutableArray array];
    [self getImageRange:text array:arr];
    NSRange newRange = _messageText.selectedRange;
    if (arr.count > 1) {
        for (NSInteger i = 0; i < arr.count; i ++) {
            NSString *str = arr[i];
            NSInteger n;
            
            _messageText.font = SYSFONT(18);
            if ([str hasPrefix:@"["]&&[str hasSuffix:@"]"] && [g_faceVC.shortNameArrayE containsObject:str]) {
                n = [g_faceVC.shortNameArrayE indexOfObject:str];
                NSDictionary *dic = [g_constant.emojiArray objectAtIndex:n];

                TFJunYou_EmojiTextAttachment *attachment = [[TFJunYou_EmojiTextAttachment alloc] init];
                attachment.emojiTag = str;
                attachment.image = [UIImage imageNamed:dic[@"filename"]];
                attachment.bounds = CGRectMake(0, -4, _messageText.font.lineHeight, _messageText.font.lineHeight);
                
                newRange = NSMakeRange(newRange.location + 1, 0);
                [_messageText.textStorage appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
                _messageText.font = SYSFONT(18);
                
                [_messageText scrollRangeToVisible:NSMakeRange(_messageText.text.length, 1)];
            }else {
                newRange = NSMakeRange(newRange.location + str.length, 0);

                [_messageText.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:str         attributes:@{NSFontAttributeName:SYSFONT(18),NSForegroundColorAttributeName:textColor}]];
                [_messageText scrollRangeToVisible:NSMakeRange(_messageText.text.length, 1)];
            }
            
        }
        _messageText.selectedRange = newRange;
    }
    return arr.count > 1;
}

//将表情和文字分开，装进array
-(void)getImageRange:(NSString*)message  array: (NSMutableArray*)array {
    NSRange range=[message rangeOfString: @"["];
    NSRange range1=[message rangeOfString: @"]"];
    NSRange atRange = [message rangeOfString:@"@"];
    //判断当前字符串是否还有表情的标志。
    
//    self.contentEmoji = [self isContainsEmoji:message];
    
    if (((range.length>0 && range1.length>0) || atRange.length>0) && range1.location > range.location) {
        if (range.length>0 && range1.length>0) {
//            self.contentEmoji = YES;
//            if (range.location > 0) {
//                [array addObject:[message substringToIndex:range.location]];
//                [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
//                NSString *str=[message substringFromIndex:range1.location+1];
//                [self getImageRange:str array:array];
//            }else {
//                NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
//                //排除文字是“”的
//                if (![nextstr isEqualToString:@""]) {
//                    [array addObject:nextstr];
//                    NSString *str=[message substringFromIndex:range1.location+1];
//                    [self getImageRange:str array:array];
//                }else {
//                    return;
//                }
//            }
            if (range.location > 0) {
    
                NSString *str = [message substringToIndex:range.location];

                NSString *str1 = [message substringFromIndex:range.location];

                [array addObject:str];

                [self getImageRange:str1 array:array];

            }else {

                NSString *emojiString = [message substringWithRange:NSMakeRange(range.location + 1, range1.location - 1)];
                BOOL isEmoji = NO;
                NSString *str;
                NSString *str1;
                for (NSMutableDictionary *dic in g_constant.emojiArray) {
                    NSString *emoji = [dic objectForKey:@"english"];
                    if ([emoji isEqualToString:emojiString]) {
                        isEmoji = YES;
                        break;
                    }
                }
                if (isEmoji) {
                    str = [message substringWithRange:NSMakeRange(range.location, range1.location + 1)];
                    str1 = [message substringFromIndex:range1.location + 1];
                    [array addObject:str];
                }else{
                    NSString *posString = [message substringWithRange:NSMakeRange(range.location + 1, range1.location)];
                    NSRange posRange = [posString rangeOfString:@"["];
                    if (posRange.location != NSNotFound) {
                        str = [message substringToIndex:posRange.location];
                        str1 = [message substringFromIndex:posRange.location];
                        [array addObject:str];
                    }else{
                        str = [message substringToIndex:range1.location + 1];
                        str1 = [message substringFromIndex:range1.location + 1];
                        [array addObject:str];
                    }
                }
                [self getImageRange:str1 array:array];
            }

            
        } else if (atRange.length>0) {
            if (atRange.location > 0) {
                [array addObject:[message substringToIndex:atRange.location]];
                [array addObject:[message substringWithRange:NSMakeRange(atRange.location, 1)]];
                NSString *str=[message substringFromIndex:atRange.location+1];
                [self getImageRange:str array:array];
            }else{
                [array addObject:[message substringWithRange:NSMakeRange(atRange.location, 1)]];
                NSString *str=[message substringFromIndex:atRange.location+1];
                [self getImageRange:str array:array];
            }
            
        }else if (message != nil) {
            [array addObject:message];
        }
    }

    else if (range.length>0 && range1.length>0 && range1.location < range.location){
        NSString *str = [message substringToIndex:range1.location + 1];
        NSString *str1 = [message substringFromIndex:range1.location + 1];
        [array addObject:str];
        [self getImageRange:str1 array:array];
    }


    
    else if (message != nil) {
        [array addObject:message];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    //如果是提示内容，光标放置开始位置
    if (textView.textColor==[UIColor lightGrayColor]) {
        NSRange range;
        range.location = 0;
        range.length = 0;
        textView.selectedRange = range;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length <= 0) {
        [self removeAllAt];
        // 显示水印
        [self getTextViewWatermark];
    }
    
    [self setTableFooterFrame:textView];
    
    // 发送正在输入过滤条件
//    BOOL enteringStatus = [g_default boolForKey:kStartEnteringStatus];
    BOOL enteringStatus = [g_myself.isTyping intValue] > 0 ? YES : NO;
    if (!enteringStatus || self.roomJid || self.isSendEntering) {
        return;
    }
    
    {// 发送正在输入
        self.isSendEntering = YES;
        [self sendEntering];
        [self.enteringTimer invalidate];
        self.enteringTimer = nil;
        self.enteringTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(enteringTimerAction:) userInfo:nil repeats:NO];
    }

}

- (void) enteringTimerAction:(NSTimer *)timer {
    self.isSendEntering = NO;
    [self.enteringTimer invalidate];
    self.enteringTimer = nil;
}

- (void) setTableFooterFrame:(UITextView *) textView {
    
    static CGFloat maxHeight =66.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    if (size.height >= maxHeight)
    {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    }
    else
    {
        textView.scrollEnabled = NO;    // 不允许滚动
    }
    if (textView.hidden) {
        size.height = 32 + 5.5;
    }
    self.heightFooter = size.height + 16;
    if (self.isHiddenFooter) {
        self.heightFooter =0;
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    inputBar.frame = CGRectMake(inputBar.frame.origin.x, inputBar.frame.origin.y, inputBar.frame.size.width, self.heightFooter);
    self.tableFooter.frame = CGRectMake(0, self.view.frame.size.height+self.deltaHeight-size.height-16, TFJunYou__SCREEN_WIDTH, self.heightFooter);
    CGFloat height = 0;
    if (self.heightFooter > 0) {
        height = self.tableFooter.frame.origin.y;
    }else {
        height = TFJunYou__SCREEN_HEIGHT;
    }
    _table.frame =CGRectMake(_table.frame.origin.x,_table.frame.origin.y,self_width,TFJunYou__SCREEN_HEIGHT-_table.frame.origin.y-(TFJunYou__SCREEN_HEIGHT - height));
    [_table gotoLastRow:NO];
    
    _publicMenuBar.frame = CGRectMake(_publicMenuBar.frame.origin.x, self.tableFooter.frame.size.height, _publicMenuBar.frame.size.width, _publicMenuBar.frame.size.height);
    
    
    self.screenShotView.frame = CGRectMake(self.screenShotView.frame.origin.x, self.tableFooter.frame.origin.y - self.screenShotView.frame.size.height - 10, self.screenShotView.frame.size.width, self.screenShotView.frame.size.height);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    _btnFace.selected = NO;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self doEndEdit];
    return YES;
}




-(void)recordSwitch:(UIButton*)sender{
    if([self showDisableSay])
        return;
    _messageText.inputView = nil;
    [_messageText reloadInputViews];

    sender.selected = !sender.selected;
    _recordBtn.hidden = !sender.selected;
    _messageText.hidden = !_recordBtn.hidden;
    if(!_recordBtn.hidden)
        [self hideKeyboard:YES];
    
    [self setTableFooterFrame:_messageText];
}

//聊天位置被点击
-(void)onDidLocation:(TFJunYou_MessageObject*)msg{
    TFJunYou_LocationVC* vc = [TFJunYou_LocationVC alloc];
    vc.longitude = [msg.location_y doubleValue];
    vc.latitude = [msg.location_x doubleValue];
    vc.locationType = TFJunYou_LocationTypeShowStaticLocation;
    vc = [vc init];
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
//    [vc release];
}

//cell里的图片，被点击后的处理事件
-(void)onSelectImage:(TFJunYou_ImageView*)sender{
//    [sender removeFromSuperview];
}

-(void)offRecordBtns{
    _recordBtnLeft.selected = NO;
    _recordBtn.hidden = YES;
    _messageText.hidden = NO;
}


-(void)scrollToPageUp{
    if(_isLoading) return;
    NSLog(@"scrollToPageUp");
    _page ++;
    [self getServerData];
}

-(void)scrollToPageDown{
    if(_isLoading) return;
    _page=0;
    [self getServerData];
}
#pragma mark - ViewLoad获取数据
-(void)getServerData{
    _isLoading = YES;
    [self refresh:nil];
    NSLog(@"_isLoading=no");
    [self stopLoading];
}


//- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self hideKeyboard:NO];
//}

-(void)sendText:(UIView*)sender{
    if([_messageText.text length]<=0){
//        [g_App showAlert:Localized(@"JXAlert_MessageNotNil")];
        return;
    }
//    [self hideKeyboard:NO];
    if (self.isGroupMessages) {
        [self hideKeyboard:YES];
        _onceSendNum = 20;
        [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_text];
    }
    [self sendIt:nil];
    [self setTableFooterFrame:_messageText];
}

-(void) setChatPerson:(TFJunYou_UserObject*)user{
    if(user == nil || user == chatPerson){
        current_chat_userId = nil;
        return;
    }
//    chatPerson = [user retain];
    chatPerson = user;
    current_chat_userId = user.userId;
}

#pragma mark----发送消息并显示
-(void)resendMsgNotif:(NSNotification*)notification{
    int indexNum = [notification.object intValue];
    TFJunYou_MessageObject *p =[_array objectAtIndex:indexNum];
    [p updateIsSend:transfer_status_ing];
    NSIndexPath* cellIndex = [NSIndexPath indexPathForRow:indexNum inSection:0];
    _selCell = [_table cellForRowAtIndexPath:cellIndex];
    [_selCell drawIsSend];
    if([p.isUpload boolValue]){
        [g_xmpp sendMessage:p roomName:nil];//发送消息
    }else{
        [g_server uploadFile:p.fileName validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
    }
}

#pragma mark----删除消息并刷新
-(void)deleteMsgNotif:(NSNotification*)notification{
    int indexNum = [notification.object intValue];
    TFJunYou_MessageObject *p=[_array objectAtIndex:indexNum];
    [p delete];
    [_array removeObject:p];
    [self deleteMsg:p];
}

- (void)showReadPersons:(NSNotification *)notification{
    if (recording) {
        return;
    }
    int indexNum = [notification.object intValue];
    TFJunYou_MessageObject *msg = _array[indexNum];
    TFJunYou_ReadListVC *vc = [[TFJunYou_ReadListVC alloc] init];
    vc.msg = msg;
    vc.room = _room;
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
}

-(void)resend:(TFJunYou_MessageObject*)p{
//    NSLog(@"resend");
    [p updateIsSend:transfer_status_ing];
    [_selCell drawIsSend];
    if([p.isUpload boolValue]){
        [g_xmpp sendMessage:p roomName:self.roomJid];//发送消息
    }else{
        [g_server uploadFile:p.fileName validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
    }
}

-(void)deleteMsg:(TFJunYou_MessageObject*)p{
    for (NSInteger i = 0; i < _array.count; i ++) {
        TFJunYou_MessageObject *msg = _array[i];
        if ([msg.type intValue] == kWCMessageTypeText) {
            TFJunYou_MessageCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell.readDelTimer invalidate];
            cell.readDelTimer = nil;
            
            if ([p.messageId isEqualToString:msg.messageId]) {
                if (i == _array.count - 1 && i > 0) {
                    TFJunYou_MessageObject *theLastMsg = _array[_array.count - 2];
                    self.lastMsg = theLastMsg;
                    [theLastMsg updateLastSend:UpdateLastSendType_None];
                }
            }
        }
    }
    
    [_array removeObject:p];
    _refreshCount++;
    [_table reloadData];
}

-(void)actionQuit{
    
    [_voice hide];
    [peakTimer invalidate];
    peakTimer = nil;
    recording = NO;
    
    if (self.isGroupMessages) {
        _isGroupSendCancel = YES;
    }
    
    if (self.isSelectMore) {
        self.isSelectMore = NO;
        self.selectMoreView.hidden = YES;

        [self.gotoBackBtn setBackgroundImage:[UIImage imageNamed:@"title_back_black_big"] forState:UIControlStateNormal];
        [self.gotoBackBtn setTitle:nil forState:UIControlStateNormal];
        [_selectMoreArr removeAllObjects];
        [self enableCell];
        [self.tableView reloadData];
        return;
    }
    
    [g_notify postNotificationName:kAllVideoPlayerStopNotifaction object:nil userInfo:nil];
    [g_notify postNotificationName:kAllAudioPlayerStopNotifaction object:nil userInfo:nil];

    for (NSInteger i = 0; i < _array.count; i ++) {
        TFJunYou_MessageObject *msg = _array[i];
        if ([msg.type intValue] == kWCMessageTypeText) {
            TFJunYou_MessageCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if ([cell isKindOfClass:[TFJunYou_MessageCell class]]) {
                
                [cell.readDelTimer invalidate];
                cell.readDelTimer = nil;
            }
        }
    }
    // 保存更新输入框中如如的信息
    if (_messageText.textColor != [UIColor lightGrayColor]) {
        chatPerson.lastInput = [_messageText.textStorage getPlainString];
        [chatPerson updateLastInput];
    }
//    if (g_mainVC.msgVc.array.count > 0) {
//        [g_mainVC.msgVc.tableView reloadRow:(int)self.rowIndex section:0];
//    }

    [g_notify postNotificationName:kChatViewDisappear object:nil];
    [g_xmpp.chatingUserIds removeObject:current_chat_userId];
    current_chat_userId = nil;
    [g_notify removeObserver:self];
    [super actionQuit];
}
-(void)showChatView{
    [_wait stop];
    NSDictionary * dict = _dataDict;
    //老房间:
    TFJunYou_RoomObject *chatRoom = [[TFJunYou_XMPP sharedInstance].roomPool joinRoom:[dict objectForKey:@"jid"] title:[dict objectForKey:@"name"] lastDate:nil isNew:YES];
    
    roomData * roomdata = [[roomData alloc] init];
    [roomdata getDataFromDict:dict];
    
    TFJunYou_ChatViewController *sendView=[TFJunYou_ChatViewController alloc];
    sendView.title = [dict objectForKey:@"name"];
    sendView.roomJid = [dict objectForKey:@"jid"];
    sendView.roomId = [dict objectForKey:@"id"];
    sendView.chatRoom = chatRoom;
    sendView.room = roomdata;
    
    
    TFJunYou_UserObject * userObj = [[TFJunYou_UserObject alloc]init];
    userObj.userId = [dict objectForKey:@"jid"];
    userObj.showRead = [dict objectForKey:@"showRead"];
    userObj.userNickname = [dict objectForKey:@"name"];
    userObj.showMember = [dict objectForKey:@"showMember"];
    userObj.allowSendCard = [dict objectForKey:@"allowSendCard"];
    userObj.chatRecordTimeOut = roomdata.chatRecordTimeOut;
    userObj.talkTime = [dict objectForKey:@"talkTime"];
    userObj.allowInviteFriend = [dict objectForKey:@"allowInviteFriend"];
    userObj.allowUploadFile = [dict objectForKey:@"allowUploadFile"];
    userObj.allowConference = [dict objectForKey:@"allowConference"];
    userObj.allowSpeakCourse = [dict objectForKey:@"allowSpeakCourse"];
    userObj.isNeedVerify = [dict objectForKey:@"isNeedVerify"];
    
    sendView.chatPerson = userObj;
    sendView = [sendView init];
    //    [g_App.window addSubview:sendView.view];
    [g_navigation pushViewController:sendView animated:YES];
    
    dict = nil;
}
-(void)onInputHello:(TFJunYou_InputVC*)sender{
    
    TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
    msg.fromUserId = MY_USER_ID;
    msg.toUserId = [NSString stringWithFormat:@"%@", [_dataDict objectForKey:@"userId"]];
    msg.fromUserName = MY_USER_NAME;
    msg.toUserName = [_dataDict objectForKey:@"nickname"];
    msg.timeSend = [NSDate date];
    msg.type = [NSNumber numberWithInt:kRoomRemind_NeedVerify];
    NSString *userIds = g_myself.userId;
    NSString *userNames = g_myself.userNickname;
    NSDictionary *dict = @{
                           @"userIds" : userIds,
                           @"userNames" : userNames,
                           @"roomJid" : self.roomJid,
                           @"reason" : sender.inputText,
                           @"isInvite" : @"1"
                           };
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    msg.objectId = jsonStr;
    [g_xmpp sendMessage:msg roomName:nil];
    [self actionQuit];
    
    //    msg.fromUserId = self.roomJid;
    //    msg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
    //    msg.content = @"申请已发送给群主，请等待群主确认";
    //    [msg insert:self.roomJid];
    //    if ([self.delegate respondsToSelector:@selector(needVerify:)]) {
    //        [self.delegate needVerify:msg];
    //    }
}

-(void)xmppRoomDidJoin{
    
    NSDictionary * dict = _dataDict;
    
    TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
    user.userNickname = [dict objectForKey:@"name"];
    user.userId = [dict objectForKey:@"jid"];
    user.userDescription = [dict objectForKey:@"desc"];
    user.roomId = [dict objectForKey:@"id"];
    user.showRead = [dict objectForKey:@"showRead"];
    user.showMember = [dict objectForKey:@"showMember"];
    user.allowSendCard = [dict objectForKey:@"allowSendCard"];
    user.chatRecordTimeOut = [dict objectForKey:@"chatRecordTimeOut"];
    user.talkTime = [dict objectForKey:@"talkTime"];
    user.allowInviteFriend = [dict objectForKey:@"allowInviteFriend"];
    user.allowUploadFile = [dict objectForKey:@"allowUploadFile"];
    user.allowConference = [dict objectForKey:@"allowConference"];
    user.allowSpeakCourse = [dict objectForKey:@"allowSpeakCourse"];
    user.isNeedVerify = [dict objectForKey:@"isNeedVerify"];
    
    if (![user haveTheUser])
        [user insertRoom];
//    else
        //        [user update];
        //    [user release];
    
//    [g_server addRoomMember:[dict objectForKey:@"id"] userId:g_myself.userId nickName:g_myself.userNickname toView:self];
    [g_server roomJoin:[dict objectForKey:@"id"] userId:g_myself.userId nickName:g_myself.userNickname toView:self];
    
    user.groupStatus = [NSNumber numberWithInt:0];
    [user updateGroupInvalid];
    
    dict = nil;
//    chatRoom.delegate = nil;
}

#pragma mark  -------------------服务器返回数据--------------------
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    
    // 回答问题
    if ([aDownload.action isEqualToString:act_apiAutoAnswergetIssue]) {
        NSDictionary *answerDict = dict;
        TFJunYou_MessageObject * msgUser = [[TFJunYou_MessageObject alloc]init];
        msgUser.changeMySend = 0;
        msgUser.chatMsgHeight = @"0";
        msgUser.type = @(kWCMessageTypeReport);
        msgUser.chatType = 0;
        msgUser.content = [NSString stringWithFormat:@"%@",answerDict[@"answer"]];
        _answerContent = [NSString stringWithFormat:@"%@",answerDict[@"answer"]];
        msgUser.deleteTime = [NSDate date];
        msgUser.fileSize = 0;
        msgUser.fromUserId = _lastMsg.fromUserId;
        msgUser.fromUserName = _lastMsg.fromUserName;;
        msgUser.answerArr = answerDict[@"autoAnswerList"];
        msgUser.index = 0;
        msgUser.isDelay = 0;
        msgUser.isGroup = 0;
        msgUser.isGroupSend = 0;
        msgUser.isLastGroupSend = 0;
        msgUser.isMultipleRelay = 0;
        msgUser.isMySend = 0;
        msgUser.isNotUpdateHeight = 0;
        msgUser.isRead = 0;
        msgUser.isReadDel = 0;
        msgUser.isReceive = @1;
        msgUser.isRepeat = 0;
        msgUser.isSend = @1;
        msgUser.isShowRemind = 0;
        msgUser.isShowTime = 1;
        msgUser.isShowWait = 0;
        msgUser.isUpload = @1;
        msgUser.messageId = @"6f74f59e3e384d29962307ef3d842734";
        msgUser.messageNo = @1;
        msgUser.progress = 0;
        msgUser.readTime = [NSDate date];
        msgUser.sendCount = 0;
        msgUser.showRead = 0;
        msgUser.timeReceive = [NSDate date];
        msgUser.timeSend = _lastMsg.timeSend;;
        msgUser.toUserId = _lastMsg.toUserId;
        msgUser.updateLastContent = 1;
        [_array addObject:msgUser];
        
        [_arrayReport addObjectsFromArray:dict[@"autoAnswerList"]];
        
        [_table reloadData];
        [_table gotoLastRow:YES];
     }
    
    
    
    
    if (![aDownload.action isEqualToString:act_FaceGetName]) {
           
       }
     if ([aDownload.action isEqualToString:act_FaceClollectList]) {
//            NSMutableArray *nameArray = [NSMutableArray array];
//            for (NSDictionary *dict in array1) {
//                [nameArray addObject:dict[@"name"]];
//            }
//            _faceView.emojiDataArray = array1;
         
            _faceView.emojiDataArray = array1;
            [g_notify postNotificationName:kFavoritesRefresh object:array1];
        }
    if ([aDownload.action isEqualToString:act_FaceClollectAddFaceClollect]) {
            [self getEmojsData];
            [g_notify postNotificationName:kFavoritesRefresh object:nil];
        }
    
    if (![aDownload.action isEqualToString:act_getRedPacket]) {
        [_wait stop];
    }
    if ([aDownload.action isEqualToString:act_roomJoin]) {
        [self showChatView];
        [self actionQuit];
    }

    if([aDownload.action isEqualToString:act_UploadFile]){
        NSDictionary* p = nil;
        if([(NSArray *)[dict objectForKey:@"audios"] count]>0)
            p = [[dict objectForKey:@"audios"] objectAtIndex:0];
        if([(NSArray *)[dict objectForKey:@"images"] count]>0)
            p = [[dict objectForKey:@"images"] objectAtIndex:0];
        if([(NSArray *)[dict objectForKey:@"videos"] count]>0)
            p = [(NSArray *)[dict objectForKey:@"videos"] objectAtIndex:0];
        if(p==nil)
            p = [(NSArray *)[dict objectForKey:@"others"] objectAtIndex:0];

        if (self.isMapMsg) {
            [self sendMapMsgWithDict:p];
        }else {
            [self doSendAfterUpload:p];
            if (self.isGroupMessages) {
                [self keepOnUplpadGroupSend];
                if (_sendedNum == self.userIds.count * self.groupUploadObjArray.count) {
                    if (self.waitGroupSendView) {
                        [self.waitGroupSendView removeFromSuperview];
                        [g_App showAlert:Localized(@"JX_SendComplete")];
                    }
                }
            }
        }
        p = nil;
    }
    if ([aDownload.action isEqualToString:act_UploadVoiceServlet]) {
        NSDictionary* p = nil;
        if([(NSDictionary *)[dict objectForKey:@"audios"] count]>0)
            p = [[dict objectForKey:@"audios"] objectAtIndex:0];
        [self doSendAfterUpload:p];
        p = nil;
    }

    if( [aDownload.action isEqualToString:act_UserGet] ){        
        if (self.firstGetUser || self.courseId.length > 0) {
            TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
            [user getDataFromDict:dict];

            [_room setNickNameForUser:user];
            
            TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
            vc.user       = user;
            vc.isJustShow = self.courseId.length > 0;
            vc.fromAddType = 3;
            vc = [vc init];
//            [g_window addSubview:vc.view];
            [g_navigation pushViewController:vc animated:YES];
        }else {
            
            self.isBeenBlack = [[(NSDictionary *)[dict objectForKey:@"friends"] objectForKey:@"isBeenBlack"] intValue];
            self.friendStatus = [[(NSDictionary *)[dict objectForKey:@"friends"] objectForKey:@"status"] intValue];
            self.isReadDelete = [[(NSDictionary *)[dict objectForKey:@"friends"] objectForKey:@"isOpenSnapchat"] boolValue];
            self.isReadDelete = [[(NSDictionary *)[dict objectForKey:@"friends"] objectForKey:@"isOpenSnapchat"] boolValue];
            self.firstGetUser = YES;
            self.onlinestate = [dict[@"onlinestate"] boolValue];
            if([chatPerson.userId intValue]<10100 && [chatPerson.userId intValue]>=10000) {
                if (chatPerson.userNickname) {
                    self.title = chatPerson.userNickname;
                }else {
                    self.title = dict[@"nickname"];
                }
                [self setAudioIconFrame];
            }else {
                if (self.courseId.length > 0) {
                    
                }else {
//                    NSString *str = self.onlinestate ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
                    if (chatPerson.userNickname) {
//                        self.title = [NSString stringWithFormat:@"%@(%@)",chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname,str];
                        [self setChatTitle:chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname];
                    }else {
//                        self.title = [NSString stringWithFormat:@"%@(%@)",dict[@"nickname"],str];
                        [self setChatTitle:dict[@"nickname"]];
                    }
                }
                
            }
            
            
            if ([dict[@"userType"] intValue] == 2) {    // 获取公众号菜单
                // 获取公众号菜单
                [g_server getPublicMenuListWithUserId:chatPerson.userId toView:self];
            }
//            else {
//                // 获取公众号菜单
//                [g_server getPublicMenuListWithUserId:chatPerson.userId toView:self];
//            }
        }
        
        
    }
    if( [aDownload.action isEqualToString:act_roomGet] ){
//        [_room getDataFromDict:dict];
//
//        TFJunYou_RoomMemberVC* vc = [TFJunYou_RoomMemberVC alloc];
//        vc.chatRoom   = chatRoom;
//        vc.room       = _room;
//        vc.delegate = self;
//        vc = [vc init];
////        [g_window addSubview:vc.view];
//        [g_navigation pushViewController:vc animated:YES];
        
        _dataDict = dict;
        
        if ([[dict objectForKey:@"s"] integerValue] == 1) {
            self.isDisable = NO;
        }else {
            self.isDisable = YES;
        }
        
        if(g_xmpp.isLogined == login_status_no){
            //        [self hideKeyboard:NO];
            //        [g_xmpp showXmppOfflineAlert];
            //        return YES;
            
            //        [g_xmpp logout];
            [g_xmpp login];
            
        }
        
        //        _chatRoom = [g_xmpp.roomPool joinRoom:[dict objectForKey:@"jid"] title:[dict objectForKey:@"name"] isNew:YES];
        

        if (self.isFirst) {
            self.isFirst = NO;
            
            roomData * roomdata = [[roomData alloc] init];
            [roomdata getDataFromDict:dict];
            return;
        }
        
        
        TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:[dict objectForKey:@"jid"]];
        if(user && [user.groupStatus intValue] == 0){
            
            //老房间:
            [self showChatView];
            [self actionQuit];
        }else{
            TFJunYou_RoomObject *chatRoomObj = [[TFJunYou_XMPP sharedInstance].roomPool joinRoom:[dict objectForKey:@"jid"] title:[dict objectForKey:@"name"] lastDate:nil isNew:YES];
            BOOL isNeedVerify = [dict[@"isNeedVerify"] boolValue];
            long userId = [dict[@"userId"] longLongValue];
            if (isNeedVerify && userId != [g_myself.userId longLongValue]) {
                
                self.roomJid = [dict objectForKey:@"jid"];
//                self.roomUserName = [dict objectForKey:@"nickname"];
//                self.roomUserId = [dict objectForKey:@"userId"];
                
                TFJunYou_InputVC* vc = [TFJunYou_InputVC alloc];
                vc.delegate = self;
                vc.didTouch = @selector(onInputHello:);
                vc.inputTitle = Localized(@"JX_GroupOwnersHaveEnabled");
                vc.titleColor = [UIColor lightGrayColor];
                vc.titleFont = [UIFont systemFontOfSize:13.0];
                vc.inputHint = Localized(@"JX_PleaseEnterTheReason");
                vc = [vc init];
                [g_window addSubview:vc.view];
            }else {
                
                [_wait start:Localized(@"JXAlert_AddRoomIng") delay:30];
                //新房间:
                chatRoomObj.delegate = self;
                [chatRoomObj joinRoom:YES];
            }
        }
        
        
    }
    if( [aDownload.action isEqualToString:act_roomMemberGet] ){
        _disableSay = [[dict objectForKey:@"talkTime"] longLongValue];
        _audioMeetingNo = [NSString stringWithFormat:@"%@",dict[@"call"]];
        _videoMeetingNo = [NSString stringWithFormat:@"%@",dict[@"videoMeetingNo"]];
        _userNickName = dict[@"nickname"];
        [_table reloadData];
        
        if (self.relayMsgArray.count > 0) {
            for (TFJunYou_MessageObject *msg in self.relayMsgArray) {
                if ([msg.type intValue] == kWCMessageTypeRedPacket) {
                    msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
                    msg.content = [NSString stringWithFormat:@"[%@]", Localized(@"JXredPacket")];
                }
                if ([msg.type intValue] == kWCMessageTypeAudioMeetingInvite || [msg.type intValue] == kWCMessageTypeVideoMeetingInvite || [msg.type intValue] == kWCMessageTypeAudioChatCancel || [msg.type intValue] == kWCMessageTypeAudioChatEnd || [msg.type intValue] == kWCMessageTypeVideoChatCancel || [msg.type intValue] == kWCMessageTypeVideoChatEnd || [msg.type intValue] == kWCMessageTypeAVBusy) {
                    
                    msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
                    msg.content = [NSString stringWithFormat:@"[%@]", Localized(@"JX_AudioAndVideoCalls")];
                }
                [self relay:msg];
            }
//            [self relay];
        }
    }
    if ([aDownload.action isEqualToString:act_roomMemberList]) {
        _room.roomId = roomId;
        _room.members = [array1 mutableCopy];
        
        memberData *data = [self.room getMember:g_myself.userId];
        if ([data.role intValue] == 1 || [data.role intValue] == 2) {
            _isAdmin = YES;
        }else {
            _isAdmin = NO;
        }
        
        if ([data.role intValue] == 1 || [data.role intValue] == 2) {
            self.title = [NSString stringWithFormat:@"%@(%ld)", self.chatPerson.userNickname, array1.count];
        } else {
            self.title = self.chatPerson.userNickname;
        }
        [self setAudioIconFrame];
    }
    //获取红包信息
    if ([aDownload.action isEqualToString:act_getRedPacket]) {
//        if ([dict[@"packet"][@"type"] intValue] != 3) {
        NSString *userId = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"packet"] objectForKey:@"userId"]];
        if (self.roomJid.length > 0) {
            if (self.isDidRedPacketRemind) {
                self.isDidRedPacketRemind = NO;
                TFJunYou_redPacketDetailVC * redPacketDetailVC = [[TFJunYou_redPacketDetailVC alloc]init];
                redPacketDetailVC.dataDict = [[NSDictionary alloc]initWithDictionary:dict];
                redPacketDetailVC.isGroup = self.room.roomId.length > 0;
                [g_navigation pushViewController:redPacketDetailVC animated:YES];
            }else {

                if ([dict[@"packet"][@"type"] intValue] == 3) {
                    //
                    [self showRedPacket:dict];
                    [self openReadPacket];
                }else {
                    [self showRedPacket:dict];
                }
            }
            
//            [g_server openRedPacket:dict[@"packet"][@"id"] toView:self];
        }else {
            [_wait stop];
            if ([userId isEqualToString:MY_USER_ID]) {
                [self changeMessageRedPacketStatus:dict[@"packet"][@"id"]];
                [self changeMessageArrFileSize:dict[@"packet"][@"id"]];
                
                TFJunYou_redPacketDetailVC * redPacketDetailVC = [[TFJunYou_redPacketDetailVC alloc]init];
                redPacketDetailVC.dataDict = [[NSDictionary alloc]initWithDictionary:dict];
                redPacketDetailVC.isGroup = self.room.roomId.length > 0;
                [g_navigation pushViewController:redPacketDetailVC animated:YES];
            }else {
//                [g_server openRedPacket:dict[@"packet"][@"id"] toView:self];
                if ([dict[@"packet"][@"type"] intValue] == 3) {
                    //
                    [self showRedPacket:dict];
                    [self openReadPacket];
                }else {
                    [self showRedPacket:dict];
                }
            }
        }
//        }
        
    }
    //打开红包
    if ([aDownload.action isEqualToString:act_openRedPacket]) {
        
        NSString *userId = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"packet"] objectForKey:@"userId"]];

//        if ([dict[@"packet"][@"status"] intValue] == 2) {
        [self changeMessageRedPacketStatus:dict[@"packet"][@"id"]];
        [self changeMessageArrFileSize:dict[@"packet"][@"id"]];
//        }
        [self doEndEdit];
        
//        TFJunYou_OpenRedPacketVC * openRedPacketVC = [[TFJunYou_OpenRedPacketVC alloc]init];
//        openRedPacketVC.dataDict = [[NSDictionary alloc]initWithDictionary:dict];
//        [g_window addSubview:openRedPacketVC.view];
        if (self.roomJid.length > 0) {
            TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
            msg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
            msg.timeSend = [NSDate date];
            msg.toUserId = self.chatPerson.userId;
            msg.fromUserId = MY_USER_ID;
            msg.objectId = dict[@"packet"][@"id"];
            NSString *userName = [NSString string];
            NSString *overStr = [NSString string];
            if ([userId intValue] == [MY_USER_ID intValue]) {
                userName = Localized(@"JX_RedPacketOneself");
                double over = [[NSString stringWithFormat:@"%.2f",[dict[@"packet"][@"over"] floatValue]] doubleValue];
                if (over < 0.01) {
                    overStr = Localized(@"JX_RedPacketOver");
                }
            }else {
                userName = dict[@"packet"][@"userName"];
            }
            NSString *getRedStr = [NSString stringWithFormat:Localized(@"JX_GetRedPacketFromFriend"),userName];
            msg.content = [NSString stringWithFormat:@"%@%@",getRedStr,overStr];
            [msg insert:self.roomJid];

            
            
            [self showOneMsg:msg];
        }
        [UIView animateWithDuration:.3f animations:^{
            _redBackV.frame = CGRectMake(_redBackV.frame.origin.x, -_redBackV.frame.size.height/2, _redBackV.frame.size.width, _redBackV.frame.size.height);
        } completion:^(BOOL finished) {
            [_redBaseView removeFromSuperview];
            
            TFJunYou_redPacketDetailVC * redPacketDetailVC = [[TFJunYou_redPacketDetailVC alloc]init];
            redPacketDetailVC.dataDict = [[NSDictionary alloc]initWithDictionary:dict];
            redPacketDetailVC.isGroup = self.room.roomId.length > 0;
            [g_navigation pushViewController:redPacketDetailVC animated:NO];
        }];


        [g_server getUserMoenyToView:self];

    }
    if ([aDownload.action isEqualToString:act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
    }
    
    // 漫游聊天记录
    if ([aDownload.action isEqualToString:act_tigaseMsgs] || [aDownload.action isEqualToString:act_tigaseMucMsgs]) {
        self.isGetServerMsg = NO;
        if (array1.count > 0) {
            NSString* s;
            if(!IsStringNull(self.roomJid))
                s = self.roomJid;
            else
                s = chatPerson.userId;
            [[TFJunYou_MessageObject sharedInstance] getHistory:array1 userId:s];
            
            if (self.roomJid && _taskList.count > 0) {
                TFJunYou_SynTask *task = _taskList.firstObject;
                if (array1.count < PAGECOUNT) {
                    [task delete];
                    [_taskList removeObjectAtIndex: 0];
                }else {
                    NSDictionary *dict = array1.lastObject;
                    task.endTime = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:kMESSAGE_TIMESEND] doubleValue] / 1000.0];
                }
            }else {
                if (self.isSyncMsg) {
                    [_array removeAllObjects];
                    _page = 0;
                    self.isSyncMsg = NO;
                }else {
                    
                    self.isShowHeaderPull = array1.count >= 20;
                }
            }
            
            int pageCount = 20;
            if (self.newMsgCount > 20) {
                pageCount = self.newMsgCount;
                self.newMsgCount = 0;
            }
            NSMutableArray *p = [[TFJunYou_MessageObject sharedInstance] fetchMessageListWithUser:s byAllNum:_array.count pageCount:pageCount startTime:[NSDate dateWithTimeIntervalSince1970:0]];
            if (p.count > 0) {
                
                self.isGetServerMsg = NO;
                self.scrollLine = 0;
                [self refresh:nil];
            }

        }
        else{
            
            if (self.roomJid && _taskList.count > 0) {
                TFJunYou_SynTask *task = _taskList.firstObject;
                [task delete];
                [_taskList removeObjectAtIndex: 0];
                
                self.isGetServerMsg = NO;
                self.scrollLine = 0;
                [self refresh:nil];
            }else {
                self.isShowHeaderPull = NO;
            }
        }
    }
    
    if ([aDownload.action isEqualToString:act_publicMenuList]) {
        
        _menuList = [NSArray arrayWithArray:array1];
        if (_menuList.count > 0) {
            [self createFooterSubViews];
        }
        
    }
    
    if ([aDownload.action isEqualToString:act_tigaseDeleteMsg]) {
        
        if (self.withdrawIndex >= 0) {
            [_wait start];
            TFJunYou_MessageObject *msg = _array[self.withdrawIndex];
            
            // 发送撤回消息的XMPP
            TFJunYou_MessageObject *newMsg=[[TFJunYou_MessageObject alloc]init];
            newMsg.timeSend     = [NSDate date];
            newMsg.fromUserId   = MY_USER_ID;
            
            if([self.roomJid length]>0){
                newMsg.isGroup = YES;
                newMsg.fromUserName = _userNickName;
                newMsg.toUserId = self.roomJid;
            }
            else{
                newMsg.fromUserName = MY_USER_NAME;
                newMsg.toUserId     = chatPerson.userId;
            }
            newMsg.content      = msg.messageId;
            newMsg.type         = [NSNumber numberWithInt:kWCMessageTypeWithdraw];
            newMsg.isSend = [NSNumber numberWithInt:transfer_status_ing];
            
            [g_xmpp sendMessage:newMsg roomName:self.roomJid];//发送消息
        }
        
    }
    
    // 收藏表情
    if ([aDownload.action isEqualToString:act_userEmojiAdd]) {
        if ([dict[@"type"] intValue] == CollectTypeEmoji) {
            [g_myself.favorites addObject:dict];
        }
        
        [TFJunYou_MyTools showTipView:Localized(@"JX_CollectionSuccess")];
        
        [g_notify postNotificationName:kEmojiRefresh object:nil];
        [g_notify postNotificationName:kFavoritesRefresh object:nil];
        if (self.isSelectMore) {
            [self actionQuit];
        }
    }
    
    // 取消收藏
    if ([aDownload.action isEqualToString:act_userEmojiDelete]) {
        [TFJunYou_MyTools showTipView:Localized(@"JXAlert_DeleteOK")];
    }
    
    // 添加课程
    if ([aDownload.action isEqualToString:act_userCourseAdd]) {
        [TFJunYou_MyTools showTipView:Localized(@"JX_AddSuccess")];
        [_recordArray removeAllObjects];
    }
    if ([aDownload.action isEqualToString:act_userCourseUpdate]) {
        [TFJunYou_MyTools showTipView:Localized(@"JXAlert_DeleteOK")];
        [g_notify postNotificationName:kUpdateCourseList object:nil];
    }
    
    // 发送收藏 拷贝文件
    if ([aDownload.action isEqualToString:act_UploadCopyFileServlet]) {
        if (self.isGroupMessages) {
            NSMutableArray *allArray = [NSMutableArray array];
            if (_collectionData.content && _collectionData.content.length > 0) {
                [allArray addObject:_collectionData.content];
            }
            [allArray addObject:dict[@"url"]];
            self.groupSendMsgArray = allArray;
            [self collectionMsgSendAll:allArray];
        }else{
            [self collectionMsgSend:dict[@"url"] isFile:YES];
        }
    }
    
    //获取音视频服务器地址
    if ([aDownload.action isEqualToString:act_UserOpenMeet]) {
        self.meetUrl = [dict objectForKey:@"meetUrl"];
        if (self.isAudioMeeting) {
            [self onChatAudio:nil];
        }else{
            [self onChatVideo:nil];
        }
    }
    
    // 获取群助手
    if ([aDownload.action isEqualToString:act_queryGroupHelper]) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < array1.count; i++) {
            TFJunYou_GroupHeplerModel *model = [[TFJunYou_GroupHeplerModel alloc] init];
            [model getDataWithDict:array1[i]];
            [arr addObject:model];
        }
        [self setupMoreView:arr];
    }
    
    if ([aDownload.action isEqualToString:act_roomGetRoom]) {
        memberData *me = [self.room getMember:g_myself.userId];
        if ([me.role intValue] == 1 || [me.role intValue] == 2) {
            self.title = [NSString stringWithFormat:@"%@(%ld)", self.chatPerson.userNickname, [dict[@"userSize"] integerValue]];
        } else {
            self.title = self.chatPerson.userNickname;
        }
        
        [self setAudioIconFrame];
        if ([dict objectForKey:@"jid"]) {
            
            if (![dict objectForKey:@"member"]) {
                [TFJunYou_MyTools showTipView:Localized(@"JX_YouOutOfGroup")];
                self.groupStatus = [NSNumber numberWithInt:1];
                chatPerson.groupStatus = [NSNumber numberWithInt:1];
                [chatPerson updateGroupInvalid];
            }else {
                
                if ([[dict objectForKey:@"s"] integerValue] != 1) {
                    [TFJunYou_MyTools showTipView:Localized(@"JX_GroupNotUse")];
                    self.isDisable = YES;
                    return;
                }
                
                _disableSay = [[(NSDictionary *)[dict objectForKey:@"member"]objectForKey:@"talkTime"] longLongValue];
                self.chatPerson.talkTime = [NSNumber numberWithLongLong:[[dict objectForKey:@"talkTime"] longLongValue]];
                NSString *role = [(NSDictionary *)[dict objectForKey:@"member"] objectForKey:@"role"];
                if ([role intValue] == 1 || [role intValue] == 2) {
                    _isAdmin = YES;
                }else {
                    _isAdmin = NO;
                }
                if ([role intValue] == 1 || [role intValue] == 2) {
                    _isAdmin = YES;
                }else {
                    _isAdmin = NO;
                }
                if (([self.chatPerson.talkTime longLongValue] > 0 && !_isAdmin) || [role intValue] == 4) {
                    _talkTimeLabel.hidden = NO;
                    _talkTimeLabel.text = Localized(@"JX_TotalSilence");
                    if ([role intValue] == 4) {
                        _talkTimeLabel.text = Localized(@"JX_ProhibitToSpeak");
                    }
                    _messageText.userInteractionEnabled = NO;
                    _shareMore.enabled = NO;
                    _recordBtnLeft.enabled = NO;
                    _btnFace.enabled = NO;
                    _messageText.text = nil;
                }else {
                    _talkTimeLabel.hidden = YES;
                    _shareMore.enabled = YES;
                    _recordBtnLeft.enabled = YES;
                    _btnFace.enabled = YES;
                    _messageText.userInteractionEnabled = YES;
                }
                self.chatPerson.showMember = [dict objectForKey:@"showMember"];
                self.room.showMember = [self.chatPerson.showMember boolValue];
                self.chatPerson.showRead = [dict objectForKey:@"showRead"];
                self.room.showRead = [self.chatPerson.showRead boolValue];
                self.chatPerson.allowSendCard = [dict objectForKey:@"allowSendCard"];
                self.room.allowSendCard = [self.chatPerson.allowSendCard boolValue];
                self.chatPerson.allowConference = [dict objectForKey:@"allowConference"];
                self.room.allowConference = [self.chatPerson.allowConference boolValue];
                self.chatPerson.allowSpeakCourse = [dict objectForKey:@"allowSpeakCourse"];
                self.room.allowSpeakCourse = [self.chatPerson.allowSpeakCourse boolValue];
                self.chatPerson.allowUploadFile = [dict objectForKey:@"allowUploadFile"];
                self.room.allowUploadFile = [self.chatPerson.allowUploadFile boolValue];
                self.chatPerson.isNeedVerify = [dict objectForKey:@"isNeedVerify"];
                [self.chatPerson updateGroupSetting];
                self.chatPerson.chatRecordTimeOut = [dict objectForKey:@"chatRecordTimeOut"];
                self.room.chatRecordTimeOut = self.chatPerson.chatRecordTimeOut;
                [self.chatPerson updateUserChatRecordTimeOut];
                self.room.curCount = [[dict objectForKey:@"userSize"] intValue];
                self.room.maxCount = [[dict objectForKey:@"maxUserSize"] intValue];

                if (self.chatRoom.roomJid.length > 0) {
                    NSString *noticeStr = [(NSDictionary *)[dict objectForKey:@"notice"] objectForKey:@"text"];
                    NSString *noticeTime = [(NSDictionary *)[dict objectForKey:@"notice"] objectForKey:@"time"];
                    [self setupNoticeWithContent:noticeStr time:noticeTime];
                }
                
                // 保存自己
                NSDictionary* p = [dict objectForKey:@"member"];
                memberData* option = [[memberData alloc] init];
                [option getDataFromDict:p];
                option.roomId = self.roomId;
                [option insert];
                
                // 保存群主和管理员
                NSMutableArray *memb = [NSMutableArray array];
                NSArray *members = [dict objectForKey:@"members"];
                for (NSDictionary *member in members) {
                    memberData* option = [[memberData alloc] init];
                    [option getDataFromDict:member];
                    option.roomId = self.roomId;
                    [option insert];
                    [memb addObject:option];
                }
                if (_room.members.count <= 0) {
                    [_room.members addObjectsFromArray:memb];
                }
                
            }
            
//<<<<<<< .working
//            [_table reloadData];
//
//=======
            if (self.isSendRedPacket) {
                
                TFJunYou_SendRedPacketViewController * sendGiftVC = [[TFJunYou_SendRedPacketViewController alloc] init];
                sendGiftVC.isRoom = YES;
                sendGiftVC.delegate = self;
                sendGiftVC.roomJid = self.roomJid;
                sendGiftVC.size = self.room.curCount;
                //    [g_window addSubview:sendGiftVC.view];
                [g_navigation pushViewController:sendGiftVC animated:YES];
                
                self.isSendRedPacket = NO;
            }
        }else {
            [TFJunYou_MyTools showTipView:Localized(@"JX_GroupDissolved")];
            chatPerson.groupStatus = [NSNumber numberWithInt:2];
            [chatPerson updateGroupInvalid];
            
        }
        [_table reloadData];
    }
    
    if ([aDownload.action isEqualToString:act_UserGetByAccount]) {
        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
        vc.userId       = dict[@"userId"];
        vc.fromAddType = 1;
        vc = [vc init];
        [g_navigation pushViewController:vc animated:YES];
    }
//    [_table reloadData];
}


-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [self doUploadError:aDownload];
    [_wait stop];
    
    //自己查看红包或者红包已领完，resultCode ＝0
    if ([aDownload.action isEqualToString:act_getRedPacket]) {
        
        [self changeMessageRedPacketStatus:dict[@"data"][@"packet"][@"id"]];
        [self changeMessageArrFileSize:dict[@"data"][@"packet"][@"id"]];
        
        TFJunYou_redPacketDetailVC * redPacketDetailVC = [[TFJunYou_redPacketDetailVC alloc]init];
        redPacketDetailVC.dataDict = [[NSDictionary alloc]initWithDictionary:dict];
        redPacketDetailVC.isGroup = self.room.roomId.length > 0;
        redPacketDetailVC.code = [[dict objectForKey:@"resultCode"] intValue];
//        [g_window addSubview:redPacketDetailVC.view];
        [g_navigation pushViewController:redPacketDetailVC animated:YES];
        
    }
    
    if ([aDownload.action isEqualToString:act_roomGetRoom]) {
        
        [TFJunYou_MyTools showTipView:Localized(@"JX_GroupDissolved")];
        chatPerson.groupStatus = [NSNumber numberWithInt:2];
        [chatPerson updateGroupInvalid];
    }
    if ([aDownload.action isEqualToString:act_userEmojiAdd]) {
        return show_error;
    }
    if ([aDownload.action isEqualToString:act_openRedPacket]) {
        self.redPacketDict = dict;
        self.openImgV.hidden = YES;
        self.seeLab.hidden = NO;
        self.tintLab.text = Localized(@"JX_SlowHandNoRedPacket");
    }
    if([aDownload.action isEqualToString:act_UploadFile]) {
        if (self.isGroupMessages) {
            [self keepOnUplpadGroupSend];
            if (_sendedNum == self.userIds.count * self.groupUploadObjArray.count) {
                if (self.waitGroupSendView) {
                    [self.waitGroupSendView removeFromSuperview];
                    [g_App showAlert:Localized(@"JX_SendComplete")];
                }
            }
        }
    }
    
    return hide_error;
}

-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [self doUploadError:aDownload];
    [_wait stop];
    return hide_error;
}

-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    if([aDownload.action isEqualToString:act_UploadFile] || [aDownload.action isEqualToString:act_publicMenuList] || [aDownload.action isEqualToString:act_tigaseMsgs] || [aDownload.action isEqualToString:act_tigaseMucMsgs])
        return;
    if ([aDownload.action isEqualToString:act_tigaseDeleteMsg]) {
        // 撤回加等待符（撤回接口调用很慢）
        [_wait start];
    }
}

- (void)collectionMsgSend:(NSString *)content isFile:(BOOL)isFile{
    NSString *userId = self.userIds[self.groupMessagesIndex];
//    NSString *userName = self.userNames[self.groupMessagesIndex];
    
    TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    if([self.roomJid length]>0){
        msg.toUserId = self.roomJid;
        msg.isGroup = YES;
        msg.fromUserName = _userNickName;
    }
    else{
        if (self.isGroupMessages) {
            msg.toUserId = userId;
        }else {
            msg.toUserId     = chatPerson.userId;
        }
        msg.isGroup = NO;
    }
    msg.content      = content;
    msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
    msg.isRead       = [NSNumber numberWithBool:NO];
    msg.isReadDel    = [NSNumber numberWithInt:self.isReadDelete];

    switch (_collectionData.type) {
        case 2:
            msg.type = [NSNumber numberWithInt:kWCMessageTypeImage];
            break;
        case 3:{
            msg.type = [NSNumber numberWithInt:kWCMessageTypeVoice];
            TFJunYou_ObjUrlData *obj = _collectionData.audios.firstObject;
            msg.timeLen = obj.timeLen;
        }
            break;
        case 4:
            msg.type = [NSNumber numberWithInt:kWCMessageTypeVideo];
            break;
        case 5:{
            msg.fileName = ((TFJunYou_ObjUrlData *)_collectionData.files.firstObject).name;
            msg.type = [NSNumber numberWithInt:kWCMessageTypeFile];
        }
            break;
        case 11:
            msg.type = [NSNumber numberWithInt:kWCMessageTypeCustomFace];
            break;
        case 12:
            msg.type = [NSNumber numberWithInt:kWCMessageTypeEmoji];
            break;
        default:
            break;
    }
    if (!isFile) {
        msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
    }
    
    if (!isFile) {
        msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
    }
    
    //发往哪里
    [msg insert:self.roomJid];
    
    [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
    
    if (self.isGroupMessages) {
        self.groupMessagesIndex ++;
        if (msg.isLastGroupSend) {
            return;
        }
        if (self.groupMessagesIndex < self.userIds.count) {
            [self collectionMsgSend:content isFile:isFile];
        }else if (self.userIds){
            self.groupMessagesIndex = 0;
            [g_App showAlert:Localized(@"JX_SendComplete")];
            return;
        }
        return;
    }
    [self showOneMsg:msg];
}

-(void)showAtSelectMemberView{
    [self hideKeyboard:NO];
    self.isShowAT = NO;
    if (_room.members.count >0) {
        TFJunYou_SelFriendVC * selVC = [[TFJunYou_SelFriendVC alloc] init];
//        selVC.chatRoom = chatRoom;
        _room.roomJid = _roomJid;
        selVC.room = _room;
        selVC.type = TFJunYou_SelUserTypeGroupAT;
        selVC.delegate = self;
        selVC.didSelect = @selector(atSelectMemberDelegate:);
        
//        [g_window addSubview:selVC.view];
        [g_navigation pushViewController:selVC animated:YES];
    }else{
        //调接口
        [g_App showAlert:Localized(@"JX_NoGetMemberList")];
    }
}

-(void)removeAllAt{
    for (int i = 0; i<_atMemberArray.count; i++) {
        [self removeAtTextString:_atMemberArray[i]];
    }
    [_atMemberArray removeAllObjects];
}

-(void)removeAtTextString:(memberData *)member{
    NSString * atStr = [NSString stringWithFormat:@"@%@",member.userNickName];
    NSRange atRange = [[_messageText.textStorage string] rangeOfString:atStr];
    if (atRange.location != NSNotFound) {
        [_messageText.textStorage deleteCharactersInRange:atRange];
    }
    
}

-(BOOL)hasMember:(NSString*)theUserId{
    for(int i=0;i<[_atMemberArray count];i++){
        memberData* p = [_atMemberArray objectAtIndex:i];
        if([theUserId intValue] == p.userId)
            return YES;
    }
    return NO;
}

-(void)atSelectMemberDelegate:(memberData *)member{
    
    
    if (member.idStr) {
        [self removeAllAt];
        [_atMemberArray addObject:member];
    }else if([self hasMember:[NSString stringWithFormat:@"%ld",member.userId]]){
        if (_messageText.selectedRange.location >=1 && [[[_messageText.textStorage string] substringWithRange:NSMakeRange(_messageText.selectedRange.location-1, 1)] isEqualToString:@"@"]) {
            [_messageText.textStorage deleteCharactersInRange:NSMakeRange(_messageText.selectedRange.location-1, 1)];
        }
        return;
    }else{
        for (int i=0; i<_atMemberArray.count; i++) {
            memberData * member = _atMemberArray[i];
            if (member.idStr){
                [self removeAllAt];
                break;
            }
        }
        [_atMemberArray addObject:member];
    }

//    [_messageText.textStorage replaceCharactersInRange:NSMakeRange(_messageText.selectedRange.location-1, 1) withString:@""];
    if (_messageText.selectedRange.location >=1 && [[[_messageText.textStorage string] substringWithRange:NSMakeRange(_messageText.selectedRange.location-1, 1)] isEqualToString:@"@"]) {
        [_messageText.textStorage deleteCharactersInRange:NSMakeRange(_messageText.selectedRange.location-1, 1)];
    }
    
    
    NSString * atStr = [NSString stringWithFormat:@"@%@",member.userNickName];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:atStr];
    [tncString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0,atStr.length)];
    [tncString addAttribute:NSFontAttributeName value:SYSFONT(18) range:NSMakeRange(0,atStr.length)];
//    if (_messageText.selectedRange.length > 0) {
//        [_messageText.textStorage deleteCharactersInRange:_messageText.selectedRange];
//    }
    [_messageText.textStorage insertAttributedString:tncString atIndex:_messageText.selectedRange.location];
    tncString = nil;
    NSRange newRange = NSMakeRange(_messageText.selectedRange.location + atStr.length, 0);
     _messageText.selectedRange = newRange;
    
    
    NSMutableAttributedString* spaceString = [[NSMutableAttributedString alloc] initWithString:@" "];
    [_messageText.textStorage insertAttributedString:spaceString atIndex:_messageText.selectedRange.location];
    newRange = NSMakeRange(_messageText.selectedRange.location + spaceString.length, 0);
    _messageText.selectedRange = newRange;
    //    attachment.emojiSize = CGSizeMake(_messageText.font.lineHeight, _messageText.font.lineHeight);
    
//
//    
//    
//    [_messageText.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:_messageText.selectedRange.location];
    
//    _messageText.selectedRange = newRange;
    _messageText.font = SYSFONT(18);
    
//    [_messageText scrollRangeToVisible:NSMakeRange(_messageText.text.length, 1)];
    
//    [_messageText becomeFirstResponder];
    [_messageText performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.7];
}

-(void)onSelMedia:(TFJunYou_MediaObject*)p{
    if (self.isGroupMessages) {
        for (NSInteger i = 0; i < self.userIds.count; i ++) {
            NSString *userId = self.userIds[i];
            
            [self sendMedia:p userId:userId];
//            [g_server uploadFile:p.fileName validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
        }
    }else {
        [self sendMedia:p userId:nil];
//        [g_server uploadFile:p.fileName validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
    }
}

-(void)pickVideo{
    
    [self hideKeyboard:YES];
    if (![self checkCameraLimits]) {
        return;
    }
    if([self showDisableSay])
        return;
    if([self sendMsgCheck]){
        return;
    }
    
    TFJunYou_CameraVC *vc = [[TFJunYou_CameraVC alloc] init];
    vc.cameraDelegate = self;
//    vc.maxTime = 30;
    [self presentViewController:vc animated:YES completion:nil];
    
//    if ([[TFJunYou_MediaObject sharedInstance] fetch].count <= 0) {
//
//        TFJunYou_myMediaVC* vc = [[TFJunYou_myMediaVC alloc]init];
//        vc.delegate = self;
//        vc.didSelect = @selector(onSelMedia:);
////        [g_window addSubview:vc.view];
//        [g_navigation pushViewController:vc animated:YES];
//        [vc onAddVideo];
//    }else {
//        TFJunYou_myMediaVC* vc = [[TFJunYou_myMediaVC alloc]init];
//        vc.delegate = self;
//        vc.didSelect = @selector(onSelMedia:);
////        [g_window addSubview:vc.view];
//        [g_navigation pushViewController:vc animated:YES];
//    }
}

#pragma mark - 視屏錄製回調
- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithVideoPath:(NSString *)filePath timeLen:(NSInteger)timeLen {
    if( ![[NSFileManager defaultManager] fileExistsAtPath:filePath] )
        return;
    NSString* file = filePath;
    
    TFJunYou_MediaObject* p = [[TFJunYou_MediaObject alloc]init];
    p.userId = g_server.myself.userId;
    p.fileName = file;
    p.isVideo = [NSNumber numberWithBool:YES];
    p.timeLen = [NSNumber numberWithInteger:timeLen];
    if (self.isGroupMessages) {
//        for (NSInteger i = 0; i < self.userIds.count; i ++) {
//            NSString *userId = self.userIds[i];
//
//            [self sendMedia:p userId:userId];
////            [g_server uploadFile:p.fileName validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
//            [self saveVideo:file];
//        }
        [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_video];
        self.groupUploadObjArray = [NSMutableArray arrayWithObject:p];
        _onceSendNum = 1;
        _isOriginal = YES;
        [self sendMedias:self.groupUploadObjArray isSave:YES];
    }else {
        [self sendMedia:p userId:nil];
//        [g_server uploadFile:p.fileName validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
        [self saveVideo:file];
    }
}
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible) {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}


//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
    }
}

-(void)onChatSip{
    [self hideKeyboard:YES];
//    if (![self checkCameraLimits]) {
//        return;
//    }
    if([self showDisableSay])
        return;
    if([self sendMsgCheck]){
        return;
    }
    
    NSString *str1;
    NSString *str2;
    NSString *str3;
    TFJunYou_ActionSheetVC *actionVC;
    if (self.roomJid.length > 0) {
        memberData *data = [self.room getMember:g_myself.userId];
       
        if (!_isAdmin && ![self.chatPerson.allowConference boolValue]) {
            [g_App showAlert:Localized(@"JX_DisabledAudioAndVideo")];
            return;
        }
        str1 = Localized(@"JXSettingVC_VideoMeeting");
        str2 = Localized(@"JX_Meeting");
        str3 = Localized(@"JX_WalkieTalkie");
        actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[@"meeting_talk",@"meeting_tel",@"meeting_video"] names:@[str3,str2,str1]];
        
    }else {
        str1 = Localized(@"JX_VideoChat");
        str2 = Localized(@"JX_VoiceChat");
        actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[@"meeting_tel",@"meeting_video"] names:@[str2,str1]];
    }
    
    actionVC.delegate = self;
    [self presentViewController:actionVC animated:NO completion:nil];
}

- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if (actionSheet.tag == 2457) {
        if (index == 0) {
            
            BOOL flag = NO;
            for (NSInteger i = 0; i < self.selectMoreArr.count; i ++) {
                TFJunYou_MessageObject *msg = [self.selectMoreArr[i] copy];
                if ([msg.type intValue] == kWCMessageTypeRedPacket || [msg.type intValue] == kWCMessageTypeTransfer) {
                    flag = YES;
                    break;
                }
            }
            
            if (flag) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"多选消息中，红包和转账消息不能被转发" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"转发", nil];
                alert.tag = 3457;
                [alert show];
            }else {
                
                TFJunYou_RelayVC *vc = [[TFJunYou_RelayVC alloc] init];
                vc.relayMsgArray = [NSMutableArray arrayWithArray:self.selectMoreArr];
                [g_navigation pushViewController:vc animated:YES];
            }
        }else if(index == 1) {
            TFJunYou_RelayVC *vc = [[TFJunYou_RelayVC alloc] init];
            
            NSMutableArray *contentArr = [NSMutableArray array];
            for (NSInteger i = 0; i < self.selectMoreArr.count; i ++) {
                TFJunYou_MessageObject *msg = [self.selectMoreArr[i] copy];
                
                if ([msg.type intValue] != kWCMessageTypeText && [msg.type intValue] != kWCMessageTypeLocation && [msg.type intValue] != kWCMessageTypeGif && [msg.type intValue] != kWCMessageTypeVideo && [msg.type intValue] != kWCMessageTypeImage && [msg.type intValue] != kWCMessageTypeCustomFace && [msg.type intValue] != kWCMessageTypeEmoji) {
                    msg.content = [msg getLastContent];
                    switch ([msg.type intValue]) {
                        case kWCMessageTypeRedPacket: {
                            msg.content = [NSString stringWithFormat:@"[%@]", Localized(@"JXredPacket")];
                        }
                            break;
                        case kWCMessageTypeAudioMeetingInvite:
                        case kWCMessageTypeVideoMeetingInvite:
                        case kWCMessageTypeAudioChatCancel:
                        case kWCMessageTypeAudioChatEnd:
                        case kWCMessageTypeVideoChatCancel:
                        case kWCMessageTypeVideoChatEnd:
                        case kWCMessageTypeAVBusy:{
                            msg.content = [NSString stringWithFormat:@"[%@]", Localized(@"JX_AudioAndVideoCalls")];;
                        }
                            break;
                        case kWCMessageTypeSystemImage1:
                        case kWCMessageTypeSystemImage2: {
                            msg.content = [NSString stringWithFormat:@"[%@]", Localized(@"JXGraphic")];
                        }
                            break;
                        case kWCMessageTypeMergeRelay:
                            msg.content = [NSString stringWithFormat:@"[%@]", Localized(@"JX_ChatRecord")];
                            break;
                        default:
                            break;
                    }
                    msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
                    msg.fileName = @"";
                }

                SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
                NSString * jsonString = [OderJsonwriter stringWithObject:[msg toDictionary]];
                [contentArr addObject:jsonString];
            }
            
            TFJunYou_MessageObject *relayMsg = [[TFJunYou_MessageObject alloc] init];
            relayMsg.type = [NSNumber numberWithInt:kWCMessageTypeMergeRelay];
            if (self.roomJid.length > 0) {
                relayMsg.objectId = Localized(@"JX_GroupChatLogs");
            }else {
                relayMsg.objectId = [NSString stringWithFormat:Localized(@"JX_GroupChat%@And%@"),self.chatPerson.userNickname, g_myself.userNickname];
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contentArr options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            relayMsg.content = jsonStr;
            
            
            vc.relayMsgArray = [NSMutableArray arrayWithObject:relayMsg];
            [g_navigation pushViewController:vc animated:YES];
        }
    }else if(actionSheet.tag == 2458) {
        if (index == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"JX_SaveOnlyPictureMessages") delegate:self cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Save"), nil];
            alert.tag = 2458;
            [alert show];
        }
    }
    else if(actionSheet.tag == 1111) {
        if(index == 0)
            [g_notify postNotificationName:kCellDeleteMsgNotifaction object:[NSNumber numberWithInt:self.indexNum]];
        if(index == 1)
            [g_notify postNotificationName:kCellResendMsgNotifaction object:[NSNumber numberWithInt:self.indexNum]];
    }else {
        
        if (self.roomJid || [g_config.isOpenCluster integerValue] != 1) {
            
            if (self.roomJid) {
                
                if (index == 0) {
                    [self onChatTalk:nil];
                }else if(index == 1){
                    [self onChatAudio:nil];
                }else if(index == 2){
                    [self onChatVideo:nil];
                }
            }else {
                
                if (index == 0) {
                    [self onChatAudio:nil];
                }else if(index == 1){
                    [self onChatVideo:nil];
                }
            }
        }else {
            if (index == 0) {
                self.isAudioMeeting = YES;
            }else if(index == 1){
                self.isAudioMeeting = NO;
            }
            [g_server userOpenMeetWithToUserId:chatPerson.userId toView:self];
        }
        
    }
    
}


#if TAR_IM
#ifdef Meeting_Version
-(void)onGroupAudioMeeting:(TFJunYou_MessageObject*)msg{
    NSString* no;
    NSString* s;
    if(msg != nil){
        no = msg.fileName;
        s  = msg.objectId;
    }else{
        no = _audioMeetingNo;
        s  = self.roomJid;
    }
//    if(!no){
//        [g_App showAlert:Localized(@"JXMeeting_numberNULL")];
//        return;
//    }
    self.meetingNo = no;
    self.isAudioMeeting = YES;
    self.isTalkMeeting = NO;
    [self onInvite];
//    [g_meeting startAudioMeeting:no roomJid:s];
}

-(void)onGroupVideoMeeting:(TFJunYou_MessageObject*)msg{
    NSString* no;
    NSString* s;
    if(msg != nil){
        no = msg.fileName;
        s  = msg.objectId;
    }else{
        no = _videoMeetingNo;
        s  = self.roomJid;
    }
//    if(!no){
//        [g_App showAlert:Localized(@"JXMeeting_numberNULL")];
//        return;
//    }
    self.isAudioMeeting = NO;
    self.meetingNo = no;
    self.isTalkMeeting = NO;
    [self onInvite];
//    [g_meeting startVideoMeeting:no roomJid:s];
}

- (void)onGroupTalkMeeting:(TFJunYou_MessageObject *)msg {
    NSString* no;
    NSString* s;
    if(msg != nil){
        no = msg.fileName;
        s  = msg.objectId;
    }else{
        no = _audioMeetingNo;
        s  = self.roomJid;
    }
    //    if(!no){
    //        [g_App showAlert:Localized(@"JXMeeting_numberNULL")];
    //        return;
    //    }
    self.meetingNo = no;
    self.isAudioMeeting = YES;
    self.isTalkMeeting = YES;
    [self onInvite];
}

-(void)onInvite{

    if (!_room.roomId) {
        return;
    }
    
    NSMutableSet* p = [[NSMutableSet alloc]init];
    
    TFJunYou_SelectFriendsVC* vc = [TFJunYou_SelectFriendsVC alloc];
    vc.isNewRoom = NO;
    vc.isShowMySelf = NO;
    vc.type = TFJunYou_SelectFriendTypeSelMembers;
    vc.room = _room;
    vc.existSet = p;
    vc.delegate = self;
    vc.didSelect = @selector(meetingAddMember:);
    vc = [vc init];
    //    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
}

-(void)meetingAddMember:(TFJunYou_SelectFriendsVC*)vc{
    int type;
    if (self.isAudioMeeting) {
        type = kWCMessageTypeAudioMeetingInvite;
    }else {
        type = kWCMessageTypeVideoMeetingInvite;
    }
    if (self.isTalkMeeting) {
        type = kWCMessageTypeTalkInvite;
    }
    for(NSNumber* n in vc.set){
        memberData *user;
        if (vc.seekTextField.text.length > 0) {
            user = vc.searchArray[[n intValue] % 100000-1];
        }else{
            user = [[vc.letterResultArr objectAtIndex:[n intValue] / 100000-1] objectAtIndex:[n intValue] % 100000-1];
        }
        NSString* s = [NSString stringWithFormat:@"%ld",user.userId];
        [g_meeting sendMeetingInvite:s toUserName:user.userName roomJid:self.roomJid callId:self.meetingNo type:type];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (g_meeting.isMeeting) {
            return;
        }
        TFJunYou_AVCallViewController *avVC = [[TFJunYou_AVCallViewController alloc] init];
        avVC.roomNum = self.roomJid;
        avVC.isAudio = self.isAudioMeeting;
        avVC.isTalk = self.isTalkMeeting;
        avVC.isGroup = YES;
        avVC.toUserName = self.chatRoom.roomTitle;
        avVC.view.frame = [UIScreen mainScreen].bounds;
//        [self presentViewController:avVC animated:YES completion:nil];
        [g_window addSubview:avVC.view];

    });

}
#endif
#endif

-(void)onChatAudio:(TFJunYou_MessageObject*)msg{
#if TAR_IM
#ifdef Meeting_Version
    if([self sendMsgCheck]){
        return;
    }
    
    // 验证XMPP是否在线
    if(g_xmpp.isLogined != login_status_yes){
        [self hideKeyboard:NO];
        [g_xmpp showXmppOfflineAlert];
        return;
    }
    
//    if(!g_meeting.connected){
//        [g_meeting showAutoConnect];
//        return;
//    }
    
    [self hideKeyboard:YES];
    if((self.roomJid || msg.objectId.length > 0) && [msg.type intValue] != kWCMessageTypeAVBusy){
        [self onGroupAudioMeeting:msg];
    }else{
        AskCallViewController* vc = [AskCallViewController alloc];
        vc.toUserId = chatPerson.userId;
        vc.toUserName = chatPerson.userNickname;
        vc.type = kWCMessageTypeAudioChatAsk;
        vc.meetUrl = self.meetUrl;
        vc = [vc init];
//        [g_window addSubview:vc.view];
        [g_navigation pushViewController:vc animated:NO];
    }
    
#endif
#endif
}

-(void)onChatVideo:(TFJunYou_MessageObject*)msg{
#if TAR_IM
#ifdef Meeting_Version
    if([self sendMsgCheck]){
        return;
    }
    
    // 验证XMPP是否在线
    if(g_xmpp.isLogined != login_status_yes){
        [self hideKeyboard:NO];
        [g_xmpp showXmppOfflineAlert];
        return;
    }
    
//    if(!g_meeting.connected){
//        [g_meeting showAutoConnect];
//        return;
//    }

    [self hideKeyboard:YES];
    if((self.roomJid || msg.objectId.length > 0) && [msg.type intValue] != kWCMessageTypeAVBusy){
        [self onGroupVideoMeeting:msg];
    }else{
        AskCallViewController* vc = [AskCallViewController alloc];
        vc.toUserId = chatPerson.userId;
        vc.toUserName = chatPerson.userNickname;
        vc.type = kWCMessageTypeVideoChatAsk;
        vc.meetUrl = self.meetUrl;
        vc = [vc init];
        //        [g_window addSubview:vc.view];
        [g_navigation pushViewController:vc animated:NO];
    }
#endif
#endif
}

- (void)onChatTalk:(TFJunYou_MessageObject*)msg {
#if TAR_IM
#ifdef Meeting_Version
    if([self sendMsgCheck]){
        return;
    }
    
    // 验证XMPP是否在线
    if(g_xmpp.isLogined != login_status_yes){
        [self hideKeyboard:NO];
        [g_xmpp showXmppOfflineAlert];
        return;
    }
    
    //    if(!g_meeting.connected){
    //        [g_meeting showAutoConnect];
    //        return;
    //    }
    
    [self hideKeyboard:YES];
    [self onGroupTalkMeeting:msg];

#endif
#endif
}


-(void)onHeadImage:(UIView*)sender{
    [self hideKeyboard:NO];

    TFJunYou_MessageObject *msg=[_array objectAtIndex:sender.tag];
    [g_server getUser:msg.fromUserId toView:self];
    msg = nil;
}

-(void)onMember{
    if (recording) {
        return;
    }
    [self hideKeyboard:YES];
    NSString *s;
    switch ([self.groupStatus intValue]) {
        case 0:
            s = nil;
            break;
        case 1:
            s = Localized(@"JX_OutOfTheGroup1");
            break;
        case 2:
            s = Localized(@"JX_DissolutionGroup1");
            break;
            
        default:
            break;
    }
    
    if (s.length > 0) {
        [self hideKeyboard:NO];
        [g_server showMsg:s];
    }else {
//        [_wait start];
        
        TFJunYou_RoomMemberVC* vc = [TFJunYou_RoomMemberVC alloc];
        //            vc.chatRoom   = [[TFJunYou_XMPP sharedInstance].roomPool joinRoom:roomdata.roomJid title:roomdata.name isNew:NO];
        //            vc.room       = roomdata;
        vc.roomId = roomId;
        vc.room = self.room;
        vc.delegate = self;
        vc = [vc init];
        //        [g_window addSubview:vc.view];
        [g_navigation pushViewController:vc animated:YES];
//        [g_server getRoom:roomId toView:self];
    }
}

-(void)onQuitRoom:(NSNotification *)notifacation//超时未收到回执
{
    TFJunYou_RoomObject* p     = (TFJunYou_RoomObject *)notifacation.object;
    if(p == chatRoom)
        [self actionQuit];
    p = nil;
}

#pragma mark - 控制消息处理
-(void)onReceiveRoomRemind:(NSNotification *)notifacation
{
    TFJunYou_RoomRemind* p     = (TFJunYou_RoomRemind *)notifacation.object;

    if([p.objectId isEqualToString:self.roomJid]){
        if([p.type intValue] == kRoomRemind_RoomName){
            memberData *me = [self.room getMember:g_myself.userId];
            if ([me.role intValue] == 1 || [me.role intValue] == 2) {
                self.title = [NSString stringWithFormat:@"%@(%ld)", p.content, _room.curCount];
            } else {
                self.title = self.chatPerson.userNickname;
            }
            
            [self setAudioIconFrame];
        }
        if([p.type intValue] == kRoomRemind_DisableSay){
            if([p.toUserId isEqualToString:MY_USER_ID])
                _disableSay = [p.content longLongValue];
        }
        if([p.type intValue] == kRoomRemind_DelMember){
            if([p.toUserId isEqualToString:MY_USER_ID])
                self.groupStatus = [NSNumber numberWithInt:1];
//                [self actionQuit];
            
            NSArray * memberArray = [memberData fetchAllMembers:_room.roomId];
            
            memberData *me = [self.room getMember:g_myself.userId];
            if ([me.role intValue] == 1 || [me.role intValue] == 2) {
                self.title = [NSString stringWithFormat:@"%@(%ld)", self.chatPerson.userNickname, memberArray.count];
            } else {
                self.title = self.chatPerson.userNickname;
            }
            [self setAudioIconFrame];
            
        }
        if([p.type intValue] == kRoomRemind_NewNotice){
            NSArray *noticeArr = [p.content componentsSeparatedByString:Localized(@"JXMessageObject_AddNewAdv")];
            [self setupNoticeWithContent:[noticeArr lastObject] time:[NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]]];
        }
        if([p.type intValue] == kRoomRemind_DelRoom){
            if([p.toUserId isEqualToString:MY_USER_ID] || IS_OTHER_DEVICE(p.toUserId))
                self.groupStatus = [NSNumber numberWithInt:2];
//                [self actionQuit];
        }
        if([p.type intValue] == kRoomRemind_AddMember){
            if([p.toUserId isEqualToString:MY_USER_ID]){
                self.groupStatus = [NSNumber numberWithInt:0];
                chatRoom.isConnected = YES;
            }
            NSArray * memberArray = [memberData fetchAllMembers:_room.roomId];
            
            memberData *me = [self.room getMember:g_myself.userId];
            if ([me.role intValue] == 1 || [me.role intValue] == 2) {
                self.title = [NSString stringWithFormat:@"%@(%ld)", self.chatPerson.userNickname, memberArray.count];
            } else {
                self.title = self.chatPerson.userNickname;
            }
            [self setAudioIconFrame];
            //                [self actionQuit];
        }
        if([p.type intValue] == kRoomRemind_NickName){
            
            memberData *data = [[memberData alloc] init];
            data.roomId = roomId;
            data.userNickName = p.content;
            data.userId = [p.toUserId longLongValue];
            [data updateUserNickName];
            
//            for (int i = 0; i < [_array count] ; i++) {
//                TFJunYou_MessageObject *msg=[_array objectAtIndex:i];
//                if ([msg.fromUserId isEqualToString:p.userId]) {
//                    msg.fromUserName = p.content;
//                }
//            }
            
            [_table reloadData];
            
//            for(int i=0;i<[_room.members count];i++){
//                memberData* m = [_room.members objectAtIndex:i];
//                if(m.userId == [p.toUserId intValue]){
//                    m.userNickName = p.content;
//                    break;
//                }
//                m = nil;
//            }
        }
        
        if ([p.type intValue] == kRoomRemind_SetManage) {
            //设置群组管理员
            
            TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:p.objectId];
            
            NSDictionary * groupDict = [user toDictionary];
            roomData * roomdata = [[roomData alloc] init];
            [roomdata getDataFromDict:groupDict];
            NSArray * allMem = [memberData fetchAllMembers:user.roomId];
            roomdata.members = [allMem mutableCopy];
            
            memberData *member = [roomdata getMember:p.toUserId];
            if ([member.role intValue] == 2) {
                member.role = [NSNumber numberWithInt:2];
            }else {
                member.role = [NSNumber numberWithInt:3];
            }
            [member updateRole];
            self.room = roomdata;
            
            if ([p.toUserId isEqualToString:g_myself.userId]) {
                if ([member.role intValue] == 2) {
                    _isAdmin = YES;
                    
                    _shareMore.enabled = YES;
                    _recordBtnLeft.enabled = YES;
                    _btnFace.enabled = YES;
                    _messageText.userInteractionEnabled = YES;
                    _talkTimeLabel.hidden = YES;
                }else {
                    _isAdmin = NO;
                    if ([self.chatPerson.talkTime longLongValue] > 0) {
                        _talkTimeLabel.hidden = NO;
                        _talkTimeLabel.text = Localized(@"JX_TotalSilence");
                        _shareMore.enabled = NO;
                        _recordBtnLeft.enabled = NO;
                        _btnFace.enabled = NO;
                        _messageText.userInteractionEnabled = NO;
                        _messageText.text = nil;
                    }else {
                        
                        _shareMore.enabled = YES;
                        _recordBtnLeft.enabled = YES;
                        _btnFace.enabled = YES;
                        _messageText.userInteractionEnabled = YES;
                        _talkTimeLabel.hidden = YES;
                    }
                }
            }
            
            [self refresh:nil];
//            [_table reloadData];
            [g_server roomGetRoom:self.roomId toView:self];
        }
        
        if([p.type intValue] == kRoomRemind_ShowRead){
            //BOOL b = [self.chatPerson.showRead boolValue];
            self.chatPerson.showRead = [NSNumber numberWithInt:[p.content intValue]];
            //if(b != [self.chatPerson.showRead boolValue])
            
//                [self refresh:nil];
            [_table reloadData];

        }
        if([p.type intValue] == kRoomRemind_ShowMember){
            // 禁止显示群成员，所有名字最后一位改为*，需要刷新界面，保证整个列表即时更新
            self.chatPerson.showMember = [NSNumber numberWithInt:[p.content intValue]];
            self.room.showMember = [p.content boolValue];
            [self refresh:nil];
            [_table reloadData];
        }
        if([p.type intValue] == kRoomRemind_allowSendCard){

            self.chatPerson.allowSendCard = [NSNumber numberWithInt:[p.content intValue]];
            self.room.allowSendCard = [p.content boolValue];
            
            [self refresh:nil];
            // 禁止私聊，需要刷新界面，保证整个列表即时更新
            [_table reloadData];
        }
        if([p.type intValue] == kRoomRemind_RoomAllowInviteFriend){
            
            self.chatPerson.allowInviteFriend = [NSNumber numberWithInt:[p.content intValue]];

        }
        if([p.type intValue] == kRoomRemind_RoomAllowUploadFile){
            
            self.chatPerson.allowUploadFile = [NSNumber numberWithInt:[p.content intValue]];
    
        }
        if([p.type intValue] == kRoomRemind_RoomAllowConference){
            
            self.chatPerson.allowConference = [NSNumber numberWithInt:[p.content intValue]];
    
        }
        if([p.type intValue] == kRoomRemind_RoomAllowSpeakCourse){
            
            self.chatPerson.allowSpeakCourse = [NSNumber numberWithInt:[p.content intValue]];
            [self refresh:nil];
        }
        if([p.type intValue] == kRoomRemind_RoomAllBanned){
            [self hideKeyboard:YES];

            self.chatPerson.talkTime = [NSNumber numberWithInt:[p.content intValue]];
            _disableSay = [self.chatPerson.talkTime longLongValue];
            
            
//            memberData *data = [self.room getMember:g_myself.userId];
//            if ([data.role intValue] == 1 || [data.role intValue] == 2) {
//                _isAdmin = YES;
//            }else {
//                _isAdmin = NO;
//            }
            
            if ([self.chatPerson.talkTime longLongValue] > 0 && !_isAdmin) {
                _talkTimeLabel.text = Localized(@"JX_TotalSilence");
                _shareMore.enabled = NO;
                _recordBtnLeft.enabled = NO;
                _btnFace.enabled = NO;
                _messageText.userInteractionEnabled = NO;
                _talkTimeLabel.hidden = NO;
                _messageText.text = nil;
            }else {
                _shareMore.enabled = YES;
                _recordBtnLeft.enabled = YES;
                _btnFace.enabled = YES;
                _messageText.userInteractionEnabled = YES;
                _talkTimeLabel.hidden = YES;
            }
//            [self refresh:nil];
        }
        if([p.type intValue] == kRoomRemind_SetInvisible){
            TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:p.objectId];
            
            NSDictionary * groupDict = [user toDictionary];
            roomData * roomdata = [[roomData alloc] init];
            [roomdata getDataFromDict:groupDict];
            NSArray * allMem = [memberData fetchAllMembers:user.roomId];
            roomdata.members = [allMem mutableCopy];
            
            memberData *member = [roomdata getMember:p.toUserId];
            if ([p.content intValue] == 1) {
                [member updateRoleByUserId:[p.toUserId longLongValue] role:[NSNumber numberWithInt:4]];
            } else {
                [member updateRoleByUserId:[p.toUserId longLongValue] role:[NSNumber numberWithInt:3]];
            }
            if ([p.toUserId isEqualToString:MY_USER_ID]) {
                if ([p.content intValue] == 1) {
                    _talkTimeLabel.text = Localized(@"JX_ProhibitToSpeak");
                    _messageText.userInteractionEnabled = NO;
                    _shareMore.enabled = NO;
                    _recordBtnLeft.enabled = NO;
                    _btnFace.enabled = NO;
                    _talkTimeLabel.hidden = NO;
                    _messageText.text = nil;
                    member.role = [NSNumber numberWithInt:4];
                }else {
                    _talkTimeLabel.hidden = YES;
                    _shareMore.enabled = YES;
                    _recordBtnLeft.enabled = YES;
                    _btnFace.enabled = YES;
                    _messageText.userInteractionEnabled = YES;
                    member.role = [NSNumber numberWithInt:3];
                }
                [member updateRole];
                self.room = roomdata;
            }
        }
        if([p.type intValue] == kRoomRemind_RoomTransfer){
            if ([p.fromUserId isEqualToString:MY_USER_ID] || [p.toUserId isEqualToString:MY_USER_ID]) {
                
                if ([p.fromUserId isEqualToString:MY_USER_ID]) {
                    _isAdmin = NO;
                }else {
                    _isAdmin = YES;
                }
                
                [self refresh:nil];
            }
        }
        
        if ([p.type intValue] == kRoomRemind_RoomDisable) {
            if ([p.content integerValue] != 1) {
                self.isDisable = YES;
            }else {
                self.isDisable = NO;
            }
        }
        
        if ([p.type intValue] == kRoomRemind_SetRecordTimeOut) {
            if ([p.objectId isEqualToString:self.roomJid]) {
                self.chatPerson.chatRecordTimeOut = p.content;
                [self.chatPerson updateUserChatRecordTimeOut];
            }
        }
        
    }
}

-(BOOL)showDisableSay{
    
    memberData *data = [self.room getMember:g_myself.userId];
//    if([[NSDate date] timeIntervalSince1970] <= _disableSay && [data.role intValue] != 1){
    if([[NSDate date] timeIntervalSince1970] <= _disableSay && !_isAdmin){
        NSString* s = [TimeUtil formatDate:[NSDate dateWithTimeIntervalSince1970:_disableSay] format:@"yyyy-MM-dd HH:mm"];
        NSString *msg = [NSString stringWithFormat:@"%@%@",s,Localized(@"JXChatVC_GagTime")];
//        [g_App showAlert:msg];
        [self.view showXHToastCenterWithText:@"你已被禁言"];
        [self hideKeyboard:NO];
        return YES;
    }
    return NO;
}

-(void)onLocation{
    [self hideKeyboard:YES];
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        //定位功能可用
        if([self showDisableSay])
            return;
        if([self sendMsgCheck]){
            return;
        }
        
        if (g_server.latitude <= 0 && g_server.longitude <= 0) {
            g_server.latitude  = 22.6;
            g_server.longitude = 114.04;
        }
        
        if (g_config.isChina) {
            _locVC = [TFJunYou_LocationVC alloc];
            _locVC.isSend = YES;
            _locVC.locationType = TFJunYou_LocationTypeCurrentLocation;
            _locVC.delegate  = self;
            _locVC.didSelect = @selector(onSelLocation:);
            //    self.locationVC.locations = [[NSMutableArray alloc]init];
            
            //    TFJunYou_MapData* p = [[TFJunYou_MapData alloc]init];
            //    p.latitude = [NSString stringWithFormat:@"%f",g_server.latitude];
            //    p.longitude = [NSString stringWithFormat:@"%f",g_server.longitude];
            //    p.title = g_server.locationCity;
            //    p.subtitle = g_server.locationAddress;
            //    [self.locationVC.locations addObject:p];
            //    [p release];
            
            _locVC = [_locVC init];
            //    self.locationVC.locY = g_server.latitude;
            //    self.locationVC.locX = g_server.longitude;
            //    [g_window addSubview:_locVC.view];
            [g_navigation pushViewController:_locVC animated:YES];
        } else {
            _gooMap = [TFJunYou_GoogleMapVC alloc];
            _gooMap.isSend = YES;
            _gooMap.delegate  = self;
            _gooMap.locationType = TFJunYou_GooLocationTypeCurrentLocation;
            _gooMap.didSelect = @selector(onSelLocation:);
            
            _gooMap = [_gooMap init];
            [g_navigation pushViewController:_gooMap animated:YES];
        }

    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        [g_App showAlert:[NSString stringWithFormat:Localized(@"JX_NoLocationPermissions"),APP_NAME]];
    }

}


-(void)onSelLocation:(TFJunYou_MapData*)location{
    if (_isGroupSendCancel) {
        return;
    }
    //上传图片
    if (location.imageUrl) {
        self.isMapMsg = YES;
        self.mapData = location;
        if (self.isGroupMessages) {
            if (!self.waitGroupSendView) {
                [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_location];
                _onceSendNum = 10;
            }
        }
        [g_server uploadFile:location.imageUrl validTime:self.chatPerson.chatRecordTimeOut messageId:nil toView:self];
    }
}

//- (void)groupSendLocation:(NSMutableArray *)msgArray{
//    NSDictionary *p = msgArray.lastObject;
//    if (_isGroupSendCancel) {
//         return;
//     }
//     NSString *userId = self.userIds[self.groupMessagesIndex];
//
//         NSString* msgId = [dict objectForKey:@"oUrl"];
//         msgId = [[msgId lastPathComponent] stringByDeletingPathExtension];
//         NSString* oFileName = [dict objectForKey:@"oFileName"];
//
//     //    NSString *userId = self.userIds[self.groupMessagesIndex];
//     //    NSString *userName = self.userNames[self.groupMessagesIndex];
//
//         TFJunYou_MessageObject* p=nil;
//         int found=-1;
//         for(int i=(int)[_array count]-1;i>=0;i--){
//             p = [_array objectAtIndex:i];
//             if([p.type intValue]==kWCMessageTypeLocation)
//                 if([[p.fileName lastPathComponent] isEqualToString:[oFileName lastPathComponent]]){
//                     found = i;
//                     break;
//                 }
//             if([p.type intValue]==kWCMessageTypeFile && ![p.isUpload boolValue])
//                 if([[p.fileName lastPathComponent] isEqualToString:[oFileName lastPathComponent]]){
//                     found = i;
//                     break;
//                 }
//             if (p.content.length > 0) {
//                 if ([oFileName rangeOfString:p.content].location != NSNotFound) {
//                     found = i;
//                     break;
//                 }
//             }
//     //        if([p.content isEqualToString:msgId]){
//     //            found = i;
//     //            break;
//     //        }
//             p = nil;
//         }
//         if(found>=0){//找到消息体
//             if([[dict objectForKey:@"status"] intValue] != 1){
//                 NSLog(@"doUploadFaire");
//                 [p updateIsSend:transfer_status_no];
//                 TFJunYou_BaseChatCell* cell = [self getCell:found];
//                 [cell drawIsSend];
//                 cell = nil;
//                 return;
//             }
//             if (self.isGroupMessages) {
//                 p.isGroupSend = YES;
//             }
//             NSLog(@"doSendAfterUpload");
//             p.content  = [dict objectForKey:@"oUrl"];
//     //        if (self.isGroupMessages) {
//     //            p.toUserId = userId;
//     //        }
//             [p updateIsUpload:YES];
//             [g_xmpp sendMessage:p roomName:self.roomJid];//发送消息
//     //        [self.tableView reloadData];
//         }
//
//         p = nil;
//     self.groupMessagesIndex ++;
//     if (self.groupMessagesIndex < self.userIds.count) {
//         if (self.groupMessagesIndex % _onceSendNum == 0) {
//             return;
//         }else{
//             [self collectionMsgSendAll:allArray];
//         }
//     }else if (self.userIds){
//         self.groupMessagesIndex = 0;
//         return;
//     }
//     return;
//}

- (void)sendMapMsgWithDict:(NSDictionary *)dict {
    NSString *userId = self.userIds[self.groupMessagesIndex];
//    NSString *userName = self.userNames[self.groupMessagesIndex];
    
    TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    msg.fromUserName = MY_USER_NAME;
    if([self.roomJid length]>0){
        msg.toUserId = self.roomJid;
        msg.isGroup = YES;
        msg.fromUserName = _userNickName;
    }
    else{
        if (self.isGroupMessages) {
            msg.toUserId = userId;
            msg.isGroupSend = YES;
            if ((self.groupMessagesIndex+1) % _onceSendNum == 0) {
                msg.isLastGroupSend = YES;
            }
        }else {
            msg.toUserId     = chatPerson.userId;
        }
        msg.isGroup = NO;
    }
    msg.location_x   = [NSNumber numberWithDouble:[self.mapData.latitude  doubleValue]];
    msg.location_y   = [NSNumber numberWithDouble:[self.mapData.longitude doubleValue]];
    msg.type         = [NSNumber numberWithInt:kWCMessageTypeLocation];
    msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
    msg.isRead       = [NSNumber numberWithBool:NO];
//    msg.isUpload     = [NSNumber numberWithBool:NO];
    //    msg.content = [NSString stringWithFormat:@"%@",location.subtitle];
    msg.objectId     = [NSString stringWithFormat:@"%@",self.mapData.subtitle];

    msg.isReadDel    = [NSNumber numberWithInt:NO];
    
    //上传图片
    //    if (location.imageUrl) {
    //        [g_server uploadFile:location.imageUrl toView:self];
    //        msg.fileName = location.imageUrl;
    //    }else{
    msg.content = [dict objectForKey:@"oUrl"];
    //    BOOL isShowGoo = [g_myself.isUseGoogleMap intValue] > 0 ? YES : NO;
    //    if (isShowGoo) {
    //        msg.content = [[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&size=640x480&markers=color:blue%7Clabel:S%7C62.107733,-145.541936&zoom=15",location.latitude, location.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    } else {
    //        msg.content = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?width=640&height=480&center=%@,%@&zoom=15",location.longitude, location.latitude];
    //    }
    msg.fileName = msg.content;
    [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
//    }
    [msg insert:self.roomJid];
    [self showOneMsg:msg];
    
    if (self.isGroupMessages) {
        self.groupMessagesIndex ++;
        if (self.groupMessagesIndex % _onceSendNum == 0) {
            return;
        }
        if (self.groupMessagesIndex < self.userIds.count) {
            [self onSelLocation:self.mapData];
        }else if (self.userIds){
            self.groupMessagesIndex = 0;
            return;
        }
        return;
    }
    self.isMapMsg = NO;
}

-(void)onCard{
    
    [self hideKeyboard:YES];
    if (self.roomJid.length > 0 && ![self.chatPerson.allowSendCard boolValue] && !_isAdmin) {
        [g_App showAlert:Localized(@"JX_GroupDisableSendCard")];
        return;
    }
    
    if([self showDisableSay])
        return;
    if([self sendMsgCheck]){
        return;
    }
    
    TFJunYou_SelectFriendsVC* vc = [TFJunYou_SelectFriendsVC alloc];
    vc.isNewRoom = NO;
    vc.chatRoom = nil;
    vc.room = nil;
    vc.isShowMySelf = YES;
    vc.delegate = self;
    vc.didSelect = @selector(onAfterAddMember:);
    vc = [vc init];
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];

}

-(void)onAfterAddMember:(TFJunYou_SelectFriendsVC*)vc{
    
    NSString *userId = self.userIds[self.groupMessagesIndex];
//    NSString *userName = self.userNames[self.groupMessagesIndex];
    
    if (self.isGroupMessages) {
        if (_isGroupSendCancel) {
            return;
        }
        if (self.groupMessagesIndex == 0) {
            [self addWaitGroupSendViewWithMsgNum:vc.set.count withType:groupsend_msgType_card];
            self.groupSendMsgArray = [NSMutableArray arrayWithObject:vc];
            _onceSendNum = 20;
        }
    }
    NSInteger i = 0;
    BOOL isLastGroupSend = NO;
    for(NSNumber* n in vc.set){
        i++;
        TFJunYou_UserObject *user;
        if (vc.seekTextField.text.length > 0) {
            user = vc.searchArray[[n intValue] % 100000-1];
        }else{
            user = [[vc.letterResultArr objectAtIndex:[n intValue] / 100000-1] objectAtIndex:[n intValue] % 100000-1];
        }
        
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg.toUserId = self.roomJid;
            msg.isGroup = YES;
            msg.fromUserName = _userNickName;
        }
        else{
            if (self.isGroupMessages) {
                msg.toUserId = userId;
                msg.isGroupSend = YES;
                if ((self.groupMessagesIndex + 1) % _onceSendNum == 0) {
                    if (i == vc.set.count) {
                        msg.isLastGroupSend = YES;
                        isLastGroupSend = YES;
                    }
                }
            }else {
                msg.toUserId     = chatPerson.userId;
            }
            msg.isGroup = NO;
        }
        msg.content      = user.userNickname;
        msg.objectId     = user.userId;
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeCard];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isReadDel    = [NSNumber numberWithInt:NO];
        
        [msg insert:self.roomJid];
        [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
        [self showOneMsg:msg];
//        [msg release];
        user = nil;
    }
    
    if (self.isGroupMessages) {
        self.groupMessagesIndex ++;
        if (isLastGroupSend) {
            return;
        }
        if (self.groupMessagesIndex < self.userIds.count) {
            [self onAfterAddMember:vc];
        }else if (self.userIds){
            self.groupMessagesIndex = 0;
            return;
        }
        return;
    }
}

-(void)sendFile:(NSString*)file userId:(NSString *)userId
{
//    NSString *userId = self.userIds[self.groupMessagesIndex];
//    NSString *userName = self.userNames[self.groupMessagesIndex];
    
    if ([file length]>0) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc] init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg.toUserId = self.roomJid;
            msg.isGroup = YES;
            msg.fromUserName = _userNickName;
        }
        else{
            if (self.isGroupMessages) {
                msg.toUserId = userId;
            }else {
                msg.toUserId     = chatPerson.userId;
            }
            msg.isGroup = NO;
        }
        msg.fileName     = file;
        msg.content      = file;
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeFile];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.isUpload     = [NSNumber numberWithBool:NO];
        
        msg.isReadDel    = [NSNumber numberWithInt:NO];
        
        [msg insert:self.roomJid];
        [self showOneMsg:msg];
        
//        if (self.isGroupMessages) {
//            self.groupMessagesIndex ++;
//            if (self.groupMessagesIndex < self.userIds.count) {
//                [self sendFile:file];
//            }else if (self.userIds){
//                self.groupMessagesIndex = 0;
//                return;
//            }
//            return;
//        }
//        [msg release];
        [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:msg.messageId toView:self];
    }
}
//发红包
-(void)sendRedPacket:(NSDictionary*)redPacketDict withGreet:(NSString *)greet
{
    [self hideKeyboard:NO];
    if ([redPacketDict[@"id"] length]>0) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc] init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg.toUserId = self.roomJid;
            msg.isGroup = YES;
            msg.fromUserName = _userNickName;
        }
        else{
            msg.toUserId     = chatPerson.userId;
            msg.isGroup = NO;
        }

        msg.content      = greet;
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeRedPacket];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
//        msg.isUpload     = [NSNumber numberWithBool:NO];
        msg.fileName = redPacketDict[@"type"];
        msg.objectId = redPacketDict[@"id"];
        msg.isReadDel    = [NSNumber numberWithInt:NO];
        
        [msg insert:self.roomJid];
        
//        if (![_orderRedPacketArray containsObject:msg]) {
//            [_orderRedPacketArray addObject:msg];
//        }
        [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
        [self showOneMsg:msg];
//        [msg release];
    }
    //获取余额
    [g_server getUserMoenyToView:self];
}

-(void)onSelFile:(NSString*)file{
    if (self.isGroupMessages) {
//        for (NSInteger i = 0; i < self.userIds.count; i ++) {
//            NSString *userId = self.userIds[i];
//
//            //发送文件，file仅仅包含文件在本地的地址
//            [self sendFile:file userId:userId];
//            //上传文件到服务器
////            [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:self.curMessageId toView:self];
//        }
        [self addWaitGroupSendViewWithMsgNum:1 withType:groupsend_msgType_file];
        self.groupUploadObjArray = [NSMutableArray arrayWithObject:file];
        _onceSendNum = 5;
        [self sendFiles:self.groupUploadObjArray];
    }else {
        //发送文件，file仅仅包含文件在本地的地址
        [self sendFile:file userId:nil];
        //上传文件到服务器
//        [g_server uploadFile:file validTime:self.chatPerson.chatRecordTimeOut messageId:self.curMessageId toView:self];
    }
}

- (void)sendFiles:(NSArray *)filesArray{
    NSString *userId = self.userIds[self.groupMessagesIndex];
    NSString *file = filesArray.lastObject;
    [self sendFile:file userId:userId];
    self.groupMessagesIndex ++;
    if (self.groupMessagesIndex < self.userIds.count) {
        if (self.groupMessagesIndex % _onceSendNum == 0) {
            return;
        }else{
            [self sendFiles:filesArray];
        }
    }else if (self.userIds){
        self.groupMessagesIndex = 0;
        return;
    }
}

-(void)sendGift{
    [self hideKeyboard:YES];
    if([self showDisableSay])
        return;
    
    if([self sendMsgCheck]){
        return;
    }
    
//    if ([g_App.videoMeeting intValue]==1) {
//
//        TFJunYou_RealCerVc *cervc=[[TFJunYou_RealCerVc alloc]init];
//        [g_navigation pushViewController:cervc animated:YES];
//
//        return;
//    }
  
    
    TFJunYou_SendRedPacketViewController * sendGiftVC = [[TFJunYou_SendRedPacketViewController alloc] init];
    sendGiftVC.isRoom = NO;
    sendGiftVC.toUserId = chatPerson.userId;
    sendGiftVC.delegate = self;
//    [g_window addSubview:sendGiftVC.view];
    [g_navigation pushViewController:sendGiftVC animated:YES];
}

- (void)onTransfer {
    
//    if ([g_App.shortVideo intValue]==0) {
//        
//        TFJunYou_RealCerVc *cervc=[[TFJunYou_RealCerVc alloc]init];
//        [g_navigation pushViewController:cervc animated:YES];
//        
//        return;
//    }
  
    
    TFJunYou_TransferViewController *transferVC = [TFJunYou_TransferViewController alloc];
    transferVC.user = chatPerson;
    transferVC.delegate = self;
    transferVC = [transferVC init];
    [g_navigation pushViewController:transferVC animated:YES];
}

- (void)sendGiftToRoom{
    [self hideKeyboard:YES];
    if([self showDisableSay])
        return;
    
    if([self sendMsgCheck]){
        return;
    }
    if (self.room.curCount == 1) {
        self.isSendRedPacket = YES;
        [g_server roomGetRoom:self.roomId toView:self];
    }else {
        // 获取群成员列表
        NSArray * memberArray = [memberData fetchAllMembers:_room.roomId];

        TFJunYou_SendRedPacketViewController * sendGiftVC = [[TFJunYou_SendRedPacketViewController alloc] init];
        sendGiftVC.isRoom = YES;
        sendGiftVC.delegate = self;
        sendGiftVC.roomJid = self.roomJid;
        sendGiftVC.size = memberArray.count;
        //    [g_window addSubview:sendGiftVC.view];
        [g_navigation pushViewController:sendGiftVC animated:YES];
    }
}

#pragma mark - 转账delegate
- (void)transferToUser:(NSDictionary *)dict {
    [self hideKeyboard:NO];
    if ([dict[@"id"] length]>0) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc] init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        msg.toUserId     = chatPerson.userId;
        msg.isGroup = NO;
        
        msg.content      = [NSString stringWithFormat:@"%@",dict[@"money"]];
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeTransfer];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
//        msg.isUpload     = [NSNumber numberWithBool:NO];
        msg.fileName = dict[@"remark"];
        msg.objectId = dict[@"id"];
        msg.isReadDel    = [NSNumber numberWithInt:NO];
        
        [msg insert:nil];
        
        [g_xmpp sendMessage:msg roomName:nil];//发送消息
        [self showOneMsg:msg];
    }
    //获取余额
    [g_server getUserMoenyToView:self];

}

-(void)sendRedPacketDelegate:(NSDictionary *)redpacketDict{
    [self hideKeyboard:NO];
    if ([redpacketDict[@"id"] length]>0) {
        TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc] init];
        msg.timeSend     = [NSDate date];
        msg.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg.toUserId = self.roomJid;
            msg.isGroup = YES;
            msg.fromUserName = _userNickName;
        }
        else{
            msg.toUserId     = chatPerson.userId;
            msg.isGroup = NO;
        }
        
        msg.content      = redpacketDict[@"greet"];
        msg.type         = [NSNumber numberWithInt:kWCMessageTypeRedPacket];
        msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg.isRead       = [NSNumber numberWithBool:NO];
        msg.fileName = redpacketDict[@"type"];
        msg.objectId = redpacketDict[@"id"];
        msg.isReadDel    = [NSNumber numberWithInt:NO];
        
        [msg insert:self.roomJid];

//        if (![_orderRedPacketArray containsObject:msg]) {
//            [_orderRedPacketArray addObject:msg];
//        }
        [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
        [self showOneMsg:msg];
        //        [msg release];
    }
    //获取余额
    [g_server getUserMoenyToView:self];
}

-(void)onFile{
    [self hideKeyboard:YES];
    if([self showDisableSay])
        return;
    if([self sendMsgCheck]){
        return;
    }
    if (self.roomJid.length > 0) {
        
        if (!_isAdmin && ![self.chatPerson.allowUploadFile boolValue]) {
            [g_App showAlert:Localized(@"JX_NotUploadSharedFiles")];
            return;
        }
    }
    TFJunYou_MyFile* vc = [[TFJunYou_MyFile alloc]init];
    vc.delegate = self;
    vc.didSelect = @selector(onSelFile:);
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
}

-(void)onDidCard:(TFJunYou_MessageObject*)msg{
//    [g_server getUser:msg.objectId toView:self];
    
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId       = msg.objectId;
    vc.isJustShow = self.courseId.length > 0;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}

#pragma mark------cell头像点击
-(void)onDidHeadImage:(NSNotification*)notification{
    if (recording) {
        return;
    }
    if ([chatPerson.userId rangeOfString:MY_USER_ID].location != NSNotFound) {
        return;
    }
    TFJunYou_MessageObject *msg = notification.object;
    
    if([msg.fromUserId isEqualToString:CALL_CENTER_USERID])
        return;
    if (!self.roomJid) {
        //看详情
//        [g_server getUser:msg.fromUserId toView:self];
        
        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
        vc.userId       = msg.fromUserId;
        vc.isJustShow = self.courseId.length > 0;
        vc.fromAddType = 3;
        vc.chatVC = self;
        vc = [vc init];
        [g_navigation pushViewController:vc animated:YES];
    }else {
        if (_isAdmin || [self.chatPerson.allowSendCard boolValue]) {
            
            NSString *s;
            switch ([self.groupStatus intValue]) {
                case 0:
                    s = nil;
                    break;
                case 1:
                    s = Localized(@"JX_OutOfTheGroup1");
                    break;
                case 2:
                    s = Localized(@"JX_DissolutionGroup1");
                    break;
                    
                default:
                    break;
            }
            
            if (s.length > 0) {
                [self hideKeyboard:NO];
                [g_server showMsg:s];
                return;
            }
            
            TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
            vc.userId       = msg.fromUserId;
            vc.isJustShow = self.courseId.length > 0;
            vc.fromAddType = 3;
            vc.chatVC = self;
            vc = [vc init];
            [g_navigation pushViewController:vc animated:YES];
        }else {
            [g_App showAlert:Localized(@"JX_GroupNotTalk")];
        }
    }

}

-(void)longGesHeadImageNotification:(NSNotification *)notification{

    if (!_messageText.userInteractionEnabled) {
        return;
    }

    TFJunYou_MessageObject *msg = notification.object;
    if (self.roomJid) {
        //@群成员
//        [self performSelector:@selector(showAtSelectMemberView) withObject:nil afterDelay:0.35];
//        [self showAtSelectMemberView];
        memberData * mem = [self.room getMember:msg.fromUserId];
        if (mem) {
            [self atSelectMemberDelegate:mem];
        }
    }
}

// 重新发送转账消息
- (void)onResend:(TFJunYou_MessageObject *)msg {
    TFJunYou_MessageObject *msg1 = [[TFJunYou_MessageObject alloc]init];
    msg1 = [msg copy];
    msg1.messageId = nil;
    msg1.timeSend     = [NSDate date];
    msg1.fromId = nil;
    msg1.isGroup = NO;
    msg1.isSend       = [NSNumber numberWithInt:transfer_status_ing];
    msg1.isRead       = [NSNumber numberWithBool:NO];
    msg1.isReadDel    = [NSNumber numberWithInt:NO];
    [msg1 insert:nil];
    [g_xmpp sendMessage:msg1 roomName:nil];//发送消息
    [self showOneMsg:msg1];
}

#pragma mark------转账点击
- (void)onDidTransfer:(NSNotification*)notification {
    if (recording) {
        return;
    }
    
    [self hideKeyboard:NO];
    TFJunYou_MessageObject *msg = notification.object;
    TFJunYou_TransferDeatilVC *detailVC = [TFJunYou_TransferDeatilVC alloc];
    detailVC.msg = msg;
    detailVC.onResend = @selector(onResend:);
    detailVC.delegate = self;
    detailVC = [detailVC init];
    [g_navigation pushViewController:detailVC animated:YES];
}

#pragma mark------红包点击
-(void)onDidRedPacket:(NSNotification*)notification{
    if (recording) {
        return;
    }

    if (self.roomJid) {
        NSString *s;
        // 验证群组是否有效
        switch ([self.groupStatus intValue]) {
            case 0:
                s = nil;
                break;
            case 1:
                s = Localized(@"JX_OutOfTheGroup1");
                break;
            case 2:
                s = Localized(@"JX_DissolutionGroup1");
                break;
                
            default:
                break;
        }
        
        if (s.length > 0) {
            [self hideKeyboard:NO];
            [g_server showMsg:s];
            return;
        }
        
    }
    
    memberData *data = [self.room getMember:g_myself.userId];
    if ([data.role integerValue] == 4) {
        [TFJunYou_MyTools showTipView:@"隐身人不能领取红包"];
        return;
    }
    
    [self hideKeyboard:NO];
    TFJunYou_MessageObject *msg = notification.object;

    if (([msg.fileName isEqualToString:@"3"] && [msg.fileSize intValue] != 2)) {
        if (self.roomId.length > 0) {
            
            _messageText.text = msg.content;
            return;
        }else {
            if (![msg.fromUserId isEqualToString:MY_USER_ID]) {
                
                _messageText.text = msg.content;
                return;
            }
        }
    }
    [_wait start];
    [g_server getRedPacket:msg.objectId toView:self];

//    if (([msg.fileName isEqualToString:@"3"] && [msg.fileSize intValue] != 2) && ![msg.fromUserId isEqualToString:MY_USER_ID]) {
//        _messageText.text = msg.content;
//        return;
//    }
//    [_wait start];
//    [g_server getRedPacket:msg.objectId toView:self];
////    [g_server openRedPacket:msg.objectId toView:self];
    
}

- (void)shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)showRedPacket:(NSDictionary *)dict {
    [_wait stop];
    [self hideKeyboard:YES];
    
    NSString *userName = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"packet"] objectForKey:@"userName"]];
    NSString *greetings = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"packet"] objectForKey:@"greetings"]];
    NSString *userId = [NSString stringWithFormat:@"%@",[(NSDictionary *)[dict objectForKey:@"packet"] objectForKey:@"userId"]];
    
    self.redPacketDict = dict;
    
    
    self.redBaseView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.redBaseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    [self.view addSubview:self.redBaseView];

    UIImage *redImage = [UIImage imageNamed:@"red_packet_bg"];
    
    CGFloat h = TFJunYou__SCREEN_HEIGHT - TFJunYou__SCREEN_TOP - TFJunYou__SCREEN_BOTTOM - 30-50;
    self.redBackV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30+TFJunYou__SCREEN_TOP, TFJunYou__SCREEN_WIDTH-40, h)];
    self.redBackV.userInteractionEnabled = YES;
    self.redBackV.image = redImage;
    [self.redBaseView addSubview:self.redBackV];
    //添加个动画
    [self shakeToShow:self.redBackV];
    
    CGSize size = [[NSString stringWithFormat:@"%@%@",userName,Localized(@"JX_FromRedPacket")] sizeWithAttributes:@{NSFontAttributeName:SYSFONT(18)}];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((TFJunYou__SCREEN_WIDTH-40 - size.width-30-5)/2, 100, 30, 30)];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = icon.frame.size.width/2;
    [self.redBackV addSubview:icon];
    [g_server getHeadImageSmall:userId userName:userName imageView:icon];
    
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+5, CGRectGetMinY(icon.frame)+(30-size.height)/2, size.width, size.height)];
    name.font = SYSFONT(18);
    name.text = [NSString stringWithFormat:@"%@%@",userName,Localized(@"JX_FromRedPacket")];
    name.textColor = HEXCOLOR(0xFEDCA2);
    [self.redBackV addSubview:name];
    
    UILabel *tint = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(icon.frame)+20, self.redBackV.frame.size.width-40, 28)];
    tint.text = greetings;
    tint.font = SYSFONT(25);
    tint.textAlignment = NSTextAlignmentCenter;
    tint.textColor = HEXCOLOR(0xFEDCA2);
    [self.redBackV addSubview:tint];
    _tintLab = tint;
    
    CGFloat b = (h / TFJunYou__SCREEN_HEIGHT) * (h-88);
    self.openImgV = [[UIImageView alloc] initWithFrame:CGRectMake((TFJunYou__SCREEN_WIDTH-40-100)/2, b, 100, 100)];
    self.openImgV.userInteractionEnabled = YES;
    self.openImgV.image = [UIImage imageNamed:@"icon_open_red_packet1"];
    [self.redBackV addSubview:self.openImgV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openReadPacket)];
    [self.openImgV addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.redBackV.frame.size.width-140)/2, self.redBackV.frame.size.height-18-40, 140, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.textColor = HEXCOLOR(0xFEDCA2);
    label.font = SYSFONT(15);
    label.text = Localized(@"JX_CheckTheClaimDetails>");
    label.hidden = [userId intValue] != [MY_USER_ID intValue];
    [self.redBackV addSubview:label];
    _seeLab = label;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CheckTheDetails)];
    [label addGestureRecognizer:tap1];
    
    UIView *canView = [[UIView alloc] initWithFrame:CGRectMake((TFJunYou__SCREEN_WIDTH-40)/2, (TFJunYou__SCREEN_HEIGHT-CGRectGetMaxY(self.redBackV.frame)-40)/2+CGRectGetMaxY(self.redBackV.frame)-10, 40, 40)];
    canView.backgroundColor = [UIColor clearColor];
    canView.layer.masksToBounds = YES;
    canView.layer.cornerRadius = canView.frame.size.width/2;
    canView.layer.borderWidth = 2.f;
    canView.layer.borderColor = HEXCOLOR(0xE8C66A).CGColor;
    [self.redBaseView addSubview:canView];
    UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelOpenRedPacket)];
    [canView addGestureRecognizer:tapC];

    UIImageView *cancelImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    cancelImgV.image = [UIImage imageNamed:@"icon_red_packet_close"];
    cancelImgV.userInteractionEnabled = YES;
    [canView addSubview:cancelImgV];


}

- (void)CheckTheDetails {
    [_redBaseView removeFromSuperview];

    TFJunYou_redPacketDetailVC * redPacketDetailVC = [[TFJunYou_redPacketDetailVC alloc]init];
    redPacketDetailVC.dataDict = [[NSDictionary alloc]initWithDictionary:self.redPacketDict];
    redPacketDetailVC.isGroup = self.room.roomId.length > 0;
    [g_navigation pushViewController:redPacketDetailVC animated:YES];

}

- (void)cancelOpenRedPacket {
    [self.redBaseView removeFromSuperview];
}


- (void)openReadPacket {
    NSMutableArray *imagesArray = [NSMutableArray array];
    for (int i = 1; i < 12; i++) {
        NSString *imageName = [NSString stringWithFormat:@"icon_open_red_packet%d", i];
        UIImage  *image     = [UIImage imageNamed:imageName];
        [imagesArray addObject:image];
    }
    _openImgV.animationImages = imagesArray;
    _openImgV.animationDuration = 0.7f;
    _openImgV.animationRepeatCount = 0;
    [_openImgV startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_openImgV stopAnimating];
//        [self cancelOpenRedPacket];
        [g_server openRedPacket:self.redPacketDict[@"packet"][@"id"] toView:self];
    });
}

#pragma mark-------照片查看
- (void)onDidImage:(NSNotification*)notification{
    if (recording) {
        return;
    }
    self.indexNum = [notification.object intValue];
    [self hideKeyboard:NO];
    TFJunYou_MessageObject *msg = [_array objectAtIndex:[notification.object intValue]];
    //图片路径数组
    NSMutableArray *imagePathArr = [[NSMutableArray alloc]init];
    NSMutableArray *msgArray = [NSMutableArray array];
    if ([msg.isReadDel boolValue] || [msg.content rangeOfString:@".gif"].location != NSNotFound) {//是阅后即焚 gif图片
        if (msg.content) {
            [msgArray addObject:msg];
            [imagePathArr addObject:msg.content];
        }
    }else{
        //获取所有聊天记录
        NSString* s;
        if([self.roomJid length]>0)
            s = self.roomJid;
        else
            s = chatPerson.userId;
        if (msg.isMySend) {
            _allChatImageArr = [msg fetchImageMessageListWithUser:s];
        }else{
            _allChatImageArr = [msg fetchImageMessageListWithUser:s];
        }
        
        for (int i = 0; i < [_allChatImageArr count]; i++) {
            TFJunYou_MessageObject * msgP = [_allChatImageArr objectAtIndex:i];
            if (![msgP.isReadDel boolValue] && [msgP.content rangeOfString:@".gif"].location == NSNotFound) {//得到的消息中含有阅后即焚 或 gif图片 的剔除掉
                if (msgP.content) {
                    [msgArray addObject:msgP];
                    NSString* url;
                    if(msgP.isMySend && isFileExist(msgP.fileName))
                        url = msgP.fileName;
                    else
                        url = msgP.content;
                    [imagePathArr addObject:url];
                }
            }
        }
    }
    
    if (self.courseId.length > 0) {
        if (msg.content) {
            [msgArray addObject:msg];
            NSString* url;
            if(msg.isMySend && isFileExist(msg.fileName))
                url = msg.fileName;
            else
                url = msg.content;
            [imagePathArr addObject:url];
        }
    }
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *arrayURL = [NSMutableArray array];
    
    if (msg.content == nil) {
        return;
    }
    [arrayURL addObject:msg.content];
    [array addObject:msg];
    
    if(array.count < 1) {
        return;
    }
    
//    [ImageBrowserViewController show:self delegate:self type:PhotoBroswerVCTypeModal contentArray:array index:0 imagesBlock:^NSArray *{
//            return arrayURL;
//        }];
    [ImageBrowserViewController show:self delegate:self isReadDel:YES type:PhotoBroswerVCTypeModal contentArray:array index:0 imagesBlock:^NSArray *{
         return arrayURL;
    }];
    //查到当前点击的图片的位置
//    for (int i = 0; i < [msgArray count]; i++) {
//        TFJunYou_MessageObject * msgObj = [msgArray objectAtIndex:i];
//        if ([msg.messageId isEqualToString:msgObj.messageId]) {
//
//            [ImageBrowserViewController show:self delegate:self isReadDel:[msgObj.isReadDel boolValue] type:PhotoBroswerVCTypeModal contentArray:msgArray index:i imagesBlock:^NSArray *{
//                return imagePathArr;
//            }];
//
//        }
//    }
    imagePathArr = nil;
}

- (void)imageBrowserVCQRCodeAction:(NSString *)stringValue {
    
    NSRange range = [stringValue rangeOfString:@"shikuId"];
    if (range.location != NSNotFound) {
        
        NSString * idStr = [stringValue substringFromIndex:range.location + range.length + 1];
        
        if ([stringValue rangeOfString:@"=user"].location != NSNotFound) {
            //                [g_server getUser:idStr toView:self];
            [g_server userGetByAccountWithAccount:idStr toView:self];
            
        }else if ([stringValue rangeOfString:@"=group"].location != NSNotFound) {
            
            [g_server getRoom:idStr toView:self];
//            TFJunYou_RoomMemberVC* vc = [TFJunYou_RoomMemberVC alloc];
//            vc.roomId = idStr;
//            vc = [vc init];
//            [g_navigation pushViewController:vc animated:YES];
        }else if ([stringValue rangeOfString:@"=open"].location != NSNotFound) {
            if ([idStr rangeOfString:@"http://"].location != NSNotFound && [idStr rangeOfString:@"https://"].location != NSNotFound) {
                webpageVC * webVC = [webpageVC alloc];
                webVC.url= idStr;
                webVC.isSend = YES;
                webVC = [webVC init];
                [g_navigation.navigationView addSubview:webVC.view];
//                [g_navigation pushViewController:webVC animated:YES];
            }else{
                [g_App showAlert:Localized(@"JX_TheUrlNotOpen")];
            }
        }
        
    }else {
        NSRange idRange = [stringValue rangeOfString:@"userId"];
        NSRange nameRange = [stringValue rangeOfString:@"userName"];
        
        if ([stringValue hasPrefix:@"http://"] || [stringValue hasPrefix:@"https://"]) {
            webpageVC * webVC = [webpageVC alloc];
            webVC.url= stringValue;
            webVC.isSend = YES;
            webVC = [webVC init];
            [g_navigation.navigationView addSubview:webVC.view];
//            [g_navigation pushViewController:webVC animated:YES];
            
        }else if (stringValue.length == 20 && [self isNumber:stringValue]){
            // 对面付款， 己方收款
            TFJunYou_InputMoneyVC *inputVC = [[TFJunYou_InputMoneyVC alloc] init];
            inputVC.type = TFJunYou_InputMoneyTypeCollection;
            inputVC.paymentCode = stringValue;
            [g_navigation pushViewController:inputVC animated:YES];
        }else if (idRange.location != NSNotFound && nameRange.location != NSNotFound) {
            // 己方付款， 对面收款
            SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
            NSDictionary *dict = [resultParser objectWithString:stringValue];
            TFJunYou_InputMoneyVC *inputVC = [[TFJunYou_InputMoneyVC alloc] init];
            inputVC.type = TFJunYou_InputMoneyTypePayment;
            inputVC.userId = [dict objectForKey:@"userId"];
            inputVC.userName = [dict objectForKey:@"userName"];
            if ([dict objectForKey:@"money"]) {
                inputVC.money = [dict objectForKey:@"money"];
            }
            if ([dict objectForKey:@"description"]) {
                inputVC.desStr = [dict objectForKey:@"description"];
            }
            [g_navigation pushViewController:inputVC animated:YES];
        }
    }
}

- (BOOL)isNumber:(NSString *)strValue {
    if (strValue == nil || [strValue length] <= 0)
    {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[strValue componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![strValue isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}


- (void)dismissImageBrowserVC {
    TFJunYou_ImageCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexNum inSection:0]];
    if (!cell.msg.isMySend) {
        if([cell respondsToSelector:@selector(deleteReadMsg)]){
            [cell deleteReadMsg];
        }

    }
}

-(void)readTypeMsgCome:(NSNotification*)notification{//发送方收到已读类型，改变消息图片为已读
    
    // 更新title 在线状态
    if (!self.roomJid && !self.onlinestate) {
        self.onlinestate = YES;
        if (self.isGroupMessages) {
            self.title = Localized(@"JX_GroupHair");
            [self setAudioIconFrame];
        }else {
            if (self.courseId.length > 0) {
                
            }else {
                if([chatPerson.userId intValue]<10100 && [chatPerson.userId intValue]>=10000) {
                    self.title = chatPerson.userNickname;
                    [self setAudioIconFrame];
                    
                }else {
//                    NSString *str = self.onlinestate ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
//                    self.title = [NSString stringWithFormat:@"%@(%@)",chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname,str];
                    [self setChatTitle:chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname];

                }
            }
            
        }
    }
    
    TFJunYou_MessageObject * msg = (TFJunYou_MessageObject *)notification.object;
    if (msg == nil)
        return;
    
    NSString * msgId = msg.content;
    for (int i = 0; i < [_array count]; i ++) {
        TFJunYou_MessageObject * p = [_array objectAtIndex:i];
        if ([p.messageId isEqualToString:msgId]) {
            if(p.isMySend){
                p.isRead = [NSNumber numberWithInt:1];
                p.isSend = [NSNumber numberWithInt:1];
            }
            p.readPersons = [NSNumber numberWithInt:[p.readPersons intValue] + 1];
            TFJunYou_BaseChatCell* cell = [self getCell:i];
            if(cell){
                [cell drawIsSend];
                //                [cell drawIsRead];
            }
            
            
            if ([p.isReadDel boolValue]) {
                
                if (!cell) {
                    
                    [self readDeleWithUser:p];
                    break;
                }
                
                switch ([p.type intValue]) {
                    case kWCMessageTypeImage:{
                        TFJunYou_ImageCell *imageCell = (TFJunYou_ImageCell *)cell;
                        imageCell.isRemove = YES;
                        [imageCell timeGo:p];
//                        [g_notify postNotificationName:kImageDidTouchEndNotification object:p];
                    }
                        break;
                    case kWCMessageTypeCustomFace:
                    {
                        TFJunYou_FaceCustomCell *imageCell = (TFJunYou_FaceCustomCell *)cell;
                        imageCell.isRemove = YES;
                        [imageCell timeGo:p];
                        //                        [g_notify postNotificationName:kImageDidTouchEndNotification object:p];
                    }
                        break;
                    case kWCMessageTypeEmoji:
                    {
                        TFJunYou_EmojiCell *imageCell = (TFJunYou_EmojiCell *)cell;
                        imageCell.isRemove = YES;
                        [imageCell timeGo:p];
                        //                        [g_notify postNotificationName:kImageDidTouchEndNotification object:p];
                    }
                        break;
                    case kWCMessageTypeVoice:{
                        TFJunYou_AudioCell *audioCell = (TFJunYou_AudioCell *)cell;
                        [audioCell timeGo:p.fileName];
                    }
                        
                        break;
                    case kWCMessageTypeVideo:{
                        TFJunYou_VideoCell *videoCell = (TFJunYou_VideoCell *)cell;
                        [videoCell timeGo:p.fileName];
                    }
                        
                        break;
                    case kWCMessageTypeText:{
                        TFJunYou_MessageCell *messageCell = (TFJunYou_MessageCell *)cell;
                        [messageCell deleteMsg:messageCell.msg];
//                        [self readDeleWithUser:messageCell.msg];
                    }
                        break;
                    case kWCMessageTypeReply:{
                        TFJunYou_ReplyCell *replyCell = (TFJunYou_ReplyCell *)cell;
                        [replyCell deleteMsg:replyCell.msg];
                    }
                        break;
                    default:
                        break;
                }
            }
            
            break;
        }
    }
}

-(void)readTypeMsgReceipt:(NSNotification*)notification{//接收方收到已读消息的回执，改变标志避免重复发
    TFJunYou_MessageObject * msg = (TFJunYou_MessageObject *)notification.object;
    if (msg == nil)
        return;
    
    for (int i = 0; i < [_array count]; i ++) {
        TFJunYou_MessageObject * p = [_array objectAtIndex:i];
        if ([p.messageId isEqualToString:msg.content]){
            if(msg.isMySend){
                p.isRead = [NSNumber numberWithInt:1];
                p.isSend = [NSNumber numberWithInt:1];
            }
            p.readPersons = [NSNumber numberWithInt:[p.readPersons intValue] + 1];
            TFJunYou_BaseChatCell* cell = [self getCell:i];
            if(cell){
                [cell drawIsSend];
                [cell drawIsRead];
            }
            break;
        }
    }
}

//获取口令红包聊天记录
-(NSMutableArray*)fetchRedPacketListWithType:(int)rpType
{
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0)
        return nil;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    NSString *s;
    if([self.roomJid length]>0)
        s = self.roomJid;
    else
        s = chatPerson.userId;
    
    NSString *queryString=[NSString stringWithFormat:@"select * from msg_%@ where type=28 and fileName=3",s];
    
    FMResultSet *rs=[db executeQuery:queryString];
    while ([rs next]) {
        TFJunYou_MessageObject *p=[[TFJunYou_MessageObject alloc]init];
        [p fromRs:rs];
        [messageList addObject:p];
//        [p release];
    }
    [rs close];
    db = nil;

    if([messageList count]==0){
//        [messageList release];
        messageList = nil;
    }
    return  messageList;
}

//改变红包对应消息的不可获取
-(void)changeMessageRedPacketStatus:(NSString*)redPacketId{
    NSString* myUserId = MY_USER_ID;
    if([myUserId length]<=0){
        return;
    }
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    
    NSString * sufStr = self.roomJid ? self.roomJid : self.chatPerson.userId;
    
    NSString * sql = [NSString stringWithFormat:@"update msg_%@ set fileSize=2 where objectId=?",sufStr];
    
    [db executeUpdate:sql,redPacketId];

    db = nil;
}
//改变红包消息不可获取
- (void)changeMessageArrFileSize:(NSString *)redPackerId{
    for (NSInteger i = _array.count - 1; i >= 0; i --) {
        TFJunYou_MessageObject *msg = _array[i];
        if ([msg.objectId isEqualToString:redPackerId]) {
            msg.fileSize = [NSNumber numberWithInt:2];
            TFJunYou_BaseChatCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell) {
                [self.tableView reloadRow:(int)i section:0];
            }
        }
    }
    for (TFJunYou_MessageObject * msg in _orderRedPacketArray) {
        if ([msg.objectId isEqualToString:redPackerId]) {
            msg.fileSize = [NSNumber numberWithInt:2];
        }
    }
}
// 更新转账已领取状态
- (void)updateTransferMsgFileSize:(NSNotification *)noti {
    NSString *str = [NSString stringWithFormat:@"%@",noti.object];
    
    TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
    msg.objectId = str;
    msg.toUserId = self.chatPerson.userId;
    NSMutableArray *msgs = [msg getMsgWithObjectId:str];
    for (int i = 0; i < msgs.count; i++) {
        TFJunYou_MessageObject *msg1 = msgs[i];
        msg1.fileSize = [NSNumber numberWithInt:2];
        [msg1 updateFileSize];
    }
    
    [self changeMessageArrFileSize:str];
}

-(TFJunYou_BaseChatCell*)getCell:(long)index{
    if(index<0 && index >= [_array count])
        return nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return (TFJunYou_BaseChatCell*)[_table cellForRowAtIndexPath:indexPath];
}
#pragma mark------自动向下播放语音
-(void)audioPlayEnd:(NSNotification*)notification{
    TFJunYou_AudioCell* cell = (TFJunYou_AudioCell*)notification.object;
    TFJunYou_MessageObject *msg=cell.msg;
    _lastIndex = cell.indexNum;
    //msg.isReadDel = [NSNumber numberWithBool:YES];
    if ([msg.isReadDel boolValue]) {
        return;
    }
    if(_lastIndex >= _array.count)
        return;
    
    while (_lastIndex<_array.count) {
        _lastIndex++;
        if(_lastIndex>=_array.count)
            break;
        msg = [_array objectAtIndex:_lastIndex];
        if([msg.type intValue] == kWCMessageTypeVoice && ![msg.isRead boolValue] && !msg.isMySend){
            TFJunYou_AudioCell* nextCell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_lastIndex inSection:0]];
            [nextCell.audioPlayer switch];
            break;
        }
    }
    
    msg = nil;
    cell = nil;
}

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    return bCanRecord;
}

- (void)readDeleWithUser:(TFJunYou_MessageObject *)p{
    self.readDelNum ++;
    if ([p.fromUserId isEqualToString:MY_USER_ID]) {
        for (NSInteger i = 0; i < _array.count; i ++) {
            TFJunYou_MessageObject *msg = _array[i];
            if ([p.messageId isEqualToString:msg.messageId]) {
                msg.type = [NSNumber numberWithInt:kWCMessageTypeRemind];
                msg.content = Localized(@"JX_OtherLookedYourReadingMsg");
                [msg update];
                
                [_table reloadData];
                
                break;
            }
        }
    }else {
        [self deleteMsg:p];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.readDelNum > 5) {
            self.readDelNum = 0;
            [self.tableView reloadData];
            NSLog(@"readDelNum ----- %d", self.readDelNum);
        }
    });
}

//#pragma mark--------登录状态改变
//-(void)onLoginChanged:(NSNotification *)notifacation{
//    [_wait stop];
//    if (_isShowLoginChange) {
//        switch ([TFJunYou_XMPP sharedInstance].isLogined){
//            case login_status_ing:
//                // 连接失败
//                [TFJunYou_MyTools showTipView:Localized(@"JX_ConnectFailed")];
//                break;
//            case login_status_no:
//                // 连接失败
//                [TFJunYou_MyTools showTipView:Localized(@"JX_ConnectFailed")];
//                break;
//            case login_status_yes:
//                // 连接成功
//                [TFJunYou_MyTools showTipView:Localized(@"JX_ConnectSuccessfully")];
//                break;
//        }
//    }
//}

- (void)onBackForRecordBtnLeft {
    self.objToMsg = nil;
    [_recordBtnLeft setBackgroundImage:[UIImage imageNamed:@"im_input_ptt_normal"] forState:UIControlStateNormal];
    [_recordBtnLeft setBackgroundImage:[UIImage imageNamed:@"im_input_keyboard_normal"] forState:UIControlStateSelected];
    [_recordBtnLeft removeTarget:self action:@selector(onBackForRecordBtnLeft) forControlEvents:UIControlEventTouchUpInside];
    [_recordBtnLeft addTarget:self action:@selector(recordSwitch:) forControlEvents:UIControlEventTouchUpInside];
    _messageText.textColor = [UIColor blackColor];
    _messageText.text = nil;
    _hisReplyMsg = nil;
    [self textViewDidChange:_messageText];
    
}

- (void)getTextViewWatermark {
    if (_hisReplyMsg.length <= 0) {
        return;
    }
    [_messageText becomeFirstResponder];
    // 长按回复 显示水印
    if (![self changeEmjoyText:_hisReplyMsg textColor:[UIColor lightGrayColor]]) {
        [_messageText.textStorage insertAttributedString:[[NSAttributedString alloc] initWithString:_hisReplyMsg         attributes:@{NSFontAttributeName:SYSFONT(18),NSForegroundColorAttributeName:[UIColor lightGrayColor]}] atIndex:_messageText.selectedRange.location];
    }
    _messageText.textColor = [UIColor lightGrayColor];
    _messageText.selectedRange = NSMakeRange(0, 0);
    [self setTableFooterFrame:_messageText];
}

// 长按回复
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell replyIndexNum:(int)indexNum {
    if (!_messageText.userInteractionEnabled) {
        [TFJunYou_MyTools showTipView:@"您已被禁止发言"];
        return;
    }

    TFJunYou_MessageObject *msg = _array[indexNum];
    if (_recordBtnLeft.selected) {
        [self recordSwitch:_recordBtnLeft];
    }
    [_messageText becomeFirstResponder];
    [_recordBtnLeft setBackgroundImage:[UIImage imageNamed:@"chat_back_reply"] forState:UIControlStateNormal];
    [_recordBtnLeft removeTarget:self action:@selector(recordSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [_recordBtnLeft addTarget:self action:@selector(onBackForRecordBtnLeft) forControlEvents:UIControlEventTouchUpInside];
    _hisReplyMsg = [NSString stringWithFormat:@"%@%@:%@",Localized(@"JX_Reply"),msg.fromUserName,[msg getTypeName]];
    // 显示水印
    [self getTextViewWatermark];
    // 转成json数据
    SBJsonWriter * OderJsonwriter = [SBJsonWriter new];
    NSString * jsonString = [OderJsonwriter stringWithObject:[msg toDictionary]];
    self.objToMsg = jsonString;
}

// 分享
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell shareWXIndexNum:(int)indexNum {
    [self hideKeyboard:NO];
    memberData *data = [self.room getMember:g_myself.userId];
    if ([data.role integerValue] == 4) {
        [TFJunYou_MyTools showTipView:@"隐身人不能转发消息"];
        return;
    }
    
    TFJunYou_MessageObject *msg = _array[indexNum];
    TFJunYou_RelayVC *vc = [[TFJunYou_RelayVC alloc] init];
    vc.chatPerson = self.chatPerson;
    vc.roomJid = self.roomJid;
    vc.isMoreSel = YES;
    vc.chatVC = self;
    NSMutableArray *array = [NSMutableArray arrayWithObject:msg];
    vc.relayMsgArray = array;
    [g_navigation pushViewController:vc animated:YES];
}

// 长按转发
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell RelayIndexNum:(int)indexNum {
    [self hideKeyboard:NO];
    memberData *data = [self.room getMember:g_myself.userId];
    if ([data.role integerValue] == 4) {
        [TFJunYou_MyTools showTipView:@"隐身人不能转发消息"];
        return;
    }
    
    TFJunYou_MessageObject *msg = _array[indexNum];
    TFJunYou_RelayVC *vc = [[TFJunYou_RelayVC alloc] init];
    vc.chatPerson = self.chatPerson;
    vc.roomJid = self.roomJid;
    vc.isMoreSel = YES;
    vc.chatVC = self;
    NSMutableArray *array = [NSMutableArray arrayWithObject:msg];
//    vc.msg = msg;
    vc.relayMsgArray = array;
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)setRelayMsgArray:(NSMutableArray *)relayMsgArray {
    _relayMsgArray = relayMsgArray;
    self.friendStatus = friend_status_friend;
    if (!self.roomJid) {
        for (TFJunYou_MessageObject *msg in relayMsgArray) {
            if ([msg.type intValue] == kWCMessageTypeRedPacket) {
                msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
                msg.content = [NSString stringWithFormat:@"[%@]", Localized(@"JX_RED")];
                msg.chatMsgHeight = @"0";
            }
            if ([msg.type intValue] == kWCMessageTypeAudioMeetingInvite || [msg.type intValue] == kWCMessageTypeVideoMeetingInvite || [msg.type intValue] == kWCMessageTypeAudioChatCancel || [msg.type intValue] == kWCMessageTypeAudioChatEnd || [msg.type intValue] == kWCMessageTypeVideoChatCancel || [msg.type intValue] == kWCMessageTypeVideoChatEnd || [msg.type intValue] == kWCMessageTypeAVBusy) {
                
                msg.type = [NSNumber numberWithInt:kWCMessageTypeText];
                msg.content = [NSString stringWithFormat:@"[%@]", Localized(@"JX_AudioAndVideoCalls")];
                msg.chatMsgHeight = @"0";
            }
            [self relay:msg];
        }
//        [self relay];
    }
}

//- (void)setRelayMsg:(TFJunYou_MessageObject *)relayMsg {
//    _relayMsg = relayMsg;
//    self.friendStatus = friend_status_friend;
//    if (!self.roomJid) {
//        [self relay];
//    }
//}

- (void) relay:(TFJunYou_MessageObject *)msg{
    if([self showDisableSay])
        return;
    if([self sendMsgCheck]){
        return;
    }
    
    if (msg.content.length > 0) {
        TFJunYou_MessageObject *msg1 = [[TFJunYou_MessageObject alloc]init];
        msg1 = [msg copy];
        msg1.messageId = nil;
        msg1.timeSend     = [NSDate date];
        msg1.fromId = nil;
        msg1.fileSize = nil;
        msg1.fileName = nil;
        msg1.fromUserId   = MY_USER_ID;
        if([self.roomJid length]>0){
            msg1.toUserId = self.roomJid;
            msg1.isGroup = YES;
            msg1.fromUserName = _userNickName;
        }
        else{
            msg1.toUserId     = chatPerson.userId;
            msg1.isGroup = NO;
        }
        //        msg.content      = relayMsg.content;
        //        msg.type         = relayMsg.type;
        msg1.isSend       = [NSNumber numberWithInt:transfer_status_ing];
        msg1.isRead       = [NSNumber numberWithBool:NO];
        msg1.isReadDel    = [NSNumber numberWithInt:NO];
        //发往哪里
        [msg1 insert:self.roomJid];
        [g_xmpp sendMessage:msg1 roomName:self.roomJid];//发送消息
        [self showOneMsg:msg1];
        if (_table.contentSize.height > (TFJunYou__SCREEN_HEIGHT + self.deltaHeight - self.heightFooter - 64 - 40 - 20)) {
            if (self.deltaY >= 0) {
                
            }else {
                
                if (self.tableFooter.frame.origin.y != TFJunYou__SCREEN_HEIGHT-self.heightFooter) {
                    [CATransaction begin];
                    [UIView animateWithDuration:0.1f animations:^{
                        //            self.tableFooter.frame = CGRectMake(0, self.view.frame.size.height+deltaY-self.heightFooter, TFJunYou__SCREEN_WIDTH, self.heightFooter);
                        [_table setFrame:CGRectMake(0, 0+_noticeHeight, _table.frame.size.width, self.view.frame.size.height+self.deltaHeight-self.heightFooter-_noticeHeight)];
                        //                [_table gotoLastRow:NO];
                    } completion:^(BOOL finished) {
                    }];
                    [CATransaction commit];
                }
                
            }
            
        }
    }
    
    [_messageText setText:nil];
    
    
    if (self.isShare && self.shareSchemes) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT)];
            self.shareView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
            [g_window addSubview:self.shareView];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH - 100, 220)];
            view.backgroundColor = [UIColor whiteColor];
            view.center = CGPointMake(self.shareView.frame.size.width / 2, self.shareView.frame.size.height / 2);
            view.layer.cornerRadius = 3.0;
            view.layer.masksToBounds = YES;
            [self.shareView addSubview:view];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 50, 50)];

            imageView.image = [UIImage imageNamed:@"ALOGO_120"];
            imageView.center = CGPointMake(view.frame.size.width / 2, imageView.center.y);
            [view addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5, view.frame.size.width, 30)];
            label.font = [UIFont systemFontOfSize:18];
            label.text = Localized(@"JX_Sended");
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 90, view.frame.size.width, LINE_WH)];
            line.backgroundColor = THE_LINE_COLOR;
            [view addSubview:line];
            
            UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, line.frame.origin.y, line.frame.size.width, 45)];
            [btn1 setTitle:Localized(@"JX_Return") forState:UIControlStateNormal];
            [btn1 setTitleColor:THEMECOLOR forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(shareBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn1];
            
            line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 45, view.frame.size.width, LINE_WH)];
            line.backgroundColor = THE_LINE_COLOR;
            [view addSubview:line];
            
            UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, line.frame.origin.y, line.frame.size.width, 45)];
            [btn2 setTitle:[NSString stringWithFormat:@"%@%@",Localized(@"JX_ToStayIn"),APP_NAME] forState:UIControlStateNormal];
            [btn2 setTitleColor:THEMECOLOR forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(shareKeepBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn2];
        });
    }
    
}

- (void)shareBackBtnAction {
    NSString *str = [NSString stringWithFormat:@"%@://type=%@",self.shareSchemes,@"Share"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] options:nil completionHandler:^(BOOL success) {
    }];
    
    self.shareView.hidden = YES;
    [self.shareView removeFromSuperview];
}

- (void)shareKeepBtnAction {
    self.shareView.hidden = YES;
    [self.shareView removeFromSuperview];
}

// 长按删除
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell deleteIndexNum:(int)indexNum {
    TFJunYou_MessageObject *msg = _array[indexNum];
    NSString* s;
    if([self.roomJid length]>0)
        s = self.roomJid;
    else
        s = chatPerson.userId;
    
    
    if (indexNum == _array.count - 1) {
        TFJunYou_MessageObject *newLastMsg;
        if (indexNum == 0) {
            newLastMsg = [_array firstObject];
        }else {
            newLastMsg = _array[indexNum - 1];
        }
        self.lastMsg.content = newLastMsg.content;
        [newLastMsg updateLastSend:UpdateLastSendType_None];
    }
    
    //删除本地聊天记录
    [_array removeObjectAtIndex:indexNum];
    [msg delete];
    
//    [_table deleteRow:indexNum section:0];
    [_table reloadData];
    if (self.courseId.length > 0) {
//        NSDictionary *dict = self.courseArray[indexNum];
        [g_server userCourseUpdateWithCourseId:self.courseId MessageIds:nil CourseName:nil CourseMessageId:msg.messageId toView:self];
    }else {
        int type = 1;
        if (self.roomJid) {
            type = 2;
        }
        self.withdrawIndex = -1;
        [g_server tigaseDeleteMsgWithMessageId:msg.messageId type:type deleteType:1 roomJid:self.roomJid toView:self];
    }
}

// 长按撤回
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell withdrawIndexNum:(int)indexNum {
    
    if ([self sendMsgCheck]) {
        return;
    }
    
    TFJunYou_MessageObject *msg = _array[indexNum];
    self.withdrawIndex = indexNum;
    int type = 1;
    if (self.roomJid) {
        type = 2;
    }
    [g_server tigaseDeleteMsgWithMessageId:msg.messageId type:type deleteType:2 roomJid:self.roomJid toView:self];
}

// 长按收藏 && 长按添加表情
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell favoritIndexNum:(int)indexNum type:(CollectType)collectType{
    TFJunYou_MessageObject *msg = _array[indexNum];
    NSMutableArray *emoji = [[NSMutableArray alloc] init];
    if (collectType == CollectTypeEmoji) {
        for (NSInteger i = 0; i < g_myself.favorites.count; i ++) {
            JLFacePackgeModel *model = g_myself.favorites[i];
            NSString *url = model.path[0];
            
            if ([msg.content isEqualToString:url]) {
                
                [TFJunYou_MyTools showTipView:Localized(@"JX_ExpressionAdded")];
                return;
            }
        }
    }
    NSString *type = [NSString stringWithFormat:@"%ld",collectType];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    if (collectType != CollectTypeEmoji) {
        [dataDict setValue:msg.messageId forKey:@"msgId"];
    }
    [dataDict setValue:msg.content forKey:@"msg"];
    [dataDict setValue:type forKey:@"type"];
    [dataDict setValue:self.roomJid forKey:@"roomJid"];
    [dataDict setValue:@0 forKey:@"collectType"];
    [dataDict setValue:msg.content forKey:@"url"];

    [emoji addObject:dataDict];
//    NSString * jsonString = [[SBJsonWriter new] stringWithObject:[msg toDictionary]];
//    [g_server addFavoriteWithContent:jsonString type:collectType toView:self];
    
    if (collectType == CollectTypeEmoji){
        // 添加单个表情
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time = [date timeIntervalSince1970]*1000;
        NSString *mixString = [NSString stringWithFormat:@"%.0f", time];
        NSString *faceName = [NSString stringWithFormat:@"%@.jpg", mixString];
        [g_server addFaceClollect:@"" faceName:@"noFacename" url:msg.content View:self];
    } else {
        // 收藏
        [g_server addFavoriteWithEmoji:emoji toView:self];
    }
    
    
//    [g_server userEmojiAddWithUrl:msg.content toView:self];
    
    
    
}

// 多选
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell selectMoreIndexNum:(int)indexNum {
    [self hideKeyboard:NO];
    self.isSelectMore = YES;
    self.selectMoreView.hidden = NO;
    [self.gotoBackBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.gotoBackBtn setTitle:Localized(@"JX_Cencal") forState:UIControlStateNormal];
    [self enableCell];
    [self.tableView reloadData];
}

// 多选选择
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell checkBoxSelectIndexNum:(int)indexNum isSelect:(BOOL)isSelect {
    
    TFJunYou_MessageObject *msg = _array[indexNum];
    
    if ([msg.isReadDel boolValue]) {
        chatCell.checkBox.selected = NO;
        [g_App showAlert:Localized(@"JX_MessageBurningNo")];
        return;
    }
    
    if (isSelect) {
        [_selectMoreArr addObject:_array[indexNum]];
    }else {
        [_selectMoreArr removeObject:_array[indexNum]];
    }
}

// 长按开始录制
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell startRecordIndexNum:(int)indexNum {
    [_recordArray removeAllObjects];
    self.isRecording = YES;
    self.recordStarNum = indexNum;
    self.title = Localized(@"JX_StopRecording");
    [self setAudioIconFrame];
}

// 长按结束录制
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell stopRecordIndexNum:(int)indexNum {
    
    for (NSInteger i = self.recordStarNum; i<= indexNum; i ++) {
        if (i >= _array.count) {
            return;
        }
        TFJunYou_MessageObject *msg = _array[i];

        if([msg isVisible] && [msg.type intValue]!=kWCMessageTypeIsRead && [msg.fromUserId isEqualToString:MY_USER_ID] && [msg.isReadDel intValue] != 1&&[msg.type intValue]!=kWCMessageTypeAudioChatCancel&&[msg.type intValue]!=kWCMessageTypeAudioChatEnd&&[msg.type intValue]!=kWCMessageTypeAudioMeetingInvite&&[msg.type intValue]!=kWCMessageTypeVideoMeetingInvite&&[msg.type intValue]!=kWCMessageTypeVideoChatCancel&&[msg.type intValue]!=kWCMessageTypeVideoChatEnd&&[msg.type intValue]!=kWCMessageTypeRedPacket&&[msg.type intValue]!=kWCMessageTypeTransfer&&[msg.type intValue]!=kWCMessageTypeAVBusy)
            if (msg.messageId) {
                [_recordArray addObject:msg.messageId];
            }
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Localized(@"JX_InputCourseName") message:nil delegate:self cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm"), nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
//    NSString *str = self.onlinestate ? Localized(@"JX_OnLine") : Localized(@"JX_OffLine");
    if (self.roomJid || ([chatPerson.userId intValue]<10100 && [chatPerson.userId intValue]>=10000)) {
        self.title = chatPerson.userNickname;
        [self setAudioIconFrame];
    }else {
        
//        self.title = [NSString stringWithFormat:@"%@(%@)",chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname,str];
        [self setChatTitle:chatPerson.remarkName.length > 0 ? chatPerson.remarkName : chatPerson.userNickname];
    }
    self.isRecording = NO;
    self.recordStarNum = 0;
    
    [self hideKeyboard:NO];
}
// 消息重发
- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell resendIndexNum:(int)indexNum {
    TFJunYou_ActionSheetVC *actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JX_Delete"),Localized(@"JXBaseChatCell_SendAngin")]];
    actionVC.tag = 1111;
    actionVC.delegate = self;
    self.indexNum = indexNum;
    [self presentViewController:actionVC animated:NO completion:nil];
}

- (void)chatCell:(TFJunYou_BaseChatCell *)chatCell audioPlayChangeIndexNum:(int)indexNum {
    BOOL flag = [g_default boolForKey:kChatVCMessageAudioIsNotPlayback];
    if (!flag) {
        // 听筒播放
        [g_default setBool:YES forKey:kChatVCMessageAudioIsNotPlayback];
    }else {
        // 扬声器播放
        [g_default setBool:NO forKey:kChatVCMessageAudioIsNotPlayback];
    }
    
    [self setAudioIconFrame];
}

- (BOOL)getRecording {
    return self.isRecording;
}
- (NSInteger)getRecordStarNum {
    return self.recordStarNum;
}

// 发送课程
- (void)sendCourseAction {
    
    if (_array.count <= 0) {
        [TFJunYou_MyTools showTipView:Localized(@"JX_ThisCourseEmpty")];
        return;
    }

    if (g_commonService.courseTimer) {
        [TFJunYou_MyTools showTipView:Localized(@"JX_SendingPleaseWait")];
        return;
    }
    TFJunYou_RelayVC *vc = [[TFJunYou_RelayVC alloc] init];
    vc.isCourse = YES;
    vc.relayDelegate = self;
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)sendCourse:(NSTimer *) timer{
    
    TFJunYou_MsgAndUserObject *obj = timer.userInfo;
    BOOL isRoom;
    if ([obj.user.roomFlag intValue] > 0  || obj.user.roomId.length > 0) {
        isRoom = YES;
    }else {
        isRoom = NO;
    }
    
    self.sendIndex ++;
//    [_chatWait start:[NSString stringWithFormat:@"正在发送：%d/%ld",self.sendIndex,_array.count] inView:g_window];
    [_chatWait setCaption:[NSString stringWithFormat:@"%@：%d/%ld",Localized(@"JX_SendNow"),self.sendIndex,_array.count]];
    [_chatWait update];
    
    TFJunYou_MessageObject *msg= _array[self.sendIndex - 1];
    msg.messageId = nil;
    msg.timeSend     = [NSDate date];
    msg.fromId = nil;
    msg.fromUserId   = MY_USER_ID;
    if(isRoom){
        msg.toUserId = obj.user.userId;
        msg.isGroup = YES;
        msg.fromUserName = g_myself.userNickname;
    }
    else{
        msg.toUserId     = obj.user.userId;
        msg.isGroup = NO;
    }
    //        msg.content      = relayMsg.content;
    //        msg.type         = relayMsg.type;
    msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
    msg.isRead       = [NSNumber numberWithBool:NO];
    msg.isReadDel    = [NSNumber numberWithInt:NO];
    //发往哪里
    if (isRoom) {
        [msg insert:obj.user.userId];
        [g_xmpp sendMessage:msg roomName:obj.user.userId];//发送消息
    }else {
        [msg insert:nil];
        [g_xmpp sendMessage:msg roomName:nil];//发送消息
    }
    
    if (_array.count == self.sendIndex) {
        [_chatWait stop];
        [_timer invalidate];
        _timer = nil;
        [TFJunYou_MyTools showTipView:Localized(@"JXAlert_SendOK")];
    }
}

- (void)relay:(TFJunYou_RelayVC *)relayVC MsgAndUserObject:(TFJunYou_MsgAndUserObject *)obj {
    
//    [g_subWindow addSubview:_suspensionBtn];
//    g_subWindow.hidden = YES;
//    _chatWait.view.frame = CGRectMake(0, 0, 50, 50);
//    [_chatWait start:[NSString stringWithFormat:@"%@：1/%ld",Localized(@"JX_SendNow"),_array.count] inView:g_subWindow];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [g_commonService sendCourse:obj Array:_array];
    });
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendCourse:) userInfo:obj repeats:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 2457) {
        
        if (buttonIndex == 1) {
            
//            NSMutableString *msgIds = [NSMutableString string];
//            NSMutableString *types = [NSMutableString string];
            NSMutableArray *emoji = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < self.selectMoreArr.count; i ++) {
                TFJunYou_MessageObject *msg = self.selectMoreArr[i];
                if ([msg.type intValue] == kWCMessageTypeText || [msg.type intValue] == kWCMessageTypeImage || [msg.type intValue] == kWCMessageTypeCustomFace || [msg.type intValue] == kWCMessageTypeEmoji || [msg.type intValue] == kWCMessageTypeVoice || [msg.type intValue] == kWCMessageTypeVideo || [msg.type intValue] == kWCMessageTypeFile) {
                    
                    CollectType collectType = CollectTypeDefult;
                    if ([msg.type intValue] == kWCMessageTypeImage) {
                        collectType = CollectTypeImage;
                    }else if ([msg.type intValue] == kWCMessageTypeCustomFace) {
                        collectType = CollectTypeEmoji;
                    }else if ([msg.type intValue] == kWCMessageTypeEmoji) {
                        collectType = CollectTypeEmoji;
                    }else if ([msg.type intValue] == kWCMessageTypeVideo) {
                        collectType = CollectTypeVideo;
                    }else if ([msg.type intValue] == kWCMessageTypeFile) {
                        collectType = CollectTypeFile;
                    }else if ([msg.type intValue] == kWCMessageTypeVoice) {
                        collectType = CollectTypeVoice;
                    }else if ([msg.type intValue] == kWCMessageTypeText) {
                        collectType = CollectTypeText;
                    }else {
                        
                    }
                    if (collectType == CollectTypeDefult) {
                        return;
                    }
//                    NSDictionary *dict = g_myself.favorites[i];
//                    NSString *url = dict[@"url"];
//                    if ([msg.content isEqualToString:url]) {
//                        continue;
//                    }

                    NSString *type = [NSString stringWithFormat:@"%ld",collectType];
                    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
                    [dataDict setValue:msg.messageId forKey:@"msgId"];
                    [dataDict setValue:msg.content forKey:@"msg"];
                    [dataDict setValue:type forKey:@"type"];
                    [dataDict setValue:self.roomJid forKey:@"roomJid"];
                    [dataDict setValue:@0 forKey:@"collectType"];

                    [emoji addObject:dataDict];
                    
//                    if (msgIds.length <= 0) {
//                        [msgIds appendString:msg.messageId];
//                        [types appendString:[NSString stringWithFormat:@"%ld",collectType]];
//                    }else {
//                        [msgIds appendFormat:@",%@", msg.messageId];
//                        [types appendFormat:@",%@", [NSString stringWithFormat:@"%ld",collectType]];
//                    }
                    
                }
            }
            
            if (emoji.count > 0) {
                [g_server addFavoriteWithEmoji:emoji toView:self];
            }else {
                if (self.isSelectMore) {
                    [self actionQuit];
                }
            }

        }
        
    }else if (alertView.tag == 2458) {
        
        for (NSInteger i = 0; i < self.selectMoreArr.count; i ++) {
            TFJunYou_MessageObject *msg = self.selectMoreArr[i];
            if ([msg.type intValue] == kWCMessageTypeImage || [msg.type intValue] == kWCMessageTypeCustomFace|| [msg.type intValue] == kWCMessageTypeEmoji) {
                UIImageView *imageView = [[UIImageView alloc] init];
                NSURL* url;
                if(msg.isMySend && isFileExist(msg.fileName))
                    url = [NSURL fileURLWithPath:msg.fileName];
                else
                    url = [NSURL URLWithString:msg.content];
                [imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    if (!error) {
                        [self saveImageToPhotos:imageView.image];
                    }
                }];
            }
            
            if ([msg.type integerValue] == kWCMessageTypeVideo) {
                
                if ([msg.content rangeOfString:@"http"].location != NSNotFound) {
                    [self playerDownload:msg.content];
                }else {
                    [self saveVideo:msg.content];
                }
                
            }
        }
        
        if (self.isSelectMore) {
            [self actionQuit];
        }
        
    }else if (alertView.tag == 3457) {
        if (buttonIndex == 1) {

            NSMutableArray *selects = [NSMutableArray array];
            for (NSInteger i = 0; i < self.selectMoreArr.count; i ++) {
                TFJunYou_MessageObject *msg = [self.selectMoreArr[i] copy];
                if ([msg.type intValue] != kWCMessageTypeRedPacket && [msg.type intValue] != kWCMessageTypeTransfer) {
                    [selects addObject:msg];
                }
            }
            
            TFJunYou_RelayVC *vc = [[TFJunYou_RelayVC alloc] init];
            vc.relayMsgArray = [NSMutableArray arrayWithArray:selects];
            [g_navigation pushViewController:vc animated:YES];
        }
    }else {
        if (buttonIndex == 1) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            if (tf.text.length <= 0) {
                [g_App showAlert:Localized(@"JX_InputCourseName")];
                return;
            }
            _recordName = tf.text;
            NSMutableString *recordStr = [NSMutableString string];
            for (NSInteger i = 0; i < _recordArray.count; i ++) {
                NSString *str = _recordArray[i];
                if (i == _recordArray.count - 1) {
                    [recordStr appendString:str];
                }else {
                    [recordStr appendFormat:@"%@,",str];
                }
            }
            
            [g_server userCourseAddWithMessageIds:recordStr CourseName:_recordName RoomJid:self.roomJid toView:self];
        }
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{

    if (!error) {
        
        [TFJunYou_MyTools showTipView:Localized(@"JX_SaveSuessed")];
    }else {
        [TFJunYou_MyTools showTipView:Localized(@"JX_SaveFiled")];
    }
}

//-----下载视频--
- (void)playerDownload:(NSString *)url{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"jaibaili.mp4"];
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       [self saveVideo:fullPath];
                   }];
    [task resume];
    
}


// 发送正在输入
- (void) sendEntering {
    TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;

    msg.toUserId     = chatPerson.userId;
    msg.type         = [NSNumber numberWithInt:kWCMessageTypeRelay];
    [g_xmpp sendMessage:msg roomName:self.roomJid];//发送消息
}

// 群更改昵称
- (void)setNickName:(NSString *)nickName {
    _userNickName = nickName.length > 0 ? nickName : _userNickName;
    [_table reloadData];
}
// 发送邀请群成员验证
- (void)needVerify:(TFJunYou_MessageObject *)msg {
    [self showOneMsg:msg];
}

// 单条图文点击
- (void) onDidSystemImage1:(NSNotification *)notif {
    if (recording) {
        return;
    }
    TFJunYou_MessageObject *msg = notif.object;
    SBJsonParser * parser = [[SBJsonParser alloc] init] ;
    id content = [parser objectWithString:msg.content];
    NSString *url = [(NSDictionary *)content objectForKey:@"url"];
    
    webpageVC *webVC = [webpageVC alloc];
    webVC.isGotoBack= YES;
    webVC.isSend = YES;
    webVC.title = [(NSDictionary *)content objectForKey:@"title"];
    webVC.url = url;
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
//    [g_navigation pushViewController:webVC animated:YES];
    
}

// 多条图文点击
- (void) onDidSystemImage2:(NSNotification *)notif {
    if (recording) {
        return;
    }
    NSDictionary *dic = notif.object;
    NSString *url = [dic objectForKey:@"url"];
    
    webpageVC *webVC = [webpageVC alloc];
    webVC.isGotoBack= YES;
    webVC.isSend = YES;
    webVC.title = [dic objectForKey:@"title"];
    webVC.url = url;
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
//    [g_navigation pushViewController:webVC animated:YES];
    
}

// 音视频通话状态cell点击
- (void) onDidAVCall:(NSNotification *)notif {
    if (recording) {
        return;
    }
    TFJunYou_MessageObject *msg = notif.object;
    
    BOOL isMeeting = NO;
    switch ([msg.type intValue]) {
        case kWCMessageTypeAudioMeetingInvite:
        case kWCMessageTypeAudioChatCancel:
        case kWCMessageTypeAudioChatEnd: {
            self.isAudioMeeting = YES;
            isMeeting = YES;
        }
//            [self onChatAudio:msg];
            break;
        case kWCMessageTypeVideoMeetingInvite:
        case kWCMessageTypeVideoChatCancel:
        case kWCMessageTypeVideoChatEnd: {
            self.isAudioMeeting = NO;
            isMeeting = YES;
        }
//            [self onChatVideo:msg];
            break;
            
        case kWCMessageTypeAVBusy: {
            if ([msg.objectId isEqualToString:@"1"]) {
                self.isAudioMeeting = NO;
            }else {
                self.isAudioMeeting = YES;
            }
        }
            
        default:
            break;
    }
    
    if (isMeeting && [g_config.isOpenCluster integerValue] == 1) {
        
        [g_server userOpenMeetWithToUserId:chatPerson.userId toView:self];
    }else {
        if (self.isAudioMeeting) {
            [self onChatAudio:msg];
        }else {
            [self onChatVideo:msg];
        }
    }
}

// 文件cell点击
- (void) onDidFile:(NSNotification *)notif {
    if (recording) {
        return;
    }
    TFJunYou_MessageObject *msg = notif.object;
    TFJunYou_ShareFileObject *obj = [[TFJunYou_ShareFileObject alloc] init];
    obj.fileName = [msg.fileName lastPathComponent];
    obj.url = msg.content;
    obj.size = msg.fileSize;
    
    TFJunYou_FileDetailViewController *vc = [[TFJunYou_FileDetailViewController alloc] init];
    vc.shareFile = obj;
//    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];

}

// 链接cell点击
- (void) onDidLink:(NSNotification *)notif {
    if (recording) {
        return;
    }
    [_messageText resignFirstResponder];
    
    TFJunYou_MessageObject *msg = notif.object;
    SBJsonParser * parser = [[SBJsonParser alloc] init] ;
    id content = [parser objectWithString:msg.content];
    NSString *url = [(NSDictionary *)content objectForKey:@"url"];
    
    webpageVC *webVC = [webpageVC alloc];
    webVC.isGotoBack= YES;
    webVC.isSend = YES;
    webVC.title = [(NSDictionary *)content objectForKey:@"title"];
    webVC.url = url;
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
//    [g_navigation pushViewController:webVC animated:YES];
    
}

// 戳一戳点击
- (void)onDidShake:(NSNotification *)notif {
    TFJunYou_MessageObject *msg = notif.object;
    
    int value = 0;
    if (msg.isMySend) {
        value = -50;
    }else {
        value = 50;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///横向移动
    
    animation.toValue = [NSNumber numberWithInt:value];
    
    animation.duration = .5;
    
    animation.removedOnCompletion = YES;//yes的话，又返回原位置了。
    
    animation.repeatCount = 2;
    
    animation.fillMode = kCAFillModeForwards;
    
    [_messageText.inputView.superview.layer addAnimation:animation forKey:nil];
    [g_window.layer addAnimation:animation forKey:nil];
}

// 合并转发点击
- (void)onDidMergeRelay:(NSNotification *)notif {
    TFJunYou_MessageObject *msg = notif.object;
    SBJsonParser * parser = [[SBJsonParser alloc] init] ;
    NSArray *content = [parser objectWithString:msg.content];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < content.count; i ++) {
        NSString *str = content[i];
        NSDictionary *dict = [parser objectWithString:str];
        TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
        [msg fromDictionary:dict];
        msg.isNotUpdateHeight = YES;
        [array addObject:msg];
    }
    
    TFJunYou_ChatLogVC *vc = [[TFJunYou_ChatLogVC alloc] init];
    
    vc.array = array;
    vc.title = msg.objectId;
    [g_navigation pushViewController:vc animated:YES];
    
}

// 分享cell点击
- (void)onDidShare:(NSNotification *)notif {
    if (recording) {
        return;
    }
    TFJunYou_MessageObject *msg = notif.object;
     NSDictionary * msgDict = [[[SBJsonParser alloc]init]objectWithString:msg.objectId];
    
    NSString *url = [msgDict objectForKey:@"url"];
    NSString *downloadUrl = [msgDict objectForKey:@"downloadUrl"];
    
    if ([url rangeOfString:@"http"].location == NSNotFound) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:^(BOOL success) {
            
            if (!success) {
                
                webpageVC *webVC = [webpageVC alloc];
                webVC.isGotoBack= YES;
                webVC.isSend = YES;
                webVC.titleString = [msgDict objectForKey:@"title"];
                webVC.url = downloadUrl;
                webVC = [webVC init];
                [g_navigation.navigationView addSubview:webVC.view];
//                [g_navigation pushViewController:webVC animated:YES];
            }
            
        }];
        
    }else {
        webpageVC *webVC = [webpageVC alloc];
        webVC.isGotoBack= YES;
        webVC.isSend = YES;
        webVC.titleString = [msgDict objectForKey:@"title"];
        webVC.url = url;
        webVC = [webVC init];
        [g_navigation.navigationView addSubview:webVC.view];
//        [g_navigation pushViewController:webVC animated:YES];
    }
    
}

// 控制消息点击
- (void)onDidRemind:(NSNotification *)notif {
    TFJunYou_MessageObject *msg = notif.object;
    
    if ([msg.remindType intValue] == kRoomRemind_NeedVerify) {
        TFJunYou_VerifyDetailVC *vc = [[TFJunYou_VerifyDetailVC alloc] init];
        vc.chatVC = self;
        vc.msg = msg;
        vc.room = self.room;
        [g_navigation pushViewController:vc animated:YES];
    }
    
    if ([msg.remindType intValue] == kWCMessageTypeRedPacketReceive) {
        self.isDidRedPacketRemind = YES;
        [g_server getRedPacket:msg.objectId toView:self];
    }
}

// 回复消息点击
- (void)onDidReply:(NSNotification *)notif {
    int indexNum = [notif.object intValue];
    TFJunYou_MessageObject *msg = _array[indexNum];
    
    TFJunYou_MessageObject *msgObj = [[TFJunYou_MessageObject alloc] init];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dict = [jsonParser objectWithString:msg.objectId];
    [msgObj fromDictionary:dict];
    for (TFJunYou_MessageObject *msg1 in _array) {
        if ([msgObj.messageId isEqualToString:msg1.messageId]) {
            NSUInteger index = [_array indexOfObject:msg1];
            [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    
}

// 文本消息阅后即焚
- (void)onDidMessageReadDel:(NSNotification *)notif {
    //    int indexNum = [notif.object intValue];
    //    [_table reloadRow:indexNum section:0];
    [_table reloadData];

}

// 消息撤回
- (void)withdrawNotifi:(NSNotification *) notif {
    TFJunYou_MessageObject *msg = notif.object;
    
    for(NSInteger i=[_array count]-1;i>=0;i--){
        TFJunYou_MessageObject *p = _array[i];
        if([p.messageId isEqualToString:msg.messageId]){//如果找到被撤回的那条消息
            p.content = msg.content;
            p.type = msg.type;
            [_table reloadRow:(int)i section:0];
        }
    }
}

- (void)enableCell{
    for (int i = 0; i < _array.count; i++) {
        TFJunYou_BaseChatCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.bubbleBg.userInteractionEnabled = !self.isSelectMore;
    }
}

- (void)createRoom{
    if (recording) {
        return;
    }
    TFJunYou_ChatSettingVC *vc = [[TFJunYou_ChatSettingVC alloc] init];
    vc.user = self.chatPerson;
    vc.room = self.room;
    vc.chatRoom = self.chatRoom;
    [g_navigation pushViewController:vc animated:YES];
    
//    TFJunYou_SelFriendVC* vc = [TFJunYou_SelFriendVC alloc];
////    vc.chatRoom = _chatRoom;
//    vc.room = _room;
//    vc.isNewRoom = YES;
//    vc.isForRoom = YES;
//    vc.forRoomUser = chatPerson;
//    vc = [vc init];
////    [g_window addSubview:vc.view];
//    [g_navigation pushViewController:vc animated:YES];
}

- (BOOL)sendMsgCheck {
    // 验证XMPP是否在线
    if(g_xmpp.isLogined == login_status_no){
        //        [self hideKeyboard:NO];
        //        [g_xmpp showXmppOfflineAlert];
        //        return YES;
        
        //        [g_xmpp logout];
        [g_xmpp login];
        
    }
    
    if (self.roomJid) {
        NSString *s;
        // 验证群组是否有效
        switch ([self.groupStatus intValue]) {
            case 0:
                s = nil;
                break;
            case 1:
                s = Localized(@"JX_OutOfTheGroup1");
                break;
            case 2:
                s = Localized(@"JX_DissolutionGroup1");
                break;
                
            default:
                break;
        }
        
        if (!s || s.length <= 0) {
            if (![g_xmpp.roomPool getRoom:self.chatPerson.userId] && [self.chatPerson.groupStatus intValue] == 0) {
                [g_xmpp.roomPool joinRoom:chatPerson.userId title:chatPerson.userNickname lastDate:nil isNew:NO];
//                s = Localized(@"JX_GroupConnectionFailed");
                chatRoom = [[TFJunYou_XMPP sharedInstance].roomPool joinRoom:chatPerson.userId title:chatPerson.userNickname lastDate:nil isNew:NO];
            }
        }
        
        if (self.isDisable) {
            s = Localized(@"JX_GroupNotUse");
        }
        
        if (s.length > 0) {
            [self hideKeyboard:NO];
            [g_server showMsg:s];
            return YES;
        }
        
//        if (!chatRoom.isConnected) {
//            [_wait start];
//            chatRoom = [[TFJunYou_XMPP sharedInstance].roomPool joinRoom:chatPerson.userId title:chatPerson.userNickname isNew:NO];
//            return YES;
//        }
        
    }else {
        if ([self.chatPerson.userId intValue] <=10100 && [self.chatPerson.userId intValue] >=10000) {
            return NO;
        }
        if (self.isGroupMessages) {
            return NO;
        }
        // 是否被拉入黑名单
        if (self.isBeenBlack > 0) {
            [g_App showAlert:Localized(@"TO_BLACKLIST")];
            return YES;
        }else
//            if (self.friendStatus != 2 && self.friendStatus != 10) {
//            [g_App showAlert:Localized(@"JX_NoFriendsWithMe")];
//            return YES;
//        }else
        {
            return NO;
        }
    }
    
    return NO;
}

- (BOOL)checkCameraLimits{
    /// 先判断摄像头硬件是否好用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        // 不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
          
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:Localized(@"JX_CameraNotTake") message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:Localized(@"JXSettingVC_Set") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:Localized(@"JX_Cencal") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [alert addAction:actionCancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            return NO;
        }else{
            // 这里是摄像头可以使用的处理逻辑
            return YES;
        }
    } else {
        // 硬件问题提示
        [g_App showAlert:Localized(@"JX_CameraBad")];
        return NO;
    }
}

- (void)showCallMsg:(NSNotification *)notifice{
    TFJunYou_MessageObject *msg = (TFJunYou_MessageObject *)notifice.object;
    if(msg==nil){
        return;
    }
    _messageText.text = msg.content;
    [self sendIt:nil];
}

- (void)addWaitGroupSendViewWithMsgNum:(NSInteger )msgNum withType:(NSInteger )type{
    _sendedNum = 0;
    self.groupMessagesIndex = 0;
    self.groupUploadObjArray = nil;
    self.groupSendMsgArray = nil;
    _groupSendType = type;
    self.groupSendAllNum = self.userIds.count * msgNum;
    _isGroupSendCancel = NO;
    self.imgsAndVideosDic = nil;
    
    self.waitGroupSendView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.waitGroupSendView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.waitGroupSendView];
    [self.view bringSubviewToFront:self.waitGroupSendView];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    centerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    centerView.layer.cornerRadius = 5.f;
    centerView.layer.masksToBounds = YES;
    [self.waitGroupSendView addSubview:centerView];
    centerView.center = self.waitGroupSendView.center;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 20)];
    [lab setTextColor:[UIColor whiteColor]];
    [lab setFont:g_factory.font12];
    [lab setText:@"正在发送："];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setBackgroundColor:[UIColor clearColor]];
    [centerView addSubview:lab];
    
    self.waitGroupSendLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 20)];
    [self.waitGroupSendLable setTextAlignment:NSTextAlignmentCenter];
    [self.waitGroupSendLable setBackgroundColor:[UIColor clearColor]];
    [self.waitGroupSendLable setTextColor:[UIColor whiteColor]];
    [self.waitGroupSendLable setFont:g_factory.font12];
    [self.waitGroupSendLable setText:[NSString stringWithFormat:@"%ld/%ld",(long)_sendedNum,(long)self.groupSendAllNum]];
    [centerView addSubview:self.waitGroupSendLable];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(85, 5, 10, 10)];
    [cancelButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(groupSendCancel) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:cancelButton];
    
}

- (void)groupSendCancel{
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert.title = @"是否停止发送";
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _isGroupSendCancel = YES;
        [self.waitGroupSendView removeFromSuperview];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)keepOnGroupSend:(NSNotification *)notifice{
    _sendedNum ++;
    TFJunYou_MessageObject *msg = (TFJunYou_MessageObject *)notifice.object;
    if (self.waitGroupSendView) {
            [self.waitGroupSendLable setText:[NSString stringWithFormat:@"%ld/%ld",(long)_sendedNum,(long)self.groupSendAllNum]];
    }
    if (_sendedNum == self.groupSendAllNum) {
        if (self.waitGroupSendView) {
            [self.waitGroupSendView removeFromSuperview];
            [g_App showAlert:Localized(@"JX_SendComplete")];
        }
        return;
    }
    if (msg.isLastGroupSend) {
        switch (_groupSendType) {
            case groupsend_msgType_text:{
                [self sendIt:nil];
                break;
            }
            case groupsend_msgType_shake:{
                [self onShake];
                break;
            }
            case groupsend_msgType_addressbook:{
                TFJunYou_SelectAddressBookVC *selectVC = self.groupUploadObjArray.lastObject;
                [self selectAddressBookVC:selectVC doneAction:self.groupSendMsgArray];
                break;
            }
            case groupsend_msgType_card:{
                TFJunYou_SelectFriendsVC *vc = self.groupSendMsgArray.lastObject;
                [self onAfterAddMember:vc];
                break;
            }
            case groupsend_msgType_collect:{
                if ([self.groupSendMsgArray.lastObject isKindOfClass:[WeiboData class]]) {
                    WeiboData *data = self.groupSendMsgArray.lastObject;
                    TFJunYou_WeiboVC *vc = nil;
                    [self weiboVC:vc didSelectWithData:data];
                }else{
                    [self collectionMsgSendAll:self.groupSendMsgArray];
                }
                break;
            }
            case groupsend_msgType_location:{
                [self onSelLocation:self.mapData];
                break;
            }
            default:
                break;
        }
    }
}

- (void)keepOnUplpadGroupSend{
    _sendedNum++;
    if (_sendedNum > self.groupSendAllNum) {
        return;
    }
    [self.waitGroupSendLable setText:[NSString stringWithFormat:@"%ld/%ld",(long)_sendedNum,(long)self.groupSendAllNum]];
    if (_sendedNum % self.groupUploadObjArray.count == 0) {
        if ((_sendedNum / self.groupUploadObjArray.count) % _onceSendNum == 0) {
            if (_groupSendType == groupsend_msgType_image) {
                [self sendPhotos:self.groupUploadObjArray withOriginal:_isOriginal];
            }else if (_groupSendType == groupsend_msgType_video){
                [self sendMedias:self.groupUploadObjArray isSave:_isOriginal];
            }else if (_groupSendType == groupsend_msgType_audio){
                [self sendVoices:self.groupUploadObjArray];
            }else if (_groupSendType == groupsend_msgType_file){
                [self sendFiles:self.groupUploadObjArray];
            }else if (_groupSendType == groupsend_msgType_imagesAndVideos){
                [self sendImagesAndVideos:self.imgsAndVideosDic];
            }
        }
    }
}
//
//
//
@end
