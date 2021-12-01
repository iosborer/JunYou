#import <Foundation/Foundation.h>
@class LKDBHelper;
typedef enum {
    LKTableUpdateTypeDefault = 1<<0,        
    LKTableUpdateTypeDeleteOld = 1<<1,      
    LKTableUpdateTypeCustom = 1<<2          
}LKTableUpdateType;
@interface NSObject (TableManager)
+(int)getTableVersion;
+(LKTableUpdateType)tableUpdateForOldVersion:(int)oldVersion newVersion:(int)newVersion;
+(void)tableUpdateAddColumeWithPN:(NSString*)propertyName;
+(void)tableUpdateAddColumeWithName:(NSString*)columeName sqliteType:(NSString*)sqliteType;
#pragma mark- DEPRECATED
#pragma mark-
@end
@interface LKTableManager : NSObject
-(id)initWithLKDBHelper:(LKDBHelper*)helper;
-(void)setTableName:(NSString*)name version:(int)version;
-(int)versionWithName:(NSString*)name;
-(void)clearTableInfos;
@end
