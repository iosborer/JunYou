//
//  AppDelegate.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/15.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_Navigation.h"
#import "TFJunYou_DidPushObj.h"
#import "JPUSHService.h"
#import "TFJunYou_MsgUtil.h"
#import "TFJunYou_MeetingObject.h"
#import "TFJunYou_emojiViewController.h"
#import "TFJunYou_Server.h"
#import "NumLockViewController.h"

 
@class TFJunYou_MainViewController;
@class TFJunYou_versionManage;
@class TFJunYou_Constant;
@class TFJunYou_UserObject; 
@class TFJunYou_CommonService;
@class ViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *subWindow;
@property (nonatomic, strong) ViewController *watherViewC;
@property (nonatomic, strong) NumLockViewController *numLockVC;
@property (nonatomic, strong) NSString *QQ_LOGIN_APPID;
@property (nonatomic,strong)  TFJunYou_MeetingObject * jxMeeting;
@property (nonatomic,strong)  TFJunYou_Server* jxServer;
@property (nonatomic,strong)  TFJunYou_Constant* jxConstant;
@property (nonatomic, strong) TFJunYou_versionManage* config;
@property (strong, nonatomic) TFJunYou_emojiViewController* faceView;
@property (strong, nonatomic) TFJunYou_MainViewController *mainVc;
@property (strong, nonatomic) NSString * isShowRedPacket;
@property (nonatomic, assign) BOOL is_iPhoneX;
@property (strong, nonatomic) NSString * shortVideo;
@property (strong, nonatomic) NSString * videoMeeting;

@property (strong, nonatomic) NSString * isShowApplyForWithdrawal;
@property (strong, nonatomic) NSNumber * isOpenActivity;
@property (strong, nonatomic) NSString * activityUrl;
@property (strong, nonatomic) NSString * activityName;
@property (assign, nonatomic) double myMoney;
@property (nonatomic, strong) TFJunYou_CommonService *commonService;
@property (nonatomic, strong) TFJunYou_Navigation *navigation;
@property (nonatomic, assign) BOOL isShowDeviceLock;
@property (nonatomic, strong) TFJunYou_DidPushObj *didPushObj;
@property (nonatomic, copy)   NSArray *linkArray;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSArray *customerLinkListArray;
@property (nonatomic, strong) TFJunYou_SecurityUtil *securityUtil;
@property (nonatomic, strong) TFJunYou_PayServer *payServer;
@property (nonatomic, strong) TFJunYou_LoginServer *loginServer;
@property (nonatomic, strong) TFJunYou_MsgUtil *msgUtil;
-(void) showAlert: (NSString *) message;
-(UIAlertView *) showAlert: (NSString *) message delegate:(id)delegate;
- (UIAlertView *) showAlert: (NSString *) message delegate:(id)delegate tag:(NSUInteger)tag onlyConfirm:(BOOL)onlyConfirm;
- (void)copyDbWithUserId:(NSString *)userId;
-(void)showMainUI;
-(void)showLoginUI;
- (void)setupLunchADUrl:(NSString *)url link:(NSString *)link;
-(void)endCall;
@end
