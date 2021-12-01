//
//  TFJunYou_UserInfoVC.h
//  TFJunYouChat
//
//  Created by flyeagleTang on 14-6-10.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
#import "TFJunYou__SelectMenuView.h"
#import "TFJunYou_GoogleMapVC.h"
#import "TFJunYou_ChatViewController.h"

@class DMScaleTransition;

@interface TFJunYou_UserInfoVC : TFJunYou_admobViewController<LXActionSheetDelegate>{
    UILabel* _name;
    UILabel* _remarkName;
    UILabel* _describe;
    UILabel* _workexp;
    UILabel* _city;
    UILabel* _dip;
    UILabel* _date;
    UILabel* _tel;
    UILabel* _lastTime;
    UILabel* _showNum;
    UILabel* _account;
    UILabel* _label;
    UIImageView* _sex;
    TFJunYou_Label *_labelLab;
    UILabel* _desLab;

    UISwitch *_messageFreeSwitch;
    UIView *_baseView;
    
    TFJunYou_ImageView *_describeImgV;
    TFJunYou_ImageView *_lifeImgV;
    TFJunYou_ImageView *_birthdayImgV;
    TFJunYou_ImageView *_lastTImgV;
    TFJunYou_ImageView *_showNImgV;
    TFJunYou_ImageView *_circleImgV;
    TFJunYou_ImageView *_desImgV;

    double _latitude;
    double _longitude;
    
    TFJunYou_ImageView* _head;
//    TFJunYou_ImageView* _body;

    int _friendStatus;
    NSString*   _xmppMsgId;
    UIButton* _btn;
    BOOL _deleleMode;
    NSMutableArray * _titleArr;
    DMScaleTransition *_scaleTransition;
    TFJunYou_GoogleMapVC *_gooMap;
}

@property (nonatomic,strong) TFJunYou_UserObject* user;
@property (nonatomic,strong) UIView * bgBlackAlpha;
@property (nonatomic,strong) TFJunYou__SelectMenuView * selectView;
@property (nonatomic, assign) BOOL isJustShow;
@property (nonatomic, assign) BOOL isShowGoinBtn;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) int fromAddType;

@property (nonatomic, weak) TFJunYou_ChatViewController *chatVC;


@end
