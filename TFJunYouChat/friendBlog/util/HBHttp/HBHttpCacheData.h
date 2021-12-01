#import <Foundation/Foundation.h>
typedef enum {
    HBHttpCacheDataTypeText=0,
    HBHttpCacheDataTypeImage=1
}HBHttpCacheDataType;
@interface HBHttpCacheData : NSObject
@property (nonatomic,strong) NSString * cacheUrl;
@property (nonatomic,strong) NSString * cacheData;
@property (nonatomic) HBHttpCacheDataType cacheType;
@property (nonatomic,strong) NSString * timestamp;
@end
