//
//  TFJunYou_LocationCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/10.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_BaseChatCell.h"
@interface TFJunYou_LocationCell : TFJunYou_BaseChatCell
@property (nonatomic,strong) UIImageView * imageBackground;
@property (nonatomic,strong) UIImageView * mapImageView;
//@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * addressLabel;
@end
