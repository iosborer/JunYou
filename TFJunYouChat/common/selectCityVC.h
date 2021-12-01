//
//  selectCityVC.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>
@class menuImageView;

@interface selectCityVC: TFJunYou_TableViewController{
    NSMutableDictionary* _array;
    NSArray* _keys;
    int _refreshCount;
}
@property(assign)int parentId;
@property(strong,nonatomic)NSString* parentName;
@property(nonatomic,assign) BOOL showArea;
@property(nonatomic,assign) int selected;
@property(nonatomic,strong) NSString* selValue;
@property(nonatomic,weak) id delegate;
@property(assign) SEL didSelect;
@property(nonatomic,assign) int cityId;
@property(nonatomic,assign) int areaId;
@end
