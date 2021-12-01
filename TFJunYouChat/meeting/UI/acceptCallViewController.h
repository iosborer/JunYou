//
//  acceptCallViewController.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/7.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

#define UpdateAcceptCallMsg @"UpdateAcceptCallMsg"

@class TFJunYou_AudioPlayer;

@interface acceptCallViewController : TFJunYou_admobViewController{
    UIButton* _buttonHangup;
    UIButton* _buttonAccept;
    TFJunYou_AudioPlayer* _player;
}
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, assign) BOOL isTalk;
@property (nonatomic, copy) NSString * toUserId;
@property (nonatomic, copy) NSString * toUserName;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString * roomNum;
@property (nonatomic, weak) NSObject* delegate;
@property (nonatomic, assign) SEL		didTouch;
@property (nonatomic, assign) SEL   changeAudio;
@property (nonatomic, assign) SEL   changeVideo;

@end
