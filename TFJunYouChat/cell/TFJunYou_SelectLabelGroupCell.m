//
//  TFJunYou_SelectLabelGroupCell.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/29.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import "TFJunYou_SelectLabelGroupCell.h"

@implementation TFJunYou_SelectLabelGroupCell
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.textLabel.frame;
    self.textLabel.frame = CGRectMake(60, rect.origin.y, rect.size.width, rect.size.height);
    CGRect detail = self.detailTextLabel.frame;
    self.detailTextLabel.frame = CGRectMake(60, detail.origin.y, detail.size.width, detail.size.height);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
