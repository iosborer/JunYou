//
//  TFJunYou_ReadListCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/2.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFJunYou_ReadListCell : UITableViewCell

@property (nonatomic, assign) int index;
@property (nonatomic, assign) NSObject* delegate;
@property (nonatomic, assign) SEL		didTouch;
@property (nonatomic, strong) roomData *room;

- (void) setData:(TFJunYou_UserObject *)obj;

@end
