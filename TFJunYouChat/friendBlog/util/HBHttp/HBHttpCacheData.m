#import "HBHttpCacheData.h"
@implementation HBHttpCacheData
@synthesize cacheData,cacheType,cacheUrl;
-(id)init{
    self= [super init];
    if(self){
        self.cacheData=nil;
        self.cacheUrl=nil;
        NSDate * date=[NSDate date];
        self.timestamp=[NSString stringWithFormat:@"%lld",(long long)date.timeIntervalSince1970];
    }
    return self;
}
+(NSString *)getPrimaryKey
{
    return @"cacheUrl";
}
+(NSString *)getTableName
{
    return @"HBHttpCacheData";
}
+(int)getTableVersion
{
    return 9;
}
@end
