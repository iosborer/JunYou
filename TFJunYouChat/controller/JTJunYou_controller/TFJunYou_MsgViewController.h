//
//  TFJunYou_MsgViewController.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import "TFJunYou_AudioPlayer.h"
#import <UIKit/UIKit.h>

@interface TFJunYou_MsgViewController : TFJunYou_TableViewController <UIScrollViewDelegate>{
//    NSMutableArray *_array;
    int _refreshCount;
    int _recordCount;
    float lastContentOffset;
    int upOrDown;
    TFJunYou_AudioPlayer* _audioPlayer;
}
@property(nonatomic,assign) int msgTotal;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic,copy)NSArray *customerArr; //客服信息

- (void)cancelBtnAction;
- (void)getTotalNewMsgCount;

@end
