//
//  TFJunYou_WhoCanSeeCell.h
//  TFJunYouChat
//
//  Created by p on 2018/6/27.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFJunYou_WhoCanSeeCell;
@protocol TFJunYou_WhoCanSeeCellDelegate <NSObject>

- (void)whoCanSeeCell:(TFJunYou_WhoCanSeeCell *)whoCanSeeCell selectAction:(NSInteger)index;
- (void)whoCanSeeCell:(TFJunYou_WhoCanSeeCell *)whoCanSeeCell editBtnAction:(NSInteger)index;

@end

@interface TFJunYou_WhoCanSeeCell : UITableViewCell
@property (nonatomic, strong) UIButton *contentBtn;
@property (nonatomic, strong) UIImageView *selImageView;
@property (nonatomic, strong) TFJunYou_Label *title;
@property (nonatomic, strong) TFJunYou_Label *userNames;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, weak) id<TFJunYou_WhoCanSeeCellDelegate>delegate;
@property (nonatomic, assign) NSInteger index;
@end
