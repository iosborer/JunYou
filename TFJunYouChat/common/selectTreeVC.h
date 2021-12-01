//
//  selectTreeVC.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>
@class menuImageView;

@interface selectTreeVC: TFJunYou_TableViewController{
    NSMutableArray* _names;
    NSMutableArray* _ids;
    NSMutableArray* _typeNames;
    NSMutableArray* _typeIds;
    int _refreshCount;
}
@property(assign)int parentId;
@property(strong,nonatomic) NSString* parentName;
@property(nonatomic,assign) int selected;
@property(nonatomic,assign) int selNumber;
@property(nonatomic,strong) NSString* selValue;
@property(nonatomic,weak) id delegate;
@property(assign) SEL didSelect;
@property(assign) BOOL hasSubtree;
@property(nonatomic,strong) NSMutableArray* selNames;
@property(nonatomic,strong) NSMutableArray* selIds;
@end
