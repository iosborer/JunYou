//
//  TFJunYou_SelectGroupSendVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/14.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import "TFJunYou_TableViewController.h"

#define SELECTGroup Localized(@"JX_SelectGroup")
#define SELECTColleague Localized(@"JX_ChooseColleagues")
#define SELECTMaillist Localized(@"JX_SelectPhoneContact")
NS_ASSUME_NONNULL_BEGIN
@class TFJunYou_SelectGroupSendVC;
@protocol TFJunYou_SelectGroupSendVCDelegate <NSObject>

- (void)selectVC:(TFJunYou_SelectGroupSendVC *)selectLabelsVC selectArray:(NSMutableArray *)array;

@end

@interface TFJunYou_SelectGroupSendVC : TFJunYou_TableViewController
@property (nonatomic,strong)NSString *titleString;
@property (nonatomic,weak) id<TFJunYou_SelectGroupSendVCDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *seletedArray;
- (instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
