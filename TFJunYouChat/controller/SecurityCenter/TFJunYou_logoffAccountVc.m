//
//  TFJunYou_logoffAccountVc.m
//  TFJunYouChat
//
//  Created by os on 2021/2/6.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_logoffAccountVc.h"
#import "TFJunYou_VerifyPayVC.h"
#import "TFJunYou_PayPasswordVC.h"
#import "MD5Util.h"
#import "TFJunYou_loginVC.h"

@interface TFJunYou_logoffAccountVc ()
@property (nonatomic,strong) TFJunYou_VerifyPayVC *verVC;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriHH;

@end

@implementation TFJunYou_logoffAccountVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    self.title = @"注销北极熊号";
    self.tableBody.frame = CGRectZero;
    self.view.backgroundColor = RGB(229, 229, 234);
    _cancleBtn.layer.cornerRadius = 4;
    _cancleBtn.layer.masksToBounds = YES;
    [_cancleBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
}
 
- (void)cancelClick{
    [g_App showAlert:@"确定要注销账号吗？" delegate:self tag:100000 onlyConfirm:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 100000) {
            if ([g_server.myself.isPayPassword boolValue]) {
             
                self.verVC = [TFJunYou_VerifyPayVC alloc];
                self.verVC.type = TFJunYou_VerifyTypeUserCancel;
                self.verVC.RMB =  @"";
                self.verVC.delegate = self;
                self.verVC.didDismissVC = @selector(dismissVerifyPayVC);
                self.verVC.didVerifyPay = @selector(didVerifyPay:);
                self.verVC = [self.verVC init];
                
                [self.view addSubview:self.verVC.view];
                 
            } else {
                //  直接注销
                [g_server get_act_UserCancelToView:self];
            }

        }
    }
}


- (void)dismissVerifyPayVC{
    [self.verVC.view removeFromSuperview];
}

- (void)didVerifyPay:(NSString *)sender{
    
     [_wait show];
    
    // 参数salt为随机UUID字符串，确保每次的mac都不同
    NSString* s = [NSUUID UUID].UUIDString;
    s = [[s stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *salt = s;
    // 获取Mac值
    NSString *mac = [self getMacWithSalt:salt payPassword:sender];
    // 获取临时密码
    [g_server transactionGetCodeWithSalt:salt mac:mac toView:self];
    
    
}

// 获取mac值
- (NSString *)getMacWithSalt:(NSString *)salt payPassword:(NSString *)payPassword {

    NSMutableString *str = [NSMutableString string];
    [str appendString:APIKEY];
    [str appendString:g_myself.userId];
    [str appendString:g_server.access_token];
    [str appendString:salt];
    
    NSData *aesData = [AESUtil encryptAESData:[g_myself.userId dataUsingEncoding:NSUTF8StringEncoding] key:[MD5Util getMD5DataWithString:payPassword]];
    
    NSData *macData = [g_securityUtil getHMACMD5:[str dataUsingEncoding:NSUTF8StringEncoding] key:[[MD5Util getMD5StringWithData:aesData] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *mac = [macData base64EncodedStringWithOptions:0];
    return mac;
}
 

-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    if ([aDownload.action isEqualToString:act_TransactionGetCode]) {
        [self.verVC didDismissVerifyPayVC];
        [g_server get_act_UserCancelToView:self];
    }
    if ([aDownload.action isEqualToString:act_UserCancel]) {
        [self doSwitch];
        [g_App showAlert:@"注销成功"];
    }
    
    
}

-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    if ([aDownload.action isEqualToString:act_TransactionGetCode]) {
        
        [g_App showAlert:@"密码错误"];
    }
    if ([aDownload.action isEqualToString:act_UserCancel]) {
        
        return show_error;
    }
    return hide_error;
}
 
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait hide];

    return hide_error;
}

- (void)didServerConnectStart:(TFJunYou_Connection*)aDownload {
    [_wait start];
}

-(void)doSwitch{
    [g_default removeObjectForKey:kMY_USER_PASSWORD];
    [g_default removeObjectForKey:kMY_USER_TOKEN];
    NSLog(@"TTT(移除):");
    [g_notify postNotificationName:kSystemLogoutNotifaction object:nil];
    g_xmpp.isReconnect = NO;
    [[TFJunYou_XMPP sharedInstance] logout];
    NSLog(@"XMPP ---- TFJunYou_settingVC doSwitch");
    // 退出登录到登陆界面 隐藏悬浮窗
    g_App.subWindow.hidden = YES;
    
    TFJunYou_loginVC* vc = [TFJunYou_loginVC alloc];
    vc.isAutoLogin = NO;
    vc.isSwitchUser= NO;
    vc = [vc init];
    [g_mainVC.view removeFromSuperview];
    g_mainVC = nil;
    [self.view removeFromSuperview];
    self.view = nil;
    g_navigation.rootViewController = vc;

#if TAR_IM
#ifdef Meeting_Version
    [g_meeting stopMeeting];
#endif
#endif
}

@end
