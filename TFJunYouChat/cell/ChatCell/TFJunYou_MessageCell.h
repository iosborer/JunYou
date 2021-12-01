//
//  TFJunYou_MessageCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/10.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_BaseChatCell.h"
//添加Cell被长按的处理
#import "QBPlasticPopupMenu.h"

@interface TFJunYou_MessageCell : TFJunYou_BaseChatCell{
    
}
@property (nonatomic,strong) TFJunYou_Emoji * messageConent;
@property (nonatomic, strong) UILabel *timeIndexLabel;
@property (nonatomic, assign) NSInteger timerIndex;
@property (nonatomic, strong) NSTimer *readDelTimer;

@property (nonatomic, assign) BOOL isDidMsgCell;

- (void)deleteMsg:(TFJunYou_MessageObject *)msg;

@end
