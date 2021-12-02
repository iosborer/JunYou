//
//  TFJunYou_FriendViewController.h.m
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_FriendViewController.h"
#import "TFJunYou_ChatViewController.h"
#import "AppDelegate.h"
#import "TFJunYou_Label.h"
#import "TFJunYou_ImageView.h"
#import "TFJunYou_Cell.h"
#import "TFJunYou_RoomPool.h"
#import "TFJunYou_TableView.h"
#import "TFJunYou_NewFriendViewController.h"
#import "menuImageView.h"
#import "FMDatabase.h"
#import "TFJunYou_ProgressVC.h"
#import "TFJunYou_TopSiftJobView.h"
#import "TFJunYou_UserInfoVC.h"
#import "BMChineseSort.h"
#import "TFJunYou_GroupViewController.h"
#import "OrganizTreeViewController.h"
#import "TFJunYou_TabMenuView.h"
#import "TFJunYou_PublicNumberVC.h"
#import "TFJunYou_BlackFriendVC.h"
#import "TFJunYou__DownListView.h"
#import "TFJunYou_NewRoomVC.h"
#import "TFJunYou_NearVC.h"
#import "TFJunYou_SearchUserVC.h"
#import "TFJunYou_ScanQRViewController.h"
#import "TFJunYou_LabelVC.h"
#import "TFJunYou_AddressBookVC.h"
#import "TFJunYou_SearchVC.h"
#import "TFJunYou_LabelObject.h"
#import "CYWebCustomerServiceVC.h"
#import "JXMsgCellView.h"
#define HEIGHT 54
#define IMAGE_HEIGHT  45  // 图片宽高
#define INSET_HEIGHT  10  // 图片文字间距


@interface TFJunYou_FriendViewController ()<UITextFieldDelegate,TFJunYou_SelectMenuViewDelegate>
@property (nonatomic, strong) TFJunYou_UserObject * currentUser;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;


@property (nonatomic, strong) UITextField *seekTextField;
@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic, strong) UILabel *friendNewMsgNum;
@property (nonatomic, strong) UILabel *abNewMsgNum;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, assign) CGFloat btnHeight;  // 按钮的真实高度

@property (nonatomic,copy)NSArray *customerArr; //客服信息
@property (nonatomic,weak)JXMsgCellView *cellView;
@end

@implementation TFJunYou_FriendViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.isOneInit = YES;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = TFJunYou__SCREEN_BOTTOM;
        if (_isMyGoIn) {
            self.isGotoBack   = YES;
            self.heightFooter = 0;
        }
//        self.view.frame = g_window.bounds;
        [self createHeadAndFoot];
        [self buildTop];
//        CGRect frame = self.tableView.frame;
//        frame.origin.y += 40;
//        frame.size.height -= 40;
//        self.tableView.frame = frame;
        self.tableView.backgroundColor=  HEXCOLOR(0xf0f0f0);
         [self customView];

        _selMenu = 0;
        
        
//        self.title = Localized(@"JXInputVC_Friend");
        self.title = Localized(@"JX_MailList");
        [g_notify  addObserver:self selector:@selector(newFriend:) name:kXMPPNewFriendNotifaction object:nil];
        
        [g_notify addObserver:self selector:@selector(newRequest:) name:kXMPPNewRequestNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(newReceipt:) name:kXMPPReceiptNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(onSendTimeout:) name:kXMPPSendTimeOutNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(friendRemarkNotif:) name:kFriendRemark object:nil];
        
        [g_notify  addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsgNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(friendListRefresh:) name:kFriendListRefresh object:nil];
        [g_notify addObserver:self selector:@selector(refreshABNewMsgCount:) name:kRefreshAddressBookNotif object:nil];
        [g_notify addObserver:self selector:@selector(contactRegisterNotif:) name:kMsgComeContactRegister object:nil];
        [g_notify addObserver:self selector:@selector(newRequest:) name:kFriendPassNotif object:nil];
        [g_notify addObserver:self selector:@selector(refresh) name:kOfflineOperationUpdateUserSet object:nil];
        [g_notify addObserver:self selector:@selector(updateLabels:) name:kXMPPMessageUpadtePasswordNotification object:nil];
//        [g_server customerLinkList:self];
      //  [self setupCustomerLinkList];
    }
    return self;
}

- (void)updateLabels:(NSNotification *)noti {
    TFJunYou_MessageObject *msg = noti.object;
    if ([msg.objectId isEqualToString:SYNC_LABEL]) {
        // 同步标签
        [g_server friendGroupListToView:self];
    }
}

- (void)friendListRefresh:(NSNotification *)notif {
    
    [self refresh];
}

- (void)contactRegisterNotif:(NSNotification *)notif {
    TFJunYou_MessageObject *msg = notif.object;
    
    NSDictionary *dict = (NSDictionary *)msg.content;
    if ([msg.content isKindOfClass:[NSString class]]) {
        SBJsonParser * resultParser = [[SBJsonParser alloc] init] ;
        dict = [resultParser objectWithString:msg.content];
    }
    TFJunYou_AddressBook *addressBook = [[TFJunYou_AddressBook alloc] init];
    addressBook.toUserId = [NSString stringWithFormat:@"%@",dict[@"toUserId"]];
    addressBook.toUserName = dict[@"toUserName"];
    addressBook.toTelephone = dict[@"toTelephone"];
    addressBook.telephone = dict[@"telephone"];
    addressBook.registerEd = dict[@"registerEd"];
    addressBook.registerTime = [NSDate dateWithTimeIntervalSince1970:[dict[@"registerTime"] longLongValue]];
    addressBook.isRead = [NSNumber numberWithBool:0];
    [addressBook insert];
    
    [self refreshABNewMsgCount:nil];
}

- (void)refreshABNewMsgCount:(NSNotification *)notif {
    [self refresh];
    TFJunYou_MsgAndUserObject* newobj = [[TFJunYou_MsgAndUserObject alloc]init];
    newobj.user = [[TFJunYou_UserObject sharedInstance] getUserById:FRIEND_CENTER_USERID];
    [self showNewMsgCount:[newobj.user.msgsNew integerValue]];
}

#pragma mark  接受新消息广播
-(void)newMsgCome:(NSNotification *)notifacation
{
    TFJunYou_MessageObject *msg = notifacation.object;
    if (![msg isAddFriendMsg]) {
        return;
    }
    
    NSString* s;
    s = [msg getTableName];
    TFJunYou_MsgAndUserObject* newobj = [[TFJunYou_MsgAndUserObject alloc]init];
    newobj.user = [[TFJunYou_UserObject sharedInstance] getUserById:s];
    [self showNewMsgCount:[newobj.user.msgsNew integerValue]];
    
}

