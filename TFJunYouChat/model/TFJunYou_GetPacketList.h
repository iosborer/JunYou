//
//  TFJunYou_GetPacketList.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/30.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_GetPacketList : NSObject
@property (nonatomic,strong) NSString * recodeId;//记录id
@property (nonatomic,assign) float money;
@property (nonatomic,strong) NSString * redId;
@property (nonatomic,assign) long time;
@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString * userName;
@property (nonatomic, strong) NSString *reply; // 回复内容

+ (NSArray*)getPackList:(NSDictionary*)dataDict;
@end
