#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@class LKDBProperty;
@class LKModelInfos;
@class LKDBHelper;
#pragma mark- 表结构
@interface NSObject(LKTabelStructure)
+(NSString*)getTableName;
+(BOOL)getAutoUpdateSqlColume;
+(void)columeAttributeWithProperty:(LKDBProperty*)property;
+(NSString*)getPrimaryKey;
+(NSArray*) getPrimaryKeyUnionArray;
@property int rowid;
+(NSString*)getDBImagePathWithName:(NSString*)filename;
+(NSString*)getDBDataPathWithName:(NSString*)filename;
@end
#pragma mark- 表数据操作
@interface NSObject(LKTableData)
-(id)userGetValueForModel:(LKDBProperty*)property;
-(void)userSetValueForModel:(LKDBProperty*)property value:(id)value;
-(id)modelGetValue:(LKDBProperty*)property;
-(void)modelSetValue:(LKDBProperty*)property value:(id)value;
-(id)singlePrimaryKeyValue;
-(BOOL)singlePrimaryKeyValueIsEmpty;
-(LKDBProperty*)singlePrimaryKeyProperty;
@end
@interface NSObject (LKModel)
+(LKDBHelper*)getUsingLKDBHelper;
+(LKModelInfos*)getModelInfos;
+(BOOL)isContainParent;
-(NSString*)printAllPropertys;
-(NSString*)printAllPropertysIsContainParent:(BOOL)containParent;
@end