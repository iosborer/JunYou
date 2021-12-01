#import "TFJunYou_WeiboCell.h"
#import "UIImageView+HBHttpCache.h"
#import "TimeUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "NSStrUtil.h"
#import "TFJunYou_ObjUrlData.h"
#import "TFJunYou_UserInfoVC.h"
#import "UIImageView+FileType.h"
#import "TFJunYou_LikeListViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "ImageResize.h"
#import "TFJunYou_GoogleMapVC.h"
#import "TFJunYou_MapData.h"
#define ICON_WIDTH  (TFJunYou__SCREEN_WIDTH - 25*3)/4  
@interface TFJunYou_WeiboCell ()<HBCoreLabelDelegate,YBAttributeTapActionDelegate>
{
}
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) TFJunYou_ImageView *shareIcon;
@property (nonatomic, strong) UILabel *shareTitle;
@property (nonatomic, assign) int delInt;
@end
@implementation TFJunYou_WeiboCell
@synthesize tableViewP,title,content,imageContent,fileView,time,delBtn,locLabel,mLogo,replyContent,btnDelete,btnReply,btnShare,back,tableReply,lockView,refreshCount,weibo;
@synthesize pauseBtn;
@synthesize imagePlayer;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _pool = [[NSMutableArray alloc]init];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        mLogo = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake(15,14,42,42)];
        mLogo.delegate = self;
        mLogo.didTouch = @selector(actionUser:);
        mLogo.layer.cornerRadius = mLogo.frame.size.width / 2;
        mLogo.layer.masksToBounds = YES;
        [self.contentView addSubview:mLogo];
        CGFloat X = CGRectGetMaxX(mLogo.frame)+10;
        title = [[UILabel alloc] initWithFrame:CGRectMake(X, 16, TFJunYou__SCREEN_WIDTH - 114, 19)];
        title.text = Localized(@"JXWeiboCell_Star");
        title.textColor = HEXCOLOR(0x576b95);
        [self.contentView addSubview:title];
        time = [[UILabel alloc]initWithFrame:CGRectMake(X,CGRectGetMaxY(title.frame)+8,40,13)];
        time.textColor = HEXCOLOR(0x999999);
        time.font = [UIFont systemFontOfSize:12];
        delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setTitle:Localized(@"JX_Delete") forState:UIControlStateNormal];
        [delBtn setTitle:Localized(@"JX_Delete") forState:UIControlStateHighlighted];
        [delBtn setTitleColor:HEXCOLOR(0x576b95) forState:UIControlStateNormal];
        [delBtn setTitleColor:HEXCOLOR(0x576b95) forState:UIControlStateHighlighted];
        delBtn.titleLabel.font = g_factory.font12;
        delBtn.tag = self.tag;
        delBtn.hidden = YES;
        [delBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        content = [[HBCoreLabel alloc]initWithFrame:CGRectMake(X, CGRectGetMaxY(mLogo.frame)+11, TFJunYou__SCREEN_WIDTH - X-15, 21)];
        content.delegate = self;
        content.textColor = HEXCOLOR(0x323232);
        [self.contentView addSubview:content];
        imageContent = [[UIView alloc]initWithFrame:CGRectMake(X, CGRectGetMaxY(mLogo.frame)+11, TFJunYou__SCREEN_WIDTH - X*2, 21)];
        [self.contentView addSubview:imageContent];
        _audioPlayer = [[TFJunYou_AudioPlayer alloc]initWithParent:self.imageContent frame:CGRectNull isLeft:YES];
        _audioPlayer.isOpenProximityMonitoring = YES;
        fileView = [[UIView alloc] initWithFrame:CGRectMake(X, 40, TFJunYou__SCREEN_WIDTH -100, 100)];
        fileView.backgroundColor = HEXCOLOR(0xF2F2F2);
        UITapGestureRecognizer * tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fileUrlCopy)];
        [fileView addGestureRecognizer:tapges];
        [self.contentView addSubview:fileView];
        fileView.hidden = YES;
        if(!_typeView){
            _typeView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 60, 60)];
            _typeView.layer.cornerRadius = 3;
            _typeView.layer.masksToBounds = YES;
            [fileView addSubview:_typeView];
        }
        if(!_fileTitleLabel){
            _fileTitleLabel = [UIFactory createLabelWith:CGRectZero text:@"--.--" font:g_factory.font15 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
            _fileTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            _fileTitleLabel.frame = CGRectMake(CGRectGetMaxX(_typeView.frame) +5, 0, CGRectGetWidth(fileView.frame)-CGRectGetMaxX(_typeView.frame)-5-5, 25);
            _fileTitleLabel.center = CGPointMake(_fileTitleLabel.center.x, _typeView.center.y);
            _fileTitleLabel.textAlignment = NSTextAlignmentLeft;
            [fileView addSubview:_fileTitleLabel];
        }
        [self createShareView];
        replyContent = [[UIView alloc]initWithFrame:CGRectMake(X,CGRectGetMaxY(mLogo.frame)+11,TFJunYou__SCREEN_WIDTH -X-15,30)];
        replyContent.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:replyContent];
        locLabel = [UIFactory createLabelWith:CGRectZero text:nil font:g_factory.font11 textColor:HEXCOLOR(0x576b95) backgroundColor:[UIColor clearColor]];
        locLabel.frame = CGRectMake(15, CGRectGetMaxY(replyContent.frame)+12, TFJunYou__SCREEN_WIDTH -70, 14);
        locLabel.hidden = YES;
        locLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:locLabel];
        UITapGestureRecognizer *locTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLoction)];
        [locLabel addGestureRecognizer:locTap];
        tableReply = [[UITableView alloc]initWithFrame:CGRectMake(0,31,TFJunYou__SCREEN_WIDTH -75,0)];
        tableReply.dataSource = self;
        tableReply.delegate   = self;
        tableReply.tag        = self.tag;
        tableReply.backgroundColor = [UIColor clearColor];
        tableReply.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableReply.frame.size.width, 23)];
        _moreLabel.backgroundColor = [UIColor clearColor];
        _moreLabel.textAlignment = NSTextAlignmentCenter;
        _moreLabel.font = SYSFONT(13);
        _moreLabel.text=Localized(@"JX_SeeMoreComments");
        _moreLabel.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getMoreData)];
        [_moreLabel addGestureRecognizer:tap];
        tableReply.tableFooterView = _moreLabel;
        _btnReport = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnReport.frame = CGRectMake(TFJunYou__SCREEN_WIDTH -15-25,15,25,25);
        [_btnReport setImage:[UIImage imageNamed:@"weibo_report"] forState:UIControlStateNormal];
        [_btnReport setImage:[UIImage imageNamed:@"weibo_reported"] forState:UIControlStateHighlighted];
        _btnReport.tag = self.tag*1000+4;
        [_btnReport addTarget:self action:@selector(btnReply:) forControlEvents:UIControlEventTouchUpInside];
        _btnCollection = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCollection setImage:[UIImage imageNamed:@"weibo_collection"] forState:UIControlStateNormal];
        [_btnCollection setImage:[UIImage imageNamed:@"weibo_collected"] forState:UIControlStateHighlighted];
        [_btnCollection setImage:[UIImage imageNamed:@"weibo_collected"] forState:UIControlStateSelected];
        _btnCollection.tag = self.tag*1000+3;
        [_btnCollection addTarget:self action:@selector(btnReply:) forControlEvents:UIControlEventTouchUpInside];
        btnReply = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnReply setTitleColor:HEXCOLOR(0x556b95) forState:UIControlStateNormal];
        [btnReply.titleLabel setFont:SYSFONT(13)];
        [btnReply setImage:[UIImage imageNamed:@"weibo_comment"] forState:UIControlStateNormal];
        [btnReply setImage:[UIImage imageNamed:@"weibo_commented"] forState:UIControlStateHighlighted];
        btnReply.tag = self.tag*1000+2;
        [btnReply setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [btnReply setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [btnReply addTarget:self action:@selector(btnReply:) forControlEvents:UIControlEventTouchUpInside];
        _btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLike setTitleColor:HEXCOLOR(0x556b95) forState:UIControlStateNormal];
        [_btnLike.titleLabel setFont:SYSFONT(13)];
        [_btnLike setImage:[UIImage imageNamed:@"weibo_thumb"] forState:UIControlStateNormal];
        [_btnLike setImage:[UIImage imageNamed:@"weibo_thumbed"] forState:UIControlStateHighlighted];
        [_btnLike setImage:[UIImage imageNamed:@"weibo_thumbed"] forState:UIControlStateSelected];
        [_btnLike setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _btnLike.tag = self.tag*1000+1;
        [_btnLike addTarget:self action:@selector(btnReply:) forControlEvents:UIControlEventTouchUpInside];
        back = [[UIImageView alloc]initWithFrame:CGRectMake(0,25,replyContent.frame.size.width,0)];
        back.image = [[[UIImage imageNamed:@"AlbumTriangleB"] imageWithTintColor:HEXCOLOR(0xF2F2F2)] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        back.userInteractionEnabled = YES;
        [self.contentView addSubview:_btnReport];
        [self.contentView addSubview:time];
        [self.contentView addSubview:delBtn];
        [replyContent addSubview:btnReply];
        [replyContent addSubview:_btnLike];
        [replyContent addSubview:_btnCollection];
        [replyContent addSubview:back];
        [replyContent addSubview:tableReply];
    }
    return self;
}
- (void)createShareView {
    if (!_shareView) {
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(57, 25, TFJunYou__SCREEN_WIDTH - 100, 70)];
        _shareView.backgroundColor = HEXCOLOR(0xf0f0f0);
        _shareView.hidden = YES;
        UITapGestureRecognizer * tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareUrlAction)];
        [_shareView addGestureRecognizer:tapges];
        [self.contentView addSubview:_shareView];
        _shareIcon = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [_shareIcon sd_setImageWithURL:[NSURL URLWithString:weibo.sdkIcon] placeholderImage:[UIImage imageNamed:@"ALOGO_120"]];
        [_shareView addSubview:_shareIcon];
       _shareTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_shareIcon.frame) + 5, _shareIcon.frame.origin.y, _shareView.frame.size.width - CGRectGetMaxX(_shareIcon.frame) - 15, _shareIcon.frame.size.height)];
        _shareTitle.numberOfLines = 0;
        _shareTitle.text = weibo.sdkTitle;
        _shareTitle.font = [UIFont systemFontOfSize:14.0];
        [_shareView addSubview:_shareTitle];
    }
}
- (void)shareUrlAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TFJunYou_WeiboCell:shareUrlActionWithUrl:title:)]) {
        [self.delegate TFJunYou_WeiboCell:self shareUrlActionWithUrl:weibo.sdkUrl title:weibo.sdkTitle];
    }
}
- (void)setupData {
    btnReply.frame = CGRectMake(0,0,60,25);
    _btnCollection.frame = CGRectMake(TFJunYou__SCREEN_WIDTH/2-67,0,25,25);
    _btnLike.frame = CGRectMake(back.frame.size.width-67-25,0,60,25);
    if ([weibo.userId isEqualToString:MY_USER_ID]) {
        _btnReport.hidden = YES;
    }else {
        _btnReport.hidden = NO;
    }
    [_btnLike setTitle:[self getMaxValue:weibo.praiseCount] forState:UIControlStateNormal];
    [btnReply setTitle:[self getMaxValue:weibo.commentCount] forState:UIControlStateNormal];
}
- (NSString *)getMaxValue:(int)value {
    NSString *str = [NSString string];
    if (value > 99) {
        str = @"99+";
    }else {
        str = [NSString stringWithFormat:@"%d",value];
    }
    return str;
}
- (void)fileUrlCopy{
    [self.controller fileAction:weibo];
}
-(void)delBtnAction:(WeiboData*)cellData{
    [self.controller delBtnAction:self.weibo];
}
- (void)setIsPraise:(BOOL)isPraise {
    _isPraise = isPraise;
    _btnLike.selected = isPraise;
}
- (void)setIsCollect:(BOOL)isCollect {
    _isCollect = isCollect;
    _btnCollection.selected = isCollect;
}
- (void)btnReply:(UIButton*)button{
    [_btnLike setTitle:[self getMaxValue:weibo.praiseCount] forState:UIControlStateNormal];
    [btnReply setTitle:[self getMaxValue:weibo.commentCount] forState:UIControlStateNormal];
    [self.controller btnReplyAction:button WithCell:self];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self){
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
#pragma -mark 私有方法
-(void) prepare
{
    [super prepareForReuse];
    for(UIView * view in imageContent.subviews)
        [view removeFromSuperview];
    UIView * view=[self.contentView viewWithTag:191];
    if(view){
        [view removeFromSuperview];
    }
    view=[self.contentView viewWithTag:192];
    if(view){
        [view removeFromSuperview];
    }
    linesLimit=NO;
}
+(float) heightForReply:(NSArray*)replys
{
    if([replys count]==0)
        return 0;
    float height=6;
    for(TFJunYou_WeiboReplyData * data in replys){
        height+=data.height+4;
    }
    return height;
}
#pragma mark --------------依据图片数量设置大小-----------------
-(void)addImagesWithFiles:(float)offset
{
    if(self.weibo.imageHeight==0){
        self.imageContent.hidden=YES;
        CGRect  frame=self.imageContent.frame;
        frame.origin.y=self.content.frame.origin.y+self.content.frame.size.height+offset+5;
        frame.size.height=0;
        self.imageContent.frame=frame;
        return;
    }else{
        self.imageContent.hidden=NO;
        CGRect  frame=self.imageContent.frame;
        frame.origin.y=self.content.frame.origin.y+self.content.frame.size.height+offset+5;
        frame.size.height=self.weibo.imageHeight;
        self.imageContent.frame=frame;
    }
    __weak TFJunYou_WeiboCell * wself=self;
    __weak WeiboData * wweibo=self.weibo;
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if (wself&&wweibo.willDisplay&&wweibo) {
            __strong TFJunYou_WeiboCell * sself=wself;
            __strong WeiboData * sweibo=wweibo;
            dispatch_async(dispatch_get_main_queue(), ^{
                HBShowImageControl *imageControl=[[HBShowImageControl alloc]initWithFrame:sself.imageContent.bounds];
                imageControl.controller=sself.controller;
                imageControl.smallTag=THUMB_WEIBO_SMALL_1;
                imageControl.bigTag=THUMB_WEIBO_BIG;
                imageControl.larges = sweibo.larges;
                [imageControl setImagesFileStr:sweibo.larges];
                [sself.imageContent addSubview:imageControl];
                imageControl.delegate=sself;
            });
        }
    });
}
-(void)addImageForAudioVideo:(float)offset
{
    self.imageContent.hidden=NO;
    CGRect  frame=self.imageContent.frame;
    frame.origin.y=self.content.frame.origin.y+self.content.frame.size.height+offset+5;
    frame.size.height=self.weibo.imageHeight+self.weibo.videoHeight;
    self.imageContent.frame=frame;
    CGFloat w = 150;
    CGFloat h = 200;
    if (self.weibo.videoHeight < 200) {
        w = 200;
        h = 150;
    }
    imagePlayer = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    imagePlayer.changeAlpha = NO;
    imagePlayer.didTouch = @selector(doNotThing);
    imagePlayer.delegate = self.controller;
    [self.imageContent addSubview:imagePlayer];
        imagePlayer.contentMode = UIViewContentModeScaleAspectFit;
        if(weibo.isVideo){
            [imagePlayer sd_setImageWithURL:[[self.weibo.images firstObject] valueForKey:@"oUrl"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error) {
                    [TFJunYou_FileInfo getFirstImageFromVideoWithImageVIew:[self.weibo getMediaURL] imageView:imagePlayer];
                }
                imagePlayer.image = [ImageResize image:image fillSize:imagePlayer.frame.size];
            }];
            UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
            pauseBtn.center = CGPointMake(imagePlayer.frame.size.width/2,imagePlayer.frame.size.height/2);
            [pauseBtn setBackgroundImage:[UIImage imageNamed:@"playvideo"] forState:UIControlStateNormal];
            [pauseBtn addTarget:self action:@selector(showTheVideo) forControlEvents:UIControlEventTouchUpInside];
            [imagePlayer addSubview:pauseBtn];
        }
}
- (void)setupAudioPlayer:(float)offset {
    if (!_audioPlayer) {
        _audioPlayer = [[TFJunYou_AudioPlayer alloc]initWithParent:self.imageContent frame:CGRectNull isLeft:YES];
    }
    TFJunYou_ObjUrlData *data = (TFJunYou_ObjUrlData *)[self.weibo.audios firstObject];
    if([data.timeLen intValue] <= 0)
        data.timeLen  = @1;
    int w = (TFJunYou__SCREEN_WIDTH-HEAD_SIZE-INSETS*2-70)/30;
    w = 70+w*[data.timeLen intValue];
    if(w<70)
        w = 70;
    if(w>200)
        w = 200;
    self.imageContent.hidden=NO;
    CGRect  frame=self.imageContent.frame;
    frame.origin.y=self.content.frame.origin.y+self.content.frame.size.height+offset+5;
    frame.size = CGSizeMake(w, 30);
    self.imageContent.frame=CGRectMake(self.imageContent.frame.origin.x, frame.origin.y, self.imageContent.frame.size.width, frame.size.height);
    self.imageContent.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAudioPlay)];
    [self.imageContent addGestureRecognizer:tap];
    _audioPlayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _audioPlayer.audioFile = [self.weibo getMediaURL];
    _audioPlayer.timeLen = [data.timeLen intValue];
    _audioPlayer.timeLenView.textColor = HEXCOLOR(0x999999);
    _audioPlayer.voiceBtn.backgroundColor = HEXCOLOR(0xECEDEF);
}
- (void)startAudioPlay {
    [_audioPlayer switch];
}
#pragma -mark 点击播放视频
- (void)showTheVideo {
    [self.delegate TFJunYou_WeiboCell:self clickVideoWithIndex:self.tag];
}
- (void)doNotThing{
}
- (void)onLoction {
    double location_x = [self.weibo.latitude doubleValue];
    double location_y = [self.weibo.longitude doubleValue];
    TFJunYou_MapData * mapData = [[TFJunYou_MapData alloc] init];
    mapData.latitude = [NSString stringWithFormat:@"%f",location_x];
    mapData.longitude = [NSString stringWithFormat:@"%f",location_y];
    NSArray * locations = @[mapData];
    mapData.title = self.weibo.location;
    if (g_config.isChina) {
        TFJunYou_LocationVC * vc = [TFJunYou_LocationVC alloc];
        vc.placeNames = self.weibo.location;
        vc.locations = [NSMutableArray arrayWithArray:locations];
        vc.locationType = TFJunYou_LocationTypeShowStaticLocation;
        vc = [vc init];
        [g_navigation pushViewController:vc animated:YES];
    }else {
        TFJunYou_GoogleMapVC *gooMap = [TFJunYou_GoogleMapVC alloc] ;
        gooMap.locations = [NSMutableArray arrayWithArray:locations];
        gooMap.locationType = TFJunYou_GooLocationTypeShowStaticLocation;
        gooMap.placeNames = self.weibo.location;
        gooMap = [gooMap init];
        [g_navigation pushViewController:gooMap animated:YES];
    }
}
#pragma -mark 接口方法
-(void)loadReply
{
    [self.tableReply reloadData];
}
#pragma  mark  ------------------填充数据--------------
-(void)setWeibo:(WeiboData *)value
{
    value.willDisplay=YES;
    weibo=value;
    [self prepare];
    replyCount=(int)[self.weibo.replys count];
    linesLimit=self.weibo.linesLimit;
    title.text = self.weibo.userNickName;
    [g_App.jxServer getHeadImageSmall:self.weibo.userId userName:self.weibo.userNickName imageView:self.mLogo];
    [self.content registerCopyAction];
    self.content.linesLimit=self.weibo.linesLimit;
    __weak HBCoreLabel * wcontent=self.content;
    MatchParser* match=[self.weibo getMatch:^(MatchParser *parser,id data) {
        if (wcontent) {
            WeiboData * weibo=(WeiboData*)data;
            if (weibo.willDisplay) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   wcontent.match=parser;
                });
            }
        }
    } data:self.weibo];
    self.content.match=match;
    self.time.text=[TimeUtil getTimeStrStyle1:weibo.createTime];
    CGRect frame=self.time.frame;
    frame.size.width = [self.time.text sizeWithAttributes:@{NSFontAttributeName:self.time.font}].width + 10;
    self.time.frame=frame;
    CGFloat delW = [self.delBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.delBtn.titleLabel.font}].width +10;
    self.delBtn.frame = CGRectMake(CGRectGetMaxX(self.time.frame)+5, CGRectGetMinY(self.time.frame), delW, CGRectGetHeight(self.time.frame));
    if (weibo.location.length >0){
        self.locLabel.text = weibo.location;
        locLabel.hidden = NO;
    }else{
        locLabel.hidden = YES;
    }
    self.tableReply.scrollEnabled=NO;
    float offset=0.0f;
    if(self.weibo.numberOfLineLimit<self.weibo.numberOfLinesTotal){
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:self.title.textColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:g_factory.font15];
        [self.contentView addSubview:button];
        [button addTarget:self action:@selector(limitAction) forControlEvents:UIControlEventTouchUpInside];
