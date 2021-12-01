//
//  TFJunYou_MsgStrCell.m
//  TFJunYouChat
//
//  Created by os on 2021/1/14.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_MsgStrCell.h"
  
 

@implementation TFJunYou_MsgStrCell
 
- (void)dealloc {
    
    [self.readDelTimer invalidate];
}

-(void)creatUI{
    _messageConentMsg=[[FMLinkLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _messageConentMsg.lineBreakMode = NSLineBreakByWordWrapping;
    _messageConentMsg.numberOfLines = 0;
    _messageConentMsg.textColor = HEXCOLOR(0x333333);
    _messageConentMsg.backgroundColor = [UIColor clearColor];
//    _messageConentMsg.font = [UIFont systemFontOfSize:15];
    _messageConentMsg.userInteractionEnabled = YES;
    [self.bubbleBg addSubview:_messageConentMsg];

    _timeIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _timeIndexLabel.layer.cornerRadius = _timeIndexLabel.frame.size.width / 2;
    _timeIndexLabel.layer.masksToBounds = YES;
    _timeIndexLabel.textColor = [UIColor whiteColor];
    _timeIndexLabel.backgroundColor = HEXCOLOR(0x02d8c9);
    _timeIndexLabel.textAlignment = NSTextAlignmentCenter;
    _timeIndexLabel.text = @"0";
    _timeIndexLabel.font = [UIFont systemFontOfSize:12.0];
    _timeIndexLabel.hidden = YES;
    [self.contentView addSubview:_timeIndexLabel];
}
-(void)setContentAswer:(NSString *)contentAswer{
    
    _contentAswer = contentAswer;
    
}

-(void)setMsgAnswerArr:(NSArray *)msgAnswerArr{
    _msgAnswerArr = msgAnswerArr;
    
}
-(void)setCellData{
    [super setCellData];
    
    
    
  
    
    _messageConentMsg.text = self.msg.content;
    _timeIndexLabel.hidden = YES;
    
  
    
    NSArray *titleArr =  self.msg.answerArr;
    
 
    for (int i=0;i<titleArr.count;i++) {
        
        NSDictionary *dict  = titleArr[i];
        NSString *titleStr = [NSString stringWithFormat:@"【%@】  %@",dict[@"sort"],dict[@"issue"]];
       
        if ([self.msg.content containsString:dict[@"issue"]]) {
            
            
            [self.messageConentMsg addClickText:titleStr attributeds:@{NSForegroundColorAttributeName : [UIColor redColor]} transmitBody:(id)dict[@"issue"] countInt:i countArr:titleArr clickItemBlock:^(id transmitBody) {
                
                
                [g_notify postNotificationName:@"clickText" object:transmitBody];
        
                
            }];
        }
    }
    
//    if (_messageConentMsg.clickItems.count>titleArr.count) {
//       
//        for (int i=0; i<titleArr.count; i++) {
//            
//            [_messageConentMsg.clickItems removeObjectAtIndex:i];
//        }
//    }
    

         
    [self creatBubbleBg];
}
-(void)creatBubbleBg{
   

    //聊天长度反正就是算错了，强行改
    CGSize textSize = [self.msg.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_messageConentMsg.font} context:nil].size;
    int n = textSize.width;
    int inset = 3;
    
      self.bubbleBg.frame=CGRectMake(CGRectGetMaxX(self.headImage.frame) + CHAT_WIDTH_ICON, INSETS2(self.msg.isGroup), n+INSETS*2+inset*2, textSize.height+INSETS*2);
  
    
        [_messageConentMsg setFrame:CGRectMake(INSETS + 3+inset, INSETS, n + 5, textSize.height)];
        _timeIndexLabel.frame = CGRectMake(CGRectGetMaxX(self.bubbleBg.frame) + 10, self.bubbleBg.frame.origin.y, 20, 20);
    
    if (self.msg.isShowTime) {
        CGRect frame = self.bubbleBg.frame;
        frame.origin.y = self.bubbleBg.frame.origin.y + 40;
        self.bubbleBg.frame = frame;
        
        _timeIndexLabel.frame = CGRectMake(_timeIndexLabel.frame.origin.x, self.bubbleBg.frame.origin.y, 20, 20);
    }
    
}

- (void)setBackgroundImage {
    [super setBackgroundImage];
 
     
     self.isDidMsgCell = YES;
     

}

//复制信息到剪贴板
- (void)myCopy{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.msg.content];
}

