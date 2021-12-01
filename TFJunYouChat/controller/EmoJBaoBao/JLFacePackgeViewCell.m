#import "JLFacePackgeViewCell.h"
@interface JLFacePackgeViewCell()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, assign) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
@end
@implementation JLFacePackgeViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _isSelectedImageHidden = NO;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected)]];
    _isSelected = NO;
    [g_notify addObserver:self selector:@selector(updateStatus) name:@"NOTSELECTED" object:nil];
}
- (void)dealloc {
    [g_notify removeObserver:self];
}
- (void)updateStatus {
    [_markButton setSelected:NO];
}
- (void)selected {
    _isSelected = !_isSelected;
    [_markButton setSelected:_isSelected];
        if (_JLFacePackgeViewCellCallBack) {
            _JLFacePackgeViewCellCallBack(_model.id, _markButton.selected);
        }
}
- (void)setPath:(NSString *)path {
    _path = path;
     [_imageView sd_setImageWithURL:[NSURL URLWithString:path]];
}
- (void)setModel:(JLFacePackgeModel *)model {
    _model = model;
    NSString *path = model.path? model.path.firstObject: model.url;
    if([model.id isEqualToString:@"plusButtonID"]) {
        _imageView.userInteractionEnabled = YES;
        _markButton.hidden = YES;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"addfriend_room"]];
    }else {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:path]];
    }
    _label.text = model.name;
}
- (void)setJLFacePackgeViewCellCallBack:(void (^)(NSString * _Nonnull, BOOL))JLFacePackgeViewCellCallBack {
    _JLFacePackgeViewCellCallBack = JLFacePackgeViewCellCallBack;
}
- (void)setIsSelectedImageHidden:(BOOL)isSelectedImageHidden {
    _isSelectedImageHidden = isSelectedImageHidden;
    if ([_model.id isEqualToString:@"plusButtonID"]) {
        _imageView.userInteractionEnabled = YES;
        _markButton.hidden = YES;
    }else {
        _imageView.userInteractionEnabled = _isSelectedImageHidden;
        _markButton.hidden = !_isSelectedImageHidden;
    }
}
@end
