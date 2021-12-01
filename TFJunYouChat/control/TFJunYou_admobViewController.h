//
//  TFJunYou_admobViewController.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/15.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@class AppDelegate;
@class TFJunYou_ImageView;
@class TFJunYou_Label;

@interface TFJunYou_admobViewController : UIViewController{
    ATMHud* _wait;
//    TFJunYou_admobViewController* _pSelf;
}
@property(nonatomic,retain,setter = setLeftBarButtonItem:)  UIBarButtonItem *leftBarButtonItem;
@property(nonatomic,retain,setter = setRightBarButtonItem:) UIBarButtonItem *rightBarButtonItem;
@property(nonatomic,assign) BOOL isGotoBack;
@property(nonatomic,assign) BOOL isFreeOnClose;
@property(nonatomic,strong) UIView *tableHeader;
@property(nonatomic,strong) UIView *tableFooter;
@property(nonatomic,strong) UIScrollView *tableBody;
@property(nonatomic,assign) int heightHeader;
@property(nonatomic,assign) int heightFooter;
@property(nonatomic,strong) UIButton *footerBtnMid;
@property(nonatomic,strong) UIButton *footerBtnLeft;
@property(nonatomic,strong) UIButton *footerBtnRight;
@property(nonatomic,strong) TFJunYou_Label  *headerTitle;

-(void)createHeadAndFoot;
-(void)actionQuit;
-(void)onGotoHome;

-(void)createHeadAndFootCancel:(NSString *)title colorStr:(UIColor *)backColor;
@end
