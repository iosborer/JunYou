//
//  TFJunYou_RedPacketCell.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/10.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_RedPacketCell.h"

@interface TFJunYou_RedPacketCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *title;

@end

@implementation TFJunYou_RedPacketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)creatUI{
    self.bubbleBg.custom_acceptEventInterval = 1.0;
    
    _imageBackground =[[TFJunYou_ImageView alloc]initWithFrame:CGRectZero];
    [_imageBackground setBackgroundColor:[UIColor clearColor]];
    _imageBackground.layer.cornerRadius = 6;
    _imageBackground.image = [UIImage imageNamed:@"hongbaokuan"];
    _imageBackground.contentMode = UIViewContentModeScaleAspectFill;
    _imageBackground.layer.masksToBounds = YES;
    [self.bubbleBg addSubview:_imageBackground];
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(15,20, 32, 42);
    _headImageView.image = [UIImage imageNamed:@"hongb"];
    _headImageView.userInteractionEnabled = NO;
    [_imageBackground addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 15,22.5, 180, 20);
    _nameLabel.font = g_factory.font15;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.numberOfLines = 0;
    _nameLabel.userInteractionEnabled = NO;
    [_imageBackground addSubview:_nameLabel];

    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_headImageView.frame) + 15, CGRectGetMaxX(_nameLabel.frame)+5, 100, 14)];
    _title.text = Localized(@"JX_BusinessCard");
    _title.font = SYSFONT(14.0);
    _title.textColor = [UIColor whiteColor];
    [_imageBackground addSubview:_title];
    
    //
//    _redPacketGreet = [[TFJunYou_Emoji alloc]initWithFrame:CGRectMake(5, 25, 80, 16)];
//    _redPacketGreet.textAlignment = NSTextAlignmentCenter;
//    _redPacketGreet.font = [UIFont systemFontOfSize:12];
//    _redPacketGreet.textColor = [UIColor whiteColor];
//    _redPacketGreet.userInteractionEnabled = NO;
//    [_imageBackground addSubview:_redPacketGreet];
}

-(void)setCellData{
    [super setCellData];
    int n = imageItemHeight;
    
    if(self.msg.isMySend)
    {
        self.bubbleBg.frame=CGRectMake(CGRectGetMinX(self.headImage.frame)- kChatCellMaxWidth - CHAT_WIDTH_ICON, INSETS, kChatCellMaxWidth, n+INSETS -4);
        _imageBackground.frame = self.bubbleBg.bounds;
        
    }
    else
    {
        self.bubbleBg.frame=CGRectMake(CGRectGetMaxX(self.headImage.frame) + CHAT_WIDTH_ICON, INSETS2(self.msg.isGroup), kChatCellMaxWidth, n+INSETS -4);
        _imageBackground.frame = self.bubbleBg.bounds;
    }
    _title.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 15, CGRectGetMaxY(_nameLabel.frame)+2.5, 100, 14);
    if (self.msg.isShowTime) {
        CGRect frame = self.bubbleBg.frame;
        frame.origin.y = self.bubbleBg.frame.origin.y + 40;
        self.bubbleBg.frame = frame;
    }
    
    [self setMaskLayer:_imageBackground];
    
    //服务端返回的数据类型错乱，强行改
    self.msg.fileName = [NSString stringWithFormat:@"%@",self.msg.fileName];
    if ([self.msg.fileName isEqualToString:@"3"]) {
//        _imageBackground.image = [UIImage imageNamed:@"口令红包"];
//        _redPacketGreet.frame = CGRectMake(5, 45, _imageBackground.frame.size.width -10, 16);
        _nameLabel.text = self.msg.content;
        _title.text = Localized(@"JX_MesGift");
    }else{
//        _imageBackground.image = [UIImage imageNamed:@"红包"];
//        _redPacketGreet.frame = CGRectMake(5, 25, _imageBackground.frame.size.width -10, 16);
        _nameLabel.text = self.msg.content;
        _title.text = Localized(@"JXredPacket");
    }
    
    if ([self.msg.fileSize intValue] == 2) {
        
        _imageBackground.alpha = 0.5;
    }else {
        
        _imageBackground.alpha = 1;
    }

}

-(void)didTouch:(UIButton*)button{
    [g_notify postNotificationName:kcellRedPacketDidTouchNotifaction object:self.msg];
}

+ (float)getChatCellHeight:(TFJunYou_MessageObject *)msg {
    if ([g_App.isShowRedPacket intValue] == 1){
        if ([msg.chatMsgHeight floatValue] > 1) {
            return [msg.chatMsgHeight floatValue];
        }
        
        float n = 0;
        if (msg.isGroup && !msg.isMySend) {
            if (msg.isShowTime) {
                n = TFJunYou__SCREEN_WIDTH/3 + 10 + 40;
            }else {
                n = TFJunYou__SCREEN_WIDTH/3 + 10;
            }
            n += GROUP_CHAT_INSET;
        }else {
            if (msg.isShowTime) {
                n = TFJunYou__SCREEN_WIDTH/3 + 40;
            }else {
                n = TFJunYou__SCREEN_WIDTH/3;
            }
        }
        
        msg.chatMsgHeight = [NSString stringWithFormat:@"%f",n];
        if (!msg.isNotUpdateHeight) {
            [msg updateChatMsgHeight];
        }
        return n;
        
    }else{
        
        msg.chatMsgHeight = [NSString stringWithFormat:@"0"];
        if (!msg.isNotUpdateHeight) {
            [msg updateChatMsgHeight];
        }
        return 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
