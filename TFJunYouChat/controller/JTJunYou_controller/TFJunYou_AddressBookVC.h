//
//  TFJunYou_AddressBookVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/30.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"

@interface TFJunYou_AddressBookVC : TFJunYou_TableViewController

@property(nonatomic,strong)NSMutableArray *array;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic, strong)NSMutableArray *abUreadArr;

@end
