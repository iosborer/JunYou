//
//  TFJunYou_PlaceMarkModel.m
//  TFJunYouChat
//
//  Created by MacZ on 16/8/31.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_PlaceMarkModel.h"
#import <MapKit/MapKit.h>

#import <BaiduMapAPI_Search/BMKPoiSearchType.h>

@implementation TFJunYou_PlaceMarkModel

+ (TFJunYou_PlaceMarkModel *)modelByCLPlacemark:(CLPlacemark *)placeMark{
    TFJunYou_PlaceMarkModel *model = [[TFJunYou_PlaceMarkModel alloc] init];
    
    model.longitude = placeMark.location.coordinate.longitude;
    model.latitude = placeMark.location.coordinate.latitude;
    model.placeName = placeMark.thoroughfare;
    model.address = [placeMark.name stringByReplacingOccurrencesOfString:placeMark.country withString:@""]; //去掉国家名
    model.address = [model.address stringByReplacingOccurrencesOfString:placeMark.administrativeArea withString:@""];   //去掉省份名
    
    return model;
}

+ (TFJunYou_PlaceMarkModel *)modelByMKMapItem:(MKMapItem *)mapItem{
    TFJunYou_PlaceMarkModel *model = [[TFJunYou_PlaceMarkModel alloc] init];
    
    model.longitude = mapItem.placemark.location.coordinate.longitude;
    model.latitude = mapItem.placemark.location.coordinate.latitude;
    model.placeName = mapItem.name;
    model.address = mapItem.placemark.thoroughfare;
    
    return model;
}

+ (TFJunYou_PlaceMarkModel *)modelByBMKPoiInfo:(BMKPoiInfo *)bmkPoiInfo{
    TFJunYou_PlaceMarkModel *model = [[TFJunYou_PlaceMarkModel alloc] init];
    
    model.longitude = bmkPoiInfo.pt.longitude;
    model.latitude = bmkPoiInfo.pt.latitude;
    model.placeName = bmkPoiInfo.name;
    model.address = bmkPoiInfo.address;
    
    model.name = bmkPoiInfo.name;
    model.city = bmkPoiInfo.city;
    
    return model;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"name:%@,经纬度:(%f,%f),建筑名:%@,地址:%@,城市:%@",self.name,self.longitude,self.latitude,self.placeName,self.address,self.city];
}

@end
