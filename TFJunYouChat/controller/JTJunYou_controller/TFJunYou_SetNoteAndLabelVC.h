//
//  TFJunYou_SetNoteAndLabelVC.h
//  TFJunYouChat
//
//  Created by 1 on 2019/5/7.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_SetNoteAndLabelVC : TFJunYou_admobViewController
@property (nonatomic, strong) TFJunYou_UserObject *user;

@property(nonatomic,weak) id delegate;
@property(assign) SEL didSelect;

@end

NS_ASSUME_NONNULL_END
