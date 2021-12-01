#import "HBHttpRequest.h"
@interface HBHttpRequest ()
{
    NSMutableDictionary * _callBackBlocks;
}
@end
@implementation HBHttpRequest
-(id)init
{
    self=[super init];
    if(self){
        _callBackBlocks=[[NSMutableDictionary alloc]init];
    }
    return self;
}
#pragma -mark 接口方法 
+(HBHttpRequest*)newIntance
{
    static HBHttpRequest * request=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request=[[HBHttpRequest alloc]init];
    });
    return request;
}
- (void)getBitmapURL:(NSString*)indirectUrl  complete:(void(^)(NSString*))complete
{
}
#pragma -mark 回调方法
@end
