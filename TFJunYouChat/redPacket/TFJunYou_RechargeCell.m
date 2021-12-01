#import "TFJunYou_RechargeCell.h"
@implementation TFJunYou_RechargeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self customSubviews];
    }
    return self;
}
-(void)customSubviews{
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-15-40, 0, 40, 40);
    _checkButton.center = CGPointMake(_checkButton.center.x, 65/2);
    [_checkButton setImage:[UIImage imageNamed:@"unchecked_round"] forState:UIControlStateNormal];
    [_checkButton setImage:[UIImage imageNamed:@"checked_round"] forState:UIControlStateSelected];
    _checkButton.userInteractionEnabled = NO;
    [self.contentView addSubview:_checkButton];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _checkButton.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-15-40, 0, 40, 40);
    _checkButton.center = CGPointMake(_checkButton.center.x, 65/2);
    [self.contentView bringSubviewToFront:_checkButton];
}
-(void)prepareForReuse{
    [super prepareForReuse];
    self.checkButton.selected = NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
