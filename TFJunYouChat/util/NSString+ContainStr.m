#import "NSString+ContainStr.h"
@implementation NSString (ContainStr)
-(BOOL)containsMyString:(NSString *)str{
    if ([self rangeOfString:str].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}
@end
