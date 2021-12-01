//
//  TFJunYou_MediaCell.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_VideoPlayer.h"

@class TFJunYou_MediaObject;

@interface TFJunYou_MediaCell : UITableViewCell{
    UIImageView* bageImage;
    UILabel* bageNumber;
    TFJunYou_VideoPlayer* _player;
}
@property (nonatomic,strong) UIButton* pauseBtn;
@property (nonatomic,strong) UIImageView* head;
@property (nonatomic,strong) NSString*  bage;
@property (nonatomic,strong) TFJunYou_MediaObject* media;
@property (nonatomic,weak) id delegate;
@end
