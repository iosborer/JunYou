//
//  TipBlackView.m
//  TFJunYouChat
//
//  Created by MacZ on 16/4/18.
//  Copyright (c) 2016年 Reese. All rights reserved.
//

#import "TFJunYou_TipBlackView.h"

@implementation TFJunYou_TipBlackView

- (id)initWithTitle:(NSString *)title{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 50)];
    if (self) {
        self.center = CGPointMake(TFJunYou__SCREEN_WIDTH/2, TFJunYou__SCREEN_HEIGHT/2);
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.text = title;
        _titleLabel.backgroundColor = [UIColor blackColor];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = _titleLabel.frame.size.height/2;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = SYSFONT(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.alpha = 0.6;
        [self addSubview:_titleLabel];
//        [_titleLabel release];
    }
    return self;
}

- (void)show{
    [UIView animateWithDuration:1.0 delay:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
        _titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
