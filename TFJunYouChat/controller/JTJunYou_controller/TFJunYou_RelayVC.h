//
//  TFJunYou_RelayVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/6/27.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import "TFJunYou_ChatViewController.h"

@class TFJunYou_RelayVC;
@protocol TFJunYou_RelayVCDelegate <NSObject>

@optional

- (void)relay:(TFJunYou_RelayVC *)relayVC MsgAndUserObject:(TFJunYou_MsgAndUserObject *)obj;

- (void)shareSuccess;

@end

@interface TFJunYou_RelayVC : TFJunYou_TableViewController

//@property (nonatomic, strong) TFJunYou_MessageObject *msg;
@property (nonatomic, strong) NSMutableArray *relayMsgArray;

@property (nonatomic, assign) BOOL isCourse;
@property (nonatomic, weak) id<TFJunYou_RelayVCDelegate> relayDelegate;

@property (nonatomic, strong) TFJunYou_UserObject *chatPerson;
@property (nonatomic,copy) NSString *roomJid;

@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, copy) NSString *shareSchemes;
@property (nonatomic, assign) BOOL isUrl;
@property (nonatomic, assign) BOOL isMoreSel;
@property (nonatomic, weak) TFJunYou_ChatViewController *chatVC; ;


@end
