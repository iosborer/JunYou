//
//  TFJunYou_TransferCell.m
//  TFJunYouChat
//
//  Created by 1 on 2019/3/1.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_TransferCell.h"

@interface TFJunYou_TransferCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation TFJunYou_TransferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)creatUI{
    self.bubbleBg.custom_acceptEventInterval = 1.0;
    
    _imageBackground =[[TFJunYou_ImageView alloc]initWithFrame:CGRectZero];
    [_imageBackground setBackgroundColor:[UIColor clearColor]];
    _imageBackground.layer.cornerRadius = 6;
    _imageBackground.image = [UIImage imageNamed:@"transfer_back_icon"];
    _imageBackground.layer.masksToBounds = YES;
    _imageBackground.contentMode = UIViewContentModeScaleAspectFill;
    [self.bubbleBg addSubview:_imageBackground];
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(15,20, 40, 40);
    _headImageView.image = [UIImage imageNamed:@"ic_transfer_money"];
    _headImageView.userInteractionEnabled = NO;
    [_imageBackground addSubview:_headImageView];
    
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 15,20, 180, 15);
    _moneyLabel.font = g_factory.font15;
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.numberOfLines = 0;
    _moneyLabel.userInteractionEnabled = NO;
    [_imageBackground addSubview:_moneyLabel];

    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 15,CGRectGetMaxY(_moneyLabel.frame)+5, 180, 14);
    _nameLabel.font = g_factory.font14;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.numberOfLines = 0;
    _nameLabel.userInteractionEnabled = NO;
    [_imageBackground addSubview:_nameLabel];
    

//    _title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 30)];
//    _title.text = Localized(@"JX_Transfer");
//    _title.font = SYSFONT(14.0);
//    _title.textColor = [UIColor whiteColor];
//    [_imageBackground addSubview:_title];
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
    _title.frame = CGRectMake(15, _imageBackground.frame.size.height - 30, 200, 30);
    
    if (self.msg.isShowTime) {
        CGRect frame = self.bubbleBg.frame;
        frame.origin.y = self.bubbleBg.frame.origin.y + 40;
        self.bubbleBg.frame = frame;
    }
    
    [self setMaskLayer:_imageBackground];
    TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
    user = [user getUserById:self.msg.toUserId];
    _nameLabel.text = self.msg.fileName.length > 0 ? self.msg.fileName : self.msg.isMySend ? [NSString stringWithFormat:@"%@%@",Localized(@"JX_TransferTo"),user.remarkName.length > 0 ? user.remarkName : user.userNickname] : Localized(@"JX_TransferToYou");
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.msg.content];

    if ([self.msg.fileSize intValue] == 2) {
        
        _imageBackground.alpha = 0.5;
    }else {
        
        _imageBackground.alpha = 1;
    }
}

-(void)didTouch:(UIButton*)button{
    self.msg.index = self.indexNum;
    [g_notify postNotificationName:kcellTransferDidTouchNotifaction object:self.msg];
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


@end