+ (float)getChatCellHeight:(TFJunYou_MessageObject *)msg {
    
    if ([msg.chatMsgHeight floatValue] > 1) {
            return [msg.chatMsgHeight floatValue];
    }
    float n;
    UILabel *messageConent=[[UILabel alloc]init];
    messageConent.backgroundColor = [UIColor clearColor];
    messageConent.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeWordWrap;
    messageConent.userInteractionEnabled = NO;
    messageConent.numberOfLines = 0;
//    messageConent.font = [UIFont systemFontOfSize:15];
    //messageConent.offset = -12;
    
    CGSize titleSize = [msg.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:messageConent.font} context:nil].size;
    
    messageConent.frame = CGRectMake(0, 0, 200, titleSize.height+12);
    
   
   // messageConent.text = msg.content;
    
     
    
    if (msg.isGroup && !msg.isMySend) {
        n = messageConent.frame.size.height+10*3 + 20;
        if (msg.isShowTime) {
            n=messageConent.frame.size.height+10*3 + 40 + 20;
        }
        n += GROUP_CHAT_INSET;
    }else {
        n= messageConent.frame.size.height+10*3 + 10;
        if (msg.isShowTime) {
            n=messageConent.frame.size.height+10*3 + 40 + 10;
        }
    }
    if(n<55)
        n = 55;
    if (msg.isShowTime) {
        if(n<95)
            n = 95;
    }
    msg.chatMsgHeight = [NSString stringWithFormat:@"%f",n];
    if (!msg.isNotUpdateHeight) {
        [msg updateChatMsgHeight];
    }
     
    return n;
}

-(void)didTouch:(UIButton*)button{
    
    
    if ([self.msg.isReadDel boolValue] && [self.msg.fileName intValue] <= 0 && !self.msg.isMySend) {
        [self.msg sendAlreadyReadMsg];
        
        self.msg.fileName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [self.msg updateFileName];
        
        self.timeIndexLabel.hidden = NO;
 
        self.isDidMsgCell = YES;
        self.msg.chatMsgHeight = [NSString stringWithFormat:@"0"];
        [self.msg updateChatMsgHeight];
        [g_notify postNotificationName:kCellMessageReadDelNotifaction object:[NSNumber numberWithInt:self.indexNum]];
 
        
    }
}

- (void)timerAction:(NSTimer *)timer {
   
    if (self.timerIndex <= 0) {
        [self.readDelTimer invalidate];
        self.readDelTimer = nil;
        self.msg.fileName = @"0";
        
        //阅后即焚通知
        [g_notify postNotificationName:kCellReadDelNotification object:self.msg];
        [self deleteMsg:self.msg];
        return;
    }
    self.timeIndexLabel.text = [NSString stringWithFormat:@"%ld",-- self.timerIndex];
 
    
}


- (void)deleteMsg:(TFJunYou_MessageObject *)msg{
    
    if ([self.msg.isReadDel boolValue]) {
        
        if ([self.msg.fileName intValue] > 0) {
            return;
        }
        
        //渐变隐藏
        [UIView animateWithDuration:2.f animations:^{
            self.bubbleBg.alpha = 0;
            self.timeIndexLabel.alpha = 0;
            self.readImage.alpha = 0;
            self.burnImage.alpha = 0;
        } completion:^(BOOL finished) {
            //动画结束后删除UI
            [self.delegate performSelectorOnMainThread:self.readDele withObject:msg waitUntilDone:NO];
            self.bubbleBg.alpha = 1;
            self.timeIndexLabel.alpha = 1;
            self.readImage.alpha = 1;
            self.burnImage.alpha = 1;
        }];
    }
    
}

 
 
-(CGSize)titleBtnWight:(NSString *)titleStr and:(UILabel *)titleLabel {
    CGSize titleSize = [titleStr boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabel.font} context:nil].size;
    titleLabel.text = titleStr;
    return titleSize;
}

@end
