//
//  TFJunYou_ActionSheetVC.h
//  TFJunYouChat
//
//  Created by 1 on 2018/9/3.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFJunYou_ActionSheetVC;

@protocol TFJunYou_ActionSheetVCDelegate <NSObject>

/**
 
  控件点击事件index从 0 开始,从下到上
 
 */
- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index;

@end

@interface TFJunYou_ActionSheetVC : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) UIColor *backGroundColor;
@property (nonatomic, weak) id<TFJunYou_ActionSheetVCDelegate>delegate;


- (instancetype)initWithImages:(NSArray *)images names:(NSArray *)names;
    
@end
