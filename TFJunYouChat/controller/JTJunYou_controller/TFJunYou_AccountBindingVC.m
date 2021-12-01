//
//  TFJunYou_AccountBindingVC.m
//  TFJunYouChat
//
//  Created by 1 on 2019/3/14.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_AccountBindingVC.h"
  

#define HEIGHT 50
#define MY_INSET  0  // 每行左右间隙
#define TOP_ADD_HEIGHT  400  // 顶部添加的高度，防止下拉顶部空白

typedef NS_ENUM(NSInteger, TFJunYou_BindType) {
    TFJunYou_BindQQ = 1,          // QQ绑定
    TFJunYou_BindWX,              // 微信绑定
};

//修改了修改了
@interface TFJunYou_AccountBindingVC () <UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *wxBindStatus;
@property (nonatomic, strong) UIButton *qqBindStatus;
 
@property (nonatomic, assign) TFJunYou_BindType type;


@end

@implementation TFJunYou_AccountBindingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"JX_AccountAndBindSettings");
    self.isGotoBack = YES;
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    [self createHeadAndFoot];
    [self getServerData];
    
    [self setupViews];
    // 微信登录回调
    [g_notify addObserver:self selector:@selector(authRespNotification:) name:kWxSendAuthRespNotification object:nil];
}


- (void)getServerData {
    [g_server getBindInfo:self];
}

- (void)setupViews {
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 18)];
    title.text = Localized(@"JX_OtherLogin");
    title.font = SYSFONT(16);
    [self.tableBody addSubview:title];
    
    // 微信绑定
    TFJunYou_ImageView* wxIv = [self createButton:Localized(@"JX_WeChat") drawTop:YES drawBottom:YES icon:@"wechat_icon" click:@selector(bindWXAcount)];
    wxIv.frame = CGRectMake(MY_INSET,CGRectGetMaxY(title.frame)+20, TFJunYou__SCREEN_WIDTH, HEIGHT);
    
    self.wxBindStatus = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-20-60, 16, 60, 20)];
    [self.wxBindStatus setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.wxBindStatus.titleLabel setFont:SYSFONT(15)];
    [self.wxBindStatus.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.wxBindStatus setTitle:Localized(@"JX_Unbounded") forState:UIControlStateNormal];
    [self.wxBindStatus setTitle:Localized(@"JX_Binding") forState:UIControlStateSelected];
    [wxIv addSubview:self.wxBindStatus];
    
    //QQ绑定
    TFJunYou_ImageView* qqIv = [self createButton:@"QQ" drawTop:YES drawBottom:YES icon:@"qq_login" click:@selector(bindQQAcount)];
    qqIv.frame = CGRectMake(MY_INSET,CGRectGetMaxY(wxIv.frame)+20, TFJunYou__SCREEN_WIDTH, HEIGHT);
    
    self.qqBindStatus = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-20-60, 16, 60, 20)];
    [self.qqBindStatus setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.qqBindStatus.titleLabel setFont:SYSFONT(15)];
    [self.qqBindStatus.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.qqBindStatus setTitle:Localized(@"JX_Unbounded") forState:UIControlStateNormal];
    [self.qqBindStatus setTitle:Localized(@"JX_Binding") forState:UIControlStateSelected];
    [qqIv addSubview:self.qqBindStatus];

    
}

- (void)bindWXAcount {
    self.type = TFJunYou_BindWX;
    if (self.wxBindStatus.selected) {
        [g_App showAlert:Localized(@"JX_UnbindWeChat?") delegate:self tag:1001 onlyConfirm:NO];
    }else {
        [g_App showAlert:Localized(@"JX_BindWeChat?") delegate:self tag:1002 onlyConfirm:NO];
    }
    
}

- (void)bindQQAcount {
    self.type = TFJunYou_BindQQ;
    if (self.qqBindStatus.selected) {
        [g_App showAlert:@"是否确认解绑QQ" delegate:self tag:1003 onlyConfirm:NO];
    }else {
        [g_App showAlert:@"是否确认绑定QQ" delegate:self tag:1004 onlyConfirm:NO];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1001) {
            [g_server setAccountUnbind:2 toView:self];
        }
        if (alertView.tag == 1002) {
         
            //修改了修改了
            //修改了修改了
        }
        
        if (alertView.tag == 1003) {
            [g_server setAccountUnbind:1 toView:self];
        }
        if (alertView.tag == 1004) {
            NSString *appid = g_App.QQ_LOGIN_APPID;
        
        }

    }
}

