//
//  TFJunYou_AutoReplyAideVC.h
//  TFJunYouChat
//
//  Created by p on 2019/5/14.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
#import "TFJunYou_GroupHeplerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_AutoReplyAideVC : TFJunYou_admobViewController

@property (nonatomic, strong) TFJunYou_HelperModel *model;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *roomJid;


@end

NS_ASSUME_NONNULL_END
