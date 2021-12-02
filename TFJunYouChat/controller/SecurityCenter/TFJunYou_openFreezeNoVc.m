//
//  TFJunYou_FreezeNoVc.m
//  TFJunYouChat
//
//  Created by os on 2021/2/6.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_openFreezeNoVc.h"
#import "TFJunYou_FreezeNoCodeVc.h"

@interface TFJunYou_openFreezeNoVc ()

@end

@implementation TFJunYou_openFreezeNoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    
    self.title = @"解冻eBay号";
    self.tableBody.backgroundColor = THEMEBACKCOLOR;
    
    UIImageView *iconImg = [[UIImageView alloc]init];
    iconImg.image = [UIImage imageNamed:@"ALOGO_120"];
    [self.tableBody addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableBody.mas_centerX);
        make.top.mas_equalTo(30);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"安全问题解决后，您可以申请解冻eBay账号";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.tableBody addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tableBody.mas_centerX);
        make.top.mas_equalTo(iconImg.mas_bottom).mas_offset(30);
    }];
    
    UILabel *subLabel = [[UILabel alloc]init];
    subLabel.text = @"检查手机有没有被植入病毒\n不要随便向外人泄漏个人信息";
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
    [sumitBtn setTitle:@"开始解冻" forState:0];
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
    vc.type = FreezeTypeUnblocked;
    [g_navigation pushViewController:vc animated:YES];
}

@end
