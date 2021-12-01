//
//  TFJunYou_CommonInputVC.h
//  TFJunYouChat
//
//  Created by p on 2019/4/1.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TFJunYou_CommonInputVC;

@protocol TFJunYou_CommonInputVCDelegate <NSObject>

- (void)commonInputVCBtnActionWithVC:(TFJunYou_CommonInputVC *)commonInputVC;

@end

@interface TFJunYou_CommonInputVC : TFJunYou_admobViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,copy) NSString *tip;
@property (nonatomic,copy) NSString *btnTitle;
@property (nonatomic, strong) UITextField *name;
@property (nonatomic, weak) id<TFJunYou_CommonInputVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
