//
//  TFJunYou_SetLabelVC.h
//  TFJunYouChat
//
//  Created by p on 2018/6/26.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

@interface TFJunYou_SetLabelVC : TFJunYou_admobViewController
@property (nonatomic, strong) TFJunYou_UserObject *user;

@property (nonatomic, strong) NSMutableArray *array;    // 已选择标签
@property (nonatomic, strong) NSMutableArray *allArray; // 所有标签

@property(nonatomic,weak) id delegate;
@property(assign) SEL didSelect;

@end
