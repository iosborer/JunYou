#import <Foundation/Foundation.h>
@interface NSStrUtil : NSObject
+ (BOOL) isEmptyOrNull:(NSString*) string;
+ (BOOL) notEmptyOrNull:(NSString*) string;
+ (NSString*) makeNode:(NSString*) str;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (NSString *)trimString:(NSString *) str;
@end
@interface NSString (MyExtensions)
- (NSString *) md5;
@end
@interface NSData (MyExtensions)
- (NSString*)md5;
@end
