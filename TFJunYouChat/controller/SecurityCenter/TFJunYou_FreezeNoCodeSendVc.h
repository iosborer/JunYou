//
//  TFJunYou_FreezeNoCodeSendVc.h
//  TFJunYouChat
//
//  Created by os on 2021/2/6.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,FreezeType) {
    FreezeTypeBlocking, // 冻结账号
    FreezeTypeUnblocked, // 解冻账号
};

@interface TFJunYou_FreezeNoCodeSendVc : TFJunYou_admobViewController
@property(nonatomic, strong) NSString *IDCard;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) FreezeType type;

@end

NS_ASSUME_NONNULL_END
