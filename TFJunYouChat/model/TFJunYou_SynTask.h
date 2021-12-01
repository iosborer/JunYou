//
//  TFJunYou_SynchronizationTask.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/18.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_SynTask : NSObject

@property (nonatomic, copy) NSString *tableName;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSDate *lastTime;
@property (nonatomic, copy) NSString *startMsgId;
@property (nonatomic, copy) NSString *endMsgId;
@property (nonatomic,strong) NSNumber *isLoading;
@property (nonatomic, strong) NSNumber *isFinish;

+(TFJunYou_SynTask *)sharedInstance;

//数据库增删改查
-(BOOL)insert;
-(BOOL)delete;
// 删除一个群的所有任务
- (BOOL)deleteTaskWithRoomId:(NSString *)roomId;
-(BOOL)update;

// 获取单个群的任务列表
- (NSMutableArray *)getTaskWithUserId:(NSString *)userId;

// 更新起始时间
- (BOOL)updateStartTime;

// 更新结束时间
- (BOOL)updateEndTime;

@end
