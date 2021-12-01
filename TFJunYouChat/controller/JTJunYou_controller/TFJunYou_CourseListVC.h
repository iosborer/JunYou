//
//  TFJunYou_CourseListVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/10/20.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_TableViewController.h"

@interface TFJunYou_CourseListVC : TFJunYou_TableViewController

@property (nonatomic, assign) int selNum;

- (NSInteger)getSelNum:(NSInteger)num indexNum:(NSInteger)indexNum;

@end
