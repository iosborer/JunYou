//
//  TFJunYou_RoomObject.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/021.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMPPRoomCoreDataStorage;
@class memberData;


@protocol TFJunYou_RoomObjectDelegate <NSObject>


- (void)xmppRoomDidJoin;
- (void)xmppRoomDidLeave;
- (void)xmppRoomDidDestroy;
-(void)xmppRoomDidCreate;

@end

@interface TFJunYou_RoomObject : NSObject{
    BOOL _isNew;
}

@property(nonatomic, strong) NSString *roomId;                     //房间名称
@property(nonatomic, strong) NSString *roomJid;                    //房间名称
@property(nonatomic, strong) NSString *roomName;                   //房间名称
@property(nonatomic, strong) NSString *roomTitle;                  //房间主题
@property(nonatomic, strong) NSString *nickName;                   //房间主题
@property(nonatomic, strong) NSString *fullJid;
@property(nonatomic, assign) XMPPRoomCoreDataStorage* storage;
@property(nonatomic, assign) BOOL isConnected;
@property (nonatomic, weak) id<TFJunYou_RoomObjectDelegate> delegate;

@property (nonatomic, strong) NSDate *lastDate;

-(void)joinRoom:(bool)isNew;//成员加入群组,isNew=Yes，则不请求历史聊天记录
-(void)createRoom;//群主创建一个群组
-(void)reconnect;
-(void)leave;
-(void)removeUser:(memberData*)userId;

// 群组请求结果
- (void)roomRequestResultWithStatus:(int)status isExit:(BOOL)isExit;
@end
