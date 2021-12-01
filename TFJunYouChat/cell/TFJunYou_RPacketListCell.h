//
//  TFJunYou_RPacketListCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/31.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFJunYou_RPacketListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UIView *buttomLine;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageWidthCon;
@property (strong, nonatomic) IBOutlet UIImageView *kingImgV;
@property (strong, nonatomic) IBOutlet UILabel *bestLab;

@property (nonatomic, strong) UIView *line;

@end
