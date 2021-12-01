#import "EmployeeTableViewCell.h"
@implementation EmployeeTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        [self customUI];
    }
    return self;
}
-(void)customUI{
    self.backgroundColor = [UIColor whiteColor];
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(10,12,36,36);
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [self.contentView addSubview:self.headImageView];
    _customTitleLabel = [UIFactory createLabelWith:CGRectMake(CGRectGetMaxX(_headImageView.frame)+16, 12, 100, 15) text:@"" font:g_UIFactory.font15 textColor:[UIColor blackColor] backgroundColor:nil];
    _customTitleLabel.textAlignment = NSTextAlignmentLeft;
    _customTitleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_customTitleLabel];
    _positionLabel = [UIFactory createLabelWith:CGRectMake(CGRectGetMaxX(_headImageView.frame)+16, CGRectGetMaxY(_headImageView.frame)-13, 100, 13) text:@"" font:g_factory.font13 textColor:THEMECOLOR backgroundColor:nil];
    [self.contentView addSubview:_positionLabel];
    _line = [[UIView alloc] initWithFrame:CGRectMake(15, 60-LINE_WH, TFJunYou__SCREEN_WIDTH-15, LINE_WH)];
    _line.backgroundColor = THE_LINE_COLOR;
    [self.contentView addSubview:_line];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutIfNeeded];
}
- (void)prepareForReuse
{
    [super prepareForReuse];
}
- (void)setupWithData:(EmployeObject *)dataObj level:(NSInteger)level
{
    self.customTitleLabel.text = dataObj.nickName;
    self.positionLabel.text = dataObj.position;
    [g_server getHeadImageSmall:dataObj.userId userName:dataObj.nickName imageView:_headImageView];
    self.employObject = dataObj;
    CGFloat left = 11 + 20 * level;
    CGRect headFrame = self.headImageView.frame;
    headFrame.origin.x = left;
    self.headImageView.frame = headFrame;
    self.customTitleLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame)+16, 12, 100, 15);
    self.positionLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame)+16, CGRectGetMaxY(_headImageView.frame)-13, 100, 13);
    self.line.frame = CGRectMake(left, self.line.frame.origin.y, TFJunYou__SCREEN_WIDTH-left, self.line.frame.size.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
