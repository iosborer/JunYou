//
//  TFJunYou_ImageCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/10.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_BaseChatCell.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface TFJunYou_ImageCell : TFJunYou_BaseChatCell
@property (nonatomic,strong) FLAnimatedImageView * chatImage;//cell里的UIView

@property (nonatomic,assign) int currentIndex;//当前选中图片的序号
@property (nonatomic,assign,getter=getImageWidth) int imageWidth;
@property (nonatomic,assign,getter=getImageHeight) int imageHeight;

@property (nonatomic, assign) BOOL isRemove;

@property (nonatomic, strong) UILabel *imageProgress;


- (void)deleteReadMsg;

- (void)timeGo:(TFJunYou_MessageObject *)msg;

@end