- (void)authRespNotification:(NSNotification *)notif {
    
}
// QQ登录成功回调
- (void)tencentDidLogin {
 
}

- (NSMutableArray *)getPermissions {
    NSMutableArray * g_permissions = [[NSMutableArray alloc]init];/* initWithObjects:kOPEN_PERMISSION_GET_USER_INFO,
                                      kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                      kOPEN_PERMISSION_ADD_ALBUM,
                                      kOPEN_PERMISSION_ADD_TOPIC,
                                      kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                      kOPEN_PERMISSION_GET_INFO,
                                      kOPEN_PERMISSION_GET_OTHER_INFO,
                                      kOPEN_PERMISSION_LIST_ALBUM,
                                      kOPEN_PERMISSION_UPLOAD_PIC,
                                      kOPEN_PERMISSION_GET_VIP_INFO,
                                      kOPEN_PERMISSION_GET_VIP_RICH_INFO, nil];*/
    return g_permissions;
}

- (void)bindTel {
    TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
    if ([g_default objectForKey:kMY_USER_PASSWORD]) {
        user.password = [g_default objectForKey:kMY_USER_PASSWORD];
    }
    NSString *areaCode = [g_default objectForKey:kMY_USER_AREACODE];
    user.areaCode = areaCode.length > 0 ? areaCode : @"86";
    if ([g_default objectForKey:kMY_USER_LoginName]) {
        user.telephone = [g_default objectForKey:kMY_USER_LoginName];
    }
    
    
    //        [g_server thirdLogin:user type:2 openId:g_server.openId isLogin:YES toView:self];
    [g_server userBindWXAccount:user type:self.type openId:g_server.openId isLogin:YES toView:self];

}


-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_unbind]){
        if (self.type == TFJunYou_BindWX) {
            self.wxBindStatus.selected = NO;
        }else {
            self.qqBindStatus.selected = NO;
        }
        [g_server showMsg:Localized(@"JX_UnboundSuccessfully")];
    }
    if ([aDownload.action isEqualToString:act_UserBindWXAccount]) {
        g_server.openId = nil;
        if (self.type == TFJunYou_BindWX) {
            self.wxBindStatus.selected = YES;
        }else {
            self.qqBindStatus.selected = YES;
        }
        [g_server showMsg:Localized(@"JX_BindingSuccessfully")];
    }
    if ([aDownload.action isEqualToString:act_GetWxOpenId]) {
        
        g_server.openId = [dict objectForKey:@"openid"];
        [self bindTel];
    }
    if( [aDownload.action isEqualToString:act_getBindInfo] ){
        if (array1.count > 0) {
            for (NSDictionary *dict in array1) {
                if ([[dict objectForKey:@"type"] intValue] == 2) {
                    //微信绑定
                    self.wxBindStatus.selected = YES;
                }
                if ([[dict objectForKey:@"type"] intValue] == 1) {
                    //QQ绑定
                    self.qqBindStatus.selected = YES;
                }
            }
        }
    }
}

-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_UserBindWXAccount]) {
        g_server.openId = nil;
    }
    return show_error;
}

-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    if ([aDownload.action isEqualToString:act_UserBindWXAccount]) {
        g_server.openId = nil;
    }
    return show_error;
}

-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}


-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom icon:(NSString*)icon click:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.delegate = self;
    [self.tableBody addSubview:btn];
    
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(20*2+20, 0, self_width-35-20-5, HEIGHT)];
    p.text = title;
    p.font = g_factory.font16;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = HEXCOLOR(0x323232);
    [btn addSubview:p];
    
    if(icon){
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, (HEIGHT-20)/2, 21, 21)];
        iv.image = [UIImage imageNamed:icon];
        [btn addSubview:iv];
    }
    
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,HEIGHT-0.3,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
//    if(click){
//        UIImageView* iv;
//        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-INSETS-20-3-MY_INSET, 16, 20, 20)];
//        iv.image = [UIImage imageNamed:@"set_list_next"];
//        [btn addSubview:iv];
//
//    }
    return btn;
}


@end
