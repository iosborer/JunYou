//
//  AppDelegate.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/15.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "AppDelegate.h"
#import <AvoidCrash/AvoidCrash.h>
#import <Bugly/Bugly.h>
#import "TFJunYou_LaunchVc.h"
#import "TFJunYou_MainViewController.h"
#import "TFJunYou_XMPP.h"
#import "TFJunYou_CommonService.h"
#import "TFJunYou_versionManage.h" 
#import "TFJunYou_Constant.h"
#import "TFJunYou_loginVC.h" 
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#if Meeting_Version
#if !TARGET_IPHONE_SIMULATOR
#import <JitsiMeet/JitsiMeet.h>
#endif
#endif
#ifdef USE_GOOGLEMAP
#import <GoogleMaps/GoogleMaps.h>
#endif
#import "NumLockViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <Bugly/Bugly.h>
#define BUGLY_APP_ID @"a5a29670ad"
#import "XHLaunchAd.h"
#import "webpageVC.h"
#import "Network.h"
#import "LaunchAdModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WXApi.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

//#import "KeyboardHelper.h"
//#import "MenuHelper.h"
//#import "BrowserViewController.h"
//#import "WebServer.h"
//#import "ErrorPageHelper.h"
//#import "SessionRestoreHelper.h"
//#import "TabManager.h"
//#import "PreferenceHelper.h"
//#import "BaseNavigationViewController.h"
#import "ViewController.h"
#import "TFJunYou_MainViewController.h"

