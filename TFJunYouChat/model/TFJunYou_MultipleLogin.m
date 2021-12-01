//
//  TFJunYou_MultipleLogin.m
//  TFJunYouChat
//
//  Created by p on 2018/5/22.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_MultipleLogin.h"
#import "TFJunYou_Device.h"

@implementation TFJunYou_MultipleLogin


static TFJunYou_MultipleLogin *sharedManager;

+(TFJunYou_MultipleLogin*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TFJunYou_MultipleLogin alloc] init];
    });
    
    return sharedManager;
}

-(id)init{
    self = [super init];
    if (self) {
        _deviceArr = [[TFJunYou_Device sharedInstance] fetchAllDeviceFromLocal];
    }
    
    return self;
}

// 发送上线消息，通知其他端自己上线
- (void)sendOnlineMessage {
    TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    msg.content = @"1";
    
    msg.toUserId     = MY_USER_ID;
    msg.type         = [NSNumber numberWithInt:kWCMessageTypeMultipleLogin];
    [g_xmpp sendMessage:msg roomName:nil];//发送消息
}
// 发送下线消息，通知其他端自己下线
- (void)sendOfflineMessage{
    TFJunYou_MessageObject *msg=[[TFJunYou_MessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    msg.content = @"0";
    
    msg.toUserId     = MY_USER_ID;
    msg.type         = [NSNumber numberWithInt:kWCMessageTypeMultipleLogin];
    [g_xmpp sendMessage:msg roomName:nil];//发送消息
}

// 收到登录验证回执或收到200消息,判断其他端是否在线
- (void)upDateOtherOnline:(XMPPMessage *)message isOnLine:(NSNumber *)isOnLine{
    
    NSString *from;
    //    NSString *to = [message toStr];
    NSRange range = [from rangeOfString:@"/"];
    if (range.location != NSNotFound) {
        NSString *str = [from substringFromIndex:range.location + 1];
        
        // 如果是自己端给的回执，不做处理
        if ([str isEqualToString:@"ios"] || !str) {
            return;
        }
        
        for (TFJunYou_Device *device in _deviceArr) {
            if ([device.userId rangeOfString:str].location != NSNotFound) {
                [device updateIsOnLine:isOnLine userId:device.userId];
                [device updateIsSendRecipt:isOnLine userId:device.userId];
                device.isOnLine = isOnLine;
                device.isSendRecipt = isOnLine;
                device.timerNum = 0;
                if ([isOnLine intValue] == 1) {
                    device.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(deviceTimerAction:) userInfo:nil repeats:YES];
                }else {
                    [device.timer invalidate];
                    device.timer = nil;
                }
                [g_notify postNotificationName:kUpdateIsOnLineMultipointLogin object:nil];
                break;
            }
        }
    }
    
}

// isOnline统一全部置状态
- (void)upDateAllDeviceOnline:(NSNumber *)isOnline {
    
    for (TFJunYou_Device *device in _deviceArr) {
        device.isOnLine = isOnline;
        device.isSendRecipt = isOnline;
        [device updateIsOnLine:isOnline userId:device.userId];
        [device updateIsSendRecipt:isOnline userId:device.userId];
        [g_notify postNotificationName:kUpdateIsOnLineMultipointLogin object:nil];
    }
}

// 转发消息给其他端
- (void) relaySendMessage:(XMPPMessage *)message msg:(TFJunYou_MessageObject *)msg {
    
    if ([msg.type intValue] == kWCMessageTypeMultipleLogin || msg.isGroup) {
        return;
    }
    // 转发消息不再转发
    NSString *from ;
    NSRange range = [from rangeOfString:@"@"];
    NSString *fromId = [from substringToIndex:range.location];
    if ([fromId isEqualToString:MY_USER_ID]) {
        
        NSRange range1 = [from rangeOfString:@"/"];
        NSString *str = [from substringFromIndex:range1.location + 1];
        for (TFJunYou_Device *device in _deviceArr) {
            if ([device.userId rangeOfString:str].location != NSNotFound) {
                device.timerNum = 0;
            }
        }

        return;
    }
    for (TFJunYou_Device *device in _deviceArr) {
        if ([device.isOnLine intValue] == 1) {
            [g_xmpp relaySendMessage:msg relayUserId:device.userId roomName:nil];
        }
    }

}

- (void)deviceTimerAction:(NSTimer *)timer {
    for (TFJunYou_Device *device in _deviceArr) {
        if (timer == device.timer) {
            device.timerNum ++;
            if (device.timerNum >= 300) {
                device.timerNum = 0;
                if ([device.isSendRecipt intValue] == 1) {
                    device.isSendRecipt = [NSNumber numberWithInt:0];
                    [device updateIsSendRecipt:device.isSendRecipt userId:device.userId];
                    [self sendOnlineMessage];
                }else {
                    device.isOnLine = [NSNumber numberWithInt:0];
                    [device updateIsOnLine:device.isOnLine userId:device.userId];
                    [device.timer invalidate];
                    device.timer = nil;
                    [g_notify postNotificationName:kUpdateIsOnLineMultipointLogin object:nil];
                }
            }
            break;
        }
    }
}


// 其他端在线状态更新
- (void)upDateOtherOnlineWithResources:(NSArray *)resources {
    
    for (TFJunYou_Device *device in _deviceArr) {
        
        BOOL flag = NO;
        for (NSString *str in resources) {
            // 如果是自己端给的回执，不做处理
            if ([str isEqualToString:@"ios"] || !str || str.length <= 0) {
                continue;
            }
            
            if ([device.userId rangeOfString:str].location != NSNotFound) {
                flag = YES;
                break;
            }
        }
        if (flag) {
            NSNumber *isOnLine = [NSNumber numberWithInt:1];
            [device updateIsOnLine:isOnLine userId:device.userId];
            [device updateIsSendRecipt:isOnLine userId:device.userId];
            device.isOnLine = isOnLine;
            device.isSendRecipt = isOnLine;
            break;
        }else {
            
            NSNumber *isOnLine = [NSNumber numberWithInt:0];
            [device updateIsOnLine:isOnLine userId:device.userId];
            [device updateIsSendRecipt:isOnLine userId:device.userId];
            device.isOnLine = isOnLine;
            device.isSendRecipt = isOnLine;
        }
    }
    
}

@end
