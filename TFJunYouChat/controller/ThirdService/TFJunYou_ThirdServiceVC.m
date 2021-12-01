//
//  TFJunYou_ThirdServiceVC.m
//  TFJunYouChat
//
//  Created by JayLuo on 2021/2/9.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_ThirdServiceVC.h"
#import "SQCustomButton.h"
#import "webpageVC.h"

@interface TFJunYou_ThirdServiceVC ()

@end

@implementation TFJunYou_ThirdServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    
    self.title = @"第三方服务";
    __weak typeof(self) weakSelf = self;
    SQCustomButton *button2 = [[SQCustomButton alloc] initWithFrame:(CGRect){TFJunYou__SCREEN_WIDTH/2 - 50,0,100,100}
                                                             type:SQCustomButtonTopImageType
                                                        imageSize:CGSizeMake(57.5, 50) midmargin:10];
    button2.isShowSelectBackgroudColor = YES;
    button2.imageView.image = [UIImage imageNamed:@"icon_logo_pinduoduo"];
    button2.backgroundColor = [UIColor whiteColor];
    button2.titleLabel.text = @"拼多多";
    [self.tableBody addSubview:button2];
    
    [button2 touchAction:^(SQCustomButton * _Nonnull button) {
        [weakSelf gotoUrl:@"https://m.pinduoduo.com/home/" title:@"拼多多"];
    }];
    
    SQCustomButton *button1 = [[SQCustomButton alloc] initWithFrame:(CGRect){CGRectGetMinX(button2.frame) -100 - 20,0,100,100}
                                                             type:SQCustomButtonTopImageType
                                                        imageSize:CGSizeMake(50, 50) midmargin:10];
    button1.isShowSelectBackgroudColor = YES;
    button1.imageView.image = [UIImage imageNamed:@"icon_logo_meituan"];
    button1.backgroundColor = [UIColor whiteColor];
    button1.titleLabel.text = @"美团";
    [self.tableBody addSubview:button1];
   
    [button1 touchAction:^(SQCustomButton * _Nonnull button) {
        [weakSelf gotoUrl:@"http://i.meituan.com/" title:@"美团"];
    }];
    
   
    
    SQCustomButton *button3 = [[SQCustomButton alloc] initWithFrame:(CGRect){CGRectGetMaxX(button2.frame)+20,0,100,100}
                                                             type:SQCustomButtonTopImageType
                                                        imageSize:CGSizeMake(50, 50) midmargin:10];
    button3.isShowSelectBackgroudColor = YES;
    button3.imageView.image = [UIImage imageNamed:@"icon_logo_jd"];
    button3.backgroundColor = [UIColor whiteColor];
    button3.titleLabel.text = @"京东";
    [self.tableBody addSubview:button3];
    
    [button3 touchAction:^(SQCustomButton * _Nonnull button) {
        [weakSelf gotoUrl:@"https://m.jd.com/" title:@"京东"];
    }];


        
}


- (void)gotoUrl:(NSString *)url title:(NSString *)title {
    webpageVC *webVC = [webpageVC alloc];
    webVC.isGotoBack= YES;
    webVC.isSend = YES;
    webVC.title = title;
    webVC.url = url;
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
}

@end
