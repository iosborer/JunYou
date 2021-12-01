#import <Foundation/Foundation.h>
@interface HBHttpRequest : NSObject
+(HBHttpRequest*)shareIntance;
- (void)getBitmapURL:(NSString*)indirectUrl  complete:(void(^)(NSString*))complete;
@end
