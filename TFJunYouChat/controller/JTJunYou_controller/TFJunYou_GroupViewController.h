//
//  TFJunYou_GroupViewController
//  BaseProject
//
//  Created by Huan Cho on 13-8-3.
//  Copyright (c) 2013年 ch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_TableViewController.h"
#import "TFJunYou_TopSiftJobView.h"

@protocol XMPPRoomDelegate;
@class TFJunYou_RoomObject;
@class menuImageView;

@interface TFJunYou_GroupViewController : TFJunYou_TableViewController{
    
    int _refreshCount;
    int _recordCount;

    NSString* _roomJid;
    TFJunYou_RoomObject *_chatRoom;
    UITextField* _inputText;

    menuImageView* _tb;
    UIScrollView * _scrollView;
    int _selMenu;
    TFJunYou_TopSiftJobView *_topSiftView; //表头筛选控件
//    UIButton * _myRoomBtn;
//    UIButton * _allRoomBtn;
//    UIView *_topScrollLine;
//    int _sel;
}
@property (nonatomic,strong) NSMutableArray * array;
@property (assign,nonatomic) int sel;

//- (void)actionNewRoom;
//- (void)reconnectToRoom;
@end