- (void) showNewMsgCount:(NSInteger)friendNewMsgNum {
    if (friendNewMsgNum >= 10 && friendNewMsgNum <= 99) {
        self.friendNewMsgNum.font = SYSFONT(12);
    }else if (friendNewMsgNum > 0 && friendNewMsgNum < 10) {
        self.friendNewMsgNum.font = SYSFONT(13);
    }else if(friendNewMsgNum > 99){
        self.friendNewMsgNum.font = SYSFONT(9);
    }

    self.friendNewMsgNum.text = [NSString stringWithFormat:@"%ld",friendNewMsgNum];
    
    if (friendNewMsgNum <= 0) {
        self.friendNewMsgNum.hidden = YES;
    }else{
        self.friendNewMsgNum.hidden = NO;
    }
    
    NSMutableArray *abUread = [[TFJunYou_AddressBook sharedInstance] doFetchUnread];
    if (abUread.count >= 10 && abUread.count <= 99) {
        self.friendNewMsgNum.font = SYSFONT(12);
    }else if (abUread.count > 0 && abUread.count < 10) {
        self.friendNewMsgNum.font = SYSFONT(13);
    }else if(abUread.count > 99){
        self.friendNewMsgNum.font = SYSFONT(9);
    }

    self.abNewMsgNum.text = [NSString stringWithFormat:@"%ld",abUread.count];
    if (abUread.count <= 0) {
        self.abNewMsgNum.hidden = YES;
    }else {
        self.abNewMsgNum.hidden = NO;
    }
    
    NSInteger num = friendNewMsgNum + abUread.count;
//    if (num <= 0) {
//        [g_mainVC.tb setBadge:1 title:@"0"];
//    }else {
//        [g_mainVC.tb setBadge:1 title:[NSString stringWithFormat:@"%ld", num]];
//    }
    if (num <= 0) {
           int number = 0;
           if (g_App.linkArray.count == 0) {
               number = 1;
            }else if(g_App.linkArray.count == 1){
              number = 1;
            }else if(g_App.linkArray.count == 2){
              number = 1;
           }

        _cellView.bageNumber=[NSString stringWithFormat:@"%ld",num];
           [g_mainVC.tb setBadge:number title:@"0"];
       }else {
           int number = 0;
           if (g_App.linkArray.count == 0) {
               number = 1;
            }else if(g_App.linkArray.count == 1){
              number = 1;
            }else if(g_App.linkArray.count == 2){
              number = 1;
           }
           NSLog(@"%@",g_mainVC.tb);
           
           
           _cellView.bageNumber=[NSString stringWithFormat:@"%ld",num];
           [g_mainVC.tb setBadge:number title:[NSString stringWithFormat:@"%ld", num]];
       }

}

-(void)newRequest:(NSNotification *)notifacation
{
    [self getFriend];
}

- (void)scrollToPageUp {
    [self getFriend];
}

-(void)buildTop{
    //刷新好友列表
//    UIButton * getFriendBtn = [[UIButton alloc]initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-35, TFJunYou__SCREEN_TOP - 34, 30, 30)];
//    getFriendBtn.custom_acceptEventInterval = .25f;
//    [getFriendBtn addTarget:self action:@selector(getFriend) forControlEvents:UIControlEventTouchUpInside];
////    [getFriendBtn setImage:[UIImage imageNamed:@"synchro_friends"] forState:UIControlStateNormal];
//    [getFriendBtn setBackgroundImage:[UIImage imageNamed:@"synchro_friends"] forState:UIControlStateNormal];
//    [self.tableHeader addSubview:getFriendBtn];
    
//    self.moreBtn = [UIFactory createButtonWithImage:@"im_003_more_button_black"
//                                          highlight:nil
//                                             target:self
//                                           selector:@selector(onMore:)];
//    self.moreBtn.custom_acceptEventInterval = 1.0f;
//    self.moreBtn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 18-BTN_RANG_UP*2, TFJunYou__SCREEN_TOP - 18-BTN_RANG_UP*2, 18+BTN_RANG_UP*2, 18+BTN_RANG_UP*2);
//    [self.tableHeader addSubview:self.moreBtn];
}

- (void) customView {
    //顶部筛选控件
//    _topSiftView = [[TFJunYou_TopSiftJobView alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP, TFJunYou__SCREEN_WIDTH, 40)];
//    _topSiftView.delegate = self;
//    _topSiftView.isShowMoreParaBtn = NO;
//    _topSiftView.dataArray = [[NSArray alloc] initWithObjects:Localized(@"JXInputVC_FriendList"),Localized(@"JX_BlackList"), nil];
//    //    _topSiftView.searchForType = SearchForPos;
//    [self.view addSubview:_topSiftView];
    
    //搜索输入框
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP, TFJunYou__SCREEN_WIDTH, 260)];
    backView.backgroundColor = [UIColor whiteColor];// HEXCOLOR(0xf0f0f0);
    [self.view addSubview:backView];
    self.tableView.tableHeaderView = backView;
    //    [seekImgView release];
    
//    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-5-45, 5, 45, 30)];
//    [cancelBtn setTitle:Localized(@"JX_Cencal") forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    cancelBtn.titleLabel.font = SYSFONT(14.0);
//    [backView addSubview:cancelBtn];
    
    
    _seekTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, backView.frame.size.width - 30, 35)];
    _seekTextField.placeholder = Localized(@"JX_Seach");
    _seekTextField.textColor = [UIColor blackColor];
    [_seekTextField setFont:SYSFONT(14)];
    _seekTextField.backgroundColor = HEXCOLOR(0xf0f0f0);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_search"]];
    UIView *leftView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 30, 30)];
    //    imageView.center = CGPointMake(leftView.frame.size.width/2, leftView.frame.size.height/2);
    imageView.center = leftView.center;
    [leftView addSubview:imageView];
    _seekTextField.leftView = leftView;
    _seekTextField.leftViewMode = UITextFieldViewModeAlways;
    _seekTextField.borderStyle = UITextBorderStyleNone;
    _seekTextField.layer.masksToBounds = YES;
    _seekTextField.layer.cornerRadius = 5;
    _seekTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _seekTextField.delegate = self;
    _seekTextField.returnKeyType = UIReturnKeyGoogle;
    [backView addSubview:_seekTextField];
    [_seekTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
//    int h = 0;
//    TFJunYou_ImageView* iv;
//    iv = [self createButton:Localized(@"JXNewFriendVC_NewFirend") drawTop:NO drawBottom:YES icon:@"im_10001" click:@selector(newFriendAction:) superView:backView];
//    iv.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), TFJunYou__SCREEN_WIDTH, HEIGHT);
//    h = iv.frame.size.height + iv.frame.origin.y;
    
    JXMsgCellView *cellView= [JXMsgCellView XIBMsgCellView];
    cellView.frame=CGRectMake(0, CGRectGetMaxY(_seekTextField.frame), TFJunYou__SCREEN_WIDTH, 219);
    [backView addSubview:cellView];
    _cellView=cellView;
    
  
    [cellView.friendViewTap addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(friendViewTap)]];
    
    [cellView.groundChatView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(groundChatViewTap)]];

    [cellView.addresView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addresViewTap)]];
    [cellView.jixinView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jixinViewTap)]];
    
    return;;
    _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_seekTextField.frame), TFJunYou__SCREEN_WIDTH, 190)];
    [backView addSubview:_menuView];
    
    int inset = 0;
    
    int n = 0;
    int m = 0;
    int X = 0;
    int Y = inset;
    
    UIButton *button;
    // 新的朋友
    button = [self createButtonWithFrame:CGRectMake(X, Y, TFJunYou__SCREEN_WIDTH/4, 0) title:Localized(@"JXNewFriendVC_NewFirend") icon:@"friend_newFriend" action:@selector(newFriendAction:)];
    [_menuView addSubview:button];
    
    // 图片在button中的左右间隙
    int  leftInset = (button.frame.size.width - IMAGE_HEIGHT)/2;
    
    self.friendNewMsgNum = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width-leftInset - 10, 20-5, 20, 20)];
    self.friendNewMsgNum.backgroundColor = HEXCOLOR(0xEF2D37);
    self.friendNewMsgNum.font = SYSFONT(12);
    self.friendNewMsgNum.textAlignment = NSTextAlignmentCenter;
    self.friendNewMsgNum.layer.cornerRadius = self.friendNewMsgNum.frame.size.width / 2;
    self.friendNewMsgNum.layer.masksToBounds = YES;
    self.friendNewMsgNum.textColor = [UIColor whiteColor];
    self.friendNewMsgNum.hidden = YES;
    self.friendNewMsgNum.text = @"99";
    [button addSubview:self.friendNewMsgNum];
    
