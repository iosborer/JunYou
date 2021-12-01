//
//  TFJunYou_BlogRemind.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/7/3.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_BlogRemind : NSObject{
    NSString* _tableName;
}

@property (nonatomic,strong) NSString* fromUserId;
@property (nonatomic,strong) NSString* fromUserName;
@property (nonatomic,strong) NSString* messageId;
@property (nonatomic,strong) NSString* objectId;
@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSString* toUserId;
@property (nonatomic,strong) NSString* toUserName;
@property (nonatomic,strong) NSString* content;
@property (nonatomic,assign) int type;
@property (nonatomic, assign) int msgType;
@property (nonatomic,strong) NSDate*   timeSend;
@property (nonatomic, assign) BOOL isRead;

//数据库增删改查
-(BOOL)insertObj;
-(BOOL)deleteAllMsg;
-(BOOL)updateObj;
// 查询所有消息
-(NSMutableArray *)doFetch;
// 查询未读消息
-(NSMutableArray *)doFetchUnread;
// 将未读消息设置为已读
- (BOOL)updateUnread;
// 将某条消息设置为已读/未读
- (BOOL)updateOneMsgUnreadWithType:(int)type;

+(TFJunYou_BlogRemind*)sharedInstance;


-(void)fromObject:(TFJunYou_MessageObject*)message;

-(void)fromDataset:(TFJunYou_BlogRemind*)obj rs:(FMResultSet*)rs;
@end
