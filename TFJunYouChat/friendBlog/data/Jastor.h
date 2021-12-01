#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface Jastor : NSObject<NSCoding>
@property (nonatomic, copy) NSString * objectId;
+ (id)objectFromDictionary:(NSDictionary*)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *)toDictionary;
-(NSMutableDictionary*)toDictionaryWithProperty:(BOOL(^)(NSString * propertyName))property;
+(NSArray*)getDataArray:(NSString*)str;
@end
