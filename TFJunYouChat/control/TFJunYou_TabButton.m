//
//  TFJunYou_TabButton.m
//  TFJunYouChat
//
//  Created by flyeagleTang on 14-5-17.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TabButton.h"
#import "TFJunYou_BadgeView.h"

#define ICON_SIZE 22

@implementation TFJunYou_TabButton
@synthesize iconName,selectedIconName,backgroundImageName,selectedBackgroundImageName,textColor,selectedTextColor,bage,text,isTabMenu;

- (void)show
{
    self.backgroundColor = [UIColor clearColor];
    
    _icon    = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-ICON_SIZE)/2, THE_DEVICE_HAVE_HEAD ? 10 : 7, ICON_SIZE, ICON_SIZE)];
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_icon.frame)+(THE_DEVICE_HAVE_HEAD ? 8 : 2), self.frame.size.width, 12)];
    _lbBage  = [[TFJunYou_BadgeView alloc] initWithFrame:CGRectMake(_icon.frame.origin.x+ICON_SIZE-7, THE_DEVICE_HAVE_HEAD ? 8 : 5, 20, 20)];

    _icon.image = [UIImage imageNamed:iconName];
    _icon.userInteractionEnabled = NO;
    
    _lbTitle.text = text;
    _lbTitle.font = g_factory.font11;
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.userInteractionEnabled = NO;
    
    _lbBage.badgeString  = bage;
    _lbBage.userInteractionEnabled = YES;
    _lbBage.didDragout = self.onDragout;
    _lbBage.delegate = self.delegate;
    _lbBage.tag = self.tag;
    
    if(backgroundImageName)
        [self setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    if(selectedBackgroundImageName)
        [self setBackgroundImage:[UIImage imageNamed:selectedBackgroundImageName] forState:UIControlStateSelected];
    
    [self addSubview:_icon];
    [self addSubview:_lbTitle];
    [self addSubview:_lbBage];
}


-(void)dealloc{
//    [_icon release];
//    [_lbTitle release];
//    [_lbBage release];
    
    self.iconName = nil;
    self.selectedIconName = nil;
    self.backgroundImageName = nil;
    self.selectedBackgroundImageName = nil;
    self.text = nil;
    self.textColor = nil;
    self.selectedTextColor = nil;
    self.bage = nil;
    
//    [super dealloc];
}

-(void)setSelected:(BOOL)selected{
    if(selected){
//        _icon.image = ThemeImage(selectedIconName);//[UIImage imageNamed:selectedIconName];
        
        _icon.image = [[UIImage imageNamed:self.selectedIconName] imageWithTintColor:THEMECOLOR]; ;
        
        _lbTitle.textColor = selectedTextColor;
    }else{
        _icon.image = [UIImage imageNamed:iconName];
        _lbTitle.textColor = textColor;
    }
    [super setSelected:selected];
}

-(void)setBage:(NSString *)s{
//    if([s intValue]>99)
//        s = @"99+";
    if([s intValue]<=0)
        s = @"";
    _lbBage.badgeString = s;

//    if(![bage isEqualToString:s])
//       [bage release];
//    bage = [s retain];
    bage = s;
}

@end
