//
//  TFJunYou_ShareModel.h
//  TFJunYouChat
//
//  Created by MacZ on 16/8/22.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TFJunYou_ShareToWechatSesion,
    TFJunYou_ShareToWechatTimeline,
    TFJunYou_ShareToSina,
    TFJunYou_ShareToFaceBook,
    TFJunYou_ShareToTwitter,
    TFJunYou_ShareToWhatsapp,
    TFJunYou_ShareToSMS,
    TFJunYou_ShareToLine,
} TFJunYou_ShareTo;

@interface TFJunYou_ShareModel : NSObject

@property (nonatomic,assign) TFJunYou_ShareTo shareTo;
@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *shareContent;
@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic,strong) UIImage *shareImage;
@property (nonatomic,copy) NSString *shareImageUrl;

@end
