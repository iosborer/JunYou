//
//  TFJunYou_RoomMember.h
//  TFJunYouChat
//
//  Created by 1 on 17/6/27.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_RoomMember : NSObject{
    NSString* _tableName;
}


//@property (nonatomic, strong) TFJunYou_UserObject * user;
@property (nonatomic, strong) NSString * roomId;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * cardName;
@property (nonatomic, assign) NSUInteger isAdmin;

@end
