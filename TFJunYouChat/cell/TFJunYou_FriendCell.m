//
//  TFJunYou_FriendCell.m
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_FriendCell.h"
#import "TFJunYou_Label.h"
#import "TFJunYou_ImageView.h"
#import "AppDelegate.h"
#import "TFJunYou_FriendObject.h"
#import "UIFactory.h"

@implementation TFJunYou_FriendCell
@synthesize title,subtitle,rightTitle,bottomTitle,headImage,bage,user,target;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        UIFont* f0 = g_factory.font14;
        UIFont* f1 = g_factory.font16;
        
        
        //时间
        _timeLab = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH - 115-15, 26, 115, 13)];
        _timeLab.textColor = HEXCOLOR(0x999999);
        _timeLab.userInteractionEnabled = NO;
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.font = SYSFONT(13);
        _timeLab.hidden = YES;
        [self.contentView addSubview:_timeLab];
        [_timeLab setText:self.bottomTitle];
        
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH -64-15-64-11, 29, 64, 27)];
        _btn1.titleLabel.font = SYSFONT(13);
        [_btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn1.layer.masksToBounds = YES;
        _btn1.layer.cornerRadius = 4.f;
        _btn1.backgroundColor = THEMECOLOR;
        
        
        _btn1.tag = self.tag;
        [self addSubview:_btn1];

        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-64-15, 29, 64, 27)];
        _btn2.titleLabel.font = SYSFONT(13);
        [_btn2 setTitleColor:THEMECOLOR forState:UIControlStateNormal];
        _btn2.backgroundColor = [UIColor whiteColor];
        _btn2.layer.borderWidth = .5;
        _btn2.layer.borderColor = [THEMECOLOR CGColor];
        _btn2.layer.cornerRadius = 4.0;
        _btn2.layer.masksToBounds = YES;
        
        _btn2.tag = self.tag;
        [self addSubview:_btn2];
        
        
        int n = 84;
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0,0, TFJunYou__SCREEN_WIDTH, n)];
        v.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.selectedBackgroundView = v;
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(73,n-LINE_WH,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        _lineView.backgroundColor = THE_LINE_COLOR;
        [self.contentView addSubview:_lineView];

        TFJunYou_ImageView* iv;
        iv = [[TFJunYou_ImageView alloc]init];
        iv.userInteractionEnabled = NO;
        iv.delegate = self;
        iv.didTouch = @selector(actionUser);
        iv.frame = CGRectMake(15,20,44,44);
        iv.layer.cornerRadius = iv.frame.size.width / 2;
        iv.layer.masksToBounds = YES;
        [self.contentView addSubview:iv];
        [g_server getHeadImageSmall:user.userId userName:user.userNickname imageView:iv];
        
        TFJunYou_Label* lb;
        //名字
        lb = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iv.frame)+14, 25, TFJunYou__SCREEN_WIDTH - 115 -CGRectGetMaxX(iv.frame)-14, 15)];
        lb.textColor = [UIColor blackColor];
        lb.userInteractionEnabled = NO;
        lb.font = SYSFONT(15);
        lb.backgroundColor = [UIColor clearColor];
        lb.font = f1;
        [self.contentView addSubview:lb];
        [lb setText:self.title];
        
        //聊天消息
        lb = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iv.frame)+14, n-13-25, TFJunYou__SCREEN_WIDTH-86-50, 13)];
        lb.textColor = [UIColor lightGrayColor];
        lb.userInteractionEnabled = NO;
        lb.font = SYSFONT(13);
        lb.backgroundColor = [UIColor clearColor];
        lb.font = f0;
        [self.contentView addSubview:lb];
        _lbSubtitle = lb;
        _lbSubtitle.text = [user getLastContent:user.userId];
        
        
        bageImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noread"]];
        bageImage.frame = CGRectMake(43, 8-10, 25, 25);
        bageImage.backgroundColor = [UIColor clearColor];
        
        bageNumber=[[UILabel alloc]initWithFrame:CGRectZero];
        bageNumber.userInteractionEnabled = NO;
        bageNumber.frame = CGRectMake(0,0, 25, 25);
        bageNumber.backgroundColor = [UIColor clearColor];
        bageNumber.textAlignment = NSTextAlignmentCenter;
        bageNumber.text  = bage;
        bageNumber.textColor = [UIColor whiteColor];
        bageNumber.font = f0;
        
        if([bage intValue]>0){
            [self.contentView addSubview:bageImage];
            [bageImage addSubview:bageNumber];
        }
        
        
        [self update];
    }
    return self;
}

- (void) actionUser {
    if ([self.delegate respondsToSelector:@selector(friendCell:headImageAction:)]) {
        [self.delegate friendCell:self headImageAction:user.userId];
    }
}

-(void)dealloc{
//    NSLog(@"TFJunYou_FriendCell.dealloc");
    self.title = nil;
    self.subtitle = nil;
    self.rightTitle = nil;
    self.bottomTitle = nil;
    self.headImage = nil;
    self.bage = nil;
    self.user = nil;
    self.target = nil;
//    [bageImage release];
//    [bageNumber release];
//    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setBage:(NSString *)s{
    bageImage.hidden = [s intValue]<=0;
    bageNumber.hidden = [s intValue]<=0;
    bageNumber.text = s;
    bage = s;
}

