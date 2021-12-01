#import "NSMutableDictionary+NSMutableDictionary_SK.h"
@implementation NSMutableDictionary (NSMutableDictionary_SK)
- (void)setNotNullObject:(id)anObject forKey:(id<NSCopying>)aKey;{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}
@end
