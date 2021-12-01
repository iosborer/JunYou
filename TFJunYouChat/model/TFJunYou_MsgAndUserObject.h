//
//  TFJunYou_MsgAndUserObject.h
//
//  Created by Reese on 13-8-15.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_MsgAndUserObject : NSObject
@property (nonatomic,strong) TFJunYou_MessageObject* message;
@property (nonatomic,strong) TFJunYou_UserObject* user;

+(TFJunYou_MsgAndUserObject *)unionWithMessage:(TFJunYou_MessageObject *)aMessage andUser:(TFJunYou_UserObject *)aUser;
@end
