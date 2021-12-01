//
//  TFJunYou_AVCallViewController.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/12/26.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JitsiMeet/JitsiMeet.h>

@interface TFJunYou_AVCallViewController : UIViewController<JitsiMeetViewDelegate>

@property (nonatomic, strong) TFJunYou_AVCallViewController *pSelf;
@property (nonatomic, copy) NSString *roomNum;
@property (nonatomic, assign) BOOL isAudio;
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, assign) BOOL isTalk;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *toUserName;
@property (nonatomic, copy) NSString *meetUrl;

@end
