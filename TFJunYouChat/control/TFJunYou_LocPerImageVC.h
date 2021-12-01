//
//  TFJunYou_LocPerImageVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/03.
//  Copyright © 2020 zengwOS. All rights reserved.
//

//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//只引入所需的单个头文件
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
@interface TFJunYou_LocPerImageVC : BMKAnnotationView

@property (nonatomic,strong) TFJunYou_ImageView * headImage;
@property (nonatomic,strong) UIImageView * pointImage;
@property (nonatomic,strong) UIView * headView;
-(void)setData:(NSDictionary*)data andType:(int)dataType;
-(void)selectAnimation;
-(void)cancelSelectAnimation;
@end
