#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "LKDBUtils.h"
#import "LKDB+Manager.h"
#import "LKDB+Mapping.h"
#import "NSObject+LKModel.h"
#import "NSObject+LKDBHelper.h"
#ifdef DEBUG
    #ifdef NSLog
        #define LKLog(fmt, ...) NSLog(@"#LKDBHelper ERROR:\n" fmt,##__VA_ARGS__);
    #else
        #define LKLog(fmt, ...) NSLog(@"\n#LKDBHelper ERROR: %s  [Line %d] \n" fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #endif
#else
#   define LKLog(...)
#endif
@interface LKDBHelper : NSObject
#pragma mark- deprecated
+(LKDBHelper*)sharedDBHelper DEPRECATED_ATTRIBUTE;
#pragma mark-
-(id)initWithDBName:(NSString*)dbname;
-(void)setDBName:(NSString*)fileName;
-(void)executeDB:(void (^)(FMDatabase *db))block;
-(BOOL)executeSQL:(NSString *)sql arguments:(NSArray *)args;
-(NSString *)executeScalarWithSQL:(NSString *)sql arguments:(NSArray *)args;
@end
@interface LKDBHelper(DatabaseManager)
-(BOOL)createTableWithModelClass:(Class)model;
-(void)dropAllTable;
-(BOOL)dropTableWithClass:(Class)modelClass;
@end
@interface LKDBHelper(DatabaseExecute)
-(int)rowCount:(Class)modelClass where:(id)where;
-(void)rowCount:(Class)modelClass where:(id)where callback:(void(^)(int rowCount))callback;
-(NSMutableArray*)search:(Class)modelClass where:(id)where orderBy:(NSString*)orderBy offset:(int)offset count:(int)count;
-(void)search:(Class)modelClass where:(id)where orderBy:(NSString*)orderBy offset:(int)offset count:(int)count callback:(void(^)(NSMutableArray* array))block;
-(id)searchSingle:(Class)modelClass where:(id)where orderBy:(NSString*)orderBy;
-(BOOL)insertToDB:(NSObject*)model;
-(void)insertToDB:(NSObject*)model callback:(void(^)(BOOL result))block;
-(BOOL)insertWhenNotExists:(NSObject*)model;
-(void)insertWhenNotExists:(NSObject*)model callback:(void(^)(BOOL result))block;
-(BOOL)updateToDB:(NSObject *)model where:(id)where;
-(void)updateToDB:(NSObject *)model where:(id)where callback:(void (^)(BOOL result))block;
-(BOOL)updateToDB:(Class)modelClass set:(NSString*)sets where:(id)where;
-(BOOL)deleteToDB:(NSObject*)model;
-(void)deleteToDB:(NSObject*)model callback:(void(^)(BOOL result))block;
-(BOOL)deleteWithClass:(Class)modelClass where:(id)where;
-(void)deleteWithClass:(Class)modelClass where:(id)where callback:(void (^)(BOOL result))block;
-(BOOL)isExistsModel:(NSObject*)model;
-(BOOL)isExistsClass:(Class)modelClass where:(id)where;
+(void)clearTableData:(Class)modelClass;
+(void)clearNoneImage:(Class)modelClass columes:(NSArray*)columes;
+(void)clearNoneData:(Class)modelClass columes:(NSArray*)columes;
-(BOOL)insertBase:(NSObject*)model;
-(void)asyncBlock:(void(^)(void))block;
@end