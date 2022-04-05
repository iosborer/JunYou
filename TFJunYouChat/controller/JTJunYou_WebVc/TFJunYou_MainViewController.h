//
//  TFJunYou_MainViewController.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/15.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_PublishVc.h"
#import "WKWebViewController.h"
@class TFJunYou_TabMenuView;
@class TFJunYou_MsgViewController;
@class TFJunYou_UserViewController;
@class TFJunYou_FriendViewController;
@class TFJunYou_GroupViewController;
@class TFJunYou_PSMyViewController;
@class searchUserVC;
@class TFJunYou_WeiboVC;
@class OrganizTreeViewController;
@class TFJunYou_SquareViewController;
@class PSJobListVC;
@class PSAuditListVC;
@class PSWriteExamListVC;
@class CYWebAddPointVC;
@class CYWebBettingVC;
@class TFJunYou_PublishVc;
 
@class TFJunYou_AddrBookVc;
@class TFJunYou_FriendCirleVc;
//@class BrowserViewController;

@interface TFJunYou_MainViewController : UIViewController<UIAlertViewDelegate>{
    
    UIView* _topView;
    UIViewController* _selectVC;
    TFJunYou_PSMyViewController* _psMyviewVC;
    TFJunYou_WeiboVC* _weiboVC;
    CYWebAddPointVC* _webAddPointVC;
    CYWebBettingVC *_webBettingVC;
    TFJunYou_SquareViewController *_squareVC;
    TFJunYou_GroupViewController* _groupVC;
//    BrowserViewController* _browserVc;
    TFJunYou_PublishVc* _publishVc;
    NSMutableArray * _friendArray;
}
@property (strong, nonatomic) TFJunYou_MsgViewController* msgVc;
@property (strong, nonatomic) TFJunYou_FriendViewController* friendVC;
 @property (strong, nonatomic) TFJunYou_AddrBookVc* xinfriendVC;

@property (strong, nonatomic) TFJunYou_FriendCirleVc *cirleFriendVc;

@property (strong, nonatomic) TFJunYou_TabMenuView* tb;
@property (nonatomic, strong) UIImageView* bottomView;
@property (strong, nonatomic) UIButton* btn;
@property (strong, nonatomic) UIView* mainView;
@property (assign) BOOL IS_HR_MODE;
@property (strong, nonatomic) TFJunYou_PSMyViewController* psMyviewVC;
@property (nonatomic, assign) BOOL isLoadFriendAndGroup;
@property (nonatomic,assign) int vcnum;
-(void)onAfterLogin;
-(void)doSelected:(int)n;
@end
