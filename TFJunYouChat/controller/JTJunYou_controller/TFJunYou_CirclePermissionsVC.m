//
//  TFJunYou_CirclePermissionsVC.m
//  TFJunYouChat
//
//  Created by 1 on 2019/8/27.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_CirclePermissionsVC.h"


#define HEIGHT 56

@interface TFJunYou_CirclePermissionsVC ()

@end

@implementation TFJunYou_CirclePermissionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isGotoBack   = YES;
    self.title = @"设置社交圈权限";
    self.heightFooter = 0;
    self.heightHeader = TFJunYou__SCREEN_TOP;

    [self createHeadAndFoot];
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);

    [self setupViews];
}

- (void)setupViews {
    TFJunYou_ImageView* iv;
    
    CGFloat h = 0;
    // 不让他看
    iv = [self createButton:[self.user.sex boolValue] ? @"不让他看" : @"不让她看"  drawTop:NO drawBottom:NO must:NO click:nil superView:self.tableBody];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    
    UISwitch *notSee = [[UISwitch alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH -70, 10, 0, 0)];
    [notSee addTarget:self action:@selector(notLookHisCircleAndVideo:) forControlEvents:UIControlEventValueChanged];
    notSee.tag = 1000;
    notSee.onTintColor = THEMECOLOR;
    [iv addSubview:notSee];
    notSee.on = [self.user.notLetSeeHim boolValue];

    h += iv.frame.size.height;
    
    // 不看他
    iv = [self createButton:[self.user.sex boolValue] ? @"不看他" : @"不看她" drawTop:YES drawBottom:NO must:NO click:nil superView:self.tableBody];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    
    UISwitch *see = [[UISwitch alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH -70, 10, 0, 0)];
    see.tag = 1001;
    see.onTintColor = THEMECOLOR;
    [see addTarget:self action:@selector(notLookHisCircleAndVideo:) forControlEvents:UIControlEventValueChanged];
    [iv addSubview:see];
    see.on = [self.user.notSeeHim boolValue];


}


- (void)notLookHisCircleAndVideo:(UISwitch *)switchButton {
    NSNumber *shieldType;
    if (switchButton.tag == 1000) {
        // 不让他看
        shieldType = @1;
        self.user.notLetSeeHim = [NSNumber numberWithBool:switchButton.isOn];
    }else if (switchButton.tag == 1001) {
        // 不看他
        shieldType = @-1;
        self.user.notSeeHim = [NSNumber numberWithBool:switchButton.isOn];
    }
    
    
    
    
//    NSMutableArray *mutArr = g_server.myself.filterCircleUserIds.mutableCopy;
//    BOOL haveTheUserId = [g_server.myself.filterCircleUserIds containsObject:[NSNumber numberWithInt:[self.userId intValue]]];
//    if (haveTheUserId && !switchButton.isOn) {
//        [mutArr removeObject:[NSNumber numberWithInt:[self.userId intValue]]];
//    }else if (!haveTheUserId && switchButton.isOn){
//        [mutArr addObject:[NSNumber numberWithInt:[self.userId intValue]]];
//    }
//    g_server.myself.filterCircleUserIds = mutArr;
    // 不看他(她)生活圈和视频
    [g_server filterUserCircle:self.user.userId shieldType:shieldType type:switchButton.isOn ? @1 : @-1 toView:self];

}



-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if([aDownload.action isEqualToString:act_filterUserCircle]){
        [_wait stop];
    }
}

-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    return show_error;
}

-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    return show_error;
}

-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}




-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom must:(BOOL)must click:(SEL)click superView:(UIView *)superView{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
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
    
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(15, 0, 200, HEIGHT)];
    p.text = title;
    p.font = g_factory.font16;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [UIColor blackColor];
    [btn addSubview:p];
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(15,0,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(15,HEIGHT-LINE_WH,TFJunYou__SCREEN_WIDTH-15,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    
    if(click){
        btn.frame = CGRectMake(btn.frame.origin.x -20, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
        
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
    }
    return btn;
}

@end