static NSString * const kUserAgentOfiOS = @"Mozilla/5.0 (iPhone; CPU iPhone OS %ld_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/%ld.0 Mobile/14A300 Safari/602.1";
@interface AppDelegate () <BuglyDelegate,WXApiDelegate>
@property (nonatomic, assign) NSInteger pasteboardChangeCount;
//@property (nonatomic,strong) SystemPlugin *sysPlugin;
@end
@implementation AppDelegate
#if TAR_IM
#ifdef Meeting_Version
#endif
#endif
static  BMKMapManager* _baiduMapManager;
- (void)dealloc
{
#if TAR_IM
#ifdef Meeting_Version
    [_jxMeeting stopMeeting];
#endif
#endif
   //  [Notifier removeObserver:self name:UIPasteboardChangedNotification object:nil];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.statusBarStyle = UIStatusBarStyleDefault;
    _navigation = [[TFJunYou_Navigation alloc] init];
    if (@available(iOS 13.0, *)) {
        _window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
       }
    [self setupBugly];
    [self networkStatusChange];
    _commonService = [[TFJunYou_CommonService alloc] init];
    _jxServer = [[TFJunYou_Server alloc] init];
    _config  = [[TFJunYou_versionManage alloc] init];
    _jxConstant = [[TFJunYou_Constant alloc]init];
    _didPushObj = [[TFJunYou_DidPushObj alloc] init];
    _securityUtil = [[TFJunYou_SecurityUtil alloc] init];
    _payServer = [[TFJunYou_PayServer alloc] init];
    _loginServer = [[TFJunYou_LoginServer alloc] init];
#ifdef IS_MsgEncrypt
    _msgUtil = [[TFJunYou_MsgUtil alloc] init];
#endif
#if TAR_IM
#ifdef Meeting_Version
    _jxMeeting = [[TFJunYou_MeetingObject alloc] init]; 
#endif
#endif
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
 
     [AvoidCrash makeAllEffective];
     NSArray *noneSelClassStrings = @[
                                   @"NSNull",
                                   @"NSNumber",
                                   @"NSString",
                                   @"NSDictionary",
                                   @"NSArray"
                                   ];
      [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
      [Bugly startWithAppId:BUGLY_APP_ID];
      [WXApi registerApp:@"wxef6e2ba2099bf1fd" universalLink:@"https://vito.liyaning.top/yiqun/"];
     
    
      /*
       [DDLog addLogger:[DDTTYLogger sharedInstance]];
       [DDLog addLogger:[DDASLLogger sharedInstance]];
       DDLogDebug(@"Home Path : %@", HomePath);
       NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                            diskCapacity:32 * 1024 * 1024
                                                                diskPath:nil];
       [NSURLCache setSharedURLCache:URLCache];
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self applicationStartPrepare];
       });
     */
//    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"cylunch"] isEqualToString:@"1"]) {
//
//       }else {
//           [self showPageUI];
//       }
    [self showLoginUI];
    
    [self startPush:application didFinishLaunchingWithOptions:launchOptions];
    /*
    [ErrorPageHelper registerWithServer:[WebServer sharedInstance]];
    [SessionRestoreHelper registerWithServer:[WebServer sharedInstance]];
    [[WebServer sharedInstance] start];
     [TabManager sharedInstance];
     */
    [self makeWebViewSafariLike];
    _baiduMapManager = [[BMKMapManager alloc]init];
    NSString * identifier = [[NSBundle mainBundle] bundleIdentifier];
    BOOL ret = false;
     ret = [_baiduMapManager start:@"IM8c4lkgVyHG2R5FjLHiaEmL7UNaVRgN"  generalDelegate:nil];
    if (!ret)
        NSLog(@"BMKMapManager start faild!");
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY
                          channel:@"App Store"  apsForProduction:YES    advertisingIdentifier:@""];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [g_default setObject:registrationID forKey:@"jPushRegistrationID"];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
#ifdef USE_GOOGLEMAP
    [GMSServices provideAPIKey:@"AIzaSyABu5gPAX0xzT1uw-W2q8XKQxxnEBNXSK8"];
#endif
    self.QQ_LOGIN_APPID = @"1106189302";
    [self registerAPN];
    [self setUserAgent];
    NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [g_default setObject:pushNotificationKey forKey:kDidReceiveRemoteDic];
    [g_default synchronize];
    [self setSDWebImageHeader];
    return YES;
}
- (void)setSDWebImageHeader {
    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageLoader;
    imgDownloader.requestModifier = [SDWebImageDownloaderRequestModifier requestModifierWithBlock:^NSURLRequest * _Nullable(NSURLRequest * _Nonnull request) {
        
        NSURL *url = request.URL;
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        NSString *imgPath = [[SDImageCache sharedImageCache] cachePathForKey:imgKey];
        
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
        NSDate *lastModifiedDate = nil;
        if (fileAttr.count > 0) {
            if (fileAttr.count > 0) {
                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            }
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
        
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest addValue:lastModifiedStr forHTTPHeaderField:@"If-Modified-Since"];
        // 拷贝request
        request = [mutableRequest copy];
        return  request;
    }];
    
}
- (void)showPageUI {
    TFJunYou_LaunchVc *lunchVC = [[TFJunYou_LaunchVc alloc] init];
    g_navigation.rootViewController = lunchVC;
}
 - (void)setupLunchADUrl:(NSString *)url link:(NSString *)link {
     int x = -1;
     if ([url.lowercaseString containsString:@".mp4"]) {
         x = 1;
     } else {
         x = 0;
     }
     if (x==0) {
            [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
            [XHLaunchAd setWaitDataDuration:2];
              XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
              imageAdconfiguration.duration = 5;
              imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
              imageAdconfiguration.imageNameOrURLString = url;
              imageAdconfiguration.GIFImageCycleOnce = NO;
              imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
              imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
              imageAdconfiguration.openModel = link;
              imageAdconfiguration.showFinishAnimate =ShowFinishAnimateLite;
              imageAdconfiguration.showFinishAnimateTime = 0.8;
              imageAdconfiguration.skipButtonType = SkipTypeTimeText;
              imageAdconfiguration.showEnterForeground = NO;
              [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
     }else {
         [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
         [XHLaunchAd setWaitDataDuration:2];
         XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration new];
         videoAdconfiguration.duration = 5;
         videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
         videoAdconfiguration.videoNameOrURLString = url;
         videoAdconfiguration.muted  = NO;
         videoAdconfiguration.videoGravity = AVLayerVideoGravityResize;
         videoAdconfiguration.videoCycleOnce = YES;
         videoAdconfiguration.openModel = link;
         videoAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
         videoAdconfiguration.showFinishAnimateTime = 0.8;
         videoAdconfiguration.showEnterForeground = NO;
         videoAdconfiguration.skipButtonType = SkipTypeTimeText;
         [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
     }
 }
- (void)setUserAgent {
}
- (void)registerAPN{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}
-(UIView *)subWindow
{
    if (!_subWindow) {
        _subWindow = [[UIView alloc] initWithFrame:CGRectMake(100,200,80,80)];
        [g_window addSubview:_subWindow];
    }
    return _subWindow;
}
- (void)resignWindow
{
    [_subWindow removeFromSuperview];
    _subWindow  =  nil ;
}
-(void)showLoginUI{
    TFJunYou_loginVC* vc = [TFJunYou_loginVC alloc];
    vc.isAutoLogin = YES;
    vc.isSwitchUser= NO;
    vc = [vc init];
    g_navigation.rootViewController = vc;
}
-(void)endCall{
    [_jxMeeting stopMeeting];
    [_jxMeeting clearMemory];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        [self applicationDidEnterBackground:[UIApplication sharedApplication]];
    }
}
-(void)showMainUI{
    _mainVc=[[TFJunYou_MainViewController alloc]init];
   // _watherViewC=[[ViewController alloc]init];
 g_navigation.rootViewController = _mainVc;
        int height = 218;
        if (THE_DEVICE_HAVE_HEAD) {
            height = 253;
        }
    _faceView = [[TFJunYou_emojiViewController alloc]initWithFrame:CGRectMake(0, TFJunYou__SCREEN_HEIGHT-height, TFJunYou__SCREEN_WIDTH, height)];
    NSString *str = [g_default stringForKey:kDeviceLockPassWord];
    if (str.length > 0) {
        [self showDeviceLock];
    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [g_notify postNotificationName:kApplicationDidEnterBackground object:nil];
    [g_notify postNotificationName:kAllVideoPlayerStopNotifaction object:nil userInfo:nil];
    [g_notify postNotificationName:kAllAudioPlayerStopNotifaction object:nil userInfo:nil];
    NSLog(@"XMPP ---- Appdelegate");
    if (g_server.isLogin) {
        [g_server userChangeMsgNum:[UIApplication sharedApplication].applicationIconBadgeNumber toView:self];
    }
#if TAR_IM
#ifdef Meeting_Version
    [_jxMeeting meetingDidEnterBackground:application];
    if (!g_meeting.isMeeting) {
        if (g_server.isLogin) {
            [g_server outTime:nil];
        }
        g_xmpp.isCloseStream = YES;
        g_xmpp.isReconnect = NO;
        NSString *str = [g_default stringForKey:kDeviceLockPassWord];
        if (str.length > 0) {
            [self showDeviceLock];
        }
    }
    UIApplication*   app = [UIApplication sharedApplication];
       __block    UIBackgroundTaskIdentifier bgTask;
       bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
           dispatch_async(dispatch_get_main_queue(), ^{
               if (bgTask != UIBackgroundTaskInvalid)
               {
                   bgTask = UIBackgroundTaskInvalid;
               }
           });
       }];
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               if (bgTask != UIBackgroundTaskInvalid)
               {
                   bgTask = UIBackgroundTaskInvalid;
               }
           });
       });
