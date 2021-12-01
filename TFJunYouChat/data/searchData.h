#import <Foundation/Foundation.h>
@interface searchData : NSObject{
}
@property(nonatomic,assign) int countryId;
@property(nonatomic,assign) int provinceId;
@property(nonatomic,assign) int cityId;
@property(nonatomic,assign) int areaId;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,assign) int sex;
@property(nonatomic,assign) int minAge;
@property(nonatomic,assign) int maxAge;
@property(nonatomic,assign) int showTime;
@end