//    iv = [self createButton:Localized(@"JX_ManyPerChat") drawTop:NO drawBottom:YES icon:@"function_icon_join_group_apply" click:@selector(myGroupAction:) superView:backView];
//    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
//    h += iv.frame.size.height;
    
    // 我的同事
    n = (n + 1) >= 4 ? 0 : n + 1;
    m += 1;
    X = TFJunYou__SCREEN_WIDTH/4 * (n >= 4 ? 0 : n);
    Y = m >=4 ? button.frame.size.height+inset : inset;
    button = [self createButtonWithFrame:CGRectMake(X, Y, TFJunYou__SCREEN_WIDTH/4, 0) title:Localized(@"OrganizVC_Organiz") icon:@"friend_colleagues" action:@selector(myColleaguesAction:)];
    [_menuView addSubview:button];

    // 手机联系人
    n = (n + 1) >= 4 ? 0 : n + 1;
    m += 1;
    X = TFJunYou__SCREEN_WIDTH/4 * (n >= 4 ? 0 : n);
    Y = m >=4 ? button.frame.size.height+inset : inset;
    button = [self createButtonWithFrame:CGRectMake(X, Y, TFJunYou__SCREEN_WIDTH/4, 0) title:Localized(@"JX_MobilePhoneContacts") icon:@"friend_phone_list" action:@selector(addressBookAction:)];
    [_menuView addSubview:button];

    self.abNewMsgNum = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width-leftInset - 10, 20-5, 20, 20)];
    self.abNewMsgNum.backgroundColor = [UIColor redColor];
    self.abNewMsgNum.font = SYSFONT(12);
    self.abNewMsgNum.textAlignment = NSTextAlignmentCenter;
    self.abNewMsgNum.layer.cornerRadius = self.abNewMsgNum.frame.size.width / 2;
    self.abNewMsgNum.layer.masksToBounds = YES;
    self.abNewMsgNum.textColor = [UIColor whiteColor];
    self.abNewMsgNum.hidden = YES;
    self.abNewMsgNum.text = @"99";
    [button addSubview:self.abNewMsgNum];

    // 公众号
    n = (n + 1) >= 4 ? 0 : n + 1;
    m += 1;
    X = TFJunYou__SCREEN_WIDTH/4 * (n >= 4 ? 0 : n);
    Y = m >=4 ? button.frame.size.height+inset : inset;
    button = [self createButtonWithFrame:CGRectMake(X, Y, TFJunYou__SCREEN_WIDTH/4, 0) title:Localized(@"JX_PublicNumber") icon:@"friend_public" action:@selector(publicNumberAction:)];
    [_menuView addSubview:button];

    // 群组
    n = (n + 1) >= 4 ? 0 : n + 1;
    m += 1;
    X = TFJunYou__SCREEN_WIDTH/4 * (n >= 4 ? 0 : n);
    Y = m >=4 ? button.frame.size.height+inset : inset;
    button = [self createButtonWithFrame:CGRectMake(X, Y, TFJunYou__SCREEN_WIDTH/4, 0) title:Localized(@"JX_ManyPerChat") icon:@"friend_group_list" action:@selector(myGroupAction:)];
    [_menuView addSubview:button];

    // 黑名单
    n = (n + 1) >= 4 ? 0 : n + 1;
    m += 1;
    X = TFJunYou__SCREEN_WIDTH/4 * (n >= 4 ? 0 : n);
    Y = m >=4 ? button.frame.size.height+inset : inset;
    button = [self createButtonWithFrame:CGRectMake(X, Y, TFJunYou__SCREEN_WIDTH/4, 0) title:Localized(@"JX_BlackList") icon:@"friend_black_list" action:@selector(blackFriendAction:)];
    [_menuView addSubview:button];

    // 我的设备
    BOOL isMultipleLogin = [g_myself.multipleDevices intValue] > 0 ? YES : NO;
    if (isMultipleLogin) {
        n = (n + 1) >= 4 ? 0 : n + 1;
        m += 1;
        X = TFJunYou__SCREEN_WIDTH/4 * (n >= 4 ? 0 : n);
        Y = m >=4 ? button.frame.size.height+inset : inset;
        button = [self createButtonWithFrame:CGRectMake(X, Y, TFJunYou__SCREEN_WIDTH/4, 0) title:Localized(@"JX_MyDevices") icon:@"friend_device" action:@selector(myDeviceAction:)];
        [_menuView addSubview:button];
    }

    // 标签
    n = (n + 1) >= 4 ? 0 : n + 1;
    m += 1;
    X = TFJunYou__SCREEN_WIDTH/4 * (n >= 4 ? 0 : n);
    Y = m >=4 ? button.frame.size.height+inset : inset;
    button = [self createButtonWithFrame:CGRectMake(X, Y, TFJunYou__SCREEN_WIDTH/4, 0) title:Localized(@"JX_Label") icon:@"friend_label" action:@selector(labelAction:)];
    [_menuView addSubview:button];

//    iv = [self createButton:Localized(@"JX_Label") drawTop:NO drawBottom:YES icon:@"label" click:@selector(labelAction:) superView:backView];
//    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
//    h += iv.frame.size.height;
//
//    iv = [self createButton:Localized(@"JX_PublicNumber") drawTop:NO drawBottom:YES icon:@"ALOGO_120" click:@selector(publicNumberAction:) superView:backView];
//    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
//    h += iv.frame.size.height;
    
//    BOOL isMultipleLogin = [[g_default objectForKey:kISMultipleLogin] boolValue];
//    BOOL isMultipleLogin = [g_myself.multipleDevices intValue] > 0 ? YES : NO;
//    if (isMultipleLogin) {
//        iv = [self createButton:Localized(@"JX_MyDevices") drawTop:NO drawBottom:YES icon:@"feb" click:@selector(myDeviceAction:) superView:backView];
//        iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
//        h += iv.frame.size.height;
//    }
    
//    iv = [self createButton:Localized(@"JX_BlackList") drawTop:NO drawBottom:YES icon:@"im_black" click:@selector(blackFriendAction:) superView:backView];
//    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
//    h += iv.frame.size.height;
//
//    iv = [self createButton:Localized(@"OrganizVC_Organiz") drawTop:NO drawBottom:YES icon:@"im_colleague" click:@selector(myColleaguesAction:) superView:backView];
//    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
//    h += iv.frame.size.height;
//
//    iv = [self createButton:Localized(@"JX_MobilePhoneContacts") drawTop:NO drawBottom:YES icon:@"sk_ic_pc" click:@selector(addressBookAction:) superView:backView];
//    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
//    h += iv.frame.size.height;
    
