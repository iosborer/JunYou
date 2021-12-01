//
//  TFJunYou_SelectLabelsVC.h
//  TFJunYouChat
//
//  Created by p on 2018/7/19.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"

@class TFJunYou_SelectLabelsVC;
@protocol TFJunYou_SelectLabelsVCDelegate <NSObject>

- (void)selectLabelsVC:(TFJunYou_SelectLabelsVC *)selectLabelsVC selectLabelsArray:(NSMutableArray *)array;

@end

@interface TFJunYou_SelectLabelsVC : TFJunYou_TableViewController

@property (nonatomic, strong) NSMutableArray *selLabels;

@property (nonatomic, weak) id<TFJunYou_SelectLabelsVCDelegate>delegate;

@end