#else
    if (g_server.isLogin) {
        [g_server outTime:nil];
    }
    g_xmpp.isCloseStream = YES;
    g_xmpp.isReconnect = NO;
    NSString *str = [g_default stringForKey:kDeviceLockPassWord];
    if (str.length > 0) {
        [self showDeviceLock];
    }
    UIApplication*   app = [UIApplication sharedApplication];
       __block    UIBackgroundTaskIdentifier bgTask;
       bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
           dispatch_async(dispatch_get_main_queue(), ^{
               if (bgTask != UIBackgroundTaskInvalid)
               {
                   bgTask = UIBackgroundTaskInvalid;
               }
           });
       }];
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               if (bgTask != UIBackgroundTaskInvalid)
               {
                   bgTask = UIBackgroundTaskInvalid;
               }
           });
       });
#endif
#endif
    NSLog(@"程序后台");
}
- (void)showDeviceLock {
    if (!self.isShowDeviceLock) {
        [g_window endEditing:YES];
        self.isShowDeviceLock = YES;
        _numLockVC = [[NumLockViewController alloc]init];
        _numLockVC.isClose = NO;
        [g_window addSubview:_numLockVC.view];
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_config showDisableUse];
    [g_notify postNotificationName:kApplicationWillEnterForeground object:nil];
    if(g_server.isLogin){
        [[TFJunYou_XMPP sharedInstance] login];
#if TAR_IM
#ifdef Meeting_Version
        [_jxMeeting meetingWillEnterForeground:application];
#endif
#endif
    }
    [[TFJunYou_UserObject sharedInstance] deleteUserChatRecordTimeOutMsg];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
   
    //跳转支付宝钱包进行支付，处理支付结果
    return  [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     
    
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
#if Meeting_Version
#if !TARGET_IPHONE_SIMULATOR
    [[JitsiMeet sharedInstance] application:app openURL:url options:options];
#endif
#endif
    if ([url.host isEqualToString:@"safepay"]) {
    }
    else if ([url.host isEqualToString:@"qzapp"]) {
    }
    if ([url.host isEqualToString:@"oauth"]){//微信登录
        return [WXApi handleOpenURL:url delegate:self];
    }
   
   
 
    return YES;
}
#if Meeting_Version
#if !TARGET_IPHONE_SIMULATOR
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
   
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
           NSURL *url = userActivity.webpageURL;
          // TODO 根据需求进行处理
       }
    //[[JitsiMeet sharedInstance] application:application   continueUserActivity:userActivity  restorationHandler:restorationHandler];
    
    return  [WXApi handleOpenUniversalLink:userActivity delegate:self];
}
#endif
#endif
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [g_notify postNotificationName:kApplicationDidBecomeActive object:nil];
    /*
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.pasteboardChangeCount != pasteboard.changeCount) {
        self.pasteboardChangeCount = pasteboard.changeCount;
        NSURL *url = pasteboard.URL;
        if (url && ![[PreferenceHelper URLForKey:KeyPasteboardURL] isEqual:url]) {
           // [PreferenceHelper setURL:url forKey:KeyPasteboardURL];
            [self presentPasteboardChangedAlertWithURL:url];
        }
    }
     */
}
- (void)applicationWillResignActive:(UIApplication *)application {
    if (g_server.isLogin) {
        [g_server userChangeMsgNum:[UIApplication sharedApplication].applicationIconBadgeNumber toView:self];
    }
   [[NSUserDefaults standardUserDefaults] synchronize];
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    static NSString *kAVFullScreenViewControllerStr = @"AVFullScreenViewController";
    UIViewController *presentedViewController = [window.rootViewController presentedViewController];
    if (presentedViewController && [presentedViewController isKindOfClass:NSClassFromString(kAVFullScreenViewControllerStr)] && [presentedViewController isBeingDismissed] == NO) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}
