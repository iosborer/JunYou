#import "JLMyFacePackgeHeader.h"
@interface JLMyFacePackgeHeader()
@property (weak, nonatomic) IBOutlet UIView *singleView;
@end
@implementation JLMyFacePackgeHeader
- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_singleView addGestureRecognizer:tap];
}
- (void)setJLMyFacePackgeHeaderCallBack:(void (^)())JLMyFacePackgeHeaderCallBack {
    _JLMyFacePackgeHeaderCallBack = JLMyFacePackgeHeaderCallBack;
}
- (void)tap {
    if (_JLMyFacePackgeHeaderCallBack) {
        _JLMyFacePackgeHeaderCallBack();
    }
}
@end
