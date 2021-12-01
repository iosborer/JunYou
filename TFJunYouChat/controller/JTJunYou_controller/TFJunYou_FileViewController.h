//
//  TFJunYou_FileViewController.h
//  TFJunYouChat
//
//  Created by 1 on 17/7/4.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"


typedef NS_OPTIONS(NSInteger, JSFileVCType) {
   JSFileVCTypeGroup    = 1 << 0,
};


@interface TFJunYou_FileViewController : TFJunYou_TableViewController
@property (nonatomic,strong) roomData * room;

@end
