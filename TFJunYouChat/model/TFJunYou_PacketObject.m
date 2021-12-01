//
//  TFJunYou_PacketObject.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/30.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_PacketObject.h"

@implementation TFJunYou_PacketObject

+ (TFJunYou_PacketObject*)getPacketObject:(NSDictionary *)dataDict{
    NSDictionary * dictPocket = dataDict[@"data"][@"packet"];
    if (dictPocket == nil) {
        dictPocket = dataDict[@"packet"];
    }
    if (dictPocket) {
        TFJunYou_PacketObject * obj = [[TFJunYou_PacketObject alloc]init];
        obj.count = [dictPocket[@"count"] longValue];
        obj.greetings = dictPocket[@"greetings"];
        obj.packetId = dictPocket[@"id"];
        obj.money = [dictPocket[@"money"] floatValue];
        obj.outTime = [dictPocket[@"outTime"] longValue];
        obj.over = [dictPocket[@"over"] floatValue];
        obj.receiveCount = [dictPocket[@"receiveCount"] longValue];
        obj.sendTime = [dictPocket[@"sendTime"] longValue];
        obj.status = [dictPocket[@"status"] longValue];
        obj.type = [dictPocket[@"type"] longValue];
        obj.userId = dictPocket[@"userId"];
        obj.userIds = dictPocket[@"userIds"];
        obj.userName = dictPocket[@"userName"];
        return obj;
    }
    return nil;
}
@end
