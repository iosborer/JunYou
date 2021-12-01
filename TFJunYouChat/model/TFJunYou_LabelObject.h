//
//  TFJunYou_LabelObject.h
//  TFJunYouChat
//
//  Created by p on 2018/6/21.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_LabelObject : NSObject

@property (nonatomic, copy) NSString *tableName;

@property (nonatomic, copy) NSString *userId;// 标签拥有者
@property (nonatomic, copy) NSString *groupId; // 标签Id
@property (nonatomic, copy) NSString *groupName;//标签名字
@property (nonatomic, copy) NSString *userIdList;// 该标签下的用户Id [100,120]

// groupHelperRecord
@property (nonatomic, copy) NSString *userIds;
@property (nonatomic, copy) NSString *text1;
@property (nonatomic, copy) NSString *text2;
@property (nonatomic, copy) NSString *userNames;
@property (nonatomic, copy) NSString *userNamesWithGroup;
@property (nonatomic, assign) BOOL   isGroupMessages;
@property (nonatomic, assign) BOOL   isCYMSGgroupANDFriendy;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, copy) NSString *userNmaesWithFriend;


+(TFJunYou_LabelObject*)sharedInstance;

//数据库增删改查
-(BOOL)insert;
-(BOOL)delete;
-(BOOL)update;

// 获取所有标签
-(NSMutableArray *)fetchAllLabelsFromLocal;

// 获取用户的所有标签
- (NSMutableArray *)fetchLabelsWithUserId:(NSString *)userId;


-(BOOL)insertRecord;
- (BOOL)checkGroupHelperRecordTableCreatedInDb:(FMDatabase *)db;
- (NSMutableArray *)fetchAllRecordsFromLocal;

@end
