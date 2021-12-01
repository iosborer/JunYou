//
//  TFJunYou_ReadListVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/2.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_TableViewController.h"

@class roomData;

@interface TFJunYou_ReadListVC : TFJunYou_TableViewController

@property (nonatomic, strong) TFJunYou_MessageObject *msg;
@property (nonatomic, strong) roomData *room;

@end
