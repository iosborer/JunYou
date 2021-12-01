//
//  TFJunYou_CommonService.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/11/9.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_CommonService : NSObject

@property (nonatomic, strong) NSTimer *courseTimer;

- (void)sendCourse:(TFJunYou_MsgAndUserObject *)obj Array:(NSArray *)array;

@end
