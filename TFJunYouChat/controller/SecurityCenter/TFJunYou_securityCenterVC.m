//
//  TFJunYou_securityCenterVC.m
//  TFJunYouChat
//
//  Created by JayLuo on 2021/2/5.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_securityCenterVC.h"
#import "TFJunYou_feedBackVC.h"
#import "TFJunYou_FreezeNoVc.h"
#import "TFJunYou_openFreezeNoVc.h"
#import "TFJunYou_logoffAccountVc.h"

#import "TFJunYou_FAQCenterDetailItemVC.h"
#import "TFJunYou_FAQCenterDetailVC.h"
#define HEIGHT 50
@class TFJunYou_FAQCenterDetailModel;
@interface TFJunYou_securityCenterVC ()

@end

@implementation TFJunYou_securityCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    
    self.title = @"安全中心";
    
    int y = 0;
    TFJunYou_ImageView *iv = [self createButton:@"解封账号" icon:@"解封" drawTop:NO drawBottom:YES must:NO click:@selector(unlockAccount:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"冻结账号" icon:@"冻结" drawTop:NO drawBottom:YES must:NO click:@selector(frozenAccount:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"解冻账号" icon:@"解冻" drawTop:NO drawBottom:YES must:NO click:@selector(unfrozenAccount:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"投诉与建议" icon:@"投诉" drawTop:NO drawBottom:YES must:NO click:@selector(complaintsSuggestions:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"注销账号" icon:@"注销" drawTop:NO drawBottom:YES must:NO click:@selector(logoff:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
}

- (void)didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1 {
    [_wait hide];
    if ([aDownload.action isEqualToString:act_ApiEditGet]) {
        TFJunYou_FAQCenterDetailModel *model = [TFJunYou_FAQCenterDetailModel mj_objectWithKeyValues:dict];
        TFJunYou_FAQCenterDetailItemVC *vc = [TFJunYou_FAQCenterDetailItemVC new];
        vc.model = model;
        [g_navigation pushViewController:vc animated:YES];
    }
}

- (int)didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict {
    [_wait hide];
    return show_error;
}

- (int)didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error {//error为空时，代表超时
    [_wait hide];
    return show_error;
}

- (void)didServerConnectStart:(TFJunYou_Connection*)aDownload {
    [_wait start];
}

- (void)unlockAccount:(TFJunYou_ImageView *)imageView {
    [g_server get_act_ApiEditGet:@"7" toView:self];
}

- (void)frozenAccount:(TFJunYou_ImageView *)imageView {
    TFJunYou_FreezeNoVc *vc = [[TFJunYou_FreezeNoVc alloc]init];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)unfrozenAccount:(TFJunYou_ImageView *)imageView {
    
    TFJunYou_openFreezeNoVc *vc = [[TFJunYou_openFreezeNoVc alloc]init];
    [g_navigation pushViewController:vc animated:YES];
 
}

- (void)complaintsSuggestions:(TFJunYou_ImageView *)imageView {
    
    TFJunYou_feedBackVC *vc  = [TFJunYou_feedBackVC new];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)logoff:(TFJunYou_ImageView *)imageView {
    
    TFJunYou_logoffAccountVc *vc = [[TFJunYou_logoffAccountVc alloc]init];
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
    
    if(must){
        UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(INSETS, 5, 20, HEIGHT-5)];
        p.text = @"*";
        p.font = g_factory.font18;
        p.backgroundColor = [UIColor clearColor];
        p.textColor = [UIColor redColor];
        p.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:p];
    }
    
    
    CGRect labelFrame = CGRectZero;
    if (icon) {
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (HEIGHT-23)/2, 23, 23)];
        iv.image = [UIImage imageNamed:icon];
        [btn addSubview:iv];
        labelFrame = CGRectMake(53, 0, self_width-35-20-5, HEIGHT);
    }else {
        labelFrame = CGRectMake(28, 0, 200, HEIGHT);
    }
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:labelFrame];
    p.text = title;
    p.font = [UIFont systemFontOfSize:16.2];
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [UIColor blackColor];
    [btn addSubview:p];
    
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT-LINE_WH,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
    }
    return btn;
}

@end
