//
//  FeedBackVC.h
//  WonBey
//
//  Created by JayLuo on 2019/4/11.
//  Copyright © 2020 Hunan Liaocheng Technology Co., Ltd.All rights reserved.
//

#import "TFJunYou_admobViewController.h"

typedef NS_ENUM(NSUInteger, FeedBackType) {
    FeedBackTypeComplaints, // 投诉
    FeedBackTypeSuggestion, // 意见反馈
};
@interface FeedBackVC : TFJunYou_admobViewController
@property(nonatomic, assign) FeedBackType type;
@end
