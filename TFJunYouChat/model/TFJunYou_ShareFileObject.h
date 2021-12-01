//
//  TFJunYou_ShareFileObject.h
//  TFJunYouChat
//
//  Created by 1 on 17/7/6.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_ShareFileObject : NSObject

@property (nonatomic,copy) NSString * createUserName;
@property (nonatomic,copy) NSString * roomId;
@property (nonatomic,copy) NSString * shareId;
@property (nonatomic,copy) NSNumber * size;
@property (nonatomic,copy) NSNumber * time;
@property (nonatomic,copy) NSNumber * type;
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * fileName;

+(TFJunYou_ShareFileObject *)shareFileWithDict:(NSDictionary *)dict;

@end
