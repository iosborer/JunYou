//
//  recordAudioVC.h
//  TFJunYouChat
//
//  Created by flyeagleTang on 14-6-24.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
#import "TFJunYou_AudioPlayer.h"
@class MixerHostAudio;
@class mediaOutput;

@interface recordAudioVC : UIViewController{
    MixerHostAudio* _mixRecorder;
    mediaOutput* outputer;
    IBOutlet UISegmentedControl* mFxType;

    BOOL _startOutput;
   
    TFJunYou_ImageView* _input;
    TFJunYou_ImageView* _volume;
    TFJunYou_ImageView* _btnPlay;
    TFJunYou_ImageView* _btnRecord;
    TFJunYou_ImageView* _btnBack;
    TFJunYou_ImageView* _btnDel;
    TFJunYou_ImageView* _btnEnter;
    TFJunYou_ImageView* _iv;
    UIScrollView* _effectType;
    UILabel* _lb;
    NSTimer* _timer;
    TFJunYou_AudioPlayer* _player;
    recordAudioVC* _pSelf;
}
@property(nonatomic,assign) int timeLen;
@property(nonatomic,weak) id delegate;
@property(assign) SEL didRecord;
@property (nonatomic, strong) NSString* outputFileName;

@end
