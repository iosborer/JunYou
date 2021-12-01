//
//  TFJunYou_LabelObject.m
//  TFJunYouChat
//
//  Created by p on 2018/6/21.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_LabelObject.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation TFJunYou_LabelObject


static TFJunYou_LabelObject *sharedLabel;

+(TFJunYou_LabelObject*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLabel=[[TFJunYou_LabelObject alloc]init];
    });
    return sharedLabel;
}

-(id)init{
    self = [super init];
    if(self){
        _tableName = @"label";
    }
    return self;
}

// 获取所有标签
-(NSMutableArray*)fetchAllLabelsFromLocal {
    NSString* sql = @"select * from label";
    
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    [self checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        TFJunYou_LabelObject *label=[[TFJunYou_LabelObject alloc] init];
        [self labelFromDataset:label rs:rs];
        [resultArr addObject:label];
    }
    [rs close];

    return resultArr;
}

- (NSMutableArray *)fetchAllRecordsFromLocal {
    NSString* sql = @"select * from groupHelperRecord order by id desc";
    
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    [self checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        TFJunYou_LabelObject *label=[[TFJunYou_LabelObject alloc] init];
        [self recordsFromDataset:label rs:rs];
        [resultArr addObject:label];
    }
    [rs close];
    
    return resultArr;
}


- (BOOL)checkGroupHelperRecordTableCreatedInDb:(FMDatabase *)db {
    
    NSString *createStr=[NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS 'groupHelperRecord' ('id' INTEGER PRIMARY KEY, 'userId' VARCHAR, 'userIds' VARCHAR, 'text1' VARCHAR,'text2' VARCHAR,'userNames' VARCHAR, 'userNamesWithGroup' VARCHAR, 'message' VARCHAR, 'sendTime' varchar, 'userNmaesWithFriend' varchar)"];
    
    BOOL worked = [db executeUpdate:createStr];
    return worked;
    
}

-(BOOL)insertRecord {
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    [self checkGroupHelperRecordTableCreatedInDb:db];
    
     NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO 'groupHelperRecord' ('userId','userIds','text1','text2','userNames','userNamesWithGroup','message','sendTime','userNmaesWithFriend') VALUES (?,?,?,?,?,?,?,?,?)"];
    BOOL worked = [db executeUpdate:insertStr,self.userId,self.userIds,self.text1,self.text2,self.userNames,self.userNamesWithGroup,self.message,self.sendTime,self.userNmaesWithFriend];
    
    return worked;
}



-(BOOL)checkTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr=[NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS '%@' ('groupId' VARCHAR PRIMARY KEY  NOT NULL  UNIQUE , 'userId' VARCHAR, 'groupName' VARCHAR, 'userIdList' VARCHAR)",_tableName];
    
    BOOL worked = [db executeUpdate:createStr];
    return worked;
}

-(void)labelFromDataset:(TFJunYou_LabelObject*)obj rs:(FMResultSet*)rs{
    obj.userId=[rs stringForColumn:@"userId"];
    obj.groupId=[rs stringForColumn:@"groupId"];
    obj.groupName=[rs stringForColumn:@"groupName"];
    obj.userIdList=[rs stringForColumn:@"userIdList"];
    
}


-(void)recordsFromDataset:(TFJunYou_LabelObject*)obj rs:(FMResultSet*)rs{
    obj.userId=[rs stringForColumn:@"userId"];
    obj.userIds=[rs stringForColumn:@"userIds"];
    obj.text1=[rs stringForColumn:@"text1"];
    obj.text2=[rs stringForColumn:@"text2"];
    
    obj.userNames=[rs stringForColumn:@"userNames"];
    obj.userNamesWithGroup=[rs stringForColumn:@"userNamesWithGroup"];
    obj.message=[rs stringForColumn:@"message"];
    obj.sendTime=[rs stringForColumn:@"sendTime"];
    obj.userNmaesWithFriend=[rs stringForColumn:@"userNmaesWithFriend"];
}

//数据库增删改查
-(BOOL)insert {
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    [self checkTableCreatedInDb:db];

    NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO '%@' ('groupId','userId','groupName','userIdList') VALUES (?,?,?,?)",_tableName];
    
    BOOL worked = [db executeUpdate:insertStr,self.groupId,self.userId,self.groupName,self.userIdList];
    
    if(!worked)
        worked = [self update];
    return worked;
}

-(BOOL)delete {
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    [self checkTableCreatedInDb:db];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where groupId=?",_tableName];
    BOOL worked=[db executeUpdate:sql,self.groupId];
    return worked;
}

-(BOOL)update {
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    [self checkTableCreatedInDb:db];
    
    NSString* sql = [NSString stringWithFormat:@"update %@ set userId=?,groupName=?,userIdList=? where groupId=?",_tableName];
    BOOL worked = [db executeUpdate:sql,self.userId,self.groupName,self.userIdList,self.groupId];
    return worked;
}

// 获取用户的所有标签
- (NSMutableArray *)fetchLabelsWithUserId:(NSString *)userId {
    NSString* sql = [NSString stringWithFormat:@"select * from label where userIdList like '%%%@%%'", userId];
    
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    NSString* myUserId = MY_USER_ID;
    FMDatabase* db = [[TFJunYou_XMPP sharedInstance] openUserDb:myUserId];
    [self checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        TFJunYou_LabelObject *label=[[TFJunYou_LabelObject alloc] init];
        [self labelFromDataset:label rs:rs];
        [resultArr addObject:label];
    }
    [rs close];

    return resultArr;
}
    
@end

