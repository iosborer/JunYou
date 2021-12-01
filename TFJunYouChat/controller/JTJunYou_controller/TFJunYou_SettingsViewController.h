//
//  TFJunYou_SettingsViewController.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/5/6.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_SettingsCell.h"

@interface TFJunYou_SettingsViewController : TFJunYou_admobViewController <UITableViewDataSource,UITableViewDelegate>{
    TFJunYou_SettingsViewController* _pSelf;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) NSDictionary * dataSorce;

@property (strong, nonatomic) NSString * att;
@property (strong, nonatomic) NSString * greet;
@property (strong, nonatomic) NSString * friends;
@property (assign, nonatomic) BOOL isEncrypt;
@end
