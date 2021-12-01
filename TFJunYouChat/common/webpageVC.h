//
//  webpageVC.h
//  sjvodios
//
//  Created by  on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
//@class TFJunYou_admobViewController;
@protocol TFJunYou_ServerResult;
#import "TFJunYou_admobViewController.h"
#import <WebKit/WebKit.h>

@interface webpageVC : TFJunYou_admobViewController<UIScrollViewDelegate>{
    UIActivityIndicatorView *aiv;
    WKWebView* webView;
    int   _type;
    float _num;
    float _price;
    NSString* _product;
}

@property(nonatomic,strong) WKWebView* webView;
@property(nonatomic,strong) NSString* url;
@property(nonatomic,strong) NSString* shareUrl;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic,copy) NSString *shareParam;

-(float)getMoney:(char*)s;
@end
