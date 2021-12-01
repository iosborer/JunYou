//
//  TFJunYou_BadgeView.m
//  TFJunYouChat
//
//  Created by flyeagleTang on 15-1-10.
//  Copyright (c) 2015年 Reese. All rights reserved.
//

#import "TFJunYou_BadgeView.h"

@implementation TFJunYou_BadgeView
@synthesize badgeString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.image = [UIImage imageNamed:@"little_red_dot"];
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;

        _lb=[[UILabel alloc]initWithFrame:CGRectZero];
        _lb.userInteractionEnabled = NO;
        _lb.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
        _lb.backgroundColor = HEXCOLOR(0xEF2D37);
        _lb.layer.cornerRadius = _lb.frame.size.width / 2;
        _lb.layer.masksToBounds = YES;
        _lb.textAlignment = NSTextAlignmentCenter;
        _lb.textColor = [UIColor whiteColor];
        _lb.font = g_factory.font9b;
        [self addSubview:_lb];
//        [_lb release];
    }
    return self;
}

-(void)setBadgeString:(NSString *)s{
    if([s isEqualToString:badgeString] && s)
        return;
//    [badgeString release];
//    badgeString = [s retain];
    badgeString = s;
    _lb.hidden = NO;
    if([s intValue]<=0){
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
//    if([s intValue]>99)
//        s = @"99+";

    if([s length]>=3)
        _lb.font = SYSFONT(9);
    else
        if([s length]>=2)
            _lb.font = SYSFONT(12);
        else
            _lb.font = SYSFONT(13);
    _lb.text = s;
}

@end
