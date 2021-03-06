//
//  TFJunYou_RoomPool.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/021.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_RoomPool.h"
#import "TFJunYou_RoomObject.h"
#import "TFJunYou_UserObject.h"
#import "TFJunYou_GroupViewController.h"

@implementation TFJunYou_RoomPool

-(id)init{
    self = [super init];
    _pool = [[NSMutableDictionary alloc] init];
    [g_notify addObserver:self selector:@selector(onQuitRoom:) name:kQuitRoomNotifaction object:nil];
    return self;
}

-(void)dealloc{
//    NSLog(@"TFJunYou_RoomPool.dealloc");
    [g_notify  removeObserver:self name:kQuitRoomNotifaction object:nil];
    [self deleteAll];
//    [_storage release];
//    [_pool release];
//    [super dealloc];
}

-(TFJunYou_RoomObject*)createRoom:(NSString*)jid title:(NSString*)title{
    if(jid==nil)
        return nil;
    TFJunYou_RoomObject* room = [[TFJunYou_RoomObject alloc] init];
    room.roomJid = jid;
    room.roomTitle = title;
    room.storage   = _storage;
    room.nickName  = MY_USER_ID;
    [room createRoom];
    [_pool setObject:room forKey:room.roomJid];
//    [room release];
    return room;
}

-(TFJunYou_RoomObject*)joinRoom:(NSString*)jid title:(NSString*)title lastDate:(NSDate *)lastDate isNew:(bool)isNew{
    if([_pool objectForKey:jid])
        return [_pool objectForKey:jid];
    if(jid==nil)
        return nil;
    TFJunYou_RoomObject* room = [[TFJunYou_RoomObject alloc] init];
    room.roomJid = jid;
    room.roomTitle = title;
    room.storage   = _storage;
    room.nickName  = MY_USER_ID;
    room.lastDate = lastDate;
    [room joinRoom:isNew];
    [_pool setObject:room forKey:room.roomJid];
//    [room release];
    return room;
}

-(void)setRoomPool:(NSString*)jid title:(NSString*)title{
    if([_pool objectForKey:jid])
        return;
    
    if(jid==nil)
        return;
    
    TFJunYou_RoomObject* room = [[TFJunYou_RoomObject alloc] init];
    room.roomJid = jid;
    room.roomTitle = title;
    room.storage   = _storage;
    room.nickName  = MY_USER_ID;
    room.isConnected = YES;
    [_pool setObject:room forKey:room.roomJid];
}


-(void)connectRoom{
    
    for (int i = 0; i < [[_pool allValues] count]; i++) {
        TFJunYou_RoomObject * obj = [_pool allValues][i];
        if (!obj.isConnected) {
            [obj reconnect];
        }
    }
//    g_App.groupVC.sel = -1;
}

-(void)deleteAll{
    for(NSInteger i=[_pool count]-1;i>=0;i--){
        TFJunYou_RoomObject* p = (TFJunYou_RoomObject*)[_pool.allValues objectAtIndex:i];
        [p leave];
        p = nil;
    }
    [_pool removeAllObjects];
}

-(void)createAll{
    
#if IS_AUTO_JOIN_ROOM
#else
    NSMutableArray* array = [[TFJunYou_UserObject sharedInstance] fetchAllRoomsFromLocal];
    
    for(int i=0;i<[array count];i++){
        TFJunYou_UserObject *room = [array objectAtIndex:i];
        if ([room.groupStatus intValue] == 0) {
            [self joinRoom:room.userId title:room.userNickname lastDate:nil isNew:NO];
        }
    }
    
#endif
}

-(void)reconnectAll{
    for(int i=0;i<[_pool count];i++){
        TFJunYou_RoomObject* p = (TFJunYou_RoomObject*)[_pool.allValues objectAtIndex:i];
        [p reconnect];
        p = nil;
    }
}

-(void)onQuitRoom:(NSNotification *)notifacation//退出房间
{
    TFJunYou_RoomObject* p     = (TFJunYou_RoomObject *)notifacation.object;
    for(NSInteger i=[_pool count]-1;i>=0;i--){
        if(p == [_pool.allValues objectAtIndex:i]){
            [_pool removeObjectForKey:p.roomJid];
            break;
        }
    }
    p = nil;
}

-(void)delRoom:(NSString*)jid{
    if([_pool objectForKey:jid]){
        TFJunYou_RoomObject* p = [_pool objectForKey:jid];
        [p leave];
        [_pool removeObjectForKey:jid];
        p = nil;
    }
}

-(TFJunYou_RoomObject*)getRoom:(NSString*)jid{
    return [_pool objectForKey:jid];
}

@end