//    self.abNewMsgNum = [[UILabel alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH - 35, (HEIGHT - 15) / 2, 15, 15)];
//    self.abNewMsgNum.backgroundColor = [UIColor redColor];
//    self.abNewMsgNum.font = [UIFont systemFontOfSize:11.0];
//    self.abNewMsgNum.textAlignment = NSTextAlignmentCenter;
//    self.abNewMsgNum.layer.cornerRadius = self.abNewMsgNum.frame.size.width / 2;
//    self.abNewMsgNum.layer.masksToBounds = YES;
//    self.abNewMsgNum.textColor = [UIColor whiteColor];
//    self.abNewMsgNum.text = @"99";
//    [iv addSubview:self.abNewMsgNum];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TFJunYou_MsgAndUserObject* newobj = [[TFJunYou_MsgAndUserObject alloc]init];
        newobj.user = [[TFJunYou_UserObject sharedInstance] getUserById:FRIEND_CENTER_USERID];
        [self showNewMsgCount:[newobj.user.msgsNew integerValue]];
        
    });
    _btnHeight = button.frame.size.height;
    [self showMenuView];
    if (_isMyGoIn) {
        [self hideMenuView];
    }
    
    [self setFooterView];
    
}
- (void)friendViewTap{
    
     
    TFJunYou_MsgAndUserObject* newobj = [[TFJunYou_MsgAndUserObject alloc]init];
    newobj.user = [[TFJunYou_UserObject sharedInstance] getUserById:FRIEND_CENTER_USERID];
    newobj.message = [[TFJunYou_MessageObject alloc] init];
    newobj.message.toUserId = FRIEND_CENTER_USERID;
    newobj.user.msgsNew = [NSNumber numberWithInt:0];
    [newobj.message updateNewMsgsTo0];
    
    NSArray *friends = [[TFJunYou_FriendObject sharedInstance] fetchAllFriendsFromLocal];
    for (NSInteger i = 0; i < friends.count; i ++) {
        TFJunYou_FriendObject *friend = friends[i];
        if ([friend.msgsNew integerValue] > 0) {
            [friend updateNewMsgUserId:friend.userId num:0];
            [friend updateNewFriendLastContent];
        }
    }
    
    [self showNewMsgCount:0];

    TFJunYou_NewFriendViewController* vc = [[TFJunYou_NewFriendViewController alloc]init];
    [g_navigation pushViewController:vc animated:YES];
}
- (void)groundChatViewTap{ 
    
    TFJunYou_GroupViewController *vc = [[TFJunYou_GroupViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
// 我的设备
- (void)addresViewTap{
    
    TFJunYou_BlackFriendVC *vc = [[TFJunYou_BlackFriendVC alloc] init];
    vc.isDevice = YES;
    vc.title = Localized(@"JX_MyDevices");
    [g_navigation pushViewController:vc animated:YES];
}
- (void)jixinViewTap{
    TFJunYou_BlackFriendVC *vc = [[TFJunYou_BlackFriendVC alloc] init];
    vc.title = Localized(@"JX_BlackList");
    [g_navigation pushViewController:vc animated:YES];
}

  
- (void) setFooterView {
    
    if (_array.count > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 44)];
        label.textColor = HEXCOLOR(0x999999);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = SYSFONT(16);
        label.text = [NSString stringWithFormat:@"%ld%@",_array.count,Localized(@"JX_ContactsNumber")];
        
        self.tableView.tableFooterView = label;
    }else {
        self.tableView.tableFooterView = nil;
    }
}

- (void)showMenuView { // 显示菜单栏
    _menuView.hidden = NO;
    CGRect backFrame = backView.frame;
    backFrame.size.height = _btnHeight*2 + 20 + 55;
    backView.frame = backFrame;
    
    CGRect menuFrame = _menuView.frame;
    menuFrame.size.height = _btnHeight*2 + 20;
    _menuView.frame = menuFrame;
    self.tableView.tableHeaderView = backView;
}

- (void)hideMenuView { // 隐藏菜单栏
    _menuView.hidden = YES;
    CGRect backFrame = backView.frame;
    backFrame.size.height = 55;
    backView.frame = backFrame;
    self.tableView.tableHeaderView = backView;
}


#pragma mark 右上角更多
-(void)onMore:(UIButton *)sender{
    NSArray *role = MY_USER_ROLE;
    if ([g_App.config.hideSearchByFriends intValue] == 1 && ([g_App.config.isCommonFindFriends intValue] == 0 || role.count > 0)) {
        [self onSearch];
    }else {
        NSMutableArray *titles = [NSMutableArray arrayWithArray:@[Localized(@"JX_LaunchGroupChat"), Localized(@"JX_Scan"), Localized(@"JXNearVC_NearPer"),Localized(@"JX_SearchPublicNumber")]];
        NSMutableArray *images = [NSMutableArray arrayWithArray:@[@"message_creat_group_black", @"messaeg_scnning_black", @"message_near_person_black",@"message_search_publicNumber"]];
        NSMutableArray *sels = [NSMutableArray arrayWithArray:@[@"onNewRoom", @"showScanViewController", @"onNear",@"searchPublicNumber"]];
        if ([g_App.config.isCommonCreateGroup intValue] == 1 && role.count <= 0) {
            [titles removeObject:Localized(@"JX_LaunchGroupChat")];
            [images removeObject:@"message_creat_group_black"];
            [sels removeObject:@"onNewRoom"];
        }
        if ([g_App.config.isOpenPositionService intValue] == 1) {
            [titles removeObject:Localized(@"JXNearVC_NearPer")];
            [images removeObject:@"message_near_person_black"];
            [sels removeObject:@"onNear"];
        }
        if (![g_App.config.enableMpModule boolValue]) {
            [titles removeObject:Localized(@"JX_SearchPublicNumber")];
            [images removeObject:@"message_search_publicNumber"];
            [sels removeObject:@"searchPublicNumber"];
        }
        
        TFJunYou__SelectMenuView *menuView = [[TFJunYou__SelectMenuView alloc] initWithTitle:titles image:images cellHeight:44];
        menuView.sels = sels;
        menuView.delegate = self;
        [g_App.window addSubview:menuView];
    }

    //    _control.hidden = YES;
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    CGRect moreFrame = [self.tableHeader convertRect:self.moreBtn.frame toView:window];
//    
//    TFJunYou__SelectMenuView *menuView = [[TFJunYou__SelectMenuView alloc] initWithTitle:@[Localized(@"JX_LaunchGroupChat"), Localized(@"JX_AddFriends"), Localized(@"JX_Scan"), Localized(@"JXNearVC_NearPer")] image:@[@"message_creat_group_black", @"message_add_friend_black", @"messaeg_scnning_black", @"message_near_person_black"] cellHeight:45];
//    menuView.delegate = self;
//    [g_App.window addSubview:menuView];
    
//    TFJunYou__DownListView * downListView = [[TFJunYou__DownListView alloc] initWithFrame:self.view.bounds];
//    downListView.listContents = @[Localized(@"JX_LaunchGroupChat"), Localized(@"JX_AddFriends"), Localized(@"JX_Scan"), Localized(@"JXNearVC_NearPer")];
//    downListView.listImages = @[@"message_creat_group_black", @"message_add_friend_black", @"messaeg_scnning_black", @"message_near_person_black"];
//
//    __weak typeof(self) weakSelf = self;
//    [downListView downlistPopOption:^(NSInteger index, NSString *content) {
//
//        [weakSelf moreListActionWithIndex:index];
//
//    } whichFrame:moreFrame animate:YES];
//    [downListView show];
    
    //    self.treeView.editing = !self.treeView.editing;

}

- (void)didMenuView:(TFJunYou__SelectMenuView *)MenuView WithIndex:(NSInteger)index {
    
    
    NSString *method = MenuView.sels[index];
    SEL _selector = NSSelectorFromString(method);
    [self performSelectorOnMainThread:_selector withObject:nil waitUntilDone:YES];
    
//    NSArray *role = MY_USER_ROLE;
//    // 显示搜索好友
//    BOOL isShowSearch = [g_App.config.hideSearchByFriends boolValue] && (![g_App.config.isCommonFindFriends boolValue] || role.count > 0);
//    //显示创建房间
//    BOOL isShowRoom = [g_App.config.isCommonCreateGroup intValue] == 0 || role.count > 0;
//    //显示附近的人
//    BOOL isShowPosition = [g_App.config.isOpenPositionService intValue] == 0;
//    switch (index) {
//        case 0:
//            if (isShowRoom) {
//                [self onNewRoom];
//            }else {
//                if (isShowSearch) {
//                    [self onSearch];
//                }else {
//                    [self showScanViewController];
//                }
//            }
//            break;
//        case 1:
//            if (isShowRoom && isShowSearch) {
//                [self onSearch];
//            }else {
//                if ((isShowRoom && !isShowSearch) || (!isShowRoom && isShowSearch)) {
//                    [self showScanViewController];
//                }else if (!isShowRoom && !isShowSearch) {
//                    if (isShowPosition) {
//                        [self onNear];
//                    }else {
//                        [self searchPublicNumber];
//                    }
//                }
//            }
//            break;
//        case 2:
//            if (isShowSearch && isShowRoom) {
//                [self showScanViewController];
//            }else {
//                if ((isShowRoom && !isShowSearch) || (!isShowRoom && isShowSearch)) {
//                    if (isShowPosition) {
//                        [self onNear];
//                    }else {
//                        [self searchPublicNumber];
//                    }
//                }
//            }
//            break;
//        case 3:
//            if (isShowPosition) {
//                [self onNear];
//            }else {
//                [self searchPublicNumber];
//            }
//            break;
//        case 4:
//            [self searchPublicNumber];
//            break;
//        default:
//            break;
//    }
}

// 搜索公众号
- (void)searchPublicNumber {
    TFJunYou_SearchUserVC *searchUserVC = [TFJunYou_SearchUserVC alloc];
    searchUserVC.type = TFJunYou_SearchTypePublicNumber;
    searchUserVC = [searchUserVC init];
    [g_navigation pushViewController:searchUserVC animated:YES];
}


- (void) moreListActionWithIndex:(NSInteger)index {
    
}

// 创建群组
-(void)onNewRoom{
    TFJunYou_NewRoomVC* vc = [[TFJunYou_NewRoomVC alloc]init];
    [g_navigation pushViewController:vc animated:YES];
}
// 附近的人
-(void)onNear{
    TFJunYou_NearVC * nearVc = [[TFJunYou_NearVC alloc] init];
    [g_navigation pushViewController:nearVc animated:YES];
}
//搜索好友
-(void)onSearch{
    TFJunYou_SearchUserVC* vc = [TFJunYou_SearchUserVC alloc];
    vc.delegate  = self;
    vc.didSelect = @selector(doSearch:);
    vc.type = TFJunYou_SearchTypeUser;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    
    [self cancelBtnAction];
}
-(void)doSearch:(searchData*)p{
    
    TFJunYou_NearVC *nearVC = [[TFJunYou_NearVC alloc]init];
    nearVC.isSearch = YES;
    [g_navigation pushViewController:nearVC animated:YES];
    [nearVC doSearch:p];
}
// 扫一扫
-(void)showScanViewController{
//    button.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        button.enabled = YES;
//    });
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        [g_server showMsg:Localized(@"JX_CanNotopenCenmar")];
        return;
    }
    
    TFJunYou_ScanQRViewController * scanVC = [[TFJunYou_ScanQRViewController alloc] init];
    
    //    [g_window addSubview:scanVC.view];
    [g_navigation pushViewController:scanVC animated:YES];
}


