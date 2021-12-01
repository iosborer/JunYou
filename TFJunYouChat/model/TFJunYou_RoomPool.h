//
//  TFJunYou_RoomPool.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/021.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFJunYou_RoomObject;
@class XMPPRoomCoreDataStorage;

@interface TFJunYou_RoomPool : NSObject{
//    NSMutableDictionary* _pool;
    XMPPRoomCoreDataStorage* _storage;
}
@property (nonatomic,strong) NSMutableDictionary* pool;

-(TFJunYou_RoomObject*)createRoom:(NSString*)jid title:(NSString*)title;
-(TFJunYou_RoomObject*)joinRoom:(NSString*)jid title:(NSString*)title lastDate:(NSDate *)lastDate isNew:(bool)isNew;

-(void)setRoomPool:(NSString*)jid title:(NSString*)title;
//-(TFJunYou_RoomObject*)connectRoom:(NSString*)jid title:(NSString*)title;

-(void)deleteAll;
-(void)createAll;
-(void)reconnectAll;
-(void)delRoom:(NSString*)jid;
-(TFJunYou_RoomObject*)getRoom:(NSString*)jid;


-(void)connectRoom;
@end
