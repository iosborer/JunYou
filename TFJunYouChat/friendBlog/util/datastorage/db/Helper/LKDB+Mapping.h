#import "LKDBUtils.h"
static NSString* const LKSQLText        =   @"text";
static NSString* const LKSQLInt         =   @"integer";
static NSString* const LKSQLDouble      =   @"double";
static NSString* const LKSQLBlob        =   @"blob";
static NSString* const LKSQLNotNull     =   @"NOT NULL";
static NSString* const LKSQLPrimaryKey  =   @"PRIMARY KEY";
static NSString* const LKSQLDefault     =   @"DEFAULT";
static NSString* const LKSQLUnique      =   @"UNIQUE";
static NSString* const LKSQLCheck       =   @"CHECK";
static NSString* const LKSQLForeignKey  =   @"FOREIGN KEY";
static NSString* const LKSQLFloatType   =   @"float_double_decimal";
static NSString* const LKSQLIntType     =   @"int_char_short_long";
static NSString* const LKSQLBlobType    =   @"";
static NSString* const LKSQLInherit          =   @"LKDBInherit";
static NSString* const LKSQLBinding          =   @"LKDBBinding";
static NSString* const LKSQLUserCalculate    =   @"LKDBUserCalculate";
extern inline NSString* LKSQLTypeFromObjcType(NSString *objcType);
@interface NSObject(TableMapping)
+(NSDictionary*)getTableMapping;
+(void)setUserCalculateForCN:(NSString*)columename;
+(void)setUserCalculateForPTN:(NSString*)propertyTypeName;
+(void)removePropertyWithColumeName:(NSString*)columename;
@end
@interface LKDBProperty:NSObject
@property(readonly,nonatomic)NSString* type;
@property(readonly,nonatomic)NSString* sqlColumeName;
@property(readonly,nonatomic)NSString* sqlColumeType;
@property(readonly,nonatomic)NSString* propertyName;
@property(readonly,nonatomic)NSString* propertyType;
@property BOOL isUnique;
@property BOOL isNotNull;
@property(strong,nonatomic) NSString* defaultValue;
@property(strong,nonatomic) NSString* checkValue;
@property int length;
-(BOOL)isUserCalculate;
@end
@interface LKModelInfos : NSObject
-(id)initWithKeyMapping:(NSDictionary*)keyMapping propertyNames:(NSArray*)propertyNames propertyType:(NSArray*)propertyType primaryKeys:(NSArray*)primaryKeys;
@property(readonly,nonatomic)int count;
@property(readonly,nonatomic)NSArray* primaryKeys;
-(LKDBProperty*)objectWithIndex:(int)index;
-(LKDBProperty*)objectWithPropertyName:(NSString*)propertyName;
-(LKDBProperty*)objectWithSqlColumeName:(NSString*)columeName;
@end