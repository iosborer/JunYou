//
//  TFJunYou_GroupHeplerModel.h
//  TFJunYouChat
//
//  Created by 1 on 2019/5/29.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFJunYou_HelperModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_GroupHeplerModel : NSObject

@property (nonatomic, strong) TFJunYou_HelperModel *helperModel;
@property (nonatomic, strong) NSString *helperId;// 群助手列表id
@property (nonatomic, strong) NSString *groupHelperId; // 添加到群的群助手id
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *roomJid;
@property (nonatomic, strong) NSString *userId;

//keywords
@property (nonatomic, strong) NSArray *keywords;


- (void)getDataWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
