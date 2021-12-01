//
//  TFJunYou_ShareFileObject.m
//  TFJunYouChat
//
//  Created by 1 on 17/7/6.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_ShareFileObject.h"

@implementation TFJunYou_ShareFileObject


+(TFJunYou_ShareFileObject *)shareFileWithDict:(NSDictionary *)dict{
    TFJunYou_ShareFileObject * shareFile = [[TFJunYou_ShareFileObject alloc] init];
    [shareFile getDataFromDict:dict];
    return shareFile;
}
-(void)getDataFromDict:(NSDictionary *)dict{
    if(dict[@"nickname"])
        self.createUserName = dict[@"nickname"];
    if(dict[@"roomId"])
        self.roomId = dict[@"roomId"];
    if(dict[@"shareId"])
        self.shareId = dict[@"shareId"];
    if(dict[@"size"])
        self.size = dict[@"size"];
    if(dict[@"time"])
        self.time = dict[@"time"];
    if(dict[@"type"])
        self.type = dict[@"type"];
    if(dict[@"url"])
        self.url = dict[@"url"];
    if(dict[@"userId"])
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
    if(dict[@"name"])
        self.fileName = dict[@"name"];
//    self.fileName = [self.url substringFromIndex:self.url.length-10];
    
}

@end
