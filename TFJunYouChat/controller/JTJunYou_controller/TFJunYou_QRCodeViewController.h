//
//  TFJunYou_QRCodeViewController.h
//  TFJunYouChat
//
//  Created by 1 on 17/9/14.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

typedef NS_OPTIONS(NSUInteger, QRViewControllerType) {
    QRUserType  =   1,
    QRGroupType =   2,
};

@interface TFJunYou_QRCodeViewController : TFJunYou_admobViewController

@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * account;
@property (nonatomic, assign) QRViewControllerType type;

@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * roomJId;
@property (nonatomic, strong) NSNumber * sex;

@end
