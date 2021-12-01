//
//  selectAreaVC.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>
@class menuImageView;

@interface selectAreaVC: TFJunYou_TableViewController{
    NSMutableDictionary* _array;
    NSArray* _keys;
    int _refreshCount;
    int _selMenu;
}
@property(assign)int parentId;
@property(nonatomic,strong)NSString* parentName;
@property(nonatomic,assign) int selected;
@property(nonatomic,strong) NSString* selValue;
@property(nonatomic,weak) id delegate;
@property(assign) SEL didSelect;
@end