// 新朋友
- (void)newFriendAction:(TFJunYou_ImageView *)imageView {
    // 清空角标
    TFJunYou_MsgAndUserObject* newobj = [[TFJunYou_MsgAndUserObject alloc]init];
    newobj.user = [[TFJunYou_UserObject sharedInstance] getUserById:FRIEND_CENTER_USERID];
    newobj.message = [[TFJunYou_MessageObject alloc] init];
    newobj.message.toUserId = FRIEND_CENTER_USERID;
    newobj.user.msgsNew = [NSNumber numberWithInt:0];
    [newobj.message updateNewMsgsTo0];
    
    NSArray *friends = [[TFJunYou_FriendObject sharedInstance] fetchAllFriendsFromLocal];
    for (NSInteger i = 0; i < friends.count; i ++) {
        TFJunYou_FriendObject *friend = friends[i];
        if ([friend.msgsNew integerValue] > 0) {
            [friend updateNewMsgUserId:friend.userId num:0];
            [friend updateNewFriendLastContent];
        }
    }
    
    [self showNewMsgCount:0];

    TFJunYou_NewFriendViewController* vc = [[TFJunYou_NewFriendViewController alloc]init];
    [g_navigation pushViewController:vc animated:YES];
    
}

// 群组
- (void)myGroupAction:(TFJunYou_ImageView *)imageView {
    TFJunYou_GroupViewController *vc = [[TFJunYou_GroupViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

// 我的同事
- (void)myColleaguesAction:(TFJunYou_ImageView *)imageView {
    OrganizTreeViewController *vc = [[OrganizTreeViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

// 公众号
- (void)publicNumberAction:(TFJunYou_ImageView *)imageView {
    TFJunYou_PublicNumberVC *vc = [[TFJunYou_PublicNumberVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

// 黑名单
- (void)blackFriendAction:(TFJunYou_ImageView *)imageView {
    TFJunYou_BlackFriendVC *vc = [[TFJunYou_BlackFriendVC alloc] init];
    vc.title = Localized(@"JX_BlackList");
    [g_navigation pushViewController:vc animated:YES];
}

// 我的设备
- (void)myDeviceAction:(TFJunYou_ImageView *)imageView {
    TFJunYou_BlackFriendVC *vc = [[TFJunYou_BlackFriendVC alloc] init];
    vc.isDevice = YES;
    vc.title = Localized(@"JX_MyDevices");
    [g_navigation pushViewController:vc animated:YES];
}

// 标签
- (void)labelAction:(TFJunYou_ImageView *)imageView {
    
    TFJunYou_LabelVC *vc = [[TFJunYou_LabelVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

// 手机通讯录
- (void)addressBookAction:(TFJunYou_ImageView *)imageView {
    
    TFJunYou_AddressBookVC *vc = [[TFJunYou_AddressBookVC alloc] init];
    NSMutableArray *arr = [[TFJunYou_AddressBook sharedInstance] doFetchUnread];
    vc.abUreadArr = arr;
    [g_navigation pushViewController:vc animated:YES];
    [[TFJunYou_AddressBook sharedInstance] updateUnread];
    
    TFJunYou_MsgAndUserObject* newobj = [[TFJunYou_MsgAndUserObject alloc]init];
    newobj.user = [[TFJunYou_UserObject sharedInstance] getUserById:FRIEND_CENTER_USERID];
    [self showNewMsgCount:[newobj.user.msgsNew integerValue]];
}

-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom icon:(NSString*)icon click:(SEL)click superView:(UIView *)superView{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.delegate = self;
    [superView addSubview:btn];
    
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(42 + 14 + 14, 0, 200, HEIGHT)];
    p.text = title;
    p.font = g_factory.font16;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = HEXCOLOR(0x323232);
    //    p.delegate = self;
    //    p.didTouch = click;
    [btn addSubview:p];
    
    if(icon){
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(14, (HEIGHT-42)/2, 42, 42)];
        iv.image = [UIImage imageNamed:icon];
        iv.layer.cornerRadius = iv.frame.size.width / 2;
        iv.layer.masksToBounds = YES;
        [btn addSubview:iv];
    }
    
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,HEIGHT-LINE_WH,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
//    if(click){
//        UIImageView* iv;
//        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-INSETS-20-3, 16, 20, 20)];
//        iv.image = [UIImage imageNamed:@"set_list_next"];
//        [btn addSubview:iv];
//
//    }
    return btn;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    TFJunYou_SearchVC *vc = [[TFJunYou_SearchVC alloc] initWithTable:@"friendsearchrecord"];
    [g_navigation pushViewController:vc animated:YES];
}

- (void) textFieldDidChange:(UITextField *)textField {
    
    if (textField.text.length <= 0) {
        if (!self.isMyGoIn) {
            [self showMenuView];
        }
        [self getArrayData];
        [self.tableView reloadData];
        return;
    }else {
        [self hideMenuView];
    }
    
    [_searchArray removeAllObjects];
    if (_selMenu == 0) {
        _searchArray = [[TFJunYou_UserObject sharedInstance] fetchFriendsFromLocalWhereLike:textField.text];
    }else if (_selMenu == 1){
        _searchArray = [[TFJunYou_UserObject sharedInstance] fetchBlackFromLocalWhereLike:textField.text];
    }
    
    [self.tableView reloadData];
}

- (void) cancelBtnAction {
    if (_seekTextField.text.length > 0) {
        _seekTextField.text = nil;
        [self getArrayData];
    }
    [_seekTextField resignFirstResponder];
    [self.tableView reloadData];
}

-(void)onClick:(UIButton*)sender{
}

//筛选点击
- (void)topItemBtnClick:(UIButton *)btn{
    [self checkAfterScroll:(btn.tag-100)];
    [_topSiftView resetAllParaBtn];
}

- (void)checkAfterScroll:(CGFloat)offsetX{
    if (offsetX == 0) {
        _selMenu = 0;
    }else {
        _selMenu = 1;
    }
    [self scrollToPageUp];
}

- (void)getFriend{
    [g_server listAttention:0 userId:MY_USER_ID toView:self];
}

//-(void)actionSegment:(UISegmentedControl*)sender{
//    _selMenu = (int)sender.selectedSegmentIndex;
//    [self refresh];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _array=[[NSMutableArray alloc] init];
    [self refresh];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 离开时重置_isMyGoIn
    if (_isMyGoIn) {
        _isMyGoIn = NO;
    }
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
    if (_seekTextField.text.length > 0) {
        return 1;
    }
    return [self.indexArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_seekTextField.text.length > 0) {
        return Localized(@"JXFriend_searchTitle");
    }
    return [self.indexArray objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.tintColor = HEXCOLOR(0xF2F2F2);
    [header.textLabel setTextColor:HEXCOLOR(0x999999)];
    [header.textLabel setFont:SYSFONT(15)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_seekTextField.text.length > 0) {
        return _searchArray.count;
    }
    return [(NSArray *)[self.letterResultArr objectAtIndex:section] count];
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (_seekTextField.text.length > 0) {
        return nil;
    }
    return self.indexArray;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_UserObject *user;
    if (_seekTextField.text.length > 0) {
        user = _searchArray[indexPath.row];
    }else{
        user = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
	TFJunYou_Cell *cell=nil;
    NSString* cellName = [NSString stringWithFormat:@"msg_%d_%ld",_refreshCount,indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(cell==nil){
        
        cell = [[TFJunYou_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        [_table addToPool:cell];
        
//        cell.headImage   = user.userHead;
//        user = nil;
    }
    
//    cell.title = user.userNickname;
    cell.title = [self multipleLoginIsOnlineTitle:user];
//    cell.subtitle = user.userId;
    cell.index = (int)indexPath.row;
    cell.delegate = self;
    cell.didTouch = @selector(onHeadImage:);
//    cell.bottomTitle = [TimeUtil formatDate:user.timeCreate format:@"MM-dd HH:mm"];
//    [cell setForTimeLabel:[TimeUtil formatDate:user.timeCreate format:@"MM-dd HH:mm"]];
    cell.timeLabel.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 120-20, 9, 115, 20);
    cell.userId = user.userId;
    [cell.lbTitle setText:cell.title];
    
    cell.dataObj = user;
//    cell.headImageView.tag = (int)indexPath.row;
//    cell.headImageView.delegate = cell.delegate;
//    cell.headImageView.didTouch = cell.didTouch;
    
    cell.isSmall = YES;
    [cell headImageViewImageWithUserId:user.userId roomId:nil];
    
    if (indexPath.section == self.letterResultArr.count-1 && indexPath.row == [(NSArray *)[self.letterResultArr objectAtIndex:indexPath.section] count]-1) {
        cell.lineView.frame = CGRectMake(0, cell.lineView.frame.origin.y, TFJunYou__SCREEN_WIDTH, cell.lineView.frame.size.height);
    }else if (indexPath.row == [(NSArray *)[self.letterResultArr objectAtIndex:indexPath.section] count]-1) {
        cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width,0);
    }else {
        cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width,LINE_WH);
    }
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (_seekTextField.text.length > 0 || section != self.letterResultArr.count-1) {
//        return 0;
//    }
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (_seekTextField.text.length > 0 || section != self.letterResultArr.count-1) {
//        return nil;
//    }
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 44)];
//    label.textColor = HEXCOLOR(0x999999);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = SYSFONT(16);
//    label.text = [NSString stringWithFormat:@"%ld位联系人",_array.count];
//
//    return label;
//}

- (NSString *)multipleLoginIsOnlineTitle:(TFJunYou_UserObject *)user {
    NSString *isOnline;
    
    NSString *isOnLine = [NSString stringWithFormat:@"%@",user.isOnLine];
    
    if ([isOnLine intValue] == 1) {
        isOnline = [NSString stringWithFormat:@"(%@)", Localized(@"JX_OnLine")];
    }else {
        isOnline = [NSString stringWithFormat:@"(%@)", Localized(@"JX_OffLine")];
    }
    NSString *title = user.remarkName.length > 0 ? user.remarkName : user.userNickname;
    if ([user.userId isEqualToString:ANDROID_USERID] || [user.userId isEqualToString:PC_USERID] || [user.userId isEqualToString:MAC_USERID]) {
        title = [title stringByAppendingString:isOnline];
    }
    return title;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    TFJunYou_Cell * cell = [_table cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    // 黑名单列表不能点击
    if (_selMenu == 1) {
        return;
    }
    
    TFJunYou_UserObject *user;
    if (_seekTextField.text.length > 0) {
        user = _searchArray[indexPath.row];
    }else{
        user = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    
    if([user.userId isEqualToString:FRIEND_CENTER_USERID]){
        TFJunYou_NewFriendViewController* vc = [[TFJunYou_NewFriendViewController alloc]init];
//        [g_App.window addSubview:vc.view];
        [g_navigation pushViewController:vc animated:YES];
//        [vc release];
        return;
    }
    
    TFJunYou_ChatViewController *sendView=[TFJunYou_ChatViewController alloc];
    if([user.roomFlag intValue] > 0  || user.roomId.length > 0){
        sendView.roomJid = user.userId;
        sendView.roomId = user.roomId;
        [[TFJunYou_XMPP sharedInstance].roomPool joinRoom:user.userId title:user.userNickname lastDate:nil isNew:NO];
    }
    sendView.title = user.remarkName.length > 0  ? user.remarkName : user.userNickname;
    sendView.chatPerson = user;
    sendView = [sendView init];
//    [g_App.window addSubview:sendView.view];
    [g_navigation pushViewController:sendView animated:YES];
    
    TFJunYou_MessageObject *msg = [[TFJunYou_MessageObject alloc] init];
    msg.toUserId = user.userId;
    [msg updateNewMsgsTo0];
    [g_notify postNotificationName:kChatViewDisappear object:nil];
    
//    [sendView release];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_seekTextField.text.length <= 0){
        if (_selMenu == 0) {
            TFJunYou_UserObject *user = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if (user.userId.length <= 5) {
                return NO;
            }else{
                return YES;
            }
        }else{
            return YES;
        }
    }else{
        return NO;
    }
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_selMenu == 0) {
//        return UITableViewCellEditingStyleDelete;
//    }else{
//        return UITableViewCellEditingStyleNone;
//    }
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selMenu == 0) {
        UITableViewRowAction *deleteBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:Localized(@"JX_Delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            TFJunYou_UserObject *user = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            _currentUser = user;
            [g_server delFriend:user.userId toView:self];
        }];
        
        return @[deleteBtn];
    }
    else {
        UITableViewRowAction *cancelBlackBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:Localized(@"REMOVE") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            TFJunYou_UserObject *user = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            _currentUser = user;
            [g_server delBlacklist:user.userId toView:self];
        }];
        
        return @[cancelBlackBtn];
    }
   
}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_selMenu == 0 && editingStyle == UITableViewCellEditingStyleDelete) {
//        TFJunYou_UserObject *user=_array[indexPath.row];
//        _currentUser = user;
//        [g_server delFriend:user.userId toView:self];
//    }
//}

- (void)dealloc {
    [g_notify removeObserver:self];
//    [_table release];
    [_array removeAllObjects];
//    [_array release];
//    [super dealloc];
}

-(void)getArrayData{
    switch (_selMenu) {
        case 0:{
            //获取好友列表
//            if (self.isOneInit) {//是否新建
//                [g_server listAttention:0 userId:MY_USER_ID toView:self];
//                self.isOneInit = NO;
//            }
            
            //从数据库获取好友staus为2且不是room的
            _array=[[TFJunYou_UserObject sharedInstance] fetchAllFriendsFromLocal];
            //选择拼音 转换的 方法
            BMChineseSortSetting.share.sortMode = 2; // 1或2
            //排序 Person对象
            [BMChineseSort sortAndGroup:_array key:@"userNickname" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
                if (isSuccess) {
                    self.indexArray = sectionTitleArr;
                    self.letterResultArr = sortedObjArr;
                    [_table reloadData];
                }
            }];

//            //根据Person对象的 name 属性 按中文 对 Person数组 排序
//            self.indexArray = [BMChineseSort IndexWithArray:_array Key:@"userNickname"];
//            self.letterResultArr = [BMChineseSort sortObjectArray:_array Key:@"userNickname"];
//
            self.isShowFooterPull = NO;
        }
            break;
        case 1:{
            //获取黑名單列表
            
            //从数据库获取好友staus为-1的
            _array=[[TFJunYou_UserObject sharedInstance] fetchAllBlackFromLocal];
            //选择拼音 转换的 方法
            BMChineseSortSetting.share.sortMode = 2; // 1或2
            //排序 Person对象
            [BMChineseSort sortAndGroup:_array key:@"userNickname" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
                if (isSuccess) {
                    self.indexArray = sectionTitleArr;
                    self.letterResultArr = sortedObjArr;
                    [_table reloadData];
                }
            }];
            //根据Person对象的 name 属性 按中文 对 Person数组 排序
//            self.indexArray = [BMChineseSort IndexWithArray:_array Key:@"userNickname"];
//            self.letterResultArr = [BMChineseSort sortObjectArray:_array Key:@"userNickname"];
        }
            break;
        case 2:{
            _array=[[TFJunYou_UserObject sharedInstance] fetchAllRoomsFromLocal];
            //选择拼音 转换的 方法
            BMChineseSortSetting.share.sortMode = 2; // 1或2
            //排序 Person对象
            [BMChineseSort sortAndGroup:_array key:@"userNickname" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
                if (isSuccess) {
                    self.indexArray = sectionTitleArr;
                    self.letterResultArr = sortedObjArr;
                    [_table reloadData];
                }
            }];
        }
//            //根据Person对象的 name 属性 按中文 对 Person数组 排序
//            self.indexArray = [BMChineseSort IndexWithArray:_array Key:@"userNickname"];
//            self.letterResultArr = [BMChineseSort sortObjectArray:_array Key:@"userNickname"];
            break;
    }
    
    [self setFooterView];
}
//服务器返回数据
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    
    //更新本地好友
    if ([aDownload.action isEqualToString:act_AttentionList]) {
        [_wait stop];
        [self stopLoading];
        TFJunYou_ProgressVC * pv = [TFJunYou_ProgressVC alloc];
        // 服务端不会返回新朋友 ， 减去新朋友
        pv.dbFriends = (long)[_array count] - 1;
        pv.dataArray = array1;
        pv = [pv init];
//        [g_window addSubview:pv.view];
    }
    
    if ([aDownload.action isEqualToString:act_FriendDel]) {
        [_currentUser doSendMsg:XMPP_TYPE_DELALL content:nil];
    }
    
    if([aDownload.action isEqualToString:act_BlacklistDel]){
        [_currentUser doSendMsg:XMPP_TYPE_NOBLACK content:nil];
    }
    
    if( [aDownload.action isEqualToString:act_UserGet] ){
        [_wait stop];
        
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        
        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
        vc.user       = user;
        vc.fromAddType = 6;
        vc = [vc init];
//        [g_window addSubview:vc.view];
        [g_navigation pushViewController:vc animated:YES];
    }
    // 同步标签
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
        
        // 删除服务器上已经删除的
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
        
        
        _array = [[TFJunYou_LabelObject sharedInstance] fetchAllLabelsFromLocal];
        for (TFJunYou_LabelObject *labelObj in _array) {
            NSString *userIdStr = labelObj.userIdList;
            NSArray *userIds = [userIdStr componentsSeparatedByString:@","];
            if (userIdStr.length <= 0) {
                userIds = nil;
            }
            
            NSMutableArray *newUserIds = [userIds mutableCopy];
            for (NSInteger i = 0; i < userIds.count; i ++) {
                NSString *userId = userIds[i];
                NSString *userName = [TFJunYou_UserObject getUserNameWithUserId:userId];
                
                if (!userName || userName.length <= 0) {
                    [newUserIds removeObject:userId];
                }
                
            }
            
            NSString *string = [newUserIds componentsJoinedByString:@","];
            
            labelObj.userIdList = string;
            
            [labelObj update];
        }
    }
    
    if ([aDownload.action isEqualToString:act_customerLinkList]){
        self.customerArr = array1;
        CGRect backFrame = backView.frame;
        backFrame.size.height = backFrame.size.height + 50* self.customerArr.count;
        backView.frame = backFrame ;
        if (self.customerArr.count == 0) {
            return;
        }
        
        int cY = _menuView.frame.origin.y + _menuView.frame.size.height;
        for (int i = 0; i < self.customerArr.count; i++) {
            UIView *customerView = [[UIView alloc] initWithFrame:CGRectMake(0, cY + 50 * i, self_width, 50)];
            //            customerView.backgroundColor = [UIColor redColor];
            
            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, .5)];
            lineView2.backgroundColor = HEXCOLOR(0xdcdcdc);
            [customerView addSubview:lineView2];
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, lineView2.frame.origin.y+5, 40, 40)];
            NSString *fileURL = self.customerArr[i][@"path"];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                imageView2.image = image;
            }else {
                imageView2.image = [UIImage imageNamed:@"ALOGO_120"];
            }
            
            [customerView addSubview:imageView2];
            UIButton *customerBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageView2.frame.origin.x+imageView2.frame.size.width + 20, imageView2.frame.origin.y, self_width-imageView2.frame.size.width-15+20, 40)];
            //            [customerBtn setTitle:@"威尼斯客服" forState:UIControlStateNormal];
            if (self.customerArr[i][@"name"]) {
                [customerBtn setTitle:self.customerArr[i][@"name"] forState:UIControlStateNormal];
            }else {
                //                imageView2.image = [UIImage imageNamed:@"ALOGO_120"];
                [customerBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            //    [customerBtn ]
            customerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //    customerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            //    customerBtn.backgroundColor = UIColor.redColor;
            [customerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [customerBtn addTarget:self action:@selector(customerClick:) forControlEvents:UIControlEventTouchUpInside];
            customerBtn.tag = i+1;
            [customerView addSubview:customerBtn];
            
            UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(self_width - 40, customerBtn.frame.origin.y + customerBtn.frame.size.height - 15, 40, 15)];
            if (self.customerArr[i][@"type"]) {
                hintLabel.text = self.customerArr[i][@"type"];
            }else{
                hintLabel.text = @"--";
            }
            hintLabel.font = [UIFont systemFontOfSize:13];
            hintLabel.backgroundColor = UIColor.clearColor;
            hintLabel.textColor = UIColor.blackColor;
            hintLabel.textAlignment = NSTextAlignmentCenter;
            [customerView addSubview:hintLabel];
            
            
            [backView addSubview:customerView];
            
        }
    }

}

