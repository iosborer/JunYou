//
//  TFJunYou_CardCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/10.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_BaseChatCell.h"
@class TFJunYou_ChatViewController;
@interface TFJunYou_CardCell : TFJunYou_BaseChatCell

@property (nonatomic,strong) UIImageView * imageBackground;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UIImageView * cardHeadImage;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *title;

@end
