//
//  TFJunYou_TGTagBtn.m
//  TFJunYouChat
//
//  Created by mac on 2020/5/20.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_TGTagBtn.h"
#import "UIView+LK.h"

@implementation TFJunYou_TGTagBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit]; 
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.x = 5;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
}
@end
