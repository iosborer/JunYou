#import "TFJunYou_BlogRemindCell.h"
#import "TFJunYou_VideoPlayer.h"
#import "TFJunYou_AudioPlayer.h"
@interface TFJunYou_BlogRemindCell ()
@property (nonatomic, strong) TFJunYou_ImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIImageView *praiseImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *descImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) TFJunYou_VideoPlayer *player;
@property (nonatomic, strong) TFJunYou_AudioPlayer *audioPlayer;
@property (nonatomic, strong) UIButton *pauseBtn;
@end
@implementation TFJunYou_BlogRemindCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
        _headImageView.layer.cornerRadius = _headImageView.frame.size.width / 2;
        _headImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImageView];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, _headImageView.frame.origin.y, 100, 20)];
        _nameLabel.font = SYSFONT(16);
        _nameLabel.textColor = HEXCOLOR(0x5B6998);
        [self.contentView addSubview:_nameLabel];
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, CGRectGetMaxY(_nameLabel.frame) + 5, TFJunYou__SCREEN_WIDTH - CGRectGetMaxX(_headImageView.frame) - 10 - 85, 20)];
        _commentLabel.font = SYSFONT(15);
        _commentLabel.textColor = [UIColor grayColor];
        _commentLabel.numberOfLines = 0;
        [self.contentView addSubview:_commentLabel];
        _praiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_commentLabel.frame.origin.x, _commentLabel.frame.origin.y + 2, 15, 15)];
        _praiseImageView.image = [UIImage imageNamed:@"weibo_thumb"];
        [self.contentView addSubview:_praiseImageView];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, CGRectGetMaxY(_commentLabel.frame) + 5, 100, 20)];
        _timeLabel.font = SYSFONT(14.0);
        _timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeLabel];
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH - 75, _headImageView.frame.origin.y, 70, 70)];
        _descLabel.font = SYSFONT(14.0);
        _descLabel.textColor = [UIColor grayColor];
        _descLabel.numberOfLines = 0;
        [self.contentView addSubview:_descLabel];
        _descImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH - 85, _headImageView.frame.origin.y, 70, 70)];
        [self.contentView addSubview:_descImageView];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 85 - LINE_WH, TFJunYou__SCREEN_WIDTH, LINE_WH)];
        _lineView.backgroundColor = THE_LINE_COLOR;
        [self.contentView addSubview:_lineView];
        _commentLabel.hidden = YES;
        _praiseImageView.hidden = YES;
        _descLabel.hidden = YES;
        _descImageView.hidden = YES;
    }
    return self;
}
-(void)doRefresh:(TFJunYou_BlogRemind *)br {
    [g_server getHeadImageLarge:br.fromUserId userName:br.fromUserName imageView:_headImageView];
    _nameLabel.text = br.fromUserName;
    if (br.type == kWCMessageTypeWeiboPraise) {
        _praiseImageView.hidden = NO;
        _commentLabel.hidden = YES;
    }else {
        _praiseImageView.hidden = YES;
        _commentLabel.hidden = NO;
        if (br.type == kWCMessageTypeWeiboComment) {
            _commentLabel.text = br.content;
            if (br.toUserName.length > 0) {
                _commentLabel.text = [NSString stringWithFormat:@"%@%@: %@", Localized(@"JX_Reply"),br.toUserName, br.content];
                NSRange range = [_commentLabel.text rangeOfString:br.toUserName];
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:_commentLabel.text];
                [att addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x5B6998) range:range];
                _commentLabel.attributedText = att;
            }
        }
        else {
            _commentLabel.text = Localized(@"JX_AndMentionYouAtTheAameTime");
        }
        CGSize size = [_commentLabel.text boundingRectWithSize:CGSizeMake(_commentLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_commentLabel.font} context:nil].size;
        if (size.height > 20) {
            _commentLabel.frame = CGRectMake(_commentLabel.frame.origin.x, _commentLabel.frame.origin.y, _commentLabel.frame.size.width, size.height);
            _timeLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, CGRectGetMaxY(_commentLabel.frame) + 5, 100, 20);
            _lineView.frame = CGRectMake(0, CGRectGetMaxY(_timeLabel.frame) + 5, TFJunYou__SCREEN_WIDTH, LINE_WH);
        }else {
            _commentLabel.frame = CGRectMake(_commentLabel.frame.origin.x, _commentLabel.frame.origin.y, _commentLabel.frame.size.width,20);
            _timeLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, CGRectGetMaxY(_commentLabel.frame) + 5, 100, 20);
            _lineView.frame = CGRectMake(0, 85 - LINE_WH, TFJunYou__SCREEN_WIDTH, LINE_WH);
        }
    }
    self.timeLabel.text =  [TimeUtil getTimeStrStyle1:[br.timeSend timeIntervalSince1970]];
    switch (br.msgType) {
        case 1:{
                self.descImageView.hidden = YES;
                self.descLabel.hidden = NO;
                _pauseBtn.hidden = YES;
                self.descLabel.text = br.url;
            }
            break;
        case 2:{
                self.descImageView.hidden = NO;
                self.descLabel.hidden = YES;
                _pauseBtn.hidden = YES;
                [self.descImageView sd_setImageWithURL:[NSURL URLWithString:br.url] placeholderImage:[UIImage imageNamed:@"avatar_normal"]];
            }
            break;
        case 3:{
                self.descImageView.hidden = NO;
                self.descLabel.hidden = YES;
                _pauseBtn.hidden = YES;
            [g_server getHeadImageLarge:g_myself.userId userName:g_myself.userNickname imageView:self.descImageView];
                _audioPlayer = [[TFJunYou_AudioPlayer alloc] initWithParent:self.descImageView];
                _audioPlayer.isOpenProximityMonitoring = NO;
            }
            break;
        case 4:{
                self.descImageView.hidden = NO;
                self.descLabel.hidden = YES;
                if (!_pauseBtn) {
                    _pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
                    _pauseBtn.center = CGPointMake(self.descImageView.frame.size.width/2,self.descImageView.frame.size.height/2);
                    [_pauseBtn setBackgroundImage:[UIImage imageNamed:@"playvideo"] forState:UIControlStateNormal];
                    [self.descImageView addSubview:_pauseBtn];
                }
                _pauseBtn.hidden = NO;
                [TFJunYou_FileInfo getFirstImageFromVideo:br.url imageView:self.descImageView];
            }
            break;
        default:
            break;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
