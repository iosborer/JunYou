//
//  TFJunYou_VideoCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/10.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_BaseChatCell.h"
@class TFJunYou_VideoPlayer;

@protocol TFJunYou_VideoCellDelegate <NSObject>

- (void)showVideoPlayerWithTag:(NSInteger)tag;

@end


@interface TFJunYou_VideoCell : TFJunYou_BaseChatCell{
}
@property (nonatomic,strong) TFJunYou_ImageView * chatImage;
@property (nonatomic, strong) UIButton *pauseBtn;
//@property (nonatomic,assign) UIImage * videoImage;
@property (nonatomic,copy)   NSString *oldFileName;
@property (nonatomic, strong) TFJunYou_VideoPlayer *player;
@property (nonatomic, assign) NSInteger indexTag;
@property (nonatomic, assign) BOOL isEndVideo;
@property (nonatomic, strong) UILabel *videoProgress;

@property (nonatomic, assign) id<TFJunYou_VideoCellDelegate>videoDelegate;

- (void)timeGo:(NSString *)fileName;

// 看完视频后调用的方法
- (void)deleteMsg;


@end
