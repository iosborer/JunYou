#import <Foundation/Foundation.h>
@class TFJunYou_Location;
@protocol TFJunYou_LocationDelegate <NSObject>
- (void) location:(TFJunYou_Location *)location CountryCode:(NSString *)countryCode CityName:(NSString *)cityName CityId:(NSString *)cityId Address:(NSString *)address Latitude:(double)lat Longitude:(double)lon;
- (void)location:(TFJunYou_Location *)location getLocationWithIp:(NSDictionary *)dict;
- (void)location:(TFJunYou_Location *)location getLocationError:(NSError *)error;
@end
@interface TFJunYou_Location : NSObject
@property (nonatomic, weak) id<TFJunYou_LocationDelegate> delegate;
- (void) locationStart;
- (void) getLocationWithIp;
@end
