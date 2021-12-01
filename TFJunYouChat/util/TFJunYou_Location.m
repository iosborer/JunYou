#import "TFJunYou_Location.h"
@interface TFJunYou_Location ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *location;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *address;
@end
@implementation TFJunYou_Location
- (instancetype)init {
    if ([super init]) {
        _location = [[CLLocationManager alloc] init] ;
        _location.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_location requestWhenInUseAuthorization];
        }
    }
    return self;
}
- (void)locationStart {
    [_location startUpdatingLocation];
    [_location stopUpdatingHeading];
}
#pragma mark -------------获取经纬度----------------
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    double latitude  =  currentLocation.coordinate.latitude;
    double longitude =  currentLocation.coordinate.longitude;
    NSLog(@"成功获得位置:latitude:%f,longitude:%f",latitude,longitude);
    [self getAddressInfo:currentLocation];
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"成功获得状态");
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"找不到位置: %@", [error description]);
    [self getLocationWithIp];
    return;
}
- (void)getAddressInfo:(CLLocation *)location{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    [self reverseGeocode:location];
}
- (void) reverseGeocode:(CLLocation *)location{
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks firstObject];
            NSString *city = placeMark.locality;
            if (!city) {    
                city = placeMark.administrativeArea;
            }
            if (city) {
                self.cityName = city;
                _cityId = [g_constant getCityID:city];
            }
            if (_cityId) {
            }
            self.countryCode = placeMark.ISOcountryCode;
            if(self.countryCode) {
                [[NSUserDefaults standardUserDefaults] setObject:self.countryCode forKey:kISOcountryCode];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSDictionary *addressDict = placeMark.addressDictionary;
            NSString *addressStr = [addressDict objectForKey:@"Name"];
            addressStr = [addressStr stringByReplacingOccurrencesOfString:placeMark.country withString:@""];
            if ([addressDict objectForKey:@"State"] != nil) {
                addressStr = [addressStr stringByReplacingOccurrencesOfString:[addressDict objectForKey:@"State"] withString:@""];
            }
            if (_address) {
                _address = nil;
            }
            _address = [[NSString alloc] initWithFormat:@"%@%@",self.cityName,addressStr];
            if ([self.delegate respondsToSelector:@selector(location:CountryCode:CityName:CityId:Address:Latitude:Longitude:)]) {
                [self.delegate location:self CountryCode:self.countryCode CityName:self.cityName CityId:self.cityId Address:self.address Latitude:location.coordinate.latitude Longitude:location.coordinate.longitude];
            }
        }else {
            [self reverseGeocodeWithGoogleapi:location];
        }
    }];
}
- (void)reverseGeocodeWithGoogleapi:(CLLocation *)location {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",location.coordinate.latitude, location.coordinate.longitude];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        if ([responseDic[@"status"] isEqualToString:@"OK"]) {
            NSArray *returenArray = responseDic[@"results"];
            NSDictionary *addressDic = returenArray[0];
            NSArray *arr = addressDic[@"address_components"];
            for (NSDictionary *dict in arr) {
                NSArray *types = dict[@"types"];
                NSString *type = [types firstObject];
                if ([type isEqualToString:@"country"]) {
                    self.countryCode = dict[@"short_name"];
                    break;
                }
            }
            if (self.countryCode) {
                [[NSUserDefaults standardUserDefaults] setObject:self.countryCode forKey:kISOcountryCode];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            for (NSDictionary *dict in arr) {
                NSArray *types = dict[@"types"];
                NSString *type = [types firstObject];
                if ([type isEqualToString:@"locality"]) {
                    self.cityName = dict[@"long_name"];
                    break;
                }
            }
            if (!self.cityId) {
                for (NSDictionary *dict in arr) {
                    NSArray *types = dict[@"types"];
                    NSString *type = [types firstObject];
                    if ([type isEqualToString:@"administrative_area_level_1"]) {
                        self.cityName = dict[@"long_name"];
                        break;
                    }
                }
            }
            if (_cityId) {
                [[NSUserDefaults standardUserDefaults] setObject:_cityId forKey:kCityId];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            _address = addressDic[@"formatted_address"];
            if ([self.delegate respondsToSelector:@selector(location:CountryCode:CityName:CityId:Address:Latitude:Longitude:)]) {
                [self.delegate location:self CountryCode:self.countryCode CityName:self.cityName CityId:self.cityId Address:self.address Latitude:location.coordinate.latitude Longitude:location.coordinate.longitude];
            }
            NSLog(@"response = %@",responseObject);
        }else {
            [self getLocationWithIp];
        }
        NSLog(@"response = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self getLocationWithIp];
        NSLog(@"error = %@",error);
    }];
}
- (void)getLocationWithIp {
    NSString *urlString = @"https://ipinfo.io/geo";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer.timeoutInterval = 5.0;
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        self.countryCode = responseDic[@"country"];
        if (self.countryCode) {
            [[NSUserDefaults standardUserDefaults] setObject:self.countryCode forKey:kISOcountryCode];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        self.cityName = responseDic[@"city"];
        if (!self.cityId) {
            self.cityName = responseDic[@"region"];
        }
        if (_cityId) {
            [[NSUserDefaults standardUserDefaults] setObject:_cityId forKey:kCityId];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _address = [NSString stringWithFormat:@"%@%@",responseDic[@"region"],responseDic[@"city"]];
        NSString *loc = responseDic[@"loc"];
        NSRange range = [loc rangeOfString:@","];
        NSString *lat = [loc substringToIndex:range.location];
        NSString *lon = [loc substringFromIndex:range.location + range.length];
        if ([self.delegate respondsToSelector:@selector(location:CountryCode:CityName:CityId:Address:Latitude:Longitude:)]) {
            [self.delegate location:self CountryCode:self.countryCode CityName:self.cityName CityId:self.cityId Address:self.address Latitude:[lat doubleValue] Longitude:[lon doubleValue]];
        }
        if ([self.delegate respondsToSelector:@selector(location:getLocationWithIp:)]) {
            [self.delegate location:self getLocationWithIp:responseDic];
        }
        NSLog(@"response = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self.delegate respondsToSelector:@selector(location:getLocationError:)]) {
            [self.delegate location:self getLocationError:error];
        }
        NSLog(@"error = %@",error);
    }];
}
@end
