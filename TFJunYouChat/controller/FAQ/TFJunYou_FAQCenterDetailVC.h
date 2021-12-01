//
//  TFJunYou_FAQCenterDetailVC.h
//  TFJunYouChat
//
//  Created by JayLuo on 2021/2/8.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_FAQCenterDetailModel : NSObject
/// 内容
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *id;
/// 标题
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *type;
@end

@interface TFJunYou_FAQCenterDetailVC : TFJunYou_admobViewController
@property(nonatomic, assign) int type;
@end

NS_ASSUME_NONNULL_END
