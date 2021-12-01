//
//  XQMapViewController.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/7/24.
//  Copyright © 2020 zengwOS.  All rights reserved.
//

#import "XQMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "topImageBottomTitleView.h"

@interface XQMapViewController ()<MAMapViewDelegate , topImageBottomTitleViewTapDelegate>
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) UIButton *gpsButton;
@end

@implementation XQMapViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"地图";
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.907728, 116.397968);
    self.mapView.showsUserLocation = YES;
    self.mapView.showsCompass = NO;
    self.mapView.zoomLevel = 15.5;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.scaleOrigin = CGPointMake(10, kNavigationBarMaxY + 10);
    [self.view addSubview:self.mapView];
    
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(zoomPannelView.bounds) - 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(zoomPannelView.bounds) - 10);
    
    zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:zoomPannelView];
    
    self.gpsButton = [self makeGPSButtonView];
    self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 20);
    [self.view addSubview:self.gpsButton];
    self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
    NSArray *imageTitleArr = @[@{@"image":@"map_1",
                                 @"title":@"标准地图"},
                               @{@"image":@"map_2",
                                 @"title":@"卫星地图"},
                               @{@"image":@"map_3",
                                 @"title":@"实时路况"}];
    
    CGFloat width , height;
    width = height = 64.0;
    for (int i = 0; i < imageTitleArr.count; i ++) {
        topImageBottomTitleView *imageTitleView = [[topImageBottomTitleView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - width - 10, (kScreenH - (imageTitleArr.count * (height + 10) - 10)) * 0.5 + i * (height + 10), width, height)];
        imageTitleView.tag = 100 + i;
        imageTitleView.delegate = self;
        [imageTitleView setUIWithDic:[imageTitleArr objectAtIndex:i]];
        [self.view addSubview:imageTitleView];
        
        imageTitleView.checked = (i == 0);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

#pragma mark - Action Handlers
- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
}

- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
    }
}

- (void)topImageBottomTitleViewTapWithView:(topImageBottomTitleView *)view {
    switch (view.tag) {
        case 100:
            //标准地图
            self.mapView.mapType = MAMapTypeStandard;
            self.mapView.showTraffic = NO;
            break;
        case 101:
            //卫星地图
            self.mapView.mapType = MAMapTypeSatellite;
            self.mapView.showTraffic = NO;
            break;
        case 102:
            //实时路况
            self.mapView.mapType = MAMapTypeStandard;
            self.mapView.showTraffic = YES;
            break;
        default:
            break;
    }
    
    [self setImageTitleViewSelectedWithView:view];
}

- (void)setImageTitleViewSelectedWithView:(topImageBottomTitleView *)view {
    for (int i = 100; i < 103; i ++) {
        topImageBottomTitleView *presentView = [self.view viewWithTag:i];
        presentView.checked = (view.tag == i);
    }
}

@end
