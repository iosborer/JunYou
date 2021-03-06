//
//  TFJunYou_AnnounceCell.h
//  TFJunYouChat
//
//  Created by 1 on 2018/8/17.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFJunYou_AnnounceCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *content;



- (void)setCellHeightWithText:(NSString *)text;

@end