- (void)setupCustomerLinkList {
        self.customerArr = g_App.customerLinkListArray;
        CGRect backFrame = backView.frame;
        backFrame.size.height = backFrame.size.height + 50* self.customerArr.count;
        backView.frame = backFrame ;
        if (self.customerArr.count == 0) {
            return;
        }
        
        int cY = _menuView.frame.origin.y + _menuView.frame.size.height;
        for (int i = 0; i < self.customerArr.count; i++) {
            UIView *customerView = [[UIView alloc] initWithFrame:CGRectMake(0, cY + 50 * i, self_width, 50)];
            //            customerView.backgroundColor = [UIColor redColor];
            
            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, .5)];
            lineView2.backgroundColor = HEXCOLOR(0xdcdcdc);
            [customerView addSubview:lineView2];
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, lineView2.frame.origin.y+5, 40, 40)];
            NSString *fileURL = self.customerArr[i][@"path"];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                imageView2.image = image;
            }else {
                imageView2.image = [UIImage imageNamed:@"ALOGO_120"];
            }
            
            [customerView addSubview:imageView2];
            UIButton *customerBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageView2.frame.origin.x+imageView2.frame.size.width + 20, imageView2.frame.origin.y, self_width-imageView2.frame.size.width-15+20, 40)];
            //            [customerBtn setTitle:@"威尼斯客服" forState:UIControlStateNormal];
            if (self.customerArr[i][@"name"]) {
                [customerBtn setTitle:self.customerArr[i][@"name"] forState:UIControlStateNormal];
            }else {
                //                imageView2.image = [UIImage imageNamed:@"ALOGO_120"];
                [customerBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            //    [customerBtn ]
            customerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //    customerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            //    customerBtn.backgroundColor = UIColor.redColor;
            [customerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [customerBtn addTarget:self action:@selector(customerClick:) forControlEvents:UIControlEventTouchUpInside];
            customerBtn.tag = i+1;
            [customerView addSubview:customerBtn];
            
            UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(self_width - 40, customerBtn.frame.origin.y + customerBtn.frame.size.height - 15, 40, 15)];
            if (self.customerArr[i][@"type"]) {
                hintLabel.text = self.customerArr[i][@"type"];
            }else{
                hintLabel.text = @"--";
            }
            hintLabel.font = [UIFont systemFontOfSize:13];
            hintLabel.backgroundColor = UIColor.clearColor;
            hintLabel.textColor = UIColor.blackColor;
            hintLabel.textAlignment = NSTextAlignmentCenter;
            [customerView addSubview:hintLabel];
            
            
            [backView addSubview:customerView];
            
        }
}



