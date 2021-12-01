//
//  TFJunYou__SelectMenuView.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/12.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFJunYou__SelectMenuView;

@protocol TFJunYou_SelectMenuViewDelegate <NSObject>

- (void)didMenuView:(TFJunYou__SelectMenuView *)MenuView WithIndex:(NSInteger)index;

@end

@interface TFJunYou__SelectMenuView : UIView

@property (nonatomic, weak) id<TFJunYou_SelectMenuViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *sels;

- (instancetype)initWithTitle:(NSArray *)titleArr image:(NSArray *)images cellHeight:(int)height;


// 隐藏
- (void)hide;

@end
