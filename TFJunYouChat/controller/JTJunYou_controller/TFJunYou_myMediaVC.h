//
//  TFJunYou_myMediaVC.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>
@class menuImageView;
@class TFJunYou_MediaCell;

@interface TFJunYou_myMediaVC: TFJunYou_TableViewController{
    NSMutableArray* _array;
    int _refreshCount;
    TFJunYou_MediaCell* _cell;
}
@property(nonatomic,weak) id delegate;
@property(assign) SEL didSelect;
- (void) onAddVideo;

@end
