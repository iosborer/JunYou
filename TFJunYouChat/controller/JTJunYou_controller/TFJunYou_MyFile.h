//
//  TFJunYou_MyFile.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>
@class menuImageView;
@class TFJunYou_RoomObject;

@interface TFJunYou_MyFile: TFJunYou_TableViewController{
    NSMutableArray* _array;
    int _refreshCount;
    menuImageView* _tb;
    UIView* _topView;
    int _selMenu;
    
}
@property (nonatomic, weak) NSObject* delegate;
@property (nonatomic, assign) SEL		didSelect;

@end
