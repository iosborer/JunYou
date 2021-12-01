//
//  TFJunYou_SettingVc.h
//  P-Note
//
//  Created by yaxiongfang on 4/9/16.
//  Copyright © 2016 yxfang. All rights reserved.
//

#import "TFJunYouChat_BaseNoteVc.h"

NS_ASSUME_NONNULL_BEGIN
@interface TFJunYouChat_SettingVc : TFJunYouChat_BaseNoteVc <UITableViewDelegate, UITableViewDataSource>
@property(weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end

NS_ASSUME_NONNULL_END
