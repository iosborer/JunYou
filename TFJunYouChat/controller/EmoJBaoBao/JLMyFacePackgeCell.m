#import "JLMyFacePackgeCell.h"
@interface JLMyFacePackgeCell()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end
@implementation JLMyFacePackgeCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _button.layer.cornerRadius = 5;
    _button.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 5;
    _imageView.layer.masksToBounds = YES;
}
- (void)setModel:(JLFacePackgeModel *)model {
    _model = model;
    NSString *path = model.path? model.path[0]: model.url;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:path]];
    _label.text = model.name;
}
- (void)setJLMyFacePackgeCellDeleteCallBack:(void (^)(NSString * _Nonnull))JLMyFacePackgeCellDeleteCallBack {
    _JLMyFacePackgeCellDeleteCallBack = JLMyFacePackgeCellDeleteCallBack;
}
- (IBAction)deleteEmoji:(UIButton *)sender {
    if (_JLMyFacePackgeCellDeleteCallBack) {
        _JLMyFacePackgeCellDeleteCallBack(_model.name);
    }
}
@end
