//
//  TFJunYou_SearchFileLogVC.h
//  TFJunYouChat
//
//  Created by p on 2019/4/8.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FileLogType_file,
    FileLogType_Link,
    FileLogType_transact,
} FileLogType;

@interface TFJunYou_SearchFileLogVC : TFJunYou_TableViewController

@property (nonatomic, assign) FileLogType type;

@property (nonatomic, strong) TFJunYou_UserObject *user;

@property (nonatomic, assign) BOOL isGroup;

@end

NS_ASSUME_NONNULL_END
