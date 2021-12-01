//
//  TFJunYou_SelectorVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/26.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
@class TFJunYou_SelectorVC;

@protocol TFJunYou_SelectorVCDelegate <NSObject>

- (void) selector:(TFJunYou_SelectorVC*)selector selectorAction:(NSInteger)selectIndex;

@end

@interface TFJunYou_SelectorVC : TFJunYou_TableViewController

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) SEL didSelected;

@property (nonatomic, weak) id<TFJunYou_SelectorVCDelegate> selectorDelegate;

@end
