//
// Created by yaxiongfang on 4/8/16.
// Copyright (c) 2016 yxfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringUtils.h"
#import "Tools.h"
#import "UserDefaultsUtils.h"
#import "TFJunYouChat_MainNoteVc.h"
 
#import "NoteFolder.h"


@interface AddFolderView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextField *edtName;
@property (weak, nonatomic) IBOutlet UISwitch *switchPrivate;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@property(nonatomic, strong) TFJunYouChat_MainNoteVc *controller;

-(void)init:(UIViewController *)controller andFrame:(CGRect)frame folder:(NoteFolder *) folder;

@end
