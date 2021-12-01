//
//  TFJunYou_PlaceMarkModel.h
//  TFJunYouChat
//
//  Created by MacZ on 16/8/31.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class BMKPoiInfo;

@interface TFJunYou_PlaceMarkModel : NSObject

@property (nonatomic,assign) double longitude;  //经度
@property (nonatomic,assign) double latitude;   //纬度

@property (nonatomic,copy) NSString *placeName;   //建筑名
@property (nonatomic,copy) NSString *address;    //街道信息

@property (nonatomic,copy) NSString *city;    //城市
@property (nonatomic,copy) NSString *imageUrl;
/**名称*/
@property(nonatomic,copy)NSString *name;

+ (TFJunYou_PlaceMarkModel *)modelByCLPlacemark:(CLPlacemark *)placeMark;
+ (TFJunYou_PlaceMarkModel *)modelByMKMapItem:(MKMapItem *)mapItem;
+ (TFJunYou_PlaceMarkModel *)modelByBMKPoiInfo:(BMKPoiInfo *)bmkPoiInfo;

@end
