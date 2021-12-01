//
//  TFJunYou_ReplyAideKeyManageVC.h
//  TFJunYouChat
//
//  Created by p on 2019/5/15.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class TFJunYou_HelperModel;

@interface TFJunYou_ReplyAideKeyManageVC : TFJunYou_admobViewController

@property (nonatomic, strong) NSMutableArray *keys;

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *helperId;
@property (nonatomic, strong) TFJunYou_HelperModel *model;

@end

NS_ASSUME_NONNULL_END
