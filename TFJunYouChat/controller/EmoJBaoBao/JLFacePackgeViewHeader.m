#import "JLFacePackgeViewHeader.h"
@interface JLFacePackgeViewHeader()
@end
@implementation JLFacePackgeViewHeader
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setJLFacePackgeViewHeaderCallBack:(void (^)())JLFacePackgeViewHeaderCallBack {
    _JLFacePackgeViewHeaderCallBack = JLFacePackgeViewHeaderCallBack;
}
- (IBAction)btnClick:(UIButton *)sender {
    if (_JLFacePackgeViewHeaderCallBack) {
        _JLFacePackgeViewHeaderCallBack();
    }
}
@end
