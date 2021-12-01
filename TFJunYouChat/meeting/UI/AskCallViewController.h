//
//  acceptCallViewController.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/7.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
@class TFJunYou_AudioPlayer;

@interface AskCallViewController : TFJunYou_admobViewController{
    BOOL _bAnswer;
    TFJunYou_AudioPlayer* _player;
}
@property (nonatomic, copy) NSString * toUserId;
@property (nonatomic, copy) NSString * toUserName;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *meetUrl;

@end
