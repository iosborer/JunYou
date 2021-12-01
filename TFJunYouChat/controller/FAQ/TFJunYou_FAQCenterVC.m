//
//  TFJunYou_FAQCenterVC.m
//  TFJunYouChat
//
//  Created by JayLuo on 2021/2/6.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_FAQCenterVC.h"
#import "FeedBackVC.h"
#import "TFJunYou_FAQCenterDetailVC.h"
#define HEIGHT 50
@interface TFJunYou_FAQCenterVC ()
@property(nonatomic, assign) int type;
@end

@implementation TFJunYou_FAQCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    
    self.title = @"常见问题";
    
    int y = 0;
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = self.title;
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.frame = CGRectMake(10, 10, 200, 20);
    [self.tableBody addSubview:tipsLabel];
    y += CGRectGetMaxY(tipsLabel.frame) + 10;
    
    TFJunYou_ImageView *iv = [self createButton:@"快讯号设置" icon:@"icon_question" drawTop:NO drawBottom:YES must:NO click:@selector(action1:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"好友添加" icon:@"icon_question" drawTop:NO drawBottom:YES must:NO click:@selector(action2:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"收发消息" icon:@"icon_question" drawTop:NO drawBottom:YES must:NO click:@selector(action3:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"快讯群聊" icon:@"icon_question" drawTop:NO drawBottom:YES must:NO click:@selector(action4:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"快讯" icon:@"icon_question" drawTop:NO drawBottom:YES must:NO click:@selector(action5:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"快讯支付" icon:@"icon_question" drawTop:NO drawBottom:YES must:NO click:@selector(action6:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    UIButton *issueBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [issueBtn setTitle:@"意见反馈" forState:(UIControlStateNormal)];
    [issueBtn addTarget:self action:@selector(action7:) forControlEvents:(UIControlEventTouchUpInside)];
    issueBtn.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    [self.tableBody addSubview:issueBtn];
}


- (void)action1:(TFJunYou_ImageView *)imageView {
    _type = 1;
    [self goNextVC:_type];
}

- (void)action2:(TFJunYou_ImageView *)imageView {
    _type = 2;
    [self goNextVC:_type];
}

- (void)action3:(TFJunYou_ImageView *)imageView {
    _type = 3;
    [self goNextVC:_type];
}

- (void)action4:(TFJunYou_ImageView *)imageView {
    _type = 4;
    [self goNextVC:_type];
}

- (void)action5:(TFJunYou_ImageView *)imageView {
    _type = 5;
    [self goNextVC:_type];
}

- (void)action6:(TFJunYou_ImageView *)imageView {
    _type = 6;
    [self goNextVC:_type];
}

- (void)goNextVC:(int)type {
    TFJunYou_FAQCenterDetailVC *vc = [TFJunYou_FAQCenterDetailVC new];
    vc.type = type;
    [g_navigation pushViewController:vc animated:YES];
}

- (void)action7:(TFJunYou_ImageView *)imageView {
    FeedBackVC *vc = [FeedBackVC new];
    vc.type = FeedBackTypeSuggestion;
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