-(void)update{
    NSString* s = @"";SEL action=nil;
    NSString* s2 = @"";SEL action2=nil;
    if([user.isMySend boolValue]){
        switch ([user.type intValue]) {
            case XMPP_TYPE_SAYHELLO:
                
                user.status = [NSNumber numberWithInt:friend_status_addFriend];
                [user update];
//                s = @"再打招呼";
//                action = @selector(onSayHello:);
                _timeLab.hidden = NO;
                break;
            case XMPP_TYPE_PASS:
                _timeLab.hidden = NO;
                break;
            case XMPP_TYPE_FEEDBACK:
                if ([user.status intValue] == friend_status_hisAddFriend) {
                    s = Localized(@"JX_Pass");
                    action = @selector(onAddFriend:);
                    s2 = Localized(@"JX_Talk");//同时显示两个按钮
                    action2 = @selector(onFeedback:);
                }else {
                    s2 = Localized(@"JX_Talk");
                    action2 = @selector(onFeedback:);
                }
                _timeLab.hidden = YES;
                break;
            case XMPP_TYPE_NEWSEE:
                s = Localized(@"JX_SayHi");
                action = @selector(onSayHello:);
                _timeLab.hidden = YES;
                break;
            case XMPP_TYPE_DELSEE:
//                s = Localized(@"JX_FollowAngin");
                action = @selector(onSeeHim:);
                _timeLab.hidden = YES;
                break;
            case XMPP_TYPE_DELALL:
//                s = Localized(@"JX_FollowAngin");
                action = @selector(onSeeHim:);
                _timeLab.hidden = YES;
                break;
            default:
                break;
        }
    }else{
        switch ([user.type intValue]) {
            case XMPP_TYPE_SAYHELLO:
                _timeLab.hidden = YES;
                s = Localized(@"JX_Pass");
                action = @selector(onAddFriend:);
                s2 = Localized(@"JX_Talk");//同时显示两个按钮
                action2 = @selector(onFeedback:);
                user.status = [NSNumber numberWithInt:friend_status_hisAddFriend];
                [user update];
                break;
            case XMPP_TYPE_PASS:
                _timeLab.hidden = NO;
                break;
            case XMPP_TYPE_FEEDBACK:
                _timeLab.hidden = YES;
                if ([user.status intValue] == friend_status_hisAddFriend) {
                    s = Localized(@"JX_Pass");
                    action = @selector(onAddFriend:);
                    s2 = Localized(@"JX_Talk");//同时显示两个按钮
                    action2 = @selector(onFeedback:);
                }else {
                    s2 = Localized(@"JX_Talk");
                    action2 = @selector(onFeedback:);
                }
                
                break;
            case XMPP_TYPE_NEWSEE:
                _timeLab.hidden = YES;
                s = Localized(@"JX_AddFriend");
                action = @selector(onAddFriend:);
                break;
            case XMPP_TYPE_DELSEE:
                _timeLab.hidden = YES;
                if([user.status intValue]==friend_status_none){
                    s = Localized(@"JX_Attion");
                    action = @selector(onSeeHim:);
                }
                if([user.status intValue]==friend_status_see){
                    s = Localized(@"JX_SayHi");
                    action = @selector(onSayHello:);
                }
                break;
            case XMPP_TYPE_RECOMMEND:
                _timeLab.hidden = YES;
                if([user.status intValue]==friend_status_none){
                    s = Localized(@"JX_Attion");
                    action = @selector(onSeeHim:);
                }
                if([user.status intValue]==friend_status_see){
                    s = Localized(@"JX_SayHi");
                    action = @selector(onSayHello:);
                }
                break;
            default:
                break;
        }
    }
    _lbSubtitle.text = [user getLastContent:user.userId];
    _btn1.hidden = [s length]==0;
    [_btn1 setTitle:s forState:UIControlStateNormal];
    [_btn1 addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    _btn2.hidden = [s2 length]==0;
    [_btn2 setTitle:s2 forState:UIControlStateNormal];
    [_btn2 addTarget:target action:action2 forControlEvents:UIControlEventTouchUpInside];
    
    if (!_btn1.hidden) {
        _lbSubtitle.frame = CGRectMake(_lbSubtitle.frame.origin.x, _lbSubtitle.frame.origin.y, TFJunYou__SCREEN_WIDTH - _lbSubtitle.frame.origin.x - (TFJunYou__SCREEN_WIDTH - _btn1.frame.origin.x) - 10, _lbSubtitle.frame.size.height);
    }else {
        if (!_btn2.hidden) {
            _lbSubtitle.frame = CGRectMake(_lbSubtitle.frame.origin.x, _lbSubtitle.frame.origin.y, TFJunYou__SCREEN_WIDTH - _lbSubtitle.frame.origin.x - (TFJunYou__SCREEN_WIDTH - _btn2.frame.origin.x) - 10, _lbSubtitle.frame.size.height);
        }else {
            _lbSubtitle.frame = CGRectMake(_lbSubtitle.frame.origin.x, _lbSubtitle.frame.origin.y, TFJunYou__SCREEN_WIDTH - _lbSubtitle.frame.origin.x - 10, _lbSubtitle.frame.size.height);
        }
    }
    
    
}

@end
