//
//  TFJunYou_FriendViewController.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>
#import "TFJunYou_TopSiftJobView.h"

@class menuImageView;

@interface TFJunYou_FriendViewController: TFJunYou_TableViewController{
    NSMutableArray* _array;
    int _refreshCount;
    menuImageView* _tb;
    UIView* _topView;
    int _selMenu;
//    UIButton * _myFriendsBtn;
//    UIButton * _listAttentionBtn;
    UIView *_topScrollLine;
    NSMutableArray * _friendArray;
    TFJunYou_TopSiftJobView *_topSiftView; //表头筛选控件
    UIView *backView;
}

@property (nonatomic,assign) BOOL isOneInit;
@property (nonatomic,assign) BOOL isMyGoIn; // 是从我界面 进入

- (void) showNewMsgCount:(NSInteger)friendNewMsgNum;

@end