-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    
    [self stopLoading];
    return hide_error;
}

-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait hide];
    [self stopLoading];
    return hide_error;
}

-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
//    [_wait start];
}

-(void)refresh{
    [self stopLoading];
    _refreshCount++;
    [_array removeAllObjects];
//    [_array release];
    [self getArrayData];
    _friendArray = [g_server.myself fetchAllFriendsOrNotFromLocal];
    [_table reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

//-(void)scrollToPageUp{
//    [self refresh];
//}

-(void)newFriend:(NSObject*)sender{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refresh];
    });
}

-(void)onHeadImage:(id)dataObj{

    TFJunYou_UserObject *p = (TFJunYou_UserObject *)dataObj;
    if([p.userId isEqualToString:FRIEND_CENTER_USERID] || [p.userId isEqualToString:CALL_CENTER_USERID])
        return;
    
    _currentUser = p;
//    [g_server getUser:p.userId toView:self];
    
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId       = p.userId;
    vc.user = p;
    vc.fromAddType = 6;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];

    p = nil;
}

-(void)onSendTimeout:(NSNotification *)notifacation//超时未收到回执
{
    //    NSLog(@"onSendTimeout");
    [_wait stop];
//    [g_App showAlert:Localized(@"JXAlert_SendFilad")];
//    [TFJunYou_MyTools showTipView:Localized(@"JXAlert_SendFilad")];
}

