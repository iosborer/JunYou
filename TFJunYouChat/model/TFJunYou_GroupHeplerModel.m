//
//  TFJunYou_GroupHeplerModel.m
//  TFJunYouChat
//
//  Created by 1 on 2019/5/29.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_GroupHeplerModel.h"

@implementation TFJunYou_GroupHeplerModel

- (void)getDataWithDict:(NSDictionary *)dict {
    self.helperModel = [TFJunYou_HelperModel initWithDict:[dict objectForKey:@"helper"]];
    self.helperId = [dict objectForKey:@"helperId"];
    self.groupHelperId = [dict objectForKey:@"id"];
    self.roomId = [dict objectForKey:@"roomId"];
    self.roomJid = [dict objectForKey:@"roomJid"];
    self.userId = [dict objectForKey:@"userId"];
    if ([dict objectForKey:@"keywords"]) {
        self.keywords = [dict objectForKey:@"keywords"];
    }
}

@end
