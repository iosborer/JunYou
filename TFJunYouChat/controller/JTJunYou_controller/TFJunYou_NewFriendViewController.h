//
//  TFJunYou_NewFriendViewController.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>

@class TFJunYou_FriendObject;
@class TFJunYou_FriendCell;

@interface TFJunYou_NewFriendViewController: TFJunYou_TableViewController<UITextFieldDelegate>{
    NSMutableArray* _array;
    int _refreshCount;
    TFJunYou_FriendObject *_user;
    NSMutableDictionary* poolCell;
    int _friendStatus;
    TFJunYou_FriendCell* _cell;
}

@end
