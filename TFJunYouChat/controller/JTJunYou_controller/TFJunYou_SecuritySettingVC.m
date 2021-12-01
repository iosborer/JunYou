//
//  TFJunYou_SecuritySettingVC.m
//  TFJunYouChat
//
//  Created by p on 2019/4/3.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_SecuritySettingVC.h"
#import "TFJunYou_DeviceLockVC.h"
#import "TFJunYou_securityCenterVC.h"
#import "IQKeyboardManager.h"

#define HEIGHT 50

@interface TFJunYou_SecuritySettingVC ()

@end

@implementation TFJunYou_SecuritySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    //self.view.frame = g_window.bounds;
    
    [self createHeadAndFoot];
    
    
//    self.title = Localized(@"JX_SecuritySettings");
    self.title = @"账号与安全";
    
    int y = 0;
    TFJunYou_ImageView *iv = [self createButton:Localized(@"JX_EquipmentLock") icon:@"手机设备管理" drawTop:NO drawBottom:YES must:NO click:@selector(deviceLock:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    iv = [self createButton:@"安全中心" icon:@"账号安全" drawTop:NO drawBottom:YES must:NO click:@selector(securityCenter:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    
}

- (void)deviceLock:(TFJunYou_ImageView *)imageView {
    
    TFJunYou_DeviceLockVC *vc = [[TFJunYou_DeviceLockVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)securityCenter:(TFJunYou_ImageView *)imageView {
    TFJunYou_securityCenterVC *vc = [[TFJunYou_securityCenterVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

-(TFJunYou_ImageView*)createButton:(NSString*)title icon:(NSString*)icon  drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom must:(BOOL)must click:(SEL)click superView:(UIView *)superView{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    if(click)
        btn.didTouch = click;
    else
        btn.didTouch = @selector(hideKeyboard);
    btn.delegate = self;
    [superView addSubview:btn];
    //    [btn release];
    if(icon){
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (HEIGHT-23)/2, 23, 23)];
        iv.image = [UIImage imageNamed:icon];
        [btn addSubview:iv];
    }
    if(must){
        UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(INSETS, 5, 20, HEIGHT-5)];
        p.text = @"*";
        p.font = g_factory.font18;
        p.backgroundColor = [UIColor clearColor];
        p.textColor = [UIColor redColor];
        p.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:p];
        //        [p release];
    }
    
//    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(28, 0, 200, HEIGHT)];
    
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(53, 0, self_width-35-20-5, HEIGHT)];
    p.text = title;
    p.font = [UIFont systemFontOfSize:16.2];
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [UIColor blackColor];
    [btn addSubview:p];
    //    [p release];
    
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
        //        [line release];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT-LINE_WH,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
        //        [line release];
    }
    
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
        //        [iv release];
    }
    return btn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
