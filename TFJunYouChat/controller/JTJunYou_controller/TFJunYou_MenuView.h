//
//  TFJunYou_MenuView.h
//  TFJunYouChat
//
//  Created by 1 on 2018/9/6.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFJunYou_MenuView;

@protocol TFJunYou_MenuViewDelegate <NSObject>

- (void)didMenuView:(TFJunYou_MenuView *)menuView WithButtonIndex:(NSInteger)index;

@end

@interface TFJunYou_MenuView : UIView

@property (nonatomic, weak) id<TFJunYou_MenuViewDelegate>delegate;

@property (nonatomic, strong) NSArray *titles;


/**
 
暂为weiboVC 专用控件
Point (.x 暂时无效)

 */

//  创建
- (instancetype)initWithPoint:(CGPoint)point Title:(NSArray *)titles Images:(NSArray *)images;

//  隐藏
- (void)dismissBaseView;


@end
