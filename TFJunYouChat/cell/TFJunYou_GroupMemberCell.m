//
//  TFJunYou_GroupMemberCell.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/10/11.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import "TFJunYou_GroupMemberCell.h"

@implementation TFJunYou_GroupMemberCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
        _imageView.layer.cornerRadius = 26;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
        _label = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(0, 55, 52, 15)];
        _label.font = g_factory.font12;
        _label.textColor = HEXCOLOR(0x333333);
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)buildNewImageview{
    if (_imageView) {
//        [_imageView sd_cancelCurrentAnimationImagesLoad];
        [_imageView removeFromSuperview];
        _imageView = nil;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
        _imageView.layer.cornerRadius = 26;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
    }

}

@end