- (void) showAlert: (NSString *) message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:self cancelButtonTitle:Localized(@"JX_Confirm") otherButtonTitles:nil, nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [av show];
        [g_navigation resetVCFrame];
    });
}
- (UIAlertView *) showAlert: (NSString *) message delegate:(id)delegate
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:delegate cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm"), nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [av show];
        [g_navigation resetVCFrame];
    });
    return av;
}
- (UIAlertView *) showAlert: (NSString *) message delegate:(id)delegate tag:(NSUInteger)tag onlyConfirm:(BOOL)onlyConfirm
{
    UIAlertView *av;
    if (onlyConfirm)
       av = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:delegate cancelButtonTitle:Localized(@"JX_Confirm") otherButtonTitles:nil];
    else
        av = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:delegate cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm"), nil];
    av.tag = tag;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [av show];
        [g_navigation resetVCFrame];
    });
    return av;
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
#if TAR_IM
#ifdef Meeting_Version
#endif
#endif
}
- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"程序杀死");
    [g_server userChangeMsgNum:[UIApplication sharedApplication].applicationIconBadgeNumber toView:self];
    [g_server outTime:nil];
    g_xmpp.isCloseStream = YES;
    g_xmpp.isReconnect = NO;
    [g_xmpp logout];
#if TAR_IM
#ifdef Meeting_Version
    [_jxMeeting doTerminate];
    [self endCall];
#endif
#endif
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
#if TAR_IM
#ifdef Meeting_Version
    [_jxMeeting clearMemory];
#endif
#endif
}
-(void)startPush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    NSString * identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([identifier isEqualToString:@"com.shiku.im.push"]) {
        [BPush registerChannel:launchOptions apiKey:@"YWCjFscGk7cv3RlEtaxoypzt0sipp6vw" pushMode: BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil useBehaviorTextInput:YES isDebug:NO];
    }else{
        [BPush registerChannel:launchOptions apiKey:@"7LlWDe0AZGKILS4Tq5cMNMum" pushMode: BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil useBehaviorTextInput:YES isDebug:NO];
    }
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"test:%@",deviceToken);
    NSString * token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [g_default setObject:token forKey:@"apnsToken"];
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        if (result) {
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                }
            }];
        }
    }];
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [BPush handleNotification:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
    [g_default setObject:userInfo forKey:kDidReceiveRemoteDic];
    [g_default synchronize];
}
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    }else{
    }
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    [g_default setObject:userInfo forKey:kDidReceiveRemoteDic];
    [g_default synchronize];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); 
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [g_default setObject:userInfo forKey:kDidReceiveRemoteDic];
    [g_default synchronize];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [g_default setObject:userInfo forKey:kDidReceiveRemoteDic];
    [g_default synchronize];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)networkStatusChange {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status != AFNetworkReachabilityStatusNotReachable) {
            if (g_server.isLogin) {
                if (g_xmpp.isLogined != login_status_yes) {
                    [[TFJunYou_XMPP sharedInstance] logout];
                    [[TFJunYou_XMPP sharedInstance] login];
                }
            }
        }else {
            [g_xmpp.reconnectTimer invalidate];
            g_xmpp.reconnectTimer = nil;
            g_xmpp.isReconnect = NO;
            [[TFJunYou_XMPP sharedInstance] logout];
            [TFJunYou_MyTools showTipView:Localized(@"JX_NetWorkError")];
        }
    }];
}
#if TAR_IM
#ifdef Meeting_Version
-(void)meetingLocalNotifi:(NSString *)fromUserName isAudio:(BOOL)isAudio{
    UILocalNotification *callNotification = [[UILocalNotification alloc] init];
    NSString *stringAlert;
    if (isAudio){
        stringAlert = [NSString stringWithFormat:@"%@ \n %@", Localized(@"JXMeetingObject_VoiceChat"),fromUserName];
    }else{
        stringAlert = [NSString stringWithFormat:@"%@\n %@",Localized(@"JXMeetingObject_VideoChat"), fromUserName];
    }
    callNotification.alertBody = stringAlert;
    callNotification.soundName = @"whynotyou.caf";
    [[UIApplication sharedApplication]
     presentLocalNotificationNow:callNotification];
}
#endif
#endif
- (NSData *)imageDataScreenShot
{
    CGSize imageSize = CGSizeZero;
    imageSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}
