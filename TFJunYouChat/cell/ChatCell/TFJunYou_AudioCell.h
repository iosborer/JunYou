//
//  TFJunYou_AudioCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/10.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_BaseChatCell.h"
#import <AVFoundation/AVFoundation.h>
@class TFJunYou_ChatViewController;

@interface TFJunYou_AudioCell : TFJunYou_BaseChatCell{
//    TFJunYou_AudioPlayer* _audioPlayer;
}

@property (nonatomic,strong) UILabel * timeLen;
@property (nonatomic,strong) UIImageView * voice;
@property (nonatomic,strong) NSArray * array;
@property (nonatomic,strong) TFJunYou_AudioPlayer* audioPlayer;
@property (nonatomic,copy)   NSString *oldFileName;

- (void)timeGo:(NSString *)fileName;
@end
