//
//  TFJunYou_SetChatBackgroundVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/12/8.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

@class TFJunYou_SetChatBackgroundVC;
@protocol TFJunYou_SetChatBackgroundVCDelegate <NSObject>

- (void)setChatBackgroundVC:(TFJunYou_SetChatBackgroundVC *)setChatBgVC image:(UIImage *)image;

@end

@interface TFJunYou_SetChatBackgroundVC : TFJunYou_admobViewController

@property (nonatomic, weak) id<TFJunYou_SetChatBackgroundVCDelegate>delegate;
@property (nonatomic, copy) NSString *userId;

@end
