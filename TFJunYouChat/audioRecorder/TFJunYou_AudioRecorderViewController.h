//
//  TFJunYou_AudioRecorderViewController.h
//  TFJunYouChat
//
//  Created by Apple on 17/1/3.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceConverter.h"
#import "ChatCacheFileUtil.h"


@interface TFJunYou_AudioRecorderViewController : TFJunYou_admobViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    BOOL _isRecording;
//    NSTimer *_peakTimer;
    
    AVAudioRecorder *_audioRecorder;
    NSURL *_pathURL;
    NSString* _lastRecordFile;
}

@property (nonatomic,weak) id delegate;
@property(nonatomic,assign) int maxTime;
@property(nonatomic,assign) int minTime;

@end

@protocol TFJunYou_AudioRecorderDelegate <NSObject>

- (void)TFJunYou_audioRecorderDidFinish:(NSString *)filePath TimeLen:(int)timenlen;

@end
