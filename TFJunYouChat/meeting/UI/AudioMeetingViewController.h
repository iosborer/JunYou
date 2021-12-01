//
//  AudioMeetingViewController.h
//  TFJunYouChat
//
//  Created by 1 on 17/3/28.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

typedef NS_OPTIONS(NSInteger, AudioMeetingType) {
    AudioMeetingTypeGroupCall   = 1 << 0,
    AudioMeetingTypeNumberByUserSelf = 1 << 1,
};
@interface AudioMeetingViewController : TFJunYou_admobViewController

@property (nonatomic, copy) NSString * call;
@property (nonatomic, assign) AudioMeetingType type;

@end
