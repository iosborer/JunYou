//
//  TFJunYou_ProgressVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/10.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

@interface TFJunYou_ProgressVC : TFJunYou_admobViewController
@property (nonatomic,strong) UIProgressView * progressView;//进度条
@property (nonatomic,strong) UILabel * progressLabel;//进度
@property (nonatomic,strong) NSArray * dataArray;//数据
@property (nonatomic,assign) long dbFriends;
@property (nonatomic,strong) UILabel * dbCountLabel;
@property (nonatomic,strong) UILabel * sysCountLabel;
@property (nonatomic,strong) UIButton * comBtn;
@end
