#import "ReplyCell.h"
@implementation ReplyCell
@synthesize label;
-(void)prepareForReuse
{
    self.label.match=nil;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.pointIndex = point.x/10;
    [super touchesEnded:touches withEvent:event];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
