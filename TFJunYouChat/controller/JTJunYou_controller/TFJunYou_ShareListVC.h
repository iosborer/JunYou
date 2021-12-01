//
//  TFJunYou_ShareSelectView.h
//  TFJunYouChat
//
//  Created by MacZ on 15/8/26.
//  Copyright (c) 2015年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
#import <UIKit/UIKit.h>

#import "TFJunYou_ShareModel.h"

@protocol ShareListDelegate <NSObject>

- (void)didShareBtnClick:(UIButton *)shareBtn;

@end

@interface TFJunYou_ShareListVC : UIViewController{
    UIView *_listView;
    
    TFJunYou_ShareListVC *_pSelf;
}

@property (nonatomic,weak) id<ShareListDelegate> shareListDelegate;

- (void)showShareView;

@end