#pragma mark － 这里更改了说说的坐标
        if(self.weibo.linesLimit){
            [button setTitle:Localized(@"JXWeiboCell_AllText") forState:UIControlStateNormal];
            content.frame=CGRectMake(CGRectGetMaxX(mLogo.frame)+10, CGRectGetMaxY(mLogo.frame)+11, TFJunYou__SCREEN_WIDTH -CGRectGetMaxX(mLogo.frame)-10-15,self.weibo.heightOflimit);
            offset=22;
        }else{
            [button setTitle:Localized(@"JXWeiboCell_Stop") forState:UIControlStateNormal];
            content.frame=CGRectMake(CGRectGetMaxX(mLogo.frame)+10, CGRectGetMaxY(mLogo.frame)+11, TFJunYou__SCREEN_WIDTH -CGRectGetMaxX(mLogo.frame)-10-15,self.weibo.height);
            offset=22;
        }
        if ((self.weibo.images.count > 0 || self.weibo.larges.count > 0 || self.weibo.smalls.count > 0) || self.weibo.audios.count > 0 || self.weibo.videos.count > 0 || self.weibo.files.count > 0) {
            offset += 15;
        }
        button.frame=CGRectMake(CGRectGetMinX(content.frame), CGRectGetMaxY(content.frame)+9, 50, 20);
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
        button.tag=191;
    }else{
        content.frame=CGRectMake(CGRectGetMaxX(mLogo.frame)+10, CGRectGetMaxY(mLogo.frame)+11, TFJunYou__SCREEN_WIDTH -CGRectGetMaxX(mLogo.frame)-10-15,self.weibo.height); 
    }
    if([weibo.videos count]>0)
        [self addImageForAudioVideo:offset];
    else if ( [weibo.audios count]>0)
        [self setupAudioPlayer:offset];
    else
        [self addImagesWithFiles:offset];
    if (weibo.type == weibo_dataType_share) {
        self.shareView.hidden = NO;
        CGRect frame=CGRectMake(CGRectGetMaxX(mLogo.frame)+10, 25, TFJunYou__SCREEN_WIDTH - 100, 70);
        frame.origin.y=CGRectGetMaxY(self.content.frame)+offset+5;
        self.shareView.frame=frame;
        _shareTitle.text = weibo.sdkTitle;
        [_shareIcon sd_setImageWithURL:[NSURL URLWithString:weibo.sdkIcon] placeholderImage:[UIImage imageNamed:@"ALOGO_120"]];
    }else {
        self.shareView.frame = CGRectZero;
        self.shareView.hidden = YES;
    }
    if ([weibo.files count]>0) {
        self.fileView.hidden = NO;
        self.fileView.frame = CGRectMake(CGRectGetMaxX(mLogo.frame)+10, 40, TFJunYou__SCREEN_WIDTH -100, 100);
        CGRect  frame=self.fileView.frame;
        frame.origin.y=self.content.frame.origin.y+self.content.frame.size.height+offset+5;
        self.fileView.frame=frame;
        TFJunYou_ObjUrlData * url= [weibo.files firstObject];
        NSString *urlName;
        if (url.name.length > 0) {
            urlName = url.name;
        }else {
            urlName = [url.url lastPathComponent];
        }
        _fileTitleLabel.text = urlName;
        NSString * fileExt = [urlName pathExtension];
        NSInteger fileType = [self fileTypeWithExt:fileExt];
        [_typeView setFileType:fileType];
    }else{
        self.fileView.frame = CGRectZero;
        self.fileView.hidden = YES;
    }
    int moreH = 0;
    if (self.weibo.replys.count == 20) {
        moreH = 23;
        tableReply.tableFooterView = _moreLabel;
    }else {
        tableReply.tableFooterView = nil;
    }
    float height=self.weibo.replyHeight;
    if(height>=0){
        [self createTableHead];
        if (self.weibo.heightPraise > 0) {
            height = self.weibo.replyHeight - self.weibo.heightPraise + _heightPraise + 5;
        }
        frame=self.replyContent.frame;
        frame.origin.y=self.imageContent.frame.origin.y+self.imageContent.frame.size.height+5 +CGRectGetHeight(self.fileView.frame)+CGRectGetHeight(self.shareView.frame);
        frame.size.height=self.weibo.replyHeight+30+moreH;
        self.replyContent.frame=frame;
        frame=back.frame;
        frame.size.height=height+3+moreH;
        frame.origin.y=25;
        back.frame=frame;
        frame=tableReply.frame;
        frame.size.height=height+moreH;
        frame.origin.y=31;
        tableReply.frame=frame;
        if ([self.weibo.replys isKindOfClass:[NSArray class]]&&([self.weibo.replys count]>0 || [self.weibo.praises count]>0)) {
            locLabel.frame = CGRectMake(CGRectGetMaxX(mLogo.frame)+10, CGRectGetMaxY(back.frame)+12+CGRectGetMinY(self.replyContent.frame), TFJunYou__SCREEN_WIDTH -70, 14);
        }else {
            locLabel.frame = CGRectMake(CGRectGetMaxX(mLogo.frame)+10, CGRectGetMaxY(replyContent.frame)+2, TFJunYou__SCREEN_WIDTH -70, 14);
        }
    }
    back.hidden = height<=0;
    tableReply.hidden = height<=0;
    if(self.weibo.local){
        [self.btnReply setEnabled:NO];
    }else{
        [self.btnReply setEnabled:YES];
    }
    [self.tableReply reloadData];
}
-(int)fileTypeWithExt:(NSString *)fileExt{
    int fileType = 0;
    if ([fileExt isEqualToString:@"jpg"] || [fileExt isEqualToString:@"jpeg"] || [fileExt isEqualToString:@"png"] || [fileExt isEqualToString:@"gif"] || [fileExt isEqualToString:@"bmp"])
        fileType = 1;
    else if ([fileExt isEqualToString:@"amr"] || [fileExt isEqualToString:@"mp3"] || [fileExt isEqualToString:@"wav"])
        fileType = 2;
    else if ([fileExt isEqualToString:@"mp4"] || [fileExt isEqualToString:@"mov"])
        fileType = 3;
    else if ([fileExt isEqualToString:@"ppt"] || [fileExt isEqualToString:@"pptx"])
        fileType = 4;
    else if ([fileExt isEqualToString:@"xls"] || [fileExt isEqualToString:@"xlsx"])
        fileType = 5;
    else if ([fileExt isEqualToString:@"doc"] || [fileExt isEqualToString:@"docx"])
        fileType = 6;
    else if ([fileExt isEqualToString:@"zip"] || [fileExt isEqualToString:@"rar"])
        fileType = 7;
    else if ([fileExt isEqualToString:@"txt"])
        fileType = 8;
    else if ([fileExt isEqualToString:@"pdf"])
        fileType = 10;
    else
        fileType = 9;
    return fileType;
}
+(float)getHeightByContent:(WeiboData*)data
{
    float height;
    if(data.shouldExtend){
        if(data.linesLimit){
            height=data.heightOflimit+23;
        }else{
            height=data.height+23;
        }
    }else{
        height=data.height;
    }
    if (data.location.length > 0) {
        height += 22;
    }
    if(data.numberOfLineLimit<data.numberOfLinesTotal){
        if ((data.images.count > 0 || data.larges.count > 0 || data.smalls.count > 0) || data.audios.count > 0 || data.videos.count > 0 || data.files.count > 0) {
            height += 15;
        }
    }
    if ([data.replys isKindOfClass:[NSArray class]]&&([data.replys count]>0 || [data.praises count]>0)&&!data.local) {
        int h = 0;
        if ([data.replys count] == 20) {
            h = 23;
        }
        CGFloat rH = data.replyHeight;
        return 100.0+h+data.imageHeight+height+rH +data.fileHeight + data.shareHeight+data.videoHeight;
    } else  {
        return 90.0+data.imageHeight+height +data.fileHeight + data.shareHeight+data.videoHeight;
    }
}
#pragma -mark 委托方法
-(void)showImageControlFinishLoad:(HBShowImageControl*)control
{
    CGRect frame=self.imageContent.frame;
    frame.size.height=control.frame.size.height;
    self.imageContent.frame=frame;
}
#pragma -mark 事件响应方法
-(void)limitAction
{
    self.weibo.linesLimit=!self.weibo.linesLimit;
    [self refresh];
}
#pragma -mark 回调方法
-(void)lookImageAction:(HBShowImageControl*)control
{
}
-(void)coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr
{
    [g_notify postNotificationName:kCellTouchUrlNotifaction object:linkStr];
}
-(void)coreLabel:(HBCoreLabel *)coreLabel phoneClick:(NSString *)linkStr
{
    [g_notify postNotificationName:kCellTouchPhoneNotifaction object:linkStr];
}
#pragma -mark  tableReply delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_WeiboReplyData * data=[self.weibo.replys objectAtIndex:indexPath.row];
    NSLog(@"------%d",data.height + 4);
    return data.height+4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = [self.weibo.replys count];
    return n;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"WeiboReplyCell"];
    ReplyCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.label = nil;
    cell.backgroundColor = [UIColor clearColor];
    if(indexPath.row>=self.weibo.replys.count)
        return cell;
    cell.label = [[HBCoreLabel alloc]initWithFrame:CGRectMake(10, 4, TFJunYou__SCREEN_WIDTH, 27)];
    [cell addSubview:cell.label];
    cell.label.backgroundColor = [UIColor clearColor];
    TFJunYou_WeiboReplyData * data=[self.weibo.replys objectAtIndex:indexPath.row];
    __weak HBCoreLabel * wlabel=cell.label;
    MatchParser * match=[data getMatch:^(MatchParser *parser, id data) {
        if (wlabel) {
            WeiboData * weibo=(WeiboData*)data;
            if (weibo.willDisplay) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    wlabel.match=parser;
                });
            }
        }
    } data:self.weibo];
    cell.label.match=match;
    cell.label.userInteractionEnabled=YES;
    CGRect frame=cell.label.frame;
    cell.backgroundColor=[UIColor clearColor];
    frame.size.height=data.height;
    cell.label.frame=frame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * row = [NSIndexPath indexPathForRow:self.tag inSection:0];
    self.controller.selectTFJunYou_WeiboCell = [self.tableViewP cellForRowAtIndexPath:row];
    self.controller.selectWeiboData = self.controller.selectTFJunYou_WeiboCell.weibo;
    TFJunYou_WeiboReplyData* p =[self.weibo.replys objectAtIndex:indexPath.row];
    if ([MY_USER_ID intValue] == [p.userId intValue]) {
        [g_App showAlert:@"是否删除评论" delegate:self];
        self.controller.deleteReply = (int)indexPath.row;
        return;
    }
    self.controller.replyDataTemp.userId    = MY_USER_ID;
    self.controller.replyDataTemp.userNickName  = g_server.myself.userNickname;
    self.controller.replyDataTemp.toNickName = p.userNickName;
    self.controller.replyDataTemp.toUserId = p.userId;
    [self.controller doShowAddComment:[NSString stringWithFormat:@"%@%@",Localized(@"JXWeiboCell_Reply"),p.userNickName]];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        TFJunYou_WeiboReplyData* p = [self.weibo.replys objectAtIndex:self.controller.deleteReply];
        [g_server delComment:self.controller.selectWeiboData.messageId commentId:p.replyId toView:self.controller];
    }
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [g_wait stop];
    if( [aDownload.action isEqualToString:act_UserGet] ){
        TFJunYou_UserObject* p = [[TFJunYou_UserObject alloc]init];
        [p getDataFromDict:dict];
        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
        vc.user       = p;
        vc.fromAddType = 6;
        vc = [vc init];
        [g_navigation pushViewController:vc animated:YES];
        [_pool addObject:vc];
    }
    if ([aDownload.action isEqualToString:act_CommentList]) {
        int moreHeight = 23;
        if (array1.count < 20) {
            self.weibo.replyHeight -= moreHeight;
            self.tableReply.tableFooterView = nil;
            moreHeight = 0;
        }else {
            self.tableReply.tableFooterView = _moreLabel;
        }
        CGFloat height = 0;
        for(int i=0;i<[array1 count];i++){
            TFJunYou_WeiboReplyData * reply=[[TFJunYou_WeiboReplyData alloc]init];
            NSDictionary* dict = [array1 objectAtIndex:i];
            reply.type=1;
            [reply getDataFromDict:dict];
            [reply setMatch];
            [self.weibo.replys addObject:reply];
            height += (reply.height +4);
        }
        self.weibo.replyHeight = self.weibo.replyHeight+height+moreHeight;
        [self.tableReply reloadData];
        [self.controller setupTableViewHeight:height tag:self.tag];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [g_wait stop];
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [g_wait stop];
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [g_wait start:nil];
}
-(void)refresh{
    NSIndexPath* row = [NSIndexPath indexPathForRow:self.tag inSection:0];
    self.controller.refreshCellIndex = self.tag;
    [self.tableViewP reloadData];
    self.controller.refreshCellIndex = -1;
    if (self.weibo.linesLimit && self.weibo.numberOfLinesTotal > 30) {
        [self.tableViewP scrollToRowAtIndexPath:row atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
-(void)setReplys:(NSArray *)replys{
    _replys = [NSArray arrayWithArray:replys];
}
-(NSArray *)getReplys{
    return _replys;
}
- (void)pushLikeVC {
    TFJunYou_LikeListViewController *likeListVC = [TFJunYou_LikeListViewController alloc];
    likeListVC.weibo = self.weibo;
    likeListVC = [likeListVC init];
    [g_navigation pushViewController:likeListVC animated:YES];
}
#pragma mark - 创建回复区的点赞区
-(void)createTableHead{
    if([self.weibo.praises count]<=0){
        self.tableReply.tableHeaderView = nil;
        return;
    }
    TFJunYou_WeiboReplyData* p = [[TFJunYou_WeiboReplyData alloc]init];
    p.type = reply_data_praise;
    p.body = [self.weibo getAllPraiseUsers];
    int y = 3;
    if([weibo.replys count]>0){
        y = 2;
    }
#pragma mark 点赞Label长度
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(32, y, self.tableReply.frame.size.width - 40, 32)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = HEXCOLOR(0x576b95);
    label.font = g_factory.font14;
    label.numberOfLines = 0;
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.weibo.praises.count; i++){
        TFJunYou_WeiboReplyData* praises = [self.weibo.praises objectAtIndex:i];
        [data addObject:praises.userNickName];
    }
    if (data.count > 20) {
        [data removeObjectAtIndex:data.count-1];
    }
    [data addObject:[NSString stringWithFormat:@"%d%@",self.weibo.praiseCount,Localized(@"WeiboData_PerZan1")]];
    NSAttributedString * showAttString = [self getAttributeWith:data string:p.body orginFont:14 orginColor:HEXCOLOR(0x576b95) attributeFont:14 attributeColor:HEXCOLOR(0x576b95)];
    label.attributedText = showAttString;
    [label yb_addAttributeTapActionWithStrings:data tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        if (index == self.weibo.praises.count) {
            [self pushLikeVC];
        }else{
            TFJunYou_WeiboReplyData *user = self.weibo.praises[index];
            TFJunYou_UserInfoVC *userInfoVC = [TFJunYou_UserInfoVC alloc];
            userInfoVC.userId = user.userId;
            userInfoVC.fromAddType = 6;
            userInfoVC = [userInfoVC init];
            [g_navigation pushViewController:userInfoVC animated:YES];
        }
    }];
    CGSize size = [p.body boundingRectWithSize:CGSizeMake(self.tableReply.frame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:g_factory.font14} context:nil].size;
    size.height += 5;
    _heightPraise = size.height+5;
    CGRect frame=label.frame;
    frame.size.height=size.height;
    label.frame=frame;
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableReply.frame.size.width, _heightPraise)];
    [v addSubview:label];
    UIImageView* iv;
    if([weibo.replys count]>0){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, _heightPraise-0.5, back.frame.size.width, LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [v addSubview:line];
    }
    iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 15, 15)];
    iv.image = [UIImage imageNamed:@"heart_praise"];
    [v addSubview:iv];
    self.tableReply.tableHeaderView = v;
}
-(void)actionUser:(UIView*)sender{
    [_pool removeAllObjects];
    if([self.weibo.userId isEqualToString:CALL_CENTER_USERID])
        return;
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId       = self.weibo.userId;
    vc.fromAddType = 6;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    [_pool addObject:vc];
}
- (void)getMoreData {
    self.weibo.page ++;
    [g_server listComment:self.weibo.messageId pageIndex:self.weibo.page pageSize:20 commentId:nil toView:self];
}
- (void)dealloc {
    NSLog(@"TFJunYou_WeiboCell.dealloc");
        [_audioPlayer stop];
        _audioPlayer = nil;
}
- (NSAttributedString *)getAttributeWith:(id)sender
                                  string:(NSString *)string
                               orginFont:(CGFloat)orginFont
                              orginColor:(UIColor *)orginColor
                           attributeFont:(CGFloat)attributeFont
                          attributeColor:(UIColor *)attributeColor
{
    __block  NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:string];
    [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:orginFont] range:NSMakeRange(0, string.length)];
    [totalStr addAttribute:NSForegroundColorAttributeName value:orginColor range:NSMakeRange(0, string.length)];
    if ([sender isKindOfClass:[NSArray class]]) {
        __block NSString *oringinStr = string;
        __weak typeof(self) weakSelf = self;
        [sender enumerateObjectsUsingBlock:^(NSString *  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [oringinStr rangeOfString:str];
            [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
            if (idx == weakSelf.weibo.praises.count) {
                [totalStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
            }else {
                [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
            }
            oringinStr = [oringinStr stringByReplacingCharactersInRange:range withString:[weakSelf getStringWithRange:range]];
        }];
    }else if ([sender isKindOfClass:[NSString class]]) {
        NSRange range = [string rangeOfString:sender];
        [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
        [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
    }
    return totalStr;
}
- (NSString *)getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}
@end
