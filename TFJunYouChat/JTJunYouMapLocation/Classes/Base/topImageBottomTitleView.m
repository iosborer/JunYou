//
//  topImageBottomTitleView.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/7/25.
//  Copyright © 2020 zengwOS.  All rights reserved.
//

#import "topImageBottomTitleView.h"
@interface topImageBottomTitleView()
@property (nonatomic , strong) UIImageView *topImageV;
@property (nonatomic , strong) UILabel *bottomLabel;
@property (nonatomic , strong) UIView *maskView;
@property (nonatomic , strong) UIImageView *checkImageV;
@end

@implementation topImageBottomTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topImageV];
        [self addSubview:self.bottomLabel];
        [self.topImageV addSubview:self.maskView];
        [self.topImageV addSubview:self.checkImageV];
        self.maskView.hidden = self.checkImageV.hidden = !self.checked;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapClick:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topImageBottomTitleViewTapWithView:)]) {
        [self.delegate topImageBottomTitleViewTapWithView:self];
    }
}

- (UIImageView *)topImageV {
    if (!_topImageV) {
        _topImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        _topImageV.contentMode = UIViewContentModeScaleAspectFill;
        _topImageV.layer.masksToBounds = YES;
        _topImageV.layer.cornerRadius = 6.0;
        _topImageV.layer.borderWidth = 1;
        _topImageV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _topImageV;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topImageV.frame), self.frame.size.width, self.frame.size.height - CGRectGetHeight(_topImageV.frame))];
        _bottomLabel.textColor = kColorFromHex(0x333333);
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = kPingFangMediumFont(14);
    }
    return _bottomLabel;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:_topImageV.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3;
    }
    return _maskView;
}

- (UIImageView *)checkImageV {
    if (!_checkImageV) {
        _checkImageV = [[UIImageView alloc] initWithFrame:CGRectMake(_topImageV.center.x - 10, _topImageV.center.y - 10, 20, 20)];
        _checkImageV.image = kGetImage(@"btn_select");
    }
    return _checkImageV;
}

- (void)setUIWithDic:(NSDictionary *)dic {
    self.topImageV.image = kGetImage([dic objectForKey:@"image"]);
    self.bottomLabel.text = [dic objectForKey:@"title"];
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    _maskView.hidden = _checkImageV.hidden = !_checked;
}

@end
