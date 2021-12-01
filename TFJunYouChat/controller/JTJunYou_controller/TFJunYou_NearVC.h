//
//  TFJunYou_NearVC.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

//#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>

@class searchData;
@class TFJunYou_LocMapVC;
@class TFJunYou_GooMapVC;
@interface TFJunYou_NearVC: TFJunYou_admobViewController{
    NSMutableArray* _array;
    int _refreshCount;

    UIView* _topView;
    UIButton* _apply;
    UILabel* _lb;
    //searchData* _search;
    //BOOL _bNearOnly;
}
@property (nonatomic,strong)searchData *search;
@property (nonatomic,assign)BOOL bNearOnly;
@property (nonatomic,assign)int page;
@property (nonatomic,assign)BOOL isSearch;

@property (nonatomic,strong) TFJunYou_LocMapVC * mapVC;
@property (nonatomic,strong) TFJunYou_GooMapVC * goomapVC;

-(void)onSearch;
-(void)getServerData;
-(void)doSearch:(searchData*)p;
@end
