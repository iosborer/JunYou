//
//  TFJunYou_SearchUserVC.h
//  TFJunYouChat
//
//  Created by flyeagleTang on 14-6-10.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
@class searchData;


typedef NS_ENUM(NSInteger, TFJunYou_SearchType) {
    TFJunYou_SearchTypeUser,           // 好友
    TFJunYou_SearchTypePublicNumber,   // 公众号
};


@interface TFJunYou_SearchUserVC : TFJunYou_admobViewController{
    UITextField* _name;
    UITextField* _minAge;
    UITextField* _maxAge;
    UILabel* _date;
    UILabel* _sex;
    UILabel* _industry;
    UILabel* _function;
    
    UIImage* _image;
    TFJunYou_ImageView* _head;
    
    NSMutableArray* _values;
    NSMutableArray* _numbers;
}

@property (nonatomic, assign) TFJunYou_SearchType type;
@property (nonatomic,strong) searchData* job;
@property(nonatomic,weak) id delegate;
@property(assign) SEL didSelect;


@end
