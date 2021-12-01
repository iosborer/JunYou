#import <Foundation/Foundation.h>
@interface TimeUtil : NSObject
+ (NSString*)getTimeStr1:(long long)time;
+(NSString*) getTimeStrStyle1:(long long)time;
+ (NSString*)getTimeStr1Short:(long long)time;
+(NSString*) getTimeStrStyle2:(long long)time;
+(NSString*)getTimeShort:(long long)t;
+(NSString*)getTimeShort1:(long long)t;
+(NSString*)getDateStr:(long long)time;
+(int)dayCountForMonth:(int)month andYear:(int)year;
+(BOOL)isLeapYear:(int)year;
+(NSDate*)dateFromString:(NSString*)s format:(NSString*)str;
+(NSString*)formatDateFromStr:(NSString*)s format:(NSString*)str;
+(NSString*)formatDate:(NSDate*)d format:(NSString*)str;
@end
