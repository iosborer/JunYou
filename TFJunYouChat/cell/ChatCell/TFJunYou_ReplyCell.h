//
//  TFJunYou_ReplyCell.h
//  TFJunYouChat
//
//  Created by 1 on 2019/3/30.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFJunYou_BaseChatCell.h"
//添加Cell被长按的处理
#import "QBPlasticPopupMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_ReplyCell : TFJunYou_BaseChatCell

@property (nonatomic,strong) TFJunYou_Emoji * messageConent;
@property (nonatomic,strong) TFJunYou_Emoji * replyConent;
@property (nonatomic, strong) UILabel *timeIndexLabel;
@property (nonatomic, assign) NSInteger timerIndex;
@property (nonatomic, strong) NSTimer *readDelTimer;

@property (nonatomic, assign) BOOL isDidMsgCell;

- (void)deleteMsg:(TFJunYou_MessageObject *)msg;

@end

NS_ASSUME_NONNULL_END
