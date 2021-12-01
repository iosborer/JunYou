#import <Foundation/Foundation.h> 
NS_ASSUME_NONNULL_BEGIN
@interface MD5Util : NSObject
+(NSString*)getMD5StringWithString:(NSString*)s;
+(NSData*)getMD5DataWithData:(NSData*)data;
+(NSData*)getMD5DataWithString:(NSString*)str;
+(NSString*)getMD5StringWithData:(NSData*)data;
@end
NS_ASSUME_NONNULL_END
