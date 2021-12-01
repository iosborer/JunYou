//
//  TFJunYou_PacketObject.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/30.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_PacketObject : NSObject

@property (nonatomic,assign) long count;
@property (nonatomic,strong) NSString * greetings;
@property (nonatomic,strong) NSString * packetId;
@property (nonatomic,assign) float money;
@property (nonatomic,assign) long outTime;
@property (nonatomic,assign) float over;
@property (nonatomic,assign) long receiveCount;
@property (nonatomic,assign) long sendTime;
@property (nonatomic,assign) long status;
@property (nonatomic,assign) long type;
@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSArray * userIds;
@property (nonatomic,strong) NSString * userName;

+ (TFJunYou_PacketObject*)getPacketObject:(NSDictionary *)dataDict;
@end
