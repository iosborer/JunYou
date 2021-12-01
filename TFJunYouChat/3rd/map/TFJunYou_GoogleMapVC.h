//
//  TFJunYou_GoogleMapVC.h
//  TFJunYouChat
//
//  Created by 1 on 2018/8/20.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"


typedef NS_OPTIONS(NSUInteger, TFJunYou_GooLocationType){
    TFJunYou_GooLocationTypeCurrentLocation     = 0,
    TFJunYou_GooLocationTypeShowStaticLocation  = 2,
};

@interface TFJunYou_GoogleMapVC : TFJunYou_admobViewController{
    NSInteger _selIndex;
    NSMutableArray *_nearMarkArray; //周边检索数据源
    UITableView * _nearMarkTableView;
}
@property (nonatomic,retain)  UIButton * sendButton;
@property (nonatomic,assign) TFJunYou_GooLocationType locationType;

@property (nonatomic,assign) double longitude; //右边
@property (nonatomic,assign) double latitude; //左边
@property (nonatomic, assign) NSObject* delegate;
@property (nonatomic, assign) SEL        didSelect;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,retain)  NSMutableArray *locations;
@property (nonatomic, copy) NSString *placeNames;

@property (assign, nonatomic) BOOL isSend;


@end
