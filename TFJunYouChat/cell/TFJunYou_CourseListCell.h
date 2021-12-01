//
//  TFJunYou_CourseListCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/10/20.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_CourseListVC.h"

typedef int(^TFJunYou_CourseListCellBlock)(int type);

@interface TFJunYou_CourseListCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) TFJunYou_CourseListVC *vc;
@property (nonatomic, assign) TFJunYou_CourseListCellBlock block;
@property (nonatomic, assign) BOOL isMultiselect;
@property (nonatomic, assign) NSInteger indexNum;

@property (nonatomic, strong) UIButton *multiselectBtn;

- (void) setData:(NSDictionary *)dict;

@end
