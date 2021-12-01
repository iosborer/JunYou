//
//  TFJunYou_SettingsCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/5/6.
//  Copyright © 2020 zengwOS. All rights reserved.
//  好友验证设置

#import <UIKit/UIKit.h>
@class TFJunYou_SettingsViewController;

@interface TFJunYou_SettingsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
//@property (strong, nonatomic) IBOutlet UISwitch *mySwitch;
@property (strong, nonatomic) UISwitch *mySwitch;

@property (strong,nonatomic) TFJunYou_SettingsViewController * inTableView;

@property (strong,nonatomic) NSString * att;
@property (strong,nonatomic) NSString * greet;
@property (strong,nonatomic) NSString * friends;

@property (nonatomic, strong) UIView *line;


@property (nonatomic,assign) void (^block)(BOOL,int);
@end
