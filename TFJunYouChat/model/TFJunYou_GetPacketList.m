//
//  TFJunYou_GetPacketList.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/30.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_GetPacketList.h"

@implementation TFJunYou_GetPacketList

+ (NSArray*)getPackList:(NSDictionary*)dataDict{
    NSArray * array = dataDict[@"data"][@"list"];
    if (array == nil) {
        array = dataDict[@"list"];
    }
    NSMutableArray * packetList = [[NSMutableArray alloc]init];
    
    for (NSDictionary * dict in array) {
        TFJunYou_GetPacketList * packet = [[TFJunYou_GetPacketList alloc]init];
        packet.recodeId = dict[@"id"];
        packet.money = [dict[@"money"] floatValue];
        packet.redId = dict[@"redId"];
        packet.time = [dict[@"time"] longValue];
        packet.userId = dict[@"userId"];
        packet.userName = dict[@"userName"];
        packet.reply = dict[@"reply"];
        [packetList addObject:packet];
//        [packet release];
    }
    return packetList;
}
@end
