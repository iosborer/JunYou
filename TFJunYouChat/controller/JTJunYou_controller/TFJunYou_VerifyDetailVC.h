//
//  TFJunYou_VerifyDetailVC.h
//  TFJunYouChat
//
//  Created by p on 2018/5/29.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
#import "TFJunYou_ChatViewController.h"


@interface TFJunYou_VerifyDetailVC : TFJunYou_admobViewController
@property (nonatomic, strong) TFJunYou_MessageObject *msg;
@property (nonatomic,strong) roomData * room;
@property (nonatomic, weak) TFJunYou_ChatViewController *chatVC;

@end