-(void)newReceipt:(NSNotification *)notifacation{//新回执
    //    NSLog(@"newReceipt");
    TFJunYou_MessageObject *msg     = (TFJunYou_MessageObject *)notifacation.object;
    if(msg == nil)
        return;
    if(![msg isAddFriendMsg])
        return;
    [_wait stop];
    if([msg.type intValue] == XMPP_TYPE_DELALL){
        if([msg.toUserId isEqualToString:_currentUser.userId] || [msg.fromUserId isEqualToString:_currentUser.userId]){
            [_array removeObject:_currentUser];
            _currentUser = nil;
            [self getArrayData];
            [_table reloadData];
//            [g_App showAlert:Localized(@"JXAlert_DeleteFirend")];
        }
    }
    
    if([msg.type intValue] == XMPP_TYPE_BLACK){//拉黑
        for (TFJunYou_UserObject *obj in _array) {
            if ([obj.userId isEqualToString:_currentUser.userId]) {
                [_array removeObject:obj];
                break;
            }
        }
        
        [self getArrayData];
        [self.tableView reloadData];
    }
    
    if([msg.type intValue] == XMPP_TYPE_NOBLACK){
//        _currentUser.status = [NSNumber numberWithInt:friend_status_friend];
//        int status = [_currentUser.status intValue];
//        [_currentUser update];
        
        if (!_currentUser) {
            return;
        }
        [[TFJunYou_XMPP sharedInstance].blackList removeObject:_currentUser.userId];
        [TFJunYou_MessageObject msgWithFriendStatus:_currentUser.userId status:friend_status_friend];
        for (TFJunYou_UserObject *obj in _array) {
            if ([obj.userId isEqualToString:_currentUser.userId]) {
                [_array removeObject:obj];
                break;
            }
        }
    
        [self getArrayData];
        [self.tableView reloadData];
//        [g_App showAlert:Localized(@"JXAlert_MoveBlackList")];
    }
    
    if([msg.type intValue] == XMPP_TYPE_PASS){//通过
        [self getFriend];
    }
}

- (void)friendRemarkNotif:(NSNotification *)notif {
    
    TFJunYou_UserObject *user = notif.object;
    for (int i = 0; i < _array.count; i ++) {
        TFJunYou_UserObject *user1 = _array[i];
        if ([user.userId isEqualToString:user1.userId]) {
            user1.userNickname = user.remarkName.length > 0 ? user.remarkName : user.userNickname;
            user1.remarkName = user.remarkName.length > 0 ? user.remarkName : user.userNickname;
            [_table reloadData];
            break;
        }
    }
}

- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title icon:(NSString *)iconName  action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    button.frame = frame;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.frame = CGRectMake((button.frame.size.width-IMAGE_HEIGHT)/2, 20, IMAGE_HEIGHT, IMAGE_HEIGHT);
    imgV.image = [UIImage imageNamed:iconName];
    [button addSubview:imgV];
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYSFONT(14)} context:nil].size;
    UILabel *lab = [[UILabel alloc] init];
    lab.text = title;
    lab.font = SYSFONT(14);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = HEXCOLOR(0x323232);
    if (size.width >= button.frame.size.width) {
        size.width = button.frame.size.width-20;
    }
    lab.frame = CGRectMake(0, CGRectGetMaxY(imgV.frame)+INSET_HEIGHT, size.width, size.height);
    CGPoint center = lab.center;
    center.x = imgV.center.x;
    lab.center = center;
    
    CGRect btnFrame = button.frame;
    btnFrame.size.height = CGRectGetMaxY(imgV.frame)+INSET_HEIGHT+size.height;
    button.frame = btnFrame;
    
    [button addSubview:lab];
    
    return button;
}

-(void)customerClick:(UIButton *)sender{
    //    UIButton *btn = (UIButton *)[self.view viewWithTag:sender.tag];
    
    if (self.customerArr[sender.tag - 1][@"link"]) {
        CYWebCustomerServiceVC *vc = [[CYWebCustomerServiceVC alloc] init];
        vc.titleName = self.customerArr[sender.tag - 1][@"name"];
        vc.link = self.customerArr[sender.tag - 1][@"link"];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }else {
        NSLog(@"链接不存在！！！！！！！！");
    }
    
}

@end
