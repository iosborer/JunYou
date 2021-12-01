//
//  TFJunYou_ChatLogMoveActionVC.m
//  TFJunYouChat
//
//  Created by p on 2019/6/11.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_ChatLogMoveActionVC.h"

@interface TFJunYou_ChatLogMoveActionVC ()

@end

@implementation TFJunYou_ChatLogMoveActionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isGotoBack = YES;
    self.title = Localized(@"JX_ChatLogMove");
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    [self createHeadAndFoot];
    
    [_wait start:Localized(@"JX_Migrating")];
}

- (void)moveActionFinish {
    
    [self actionQuit];
    
    [TFJunYou_MyTools showTipView:Localized(@"JX_ChatLogReceivingCompleted")];
}

- (void)actionQuit {
 
    [_wait stop];
    
    [super actionQuit];
    
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
