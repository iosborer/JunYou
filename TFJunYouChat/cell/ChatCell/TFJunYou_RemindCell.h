//
//  TFJunYou_RemindCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/11.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_BaseChatCell.h"
@interface TFJunYou_RemindCell : TFJunYou_BaseChatCell
@property (nonatomic,strong) UILabel* messageRemind;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *baseView;

@end
