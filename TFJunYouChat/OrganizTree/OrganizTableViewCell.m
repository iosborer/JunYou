#import "OrganizTableViewCell.h"
@implementation OrganizTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customUI];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutIfNeeded];
    _additionButton.frame = CGRectMake(self.frame.size.width -28-6.5, 0, 28, 24);
    _additionButton.center = CGPointMake(_additionButton.center.x, self.contentView.center.y);
    _nameLabel.center = CGPointMake(_nameLabel.center.x, self.contentView.center.y);
    _arrowView.center = CGPointMake(_arrowView.center.x, self.contentView.center.y);
    _noticeLab.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+10, 5, TFJunYou__SCREEN_WIDTH-CGRectGetMaxX(_nameLabel.frame)-28-6.5-20, 22);
    _noticeLab.center = CGPointMake(_noticeLab.center.x, self.contentView.center.y);
}
-(void)customUI{
    _arrowView = [[UIImageView alloc] init];
    _arrowView.frame = CGRectMake(15, 0, 9, 9);
    _arrowView.image = [[UIImage imageNamed:@"arrow_right"] imageWithTintColor:THEMECOLOR];
    [self.contentView addSubview:_arrowView];
    _nameLabel = [UIFactory createLabelWith:CGRectMake(22, 5, 200, 22) text:@"" font:g_UIFactory.font15 textColor:[UIColor blackColor] backgroundColor:nil];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];
    _additionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _additionButton.frame = CGRectMake(self.frame.size.width -13-15-6.5, 10, 28, 24);
    [self.contentView addSubview:_additionButton];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(6.5, 10.5, 13, 3)];
    [imgV setImage:[[UIImage imageNamed:@"organize_more"] imageWithTintColor:THEMECOLOR]];
    [_additionButton addSubview:imgV];
    [_additionButton addTarget:self action:@selector(additionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), 5, 100, 22)];
    _noticeLab.textColor = THEMECOLOR;
    _noticeLab.font = SYSFONT(15);
    _noticeLab.text = @"????????????";
    _noticeLab.userInteractionEnabled = YES;
    [self.contentView addSubview:_noticeLab];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDidNotice:)];
    [_noticeLab addGestureRecognizer:tap];
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    self.arrowExpand = NO;
}
- (void)setupWithData:(DepartObject *)dataObj level:(NSInteger)level expand:(BOOL)expand
{
    _arrowView.transform = CGAffineTransformIdentity;
    if (expand == YES) {
        self.arrowExpand = expand;
    }
    self.nameLabel.text = dataObj.departName;
    self.organizObject = dataObj;
    CGFloat left = 15 * (level+1);
    CGRect arrowFrame = self.arrowView.frame;
    arrowFrame.origin.x = left;
    self.arrowView.frame = arrowFrame;
    CGSize size = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:SYSFONT(15)}];
    CGRect titleFrame = self.nameLabel.frame;
    titleFrame.origin.x = left +22;
    titleFrame.size.width = size.width;
    self.nameLabel.frame = titleFrame;
    _noticeLab.hidden = level != 0;
    if (!IsStringNull(dataObj.noticeContent)) {
        self.noticeLab.text = dataObj.noticeContent;
    }
}
#pragma mark - Properties
-(void)setArrowExpand:(BOOL)arrowExpand{
    [self setArrowExpand:arrowExpand animated:YES];
}
- (void)setArrowExpand:(BOOL)arrowExpand animated:(BOOL)animated{
    _arrowExpand = arrowExpand;
    [UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
        if (arrowExpand) {
            _arrowView.transform = CGAffineTransformRotate(_arrowView.transform, M_PI_2);
        }else{
            _arrowView.transform = CGAffineTransformRotate(_arrowView.transform, -M_PI_2);
        }
    }];
}
#pragma mark - Actions
- (void)additionButtonTapped:(id)sender
{
    if (self.additionButtonTapAction) {
        self.additionButtonTapAction(sender);
    }
}
- (void)onDidNotice:(UITapGestureRecognizer *)tap {
    if (self.noticeLabTapAction) {
        self.noticeLabTapAction(self.organizObject);
    }
}
@end
