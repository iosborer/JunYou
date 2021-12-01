#import "JLFacePackgeDetailViewHeader.h"
@interface JLFacePackgeDetailViewHeader()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end
@implementation JLFacePackgeDetailViewHeader
- (void)awakeFromNib {
    [super awakeFromNib];
    _addButton.layer.cornerRadius = 5;
    _addButton.layer.masksToBounds = YES;
}
- (void)setModel:(JLFacePackgeModel *)model {
    _model = model;
    _label.text = model.desc.length>0?model.desc:@"什么都没写...";
}
- (void)setJLFacePackgeDetailViewAddCallBack:(void (^)())JLFacePackgeDetailViewAddCallBack {
    _JLFacePackgeDetailViewAddCallBack = JLFacePackgeDetailViewAddCallBack;
}
- (IBAction)addBtnClick:(UIButton *)sender {
    if (_JLFacePackgeDetailViewAddCallBack) {
        _JLFacePackgeDetailViewAddCallBack();
    }
}
@end
