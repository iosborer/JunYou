//
//  TFJunYou_SearchFileLogCell.h
//  TFJunYouChat
//
//  Created by p on 2019/4/8.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_SearchFileLogVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_SearchFileLogCell : UITableViewCell

@property (nonatomic, strong) TFJunYou_MessageObject *msg;

@property (nonatomic, assign) FileLogType type;

@end

NS_ASSUME_NONNULL_END
