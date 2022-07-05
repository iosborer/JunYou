//
//  TFJunYou_FreezeNoCodeVc.m
//  TFJunYouChat
//
//  Created by os on 2021/2/6.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_FreezeNoCodeVc.h"
#import "TFJunYou_FreezeNoCodeSendVc.h"

@interface TFJunYou_FreezeNoCodeVc ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHHH;
@property (weak, nonatomic) IBOutlet UIButton *areaNoBtn;
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;

@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UITextField *tf_card;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

@implementation TFJunYou_FreezeNoCodeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    self.title = [NSString stringWithFormat:@"%@%@号", _type == FreezeTypeBlocking ? @"冻结" : @"解冻", app_name];
    self.tableBody.frame = CGRectZero;
    _constraintHHH.constant = 44;
    _nextBtn.layer.cornerRadius = 5;
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

 
- (void)nextBtnClick:(UIButton *)sender {
    if (_tf_phone.text.length < 1) {
        [g_App showAlert:@"请输入手机号"];
        return;
    }
    if (_tf_name.text.length < 1) {
        [g_App showAlert:@"请输入姓名"];
        return;
    }
    
    if (_tf_card.text.length < 18) {
        [g_App showAlert:@"请输入正确的证件号"];
        return;
    }

    
    TFJunYou_FreezeNoCodeSendVc *vc =[TFJunYou_FreezeNoCodeSendVc new];
    vc.IDCard = _tf_card.text;
    vc.phone = _tf_phone.text;
    vc.name = _tf_name.text;
    vc.type = _type;
    [g_navigation pushViewController:vc animated:YES];
}

@end
