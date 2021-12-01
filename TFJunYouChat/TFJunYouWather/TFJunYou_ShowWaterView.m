//
//  TFJunYou_ShowWaterView.m
//  TFJunYouChat
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_ShowWaterView.h"

@implementation TFJunYou_ShowWaterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(void)showView{
    TFJunYou_ShowWaterView *show=[[TFJunYou_ShowWaterView alloc]init];
    show.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.3];
    show.frame=[UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:show];
    
}

- (IBAction)closeBtn:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"33000"];
     [self removeFromSuperview];
     [self removeFromSuperview];
}
@end
