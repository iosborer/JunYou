//
//  TFJunYou_MsgStrCell.h
//  TFJunYouChat
//
//  Created by os on 2021/1/14.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_BaseChatCell.h"
#import "TFJunYou_BaseChatCell.h"
//添加Cell被长按的处理
#import "QBPlasticPopupMenu.h"
#import "FMLinkLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_MsgStrCell : TFJunYou_BaseChatCell

//@property (nonatomic,strong) TFJunYou_Emoji * messageConent;

@property (nonatomic,strong) FMLinkLabel * messageConentMsg;

@property (nonatomic, strong) NSString *contentAswer;
@property (nonatomic, strong) NSArray *msgAnswerArr;

@property (nonatomic, strong) UILabel *timeIndexLabel;
@property (nonatomic, assign) NSInteger timerIndex;
@property (nonatomic, strong) NSTimer *readDelTimer;

@property (nonatomic, assign) BOOL isDidMsgCell;

- (void)deleteMsg:(TFJunYou_MessageObject *)msg;
 
@end

NS_ASSUME_NONNULL_END
