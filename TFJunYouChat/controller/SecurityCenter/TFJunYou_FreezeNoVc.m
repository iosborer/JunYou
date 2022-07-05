//
//  TFJunYou_FreezeNoVc.m
//  TFJunYouChat
//
//  Created by os on 2021/2/6.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_FreezeNoVc.h"
#import "TFJunYou_FreezeNoCodeVc.h"

@interface TFJunYou_FreezeNoVc ()

@end

@implementation TFJunYou_FreezeNoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    
    self.title = [NSString stringWithFormat:@"冻结%@号", app_name];
    self.tableBody.backgroundColor = THEMEBACKCOLOR;
    
    UIImageView *iconImg = [[UIImageView alloc]init];
    iconImg.image = [UIImage imageNamed:@"ALOGO_120"];
    [self.tableBody addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableBody.mas_centerX);
        make.top.mas_equalTo(30);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [NSString stringWithFormat: @"遇到%@被盗或手机遗失，你可以申请冻结账号", app_name];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.tableBody addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableBody.mas_centerX);
        make.top.mas_equalTo(iconImg.mas_bottom).mas_offset(30);
    }];
    
    UILabel *subLabel = [[UILabel alloc]init];
    subLabel.text = @"防止不法分子盗取您的信息\n防止不法分子假借您的身份进行违法行为\n防止不法分子盗取您的账户资金";
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.textColor = [UIColor lightGrayColor];
    subLabel.numberOfLines = 0;
    subLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self.tableBody addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.centerX.mas_equalTo(self.tableBody.mas_centerX);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(20);
    }];
    
    UIButton *sumitBtn = [[UIButton alloc]init];
    sumitBtn.layer.cornerRadius = 5;
    sumitBtn.layer.masksToBounds = YES;
    sumitBtn.backgroundColor = RGB(69, 129, 246);
    [sumitBtn setTitle:@"开始冻结" forState:0];
    [self.tableBody addSubview:sumitBtn];
    [sumitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(subLabel.mas_bottom).mas_offset(20);
    }];
    
    [sumitBtn addTarget:self action:@selector(sumitBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
 
- (void)sumitBtnClick {
    
    TFJunYou_FreezeNoCodeVc *vc = [TFJunYou_FreezeNoCodeVc new];
    vc.type = FreezeTypeBlocking;
    [g_navigation pushViewController:vc animated:YES];
}

@end
