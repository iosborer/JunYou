//
//  TFJunYou_FaceCustomCell.h
//  TFJunYouChat
//
//  Created by JayLuo on 2019/12/13.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFJunYou_BaseChatCell.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_EmojiCell : TFJunYou_BaseChatCell
@property (nonatomic,strong) FLAnimatedImageView * chatImage;//cell里的UIView

@property (nonatomic,assign) int currentIndex;//当前选中图片的序号
@property (nonatomic,assign,getter=getImageWidth) int imageWidth;
@property (nonatomic,assign,getter=getImageHeight) int imageHeight;

@property (nonatomic, assign) BOOL isRemove;

@property (nonatomic, strong) UILabel *imageProgress;


- (void)deleteReadMsg;

- (void)timeGo:(TFJunYou_MessageObject *)msg;

@end

NS_ASSUME_NONNULL_END
