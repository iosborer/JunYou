//
//  TFJunYou_SelectAddressBookVC.h
//  TFJunYouChat
//
//  Created by p on 2019/4/3.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TFJunYou_SelectAddressBookVC;

@protocol TFJunYou_SelectAddressBookVCDelegate <NSObject>

- (void)selectAddressBookVC:(TFJunYou_SelectAddressBookVC *)selectVC doneAction:(NSArray *)array;

@end

@interface TFJunYou_SelectAddressBookVC : TFJunYou_TableViewController

@property (nonatomic, weak) id<TFJunYou_SelectAddressBookVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
