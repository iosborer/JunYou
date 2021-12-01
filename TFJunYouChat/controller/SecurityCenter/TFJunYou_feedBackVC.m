//
//  TFJunYou_feedBackVC.m
//  TFJunYouChat
//
//  Created by JayLuo on 2021/2/5.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_feedBackVC.h"
#import "FeedBackVC.h"
#define HEIGHT 50
@interface TFJunYou_feedBackVC ()

@end

@implementation TFJunYou_feedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    
    self.title = @"投诉与建议";
    
    int y = 0;
    TFJunYou_ImageView *iv = [self createButton:@"违规投诉(骚扰他人、诈骗等行为)" icon:nil drawTop:NO drawBottom:YES must:NO click:@selector(complaintsSuggestions1:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    iv = [self createButton:@"功能体验与其他意见反馈" icon:nil drawTop:NO drawBottom:YES must:NO click:@selector(complaintsSuggestions2:) superView:self.tableBody];
    iv.frame = CGRectMake(0,y, TFJunYou__SCREEN_WIDTH, HEIGHT);
    y += iv.frame.size.height;
    
    
}

- (void)complaintsSuggestions1:(TFJunYou_ImageView *)imageView {
    FeedBackVC *vc  = [FeedBackVC new];
    vc.type = FeedBackTypeComplaints;
    [g_navigation pushViewController:vc animated:YES];
    
}

- (void)complaintsSuggestions2:(TFJunYou_ImageView *)imageView {
    FeedBackVC *vc  = [FeedBackVC new];
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
        labelFrame = CGRectMake(10, 0, 300, HEIGHT);
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
