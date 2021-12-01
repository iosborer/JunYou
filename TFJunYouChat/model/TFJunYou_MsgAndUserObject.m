//
//  TFJunYou_MsgAndUserObject.m
//
//  Created by Reese on 13-8-15.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "TFJunYou_MsgAndUserObject.h"

@implementation TFJunYou_MsgAndUserObject
@synthesize message,user;


+(TFJunYou_MsgAndUserObject *)unionWithMessage:(TFJunYou_MessageObject *)aMessage andUser:(TFJunYou_UserObject *)aUser
{
    TFJunYou_MsgAndUserObject *unionObject=[[TFJunYou_MsgAndUserObject alloc]init];
    unionObject.user = aUser;
    unionObject.message = aMessage;
//    NSLog(@"%d,%d",aMessage.retainCount,aUser.retainCount);
    return unionObject;
}

-(void)dealloc{
//    NSLog(@"TFJunYou_MsgAndUserObject.dealloc");
    self.user = nil;
    self.message = nil;
//    [super dealloc];
}



@end
