//
//  TFJunYou_RPacketListCell.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/31.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_RPacketListCell.h"

@implementation TFJunYou_RPacketListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headerImage.layer.cornerRadius = 24.5;
    _headerImage.clipsToBounds = YES;
    _buttomLine.frame = CGRectMake(_buttomLine.frame.origin.x, _buttomLine.frame.origin.y, TFJunYou__SCREEN_WIDTH, LINE_WH);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
//    [_headerImage release];
//    [_nameLabel release];
//    [_timeLabel release];
//    [_moneyLabel release];
//    [_buttomLine release];
//    [super dealloc];
}
@end
