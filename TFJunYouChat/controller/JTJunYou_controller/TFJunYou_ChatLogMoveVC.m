//
//  TFJunYou_ChatLogMoveVC.m
//  TFJunYouChat
//
//  Created by p on 2019/6/5.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_ChatLogMoveVC.h"
#import "TFJunYou_ChatLogMoveSelectVC.h"

@interface TFJunYou_ChatLogMoveVC ()

@end

@implementation TFJunYou_ChatLogMoveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isGotoBack = YES;
    self.title = Localized(@"JX_ChatLogMove");
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    [self createHeadAndFoot];
        
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 128 + 24, TFJunYou__SCREEN_WIDTH, 15)];
    title.font = [UIFont systemFontOfSize:14];

    title.textAlignment = NSTextAlignmentCenter;
    title.text = Localized(@"JX_ChatLogMoveToDevice");
    [self.tableBody addSubview:title];
    
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame) + 12, TFJunYou__SCREEN_WIDTH, 14)];
    subTitle.font = [UIFont systemFontOfSize:13];
    subTitle.textColor = [UIColor lightGrayColor];
    subTitle.textAlignment = NSTextAlignmentCenter;
    subTitle.text = Localized(@"JX_TwoDeviceConnectWIFI");
    [self.tableBody addSubview:subTitle];
    
    UIButton *btn = [UIFactory createCommonButton:Localized(@"JX_MoveChatRecords") target:self action:@selector(onMove)];
    [btn setBackgroundImage:nil forState:UIControlStateHighlighted];
    btn.custom_acceptEventInterval = 1.f;
    [btn.titleLabel setFont:SYSFONT(15)];
    btn.frame = CGRectMake(62,CGRectGetMaxY(subTitle.frame) + 39, TFJunYou__SCREEN_WIDTH- 62*2, 40);
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 7.f;
    btn.backgroundColor = THEMECOLOR;
    [self.tableBody addSubview:btn];
    
    
}

- (void)onMove {
    
    TFJunYou_ChatLogMoveSelectVC *vc = [[TFJunYou_ChatLogMoveSelectVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
    
    [self actionQuit];
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
