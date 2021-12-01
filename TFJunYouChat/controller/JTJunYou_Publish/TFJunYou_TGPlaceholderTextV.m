//
//  TFJunYou_TGPlaceholderTextV.m
//  TFJunYouChat
//
//  Created by mac on 2020/5/20.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_TGPlaceholderTextV.h"

@interface TFJunYou_TGPlaceholderTextV()
@property (weak , nonatomic)UILabel *placeholderLbl;
@end

@implementation TFJunYou_TGPlaceholderTextV

-(UILabel *)placeholderLbl{
    if (! _placeholderLbl) {
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        _placeholderLbl = placeholderLabel;
     
    }
    return _placeholderLbl;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.alwaysBounceVertical = YES;
        self.font = [UIFont systemFontOfSize:15];
        self.placeholderLbl.font = self.font;
        self.placeholderColor = [UIColor lightGrayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeholderLbl.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    self.placeholderLbl.text = placeholder;
    //[self updatePlaceholderLabelSize];
    [self setNeedsLayout];
}

-(void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderLbl.font = font;
    //[self updatePlaceholderLabelSize];
    [self setNeedsLayout];
}

-(void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)textDidChange{
    self.placeholderLbl.hidden = self.hasText;
}

- (void)updatePlaceholderLabelSize{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
     
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
