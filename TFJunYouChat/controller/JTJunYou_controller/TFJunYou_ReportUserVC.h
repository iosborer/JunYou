//
//  TFJunYou_ReportUserVC.h
//  TFJunYouChat
//
//  Created by 1 on 17/6/26.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_TableViewController.h"

@protocol TFJunYou_ReportUserDelegate <NSObject>

-(void)report:(TFJunYou_UserObject *)reportUser reasonId:(NSNumber *)reasonId;

@end

@interface TFJunYou_ReportUserVC : TFJunYou_TableViewController

@property (nonatomic, strong) TFJunYou_UserObject * user;

@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) BOOL isUrl;


@end