- (void)copyDbWithUserId:(NSString *)userId {
    userId = [userId uppercaseString];
    NSString* t =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* copyPath = [NSString stringWithFormat:@"%@/%@.db",t,userId];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *groupURL = [manager containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_ID];
    NSString *fileName = [NSString stringWithFormat:@"%@.db",userId];
    NSURL *fileURL = [groupURL URLByAppendingPathComponent:fileName];
    NSString *path = [fileURL.absoluteString substringFromIndex:7];
    NSError *error = nil;
    [manager removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"删除失败error : %@",error);
    }
    if (path.length <= 0) {
        return;
    }
    BOOL isCopy = [manager copyItemAtPath:copyPath toPath:path error:nil];
    if (isCopy) {
        static dispatch_once_t disOnce;
        dispatch_once(&disOnce,^ {
            NSLog(@"share extension : %@",path);
        });
    }
}
- (void)setupBugly {
    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.debugMode = YES;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    config.channel = @"Bugly";
    config.delegate = self;
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
}
#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    return @"This is an attachment";
}
#pragma mark - XHLaunchAdDelegate
-(BOOL)xhLaunchAd:(XHLaunchAd *)launchAd clickAtOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    NSLog(@"广告点击事件");
    if(openModel == nil) return NO;
    NSString *urlString = (NSString *)openModel;
    webpageVC *webVC = [webpageVC alloc];
    webVC.isGotoBack = YES;
    webVC.url   = urlString;
    webVC = [webVC init];
    [g_navigation pushViewController:webVC animated:YES];
    return YES;
}
- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickSkipButton:(UIButton *)skipButton {
    [XHLaunchAd removeAndAnimated:YES];
}
- (void)setAudioPlayInBackgroundMode {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError];
    if (!success) {  }
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) {  }
}
- (void)handlePasteboardNotification:(NSNotification *)notify {
    self.pasteboardChangeCount = [UIPasteboard generalPasteboard].changeCount;
}
- (void)presentPasteboardChangedAlertWithURL:(NSURL *)url {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新窗口打开剪切板网址" message:@"您是否需要在新窗口中打开剪切板中的网址？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
       // NSNotification *notify = [NSNotification notificationWithName:kOpenInNewWindowNotification object:self userInfo:@{@"url": url}];
       // [Notifier postNotification:notify];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)makeWebViewSafariLike {
    NSOperatingSystemVersion systemVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
    NSInteger version = systemVersion.majorVersion;
    NSString *userAgent = [NSString stringWithFormat:kUserAgentOfiOS, version, version];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : userAgent}];
}
- (void)applicationStartPrepare {
    [self setAudioPlayInBackgroundMode];
    /*[[KeyboardHelper sharedInstance] startObserving];
    [[MenuHelper sharedInstance] setItems];
    [Notifier addObserver:self selector:@selector(handlePasteboardNotification:) name:UIPasteboardChangedNotification object:nil];
     */
}
  
/*! @brief 发送一个sendReq后，收到微信的回应
*
* 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
* 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
* @param resp具体的回应内容，是自动释放的
*/
- (void)onResp:(BaseResp*)resp{
    
    
    [g_notify postNotificationName:@"wxBandId" object:resp];
}

- (BOOL)is_iPhoneX {
    if (@available(iOS 11.0, *)) {
            return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom ? YES : NO;
        }
    return NO;
}
@end
