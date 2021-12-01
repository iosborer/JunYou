//
//  TFJunYou_TalkViewController.h
//  TFJunYouChat
//
//  Created by p on 2019/6/18.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFJunYou_TalkViewControllerDelegate <NSObject>

- (void)talkVCCloseBtnAction;
- (void)talkVCTalkStart;
- (void)talkVCTalkStop;

@end

@interface TFJunYou_TalkViewController : TFJunYou_admobViewController

@property (nonatomic, weak) id<TFJunYou_TalkViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *roomNum;

@end

NS_ASSUME_NONNULL_END
