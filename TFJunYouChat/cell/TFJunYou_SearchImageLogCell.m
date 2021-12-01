//
//  TFJunYou_SearchImageLogCell.m
//  TFJunYouChat
//
//  Created by p on 2019/4/9.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "TFJunYou_SearchImageLogCell.h"

@interface TFJunYou_SearchImageLogCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *pauseBtn;

@end

@implementation TFJunYou_SearchImageLogCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self customViewWithFrame:frame];
    }
    
    return self;
}


- (void)customViewWithFrame:(CGRect)frame{
    self.contentView.clipsToBounds = YES;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.contentView addSubview:self.imageView];
    
    _pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    _pauseBtn.center = CGPointMake(self.imageView.frame.size.width/2,self.imageView.frame.size.height/2);
    [_pauseBtn setBackgroundImage:[UIImage imageNamed:@"playvideo"] forState:UIControlStateNormal];
    //    [_pauseBtn setBackgroundImage:[UIImage imageNamed:@"pausevideo"] forState:UIControlStateSelected];
//    [_pauseBtn addTarget:self action:@selector(showTheVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:_pauseBtn];
}

- (void)setMsg:(TFJunYou_MessageObject *)msg {
    _msg = msg;
    
    if ([msg.type integerValue] == kWCMessageTypeImage || [msg.type integerValue] == kWCMessageTypeCustomFace || [msg.type integerValue] == kWCMessageTypeEmoji) {
        self.pauseBtn.hidden = YES;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:msg.content] placeholderImage:[UIImage imageNamed:@"avatar_normal"]];
    }else {
        self.pauseBtn.hidden = NO;
        if([self.msg.content rangeOfString:@"http://"].location == NSNotFound && [self.msg.content rangeOfString:@"https://"].location == NSNotFound) {
            [TFJunYou_FileInfo getFirstImageFromVideo:self.msg.fileName imageView:self.imageView];
        }else {
            [TFJunYou_FileInfo getFirstImageFromVideo:self.msg.content imageView:self.imageView];
        }
    }
    
}

- (void)showTheVideo {
   
}

@end
