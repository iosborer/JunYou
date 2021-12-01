#import <AVFoundation/AVFoundation.h>
#import "TFJunYou_addMsgVC.h"
#import "AppDelegate.h"
#import "TFJunYou_ImageView.h"
#import "TFJunYou_Server.h"
#import "TFJunYou_Connection.h"
#import "ImageResize.h"
#import "UIFactory.h"
#import "TFJunYou_TableView.h"
#import "QBImagePickerController.h"
#import "SBJsonWriter.h"
#import "recordVideoViewController.h"
#import "TFJunYou_TextView.h"
#import "TFJunYou_MediaObject.h"
#import "LXActionSheet.h"
#import "TFJunYou_myMediaVC.h"
#import "TFJunYou_LocationVC.h"
#import "TFJunYou_MapData.h"
#import "WhoCanSeeViewController.h"
#import "TFJunYou_SelFriendVC.h"
#import "TFJunYou_SelectFriendsVC.h"
#import "RITLPhotosViewController.h"
#import "RITLPhotosDataManager.h"
#import "TFJunYou_MyFile.h"
#import "UIImageView+FileType.h"
#import "TFJunYou_FileDetailViewController.h"
#import "TFJunYou_ShareFileObject.h"
#import "webpageVC.h"
#import "TFJunYou_SelectorVC.h"
#ifdef Meeting_Version
#ifdef Live_Version
#import "TFJunYou_SmallVideoViewController.h"
#endif
#endif
#import "TFJunYou_ActionSheetVC.h"
#import "TFJunYou_CameraVC.h"
#import "QCheckBox.h"
#import "TFJunYou_SelectCoverVC.h"
#define insert_photo_tag -100000
typedef enum {
    MsgVisible_public = 1,
    MsgVisible_private,
    MsgVisible_see,
    MsgVisible_nonSee,
}MsgVisible;
@interface TFJunYou_addMsgVC()<VisibelDelegate,RITLPhotosViewControllerDelegate,TFJunYou_SelectorVCDelegate, TFJunYou_ActionSheetVCDelegate, TFJunYou_CameraVCDelegate,TFJunYou_SelectCoverVCDelegate,TFJunYou_ImageViewPanDelegate,TFJunYou_ActionSheetVCDelegate>
@property (nonatomic) UIButton * lableBtn;
@property (nonatomic) UIButton * locBtn;
@property (nonatomic) UIButton * canSeeBtn;
@property (nonatomic) UIButton * remindWhoBtn;
@property (nonatomic) UIButton * replybanBtn;
@property (nonatomic, strong) QCheckBox *checkbox;
@property (nonatomic) UIButton * notReplyBtn;
@property (nonatomic) UILabel * lableLabel;
@property (nonatomic) UILabel * visibleLabel;
@property (nonatomic) UILabel * remindLabel;
@property (nonatomic) MsgVisible visible;
@property (nonatomic) NSArray * userArray;
@property (nonatomic) NSArray * userIdArray;
@property (nonatomic) NSMutableArray * selLabelsArray;
@property (nonatomic) NSMutableArray * mailListUserArray;
@property (nonatomic) CLLocationCoordinate2D coor;
@property (nonatomic) NSString * locStr;
@property (nonatomic) NSArray * remindArray;
@property (nonatomic) NSArray * remindNameArray;
@property (nonatomic) NSArray * visibelArray;
@property (nonatomic, assign) int timeLen;
@property (nonatomic, assign) NSInteger currentLableIndex;
@property (nonatomic, strong) TFJunYou_LocationVC *locationVC;
@property (nonatomic, strong) TFJunYou_ImageView* iv;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint oraginPoint;
@property (nonatomic, assign) CGPoint newPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) NSMutableArray* imageViewArray;
@property (nonatomic, assign) NSTimeInterval intoBorderTime;
@property (nonatomic, assign) NSTimeInterval stayBorderTime;
@property (nonatomic, assign) BOOL inBorder;
@property (nonatomic, assign) BOOL isUpdateImage;
@property (nonatomic, strong) NSMutableArray *videoImageUlrArr; 
@property (nonatomic, assign) BOOL isVideoFirstUpload; 
@property (nonatomic, strong) NSMutableDictionary *gifDataDic;
@end
@implementation TFJunYou_addMsgVC
@synthesize isChanged;
@synthesize audioFile;
@synthesize videoFile;
@synthesize fileFile;
@synthesize dataType;
#define video_tag -100
#define audio_tag -200
#define pause_tag -300
#define file_tag  -400
- (TFJunYou_addMsgVC *) init
{
	self  = [super init];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.maxImageCount = 9;
    self.isGotoBack = YES;
    self.isFreeOnClose = YES;
    self.title = Localized(@"addMsgVC_SendFriend");
    [self createHeadAndFoot];
    self.tableBody.backgroundColor = [UIColor whiteColor];
    _images = [[NSMutableArray alloc]init];
    _videoImageUlrArr = [[NSMutableArray alloc]init];
    _visible = MsgVisible_public;
    _remindArray = [NSArray array];
    _visibelArray = [NSArray arrayWithObjects:Localized(@"JXBlogVisibel_public"), Localized(@"JXBlogVisibel_private"), Localized(@"JXBlogVisibel_see"), Localized(@"JXBlogVisibel_nonSee"), nil];
#ifdef Meeting_Version
#ifdef Live_Version
    _currentLableIndex = TFJunYou_SmallVideoTypeOther - 1;
#endif
#endif
	return self;
}
-(void)dealloc{
    [_images removeAllObjects];
}
-(void)setDataType:(int)value{
    dataType = value;
    [g_factory removeAllChild:self.tableBody];
    _buildHeight=0;
    if(dataType >= weibo_dataType_text){
        [self buildTextView];
        self.title = Localized(@"JX_SendWord");
    }
    if(dataType == weibo_dataType_image){
        [self buildImageViews];
        self.title = Localized(@"JX_SendImage");
    }
    if(dataType == weibo_dataType_audio){
        [self buildAudios];
        [self showAudios];
        self.title = Localized(@"JX_SendVoice");
    }
    if(dataType == weibo_dataType_video){
        [self buildVideos];
        if (videoFile.length > 0) {
            UIImage *image = [TFJunYou_FileInfo getFirstImageFromVideo:videoFile];
            if (image) {
                [_images addObject:image];
            }
        }
        [self showVideos];
        self.title = Localized(@"JX_SendVideo");
    }
    if (dataType == weibo_dataType_file) {
        [self buildFiles];
        [self showFiles];
        self.title = Localized(@"JX_SendFile");
    }
    if (dataType == weibo_dataType_share) {
        [self buildShare];
        self.title = Localized(@"JX_ShareLifeCircle");
    }
    int h1 = 38,h=0,w=TFJunYou__SCREEN_WIDTH-9*2;
    CGFloat maxY = 0;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, h+_buildHeight+10, TFJunYou__SCREEN_WIDTH, 8)];
    line.backgroundColor = HEXCOLOR(0xF2F2F2);
    [self.tableBody addSubview:line];
    [self.tableBody addSubview:self.canSeeBtn];
    self.canSeeBtn.frame = CGRectMake(0, CGRectGetMaxY(line.frame), TFJunYou__SCREEN_WIDTH, 56);
    maxY = CGRectGetMaxY(self.canSeeBtn.frame);
    [self.tableBody addSubview:self.remindWhoBtn];
    self.remindWhoBtn.frame = CGRectMake(0, h+CGRectGetMaxY(self.canSeeBtn.frame), TFJunYou__SCREEN_WIDTH, 56);
    maxY = CGRectGetMaxY(self.remindWhoBtn.frame);
    if (self.isShortVideo) {
        [self.tableBody addSubview:self.lableBtn];
        self.lableBtn.frame = CGRectMake(0, h+CGRectGetMaxY(self.remindWhoBtn.frame), TFJunYou__SCREEN_WIDTH, 56);
        maxY = CGRectGetMaxY(self.lableBtn.frame);
    }
    if ([g_config.isOpenPositionService intValue] == 0) {
        [self.tableBody addSubview:self.locBtn];
        if (self.isShortVideo) {
            self.locBtn.frame = CGRectMake(0, h+CGRectGetMaxY(self.lableBtn.frame), TFJunYou__SCREEN_WIDTH, 56);
        }else {
            self.locBtn.frame = CGRectMake(0, h+CGRectGetMaxY(self.remindWhoBtn.frame), TFJunYou__SCREEN_WIDTH, 56);
        }
        maxY = CGRectGetMaxY(self.locBtn.frame);
    }
    [self.tableBody addSubview:self.replybanBtn];
    self.replybanBtn.frame = CGRectMake(0, maxY, TFJunYou__SCREEN_WIDTH, 56);
    maxY = CGRectGetMaxY(self.replybanBtn.frame);
    UIButton* btn;
    btn = [UIFactory createButtonWithTitle:Localized(@"JX_Send")
                                 titleFont:g_factory.font15
                                titleColor:[UIColor whiteColor]
                                    normal:nil
                                 highlight:nil];
    [btn setBackgroundImage:[UIImage createImageWithColor:THEMECOLOR] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage createImageWithColor:[THEMECOLOR colorWithAlphaComponent:0.5]] forState:UIControlStateDisabled];
    btn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-15-51, TFJunYou__SCREEN_TOP-9-29, 51, 29);
    btn.custom_acceptEventInterval = .25f;
    btn.layer.cornerRadius = 3.f;
    btn.layer.masksToBounds = YES;
    btn.enabled = NO;
    [btn addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeader addSubview:btn];
    _sendBtn = btn;
    [self showImages];
}
- (UIButton *)lableBtn {
    if (!_lableBtn) {
        _lableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lableBtn setBackgroundColor:[UIColor whiteColor]];
        [_lableBtn setTitle:Localized(@"JX_SelectionLabel") forState:UIControlStateNormal];
        [_lableBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_lableBtn setTitleColor:HEXCOLOR(0x576b95) forState:UIControlStateSelected];
        _lableBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_lableBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
        _lableBtn.titleLabel.font = g_factory.font16;
        _lableBtn.custom_acceptEventInterval = 1.0f;
        [_lableBtn addTarget:self action:@selector(lableBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(15, 55.5, TFJunYou__SCREEN_WIDTH-15*2, LINE_WH);
        line.backgroundColor = THE_LINE_COLOR;
        [_lableBtn addSubview:line];
        UIImageView * locImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tap"]];
        locImg.frame = CGRectMake(15, 17, 22, 22);
        [_lableBtn addSubview:locImg];
        UIImageView * arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, 21.5, 7, 13)];
        arrowView.image = [UIImage imageNamed:@"new_icon_>"];
        [_lableBtn addSubview:arrowView];
        _lableLabel = [UIFactory createLabelWith:CGRectZero text:Localized(@"OTHER") font:g_factory.font16 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
        _lableLabel.frame = CGRectMake(arrowView.frame.origin.x - 200 - 10, 17, 200, 22);
        _lableLabel.textAlignment = NSTextAlignmentRight;
        [_lableBtn addSubview:_lableLabel];
    }
    return _lableBtn;
}
-(UIButton *)locBtn{
    if (!_locBtn) {
        _locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locBtn setBackgroundColor:[UIColor whiteColor]];
        [_locBtn setTitle:Localized(@"JXUserInfoVC_Loation") forState:UIControlStateNormal];
        [_locBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_locBtn setTitleColor:HEXCOLOR(0x576b95) forState:UIControlStateSelected];
        _locBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_locBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
        _locBtn.titleLabel.font = g_factory.font16;
        _locBtn.custom_acceptEventInterval = 1.0f;
        [_locBtn addTarget:self action:@selector(locBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(50, 55.5, TFJunYou__SCREEN_WIDTH-15*2, LINE_WH);
        line.backgroundColor = THE_LINE_COLOR;
        [_locBtn addSubview:line];
        UIImageView * locImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"currentLocation_gray"]];
        locImg.frame = CGRectMake(15, 17, 22, 22);
        [_locBtn addSubview:locImg];
        UIImageView * arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, 21.5, 7, 13)];
        arrowView.image = [UIImage imageNamed:@"new_icon_>"];
        [_locBtn addSubview:arrowView];
    }
    return _locBtn;
}
-(UIButton *)canSeeBtn{
    if (!_canSeeBtn) {
        _canSeeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_canSeeBtn setBackgroundColor:[UIColor whiteColor]];
        [_canSeeBtn setTitle:Localized(@"JXBlog_whocansee") forState:UIControlStateNormal];
        [_canSeeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_canSeeBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _canSeeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_canSeeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
        _canSeeBtn.titleLabel.font = g_factory.font16;
        _canSeeBtn.custom_acceptEventInterval = 1.0f;
        [_canSeeBtn addTarget:self action:@selector(whoCanSeeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(50, 55.5, TFJunYou__SCREEN_WIDTH-15*2, LINE_WH);
        line.backgroundColor = THE_LINE_COLOR;
        [_canSeeBtn addSubview:line];
        UIImageView * locImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seeVisibel_gray"]];
        locImg.frame = CGRectMake(15, 17, 22, 22);
        [_canSeeBtn addSubview:locImg];
        UIImageView * arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, 21.5, 7, 13)];
        arrowView.image = [UIImage imageNamed:@"new_icon_>"];
        [_canSeeBtn addSubview:arrowView];
        _visibleLabel = [UIFactory createLabelWith:CGRectZero text:_visibelArray[_visible-1] font:g_factory.font16 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
        _visibleLabel.frame = CGRectMake(CGRectGetMaxX(_canSeeBtn.titleLabel.frame)+_canSeeBtn.titleEdgeInsets.left+10, 17, CGRectGetMinX(arrowView.frame)-CGRectGetMaxX(_canSeeBtn.titleLabel.frame)-_canSeeBtn.titleEdgeInsets.left-10-10, 22);
        _visibleLabel.textAlignment = NSTextAlignmentRight;
        _visibleLabel.textColor = HEXCOLOR(0x999999);
        [_canSeeBtn addSubview:_visibleLabel];
    }
    return _canSeeBtn;
}
-(UIButton *)remindWhoBtn{
    if (!_remindWhoBtn) {
        _remindWhoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_remindWhoBtn setBackgroundColor:[UIColor whiteColor]];
        [_remindWhoBtn setTitle:Localized(@"JXBlog_remindWho") forState:UIControlStateNormal];
        [_remindWhoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_remindWhoBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_remindWhoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _remindWhoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_remindWhoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
        _remindWhoBtn.titleLabel.font = g_factory.font16;
        _remindWhoBtn.custom_acceptEventInterval = 1.0f;
        [_remindWhoBtn addTarget:self action:@selector(remindWhoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(50, 55.5, TFJunYou__SCREEN_WIDTH-15*2, LINE_WH);
        line.backgroundColor = THE_LINE_COLOR;
        [_remindWhoBtn addSubview:line];
        UIImageView * locImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blogRemind_gray"]];
        locImg.frame = CGRectMake(15, 17, 22, 22);
        [_remindWhoBtn addSubview:locImg];
        UIImageView * arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, 21.5, 7, 13)];
        arrowView.image = [UIImage imageNamed:@"new_icon_>"];
        [_remindWhoBtn addSubview:arrowView];
        _remindLabel = [UIFactory createLabelWith:CGRectZero text:@"" font:g_factory.font16 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
        _remindLabel.frame = CGRectMake(CGRectGetMaxX(_remindWhoBtn.titleLabel.frame)+_remindWhoBtn.titleEdgeInsets.left+30, 17, CGRectGetMinX(arrowView.frame)-CGRectGetMaxX(_remindWhoBtn.titleLabel.frame)-_remindWhoBtn.titleEdgeInsets.left-10-30, 22);
        _remindLabel.textAlignment = NSTextAlignmentRight;
        _remindLabel.textColor = HEXCOLOR(0x999999);
        [_remindWhoBtn addSubview:_remindLabel];
    }
    return _remindWhoBtn;
}
- (UIButton *)replybanBtn {
    if (!_replybanBtn) {
        _replybanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _notReplyBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 17, 22, 22)];
        [_notReplyBtn setBackgroundImage:[UIImage imageNamed:@"weibo_not_reply"] forState:UIControlStateNormal];
        [_notReplyBtn setBackgroundImage:[UIImage imageNamed:@"sel_check_wx2"] forState:UIControlStateSelected];
        [_notReplyBtn addTarget:self action:@selector(clickReplyBanBtn) forControlEvents:UIControlEventTouchUpInside];
        [_replybanBtn addSubview:_notReplyBtn];
        UILabel *tint = [[UILabel alloc] initWithFrame:CGRectMake(50, 18, 100, 20)];
        tint.text = Localized(@"JX_DoNotCommentOnThem");
        tint.font = SYSFONT(16);
        [_replybanBtn addSubview:tint];
        UILabel *tintGray = [[UILabel alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-160, 18, 160, 20)];
        tintGray.text = Localized(@"JX_ EveryoneCanNotComment");
        tintGray.textColor = HEXCOLOR(0x999999);
        tintGray.font = SYSFONT(12);
        [_replybanBtn addSubview:tintGray];
        [_replybanBtn addTarget:self action:@selector(clickReplyBanBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replybanBtn;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)doRefresh{
    _refreshCount++;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.urlShare.length > 0) {
        _remark.text = self.urlShare;
    }
}
-(void)buildTextView{
    _buildHeight = 0;
    _remark = [[UITextView alloc] initWithFrame:CGRectMake(15, 1, TFJunYou__SCREEN_WIDTH -30,78)];
    _remark.backgroundColor = [UIColor clearColor];
    _remark.returnKeyType = UIReturnKeyDone;
    _remark.font = g_factory.font16;
    _remark.text = Localized(@"addMsgVC_Mind");
    _remark.textColor = [UIColor grayColor];
    _remark.delegate = self;
    [self.tableBody addSubview:_remark];
    _buildHeight += 80;
}
- (void)textViewDidChange:(UITextView *)textView {
    _sendBtn.enabled = fileFile.length > 0 || _images.count > 0 || videoFile.length > 0 || audioFile.length > 0 || textView.text.length > 0;
}
-(void)buildImageViews{
    svImages = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _buildHeight+25, TFJunYou__SCREEN_WIDTH,80)];
    svImages.pagingEnabled = YES;
    svImages.delegate = self;
    svImages.showsVerticalScrollIndicator = NO;
    svImages.showsHorizontalScrollIndicator = NO;
    svImages.backgroundColor = [UIColor clearColor];
    svImages.userInteractionEnabled = YES;
    [self.tableBody addSubview:svImages];
    _buildHeight += 105;
}
-(void)buildAudios{
    svAudios = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _buildHeight+25, TFJunYou__SCREEN_WIDTH,80)];
    svAudios.pagingEnabled = YES;
    svAudios.delegate = self;
    svAudios.showsVerticalScrollIndicator = NO;
    svAudios.showsHorizontalScrollIndicator = NO;
    svAudios.backgroundColor = [UIColor clearColor];
    svAudios.userInteractionEnabled = YES;
    [self.tableBody addSubview:svAudios];
   _buildHeight += 105;
}
-(void)buildVideos{
    svVideos = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _buildHeight+25, TFJunYou__SCREEN_WIDTH ,80)];
    svVideos.pagingEnabled = YES;
    svVideos.delegate = self;
    svVideos.showsVerticalScrollIndicator = NO;
    svVideos.showsHorizontalScrollIndicator = NO;
    svVideos.backgroundColor = [UIColor clearColor];
    svVideos.userInteractionEnabled = YES;
    [self.tableBody addSubview:svVideos];
    _buildHeight += 105;
}
-(void)buildFiles{
    svFiles = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _buildHeight+25, TFJunYou__SCREEN_WIDTH ,80)];
    svFiles.pagingEnabled = YES;
    svFiles.delegate = self;
    svFiles.showsVerticalScrollIndicator = NO;
    svFiles.showsHorizontalScrollIndicator = NO;
    svFiles.backgroundColor = [UIColor clearColor];
    svFiles.userInteractionEnabled = YES;
    [self.tableBody addSubview:svFiles];
    _buildHeight += 105;
}
- (void)buildShare{
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(10, _buildHeight + 25, TFJunYou__SCREEN_WIDTH - 20, 70)];
    view.backgroundColor = HEXCOLOR(0xf0f0f0);
    [view addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableBody addSubview:view];
    TFJunYou_ImageView *imageView = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.shareIcon] placeholderImage:[UIImage imageNamed:@"ALOGO_120"]];
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, imageView.frame.origin.y, view.frame.size.width - CGRectGetMaxX(imageView.frame) - 15, imageView.frame.size.height)];
    label.numberOfLines = 0;
    label.text = self.shareTitle;
    label.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:label];
    _buildHeight += 105;
}
- (void)shareAction:(UIButton *)btn {
    webpageVC *webVC = [webpageVC alloc];
    webVC.isGotoBack= YES;
    webVC.isSend = YES;
    webVC.title = self.shareTitle;
    webVC.url = self.shareUr;
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
}
-(void)showImages{
    int i;
    [g_factory removeAllChild:svImages];
    NSInteger n = [_images count];
    _sendBtn.enabled = n > 1 || _remark.text.length > 0;
    svImages.contentSize = CGSizeMake((n+1) * 80, svImages.frame.size.height);
    for(i=0;i<n&&i<9;i++){
        TFJunYou_ImageView* iv = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake(i*78+15, 10, 63,63)];
        iv.delegate = self;
        iv.panDelegate = self;
        iv.userInteractionEnabled = YES;
        iv.layer.cornerRadius = 6;
        iv.layer.masksToBounds = YES;
        iv.animationType = TFJunYou_ImageView_Animation_Line;
        iv.tag = i;
        [iv addLongPressGesture];
        [iv addTapGesture];
        iv.image = [_images objectAtIndex:i];
        [svImages addSubview:iv];
    }
    _imageViewArray = [NSMutableArray arrayWithArray:svImages.subviews];
    UIButton* btn = [self createButton:nil icon:@"add_picture" action:@selector(actionImage:) parent:svImages];
    btn.frame = CGRectMake(i*78+15, 10, 63, 63);
    btn.tag = insert_photo_tag;
}
- (void)tapImageView:(TFJunYou_ImageView *)imageView{
    [self actionImage:imageView];
}
- (void)getTouchWhenMove:(TFJunYou_ImageView *)imageView withTouch:(NSSet *)touch withEvent:(UIEvent *)event withLongPressGes:(UILongPressGestureRecognizer *)lpGes{
    UITouch *mytouch = touch.allObjects.lastObject;
    CGPoint inWindow = [mytouch locationInView:nil];
    if ((inWindow.x > TFJunYou__SCREEN_WIDTH - 30 && inWindow.x < TFJunYou__SCREEN_WIDTH && svImages.contentOffset.x == 0) || (inWindow.x < 30 && svImages.contentOffset.x > 0)) {
        if (_inBorder) {
            _stayBorderTime = mytouch.timestamp - _intoBorderTime;
            if (_stayBorderTime > 0.3) {
                [self changeWhenPan:imageView gesture:lpGes];
            }
        }else{
            _inBorder = YES;
            _intoBorderTime = mytouch.timestamp;
        }
    }else{
        _inBorder = NO;
        _intoBorderTime = 0;
    }
}
- (void)changeWhenPan:(TFJunYou_ImageView *)sender gesture:(UILongPressGestureRecognizer *)sender2{
    BOOL isBorderStart = NO;
    if (sender2.state == UIGestureRecognizerStateBegan) {
        [svImages setScrollEnabled:NO];
        sender.alpha = 0.5;
        self.startPoint = [sender2 locationInView:svImages];
        CGPoint inWindow = [sender2 locationInView:nil];
        if ((inWindow.x > TFJunYou__SCREEN_WIDTH - 30 && inWindow.x < TFJunYou__SCREEN_WIDTH && svImages.contentOffset.x == 0) || (inWindow.x < 30 && svImages.contentOffset.x > 0)) {
            isBorderStart = YES;
        }else{
            isBorderStart = NO;
        }
        self.oraginPoint = sender.center;
        _lastPoint = _oraginPoint;
        [self.view bringSubviewToFront:svImages];
        [svImages bringSubviewToFront:sender];
    }else if (sender2.state == UIGestureRecognizerStateChanged) {
        self.newPoint = [sender2 locationInView:svImages];
        CGFloat xChange = _newPoint.x - _startPoint.x;
        CGFloat yChange = _newPoint.y - _startPoint.y;
        sender.center = CGPointMake(_oraginPoint.x + xChange, _oraginPoint.y + yChange);
        CGPoint inWindow = [sender2 locationInView:nil];
        if (isBorderStart) {
            if ((inWindow.x < TFJunYou__SCREEN_WIDTH - 30 && svImages.contentOffset.x == 0) && (inWindow.x > 30 && svImages.contentOffset.x > 0)){
                isBorderStart = NO;
            }
        }
        if (inWindow.x < 30 && svImages.contentOffset.x > 0 && !isBorderStart && _stayBorderTime > 0.3) {
            for (int num = 0; num <_imageViewArray.count; num++) {
                TFJunYou_ImageView *imgView = _imageViewArray[num];
                if (imgView.tag != num) {
                    [_imageViewArray exchangeObjectAtIndex:num withObjectAtIndex:imgView.tag];
                }
            }
            [UIView animateWithDuration:0.3 animations:^{
                [svImages setContentOffset:CGPointMake(0, 0)];
            }];
            _stayBorderTime = 0;
            _inBorder = NO;
            NSInteger index = sender.tag;
            for (NSInteger i = index - 1; i > -1; i--) {
                TFJunYou_ImageView *imgView = _imageViewArray[i];
                [_images exchangeObjectAtIndex:imgView.tag withObjectAtIndex:imgView.tag + 1];
                [UIView animateWithDuration:0.5 animations:^{
                    imgView.tag = imgView.tag + 1;
                    CGPoint center = imgView.center;
                    imgView.center = _lastPoint;
                    _lastPoint = center;
                }];
            }
            sender.tag = 0;
        }else if (inWindow.x > g_window.frame.size.width - 30 && _newPoint.x < svImages.contentSize.width && !isBorderStart && _stayBorderTime > 0.3) {
            for (int num = 0; num <_imageViewArray.count; num++) {
                TFJunYou_ImageView *imgView = _imageViewArray[num];
                if (imgView.tag != num) {
                    [_imageViewArray exchangeObjectAtIndex:num withObjectAtIndex:imgView.tag];
                }
            }
            [UIView animateWithDuration:0.3 animations:^{
                [svImages setContentOffset:CGPointMake(svImages.contentSize.width - TFJunYou__SCREEN_WIDTH, 0)];
            }];
            _stayBorderTime = 0;
            _inBorder = NO;
            NSInteger index = sender.tag;
            for (NSInteger i = index + 1; i < _imageViewArray.count; i++) {
                TFJunYou_ImageView *imgView = _imageViewArray[i];
                [_images exchangeObjectAtIndex:imgView.tag withObjectAtIndex:imgView.tag - 1];
                [UIView animateWithDuration:0.5 animations:^{
                    imgView.tag = imgView.tag - 1;
                    CGPoint center = imgView.center;
                    imgView.center = _lastPoint;
                    _lastPoint = center;
                }];
            }
            sender.tag = _imageViewArray.count - 1;
        }else{
            for (int num = 0; num <_imageViewArray.count; num++) {
                TFJunYou_ImageView *imgView = _imageViewArray[num];
                if (imgView.tag != num) {
                    [_imageViewArray exchangeObjectAtIndex:num withObjectAtIndex:imgView.tag];
                }
            }
            for (NSInteger i = 0;i < _imageViewArray.count; i++) {
                TFJunYou_ImageView * imgView = _imageViewArray[i];
                if (CGRectContainsPoint(imgView.frame, _newPoint)) {
                    if (imgView == sender) {
                        continue;
                    }
                    [UIView animateWithDuration:0.3 animations:^{
                        CGPoint point = imgView.center;
                        imgView.center = _lastPoint;
                        _lastPoint = point;
                    }];
                    [_images exchangeObjectAtIndex:imgView.tag withObjectAtIndex:sender.tag];
                    NSInteger l = imgView.tag;
                    imgView.tag = sender.tag;
                    sender.tag = l;
                }
            }
            if (!CGRectContainsPoint(svImages.bounds, _newPoint)) {
                [sender2 setState:UIGestureRecognizerStateEnded];
            }
        }
    }else if(sender2.state == UIGestureRecognizerStateEnded) {
        sender.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            sender.center = _lastPoint;
        }];
        [svImages setScrollEnabled:YES];
    }
}
-(void)showAudios{
    [g_factory removeAllChild:svAudios];
    if(audioFile){
        _sendBtn.enabled = YES;
        TFJunYou_ImageView* iv = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        iv.userInteractionEnabled = YES;
        iv.layer.cornerRadius = 6;
        iv.layer.masksToBounds = YES;
        iv.delegate = self;
        iv.didTouch = @selector(donone);
        iv.animationType = TFJunYou_ImageView_Animation_Line;
        iv.tag = audio_tag;
        [svAudios addSubview:iv];
        if([_images count]>0)
            iv.image = [_images objectAtIndex:0];
        else
            [g_server getHeadImageSmall:g_server.myself.userId userName:g_server.myself.userNickname imageView:iv];
        audioPlayer = [[TFJunYou_AudioPlayer alloc] initWithParent:iv];
        audioPlayer.isOpenProximityMonitoring = NO;
        audioPlayer.pauseBtn.userInteractionEnabled = NO;
        audioPlayer.audioFile = audioFile;
    }else{
        _sendBtn.enabled = _remark.text.length > 0;
        UIButton* btn = [self createButton:nil icon:@"add_voice" action:@selector(onAddAudio) parent:svAudios];
        btn.frame = CGRectMake(15, 10, 63, 63);
    }
}
-(void)showVideos{
    [g_factory removeAllChild:svVideos];
    if(videoFile){
        _sendBtn.enabled = YES;
        _iv = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        _iv.userInteractionEnabled = YES;
        _iv.layer.cornerRadius = 6;
        _iv.layer.masksToBounds = YES;
        _iv.delegate = self;
        _iv.didTouch = @selector(donone);
        _iv.animationType = TFJunYou_ImageView_Animation_Line;
        _iv.tag = video_tag;
        if([_images count]>0)
            _iv.image = [_images objectAtIndex:0];
        else
            [g_server getHeadImageSmall:g_server.myself.userId userName:g_server.myself.userNickname imageView:_iv];
        [svVideos addSubview:_iv];
        UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        pauseBtn.center = CGPointMake(_iv.frame.size.width/2,_iv.frame.size.height/2);
        [pauseBtn setBackgroundImage:[UIImage imageNamed:@"playvideo"] forState:UIControlStateNormal];
        [pauseBtn addTarget:self action:@selector(showTheVideo) forControlEvents:UIControlEventTouchUpInside];
        [_iv addSubview:pauseBtn];
        pauseBtn.userInteractionEnabled = NO;
    }else{
        _sendBtn.enabled = _remark.text.length > 0;
        UIButton* btn = [self createButton:nil icon:@"add_video" action:@selector(onAddVideo) parent:svVideos];
        btn.frame = CGRectMake(15, 10, 63, 63);
    }
}
- (void)donone {
    if (audioFile) {
        TFJunYou_ActionSheetVC *vc = [[TFJunYou_ActionSheetVC alloc] initWithImages:nil names:@[@"重新录制",@"播放"]];
        vc.delegate = self;
        vc.tag = 10021;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if (videoFile) {
        TFJunYou_ActionSheetVC *vc = [[TFJunYou_ActionSheetVC alloc] initWithImages:nil names:@[@"重新选择",@"重新录制",@"播放"]];
        vc.delegate = self;
        vc.tag = 10022;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)selectImageView:(id)imgView index:(NSInteger)tag{
    NSLog(@"我的tag = %ld",(long)tag);
    _iv.image = _images[tag];
    [self saveImgCover:_images[tag]];
}
- (void)saveImgCover:(UIImage *)img{
    NSString *filePath = [NSString stringWithFormat:@"%@%@.jpg",myTempFilePath,[[videoFile lastPathComponent] stringByDeletingPathExtension]];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isExist = [manager fileExistsAtPath:filePath];
    NSError *error;
    if (isExist) {
        [manager removeItemAtPath:filePath error:&error];
    }
    NSData * imageData = UIImageJPEGRepresentation(img, 1);
    BOOL isSave = [imageData writeToFile:filePath atomically:YES];
    if (!isSave) {
        NSLog(@"保存封面图失败");
        return;
    }
    [self.videoImageUlrArr removeAllObjects];
    self.isVideoFirstUpload = YES;
    [g_server uploadFile:filePath validTime:nil messageId:nil toView:self];
}
- (void)showTheVideo {
    videoPlayer= [TFJunYou_VideoPlayer alloc];
    videoPlayer.videoFile = videoFile;
    videoPlayer.didVideoPlayEnd = @selector(didVideoPlayEnd);
    videoPlayer.isStartFullScreenPlay = YES; 
    videoPlayer.delegate = self;
    videoPlayer = [videoPlayer initWithParent:self.view];
    [videoPlayer switch];
}
-(void)showFiles{
    [g_factory removeAllChild:svFiles];
    if(fileFile){
        _sendBtn.enabled = YES;
        TFJunYou_ImageView* iv = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        iv.userInteractionEnabled = YES;
        iv.layer.cornerRadius = 6;
        iv.layer.masksToBounds = YES;
        iv.delegate = self;
        iv.didTouch = @selector(actionFile:);
        iv.animationType = TFJunYou_ImageView_Animation_Line;
        iv.tag = file_tag;
        NSString * fileExt = [fileFile pathExtension];
        NSInteger fileType = [self fileTypeWithExt:fileExt];
        [iv setFileType:fileType];
        [svFiles addSubview:iv];
    }else{
        _sendBtn.enabled = _remark.text.length > 0;
        UIButton* btn = [self createButton:nil icon:@"add_file" action:@selector(onAddFile) parent:svFiles];
        btn.frame = CGRectMake(15, 10, 63, 63);
    }
}
- (void)actionFile:(TFJunYou_ImageView *)imageView {
    TFJunYou_ActionSheetVC *vc = [[TFJunYou_ActionSheetVC alloc] initWithImages:nil names:@[@"重新选择",@"打开"]];
    vc.delegate = self;
    vc.tag = 10001;
    [self presentViewController:vc animated:YES completion:nil];
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
- (void)viewDidload{
    [super viewDidLoad];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:Localized(@"addMsgVC_Mind")]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    return;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] ) {
        [self.view endEditing:YES];
    }
    if(textView.text.length > 10000 && ![text isEqualToString:@""]){
        [TFJunYou_MyTools showTipView:Localized(@"JX_InputLimit")];
        return NO;
    }
    return YES;
}
-(void)actionImage:(TFJunYou_ImageView*)sender{
    _photoIndex = sender.tag;
    if(_photoIndex==insert_photo_tag&&[_images count]>8){
        [g_App showAlert:Localized(@"addMsgVC_SelNinePhoto")];
        return;
    }else if(_photoIndex==insert_photo_tag){
        TFJunYou_ActionSheetVC *actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JX_ChoosePhoto"),Localized(@"JX_TakePhoto")]];
        actionVC.delegate = self;
        actionVC.tag = 111;
        [self presentViewController:actionVC animated:NO completion:nil];
        return;
    }
    LXActionSheet* _menu = [[LXActionSheet alloc]
                            initWithTitle:nil
                            delegate:self
                            cancelButtonTitle:Localized(@"JX_Cencal")
                            destructiveButtonTitle:Localized(@"JX_Update")
                            otherButtonTitles:@[Localized(@"JX_Delete")]];
    [g_window addSubview:_menu];
}
- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if (actionSheet.tag == 2457) {
        if (index == 0) {
            RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
            photoController.configuration.maxCount = 1;
            photoController.configuration.containVideo = YES;
            photoController.configuration.containImage = NO;
            photoController.photo_delegate = self;
            [self presentViewController:photoController animated:true completion:^{}];
        }else {
            TFJunYou_CameraVC *vc = [TFJunYou_CameraVC alloc];
            vc.cameraDelegate = self;
            vc.isVideo = YES;
            vc = [vc init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    else if (actionSheet.tag == 10001) {
        if (index == 0) {
            [self onAddFile];
        }
        else if (index == 1) {
            webpageVC *webVC = [webpageVC alloc];
            webVC.isGotoBack= YES;
            webVC.isSend = YES;
            webVC.title = [fileFile pathExtension];
            webVC.url = fileFile;
            webVC = [webVC init];
            [g_navigation.navigationView addSubview:webVC.view];
        }
    }
    else if (actionSheet.tag == 10021) {
        if (index == 0) {
            [self onAddAudio];
        }
        else if (index == 1) {
            [audioPlayer switch];
        }
    }
    else if (actionSheet.tag == 10022) {
        if (index == 0) {
            RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
            photoController.configuration.maxCount = 1;
            photoController.configuration.containVideo = YES;
            photoController.configuration.containImage = NO;
            photoController.photo_delegate = self;
            [self presentViewController:photoController animated:true completion:^{}];
        }
        else if (index == 1) {
            TFJunYou_CameraVC *vc = [TFJunYou_CameraVC alloc];
            vc.cameraDelegate = self;
            vc.isVideo = YES;
            vc = [vc init];
            [self presentViewController:vc animated:YES completion:nil];
        }
        else {
            [self showTheVideo];
        }
    }
    else{
        if (index == 0) {
            self.maxImageCount = self.maxImageCount - (int)[_images count];
            self.isUpdateImage = NO;
            [self pickImages:YES];
        }else {
            TFJunYou_CameraVC *vc = [TFJunYou_CameraVC alloc];
            vc.cameraDelegate = self;
            vc.isPhoto = YES;
            vc = [vc init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}
- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithImage:(UIImage *)image {
    [_images addObject:image];
    [self showImages];
}
- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithVideoPath:(NSString *)filePath timeLen:(NSInteger)timeLen {
    [_images removeAllObjects];
    TFJunYou_MediaObject* media = [[TFJunYou_MediaObject alloc] init];
    media.userId = MY_USER_ID;
    media.fileName = filePath;
    media.isVideo = [NSNumber numberWithBool:YES];
    media.timeLen = [NSNumber numberWithInteger:timeLen];
    media.createTime = [NSDate date];
    [media insert];
    NSString* file = media.fileName;
    UIImage *image = [TFJunYou_FileInfo getFirstImageFromVideo:file];
    videoFile = [file copy];
    [_images addObject:image];
    TFJunYou_SelectCoverVC *Vc = [[TFJunYou_SelectCoverVC alloc] initWithVideo:videoFile];
    Vc.delegate = self;
    [g_navigation pushViewController:Vc animated:YES];
    [self showVideos];
}
- (void)didClickOnButtonIndex:(LXActionSheet*)sender buttonIndex:(int)buttonIndex{
    if(buttonIndex<0)
        return;
    _nSelMenu = buttonIndex;
    [self doOutputMenu];
}
-(void)doOutputMenu{
    if(_nSelMenu==0){
        if(_photoIndex == audio_tag){
            [self onAddAudio];
            return;
        }
        if(_photoIndex == video_tag){
            [self onAddVideo];
            return;
        }
        self.isUpdateImage = YES;
        [self pickImages:NO];
    }
    if(_nSelMenu==1){
        if(_photoIndex == audio_tag){
            [self onDelAudio];
            return;
        }
        if(_photoIndex == video_tag){
            [self onDelVideo];
            return;
        }
        [_images removeObjectAtIndex:_photoIndex];
        [self showImages];
    }
}
-(void)pickImages:(BOOL)Multi{
    RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
    if (!self.isUpdateImage) {
        photoController.configuration.maxCount = 9 - _images.count;
    }else {
        photoController.configuration.maxCount = 1;
    }
    photoController.configuration.containVideo = NO;
    photoController.photo_delegate = self;
    photoController.thumbnailSize = CGSizeMake(320, 320);
    [self presentViewController:photoController animated:true completion:^{}];
}
#pragma mark - 发送原图
- (void)photosViewController:(UIViewController *)viewController images:(NSArray<UIImage *> *)images infos:(NSArray<NSDictionary *> *)infos {
    if (self.isUpdateImage) {
        _images[_photoIndex] = images.firstObject;
    }else {
        [_images addObjectsFromArray:images.mutableCopy];
    }
    self.gifDataDic = nil;
    self.gifDataDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < images.count; i++) {
        UIImage *image = images[i];
        if (image.images.count > 0) {
            NSDictionary *dic = [infos objectAtIndex:i];
            NSData *data = [dic objectForKey:@"gifData"];
            [self.gifDataDic setValue:data forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    [self showImages];
}
#pragma mark - 发送缩略图
- (void)photosViewController:(UIViewController *)viewController thumbnailImages:(NSArray *)thumbnailImages infos:(NSArray<NSDictionary *> *)infos {
    if (self.isUpdateImage) {
        _images[_photoIndex] = thumbnailImages.firstObject;
    }else {
        [_images addObjectsFromArray:thumbnailImages.mutableCopy];
    }
    self.gifDataDic = nil;
    self.gifDataDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < thumbnailImages.count; i++) {
        UIImage *image = thumbnailImages[i];
        if (image.images.count > 0) {
            NSDictionary *dic = [infos objectAtIndex:i];
            NSData *data = [dic objectForKey:@"gifData"];
            [self.gifDataDic setValue:data forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    [self showImages];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if(imagePickerController.allowsMultipleSelection) {
        NSArray *mediaInfoArray = (NSArray *)info;
        for(int i=0;i<[mediaInfoArray count];i++){
            NSDictionary *selected = (NSDictionary *)[mediaInfoArray objectAtIndex:i];
            [_images addObject:[selected objectForKey:@"UIImagePickerControllerOriginalImage"]];
        }
    } else {
        NSDictionary *selected = (NSDictionary *)info;
        [_images replaceObjectAtIndex:_photoIndex withObject:[selected objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self showImages];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos{
    return [NSString stringWithFormat:@"%ld photos",numberOfPhotos];
}
- (NSString *)getNumberFromStr:(NSString *)str
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_UploadFile]){
        if (self.isVideoFirstUpload) {
            self.isVideoFirstUpload = NO;
            self.videoImageUlrArr = [dict objectForKey:@"images"];
            return;
        }
        NSDictionary *dataD;
        if (_timeLen > 0) {  
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
            [dataDict setObject:@(_timeLen) forKey:@"length"];
            [dataDict setObject:[(NSDictionary *)[[dict objectForKey:@"audios"] firstObject] objectForKey:@"oFileName"] forKey:@"oFileName"];
            [dataDict setObject:[(NSDictionary *)[[dict objectForKey:@"audios"] firstObject] objectForKey:@"status"] forKey:@"status"];
            [dataDict setObject:[(NSDictionary *)[[dict objectForKey:@"audios"] firstObject] objectForKey:@"oUrl"] forKey:@"oUrl"];
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            NSMutableArray *mutArr = [NSMutableArray arrayWithObjects:dataDict, nil];
            [mutDict setObject:mutArr forKey:@"audios"];
            dataD = mutDict;
        }else {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"images"]];
            if (array.count > 0) {
                for (NSInteger i = 0; i < array.count -1; i++) {
                    for (NSInteger j = 0; j < array.count - 1; j++) {
                        NSString *str1 = [(NSDictionary *)array[j] objectForKey:@"oFileName"];
                        NSString *str2 = [(NSDictionary *)array[j+1] objectForKey:@"oFileName"];
                        NSInteger num1 = [[self getNumberFromStr:str1] integerValue];
                        NSInteger num2 = [[self getNumberFromStr:str2] integerValue];
                        if (num1 > num2) {
                            [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        }
                    }
                }
                [dict setValue:array forKey:@"images"];
            }
            if (self.videoImageUlrArr.count > 0) {
                [dict setValue:self.videoImageUlrArr forKey:@"images"];
            }
            dataD = dict;
        }
        NSString *label = nil;
        if (self.isShortVideo) {
            label = [NSString stringWithFormat:@"%ld",self.currentLableIndex + 1];
        }
        [g_server addMessage:_remark.text type:dataType data:dataD flag:3 visible:_visible lookArray:_userIdArray coor:_coor location:_locStr remindArray:_remindArray lable:label isAllowComment:self.notReplyBtn.selected toView:self];
    }
    if([aDownload.action isEqualToString:act_MsgAdd]){
        if (self.block) {
            self.block();
        }
        [g_App showAlert:Localized(@"JXAlert_SendOK")];
        [self hideKeyboard];
        if (self.urlShare.length > 0) {
            [self.view removeFromSuperview];
        }else {
            [self actionQuit];
        }
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if([aDownload.action isEqualToString:act_UploadFile]){
        if (self.isVideoFirstUpload) {
            self.isVideoFirstUpload = NO;
        }
    }
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    if([aDownload.action isEqualToString:act_UploadFile]){
        if (self.isVideoFirstUpload) {
            self.isVideoFirstUpload = NO;
        }
    }
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start:Localized(@"JX_SendNow")];
}
- (void)lableBtnAction:(UIButton *)button {
    TFJunYou_SelectorVC *vc = [[TFJunYou_SelectorVC alloc] init];
    vc.title = Localized(@"JX_SelectionLabel");
    vc.array = @[Localized(@"JX_Food"),Localized(@"JX_Attractions"),Localized(@"JX_Culture"),Localized(@"JX_HaveFun"),Localized(@"JX_Hotel"),Localized(@"JX_Shopping"),Localized(@"JX_Movement"),Localized(@"OTHER"),];
    vc.selectIndex = _currentLableIndex;
    vc.selectorDelegate = self;
    [g_navigation pushViewController:vc animated:YES];
}
- (void)selector:(TFJunYou_SelectorVC *)selector selectorAction:(NSInteger)selectIndex {
    self.currentLableIndex = selectIndex;
    self.lableLabel.text = selector.array[selectIndex];
}
-(void)locBtnAction:(UIButton *)button{
    _locationVC = [TFJunYou_LocationVC alloc];
    _locationVC.isSend = YES;
    _locationVC.locationType = TFJunYou_LocationTypeCurrentLocation;
    _locationVC.delegate  = self;
    _locationVC.didSelect = @selector(onSelLocation:);
    _locationVC.isCircleCome = YES;
    _locationVC = [_locationVC init];
    [g_navigation pushViewController:_locationVC animated:YES];
}
-(void)whoCanSeeBtnAction:(UIButton *)button{
    WhoCanSeeViewController * whoVC = [[WhoCanSeeViewController alloc] init];
    whoVC.visibelDelegate = self;
    whoVC.type = _visible;
    whoVC.selLabelsArray = self.selLabelsArray.count > 0 ? self.selLabelsArray : [NSMutableArray array];
    whoVC.mailListUserArray = self.mailListUserArray.count > 0 ? self.mailListUserArray : [NSMutableArray array];
    [g_navigation pushViewController:whoVC animated:YES];
}
-(void)remindWhoBtnAction:(UIButton *)button{
    TFJunYou_SelectFriendsVC * selVC = [[TFJunYou_SelectFriendsVC alloc] init];
    selVC.delegate = self;
    selVC.didSelect = @selector(selRemindDelegate:);
    if (_visible == MsgVisible_see) {
        selVC.type = TFJunYou_SelUserTypeCustomArray;
        selVC.array = [_userArray mutableCopy];
    }else if (_visible == MsgVisible_nonSee) {
        selVC.type = TFJunYou_SelUserTypeDisAble;
        NSMutableSet * set = [NSMutableSet set];
        [set addObjectsFromArray:_userIdArray];
        selVC.disableSet = set;
    }else {
        selVC.type = TFJunYou_SelUserTypeSelFriends;
        NSMutableSet * set = [NSMutableSet set];
        [set addObjectsFromArray:_remindArray];
        selVC.existSet = set;
    }
    [g_navigation pushViewController:selVC animated:YES];
}
- (void)clickReplyBanBtn  {
    _notReplyBtn.selected = !_notReplyBtn.selected;
}
-(void)selRemindDelegate:(TFJunYou_SelectFriendsVC*)vc{
    NSArray * indexArr = [vc.set allObjects];
    NSMutableArray * adduserArr = [NSMutableArray array];
    NSMutableArray * userNameArr = [NSMutableArray array];
    for (NSNumber * index in indexArr) {
        TFJunYou_UserObject * selUser;
        if (vc.seekTextField.text.length > 0) {
            selUser = vc.searchArray[[index intValue] % 100000-1];
        }else{
            selUser = [[vc.letterResultArr objectAtIndex:[index intValue] / 100000-1] objectAtIndex:[index intValue] % 100000-1];
        }
        [adduserArr addObject:selUser.userId];
        [userNameArr addObject:selUser.userNickname];
    }
    _remindArray = [NSArray arrayWithArray:adduserArr];
    _remindNameArray = [NSArray arrayWithArray:userNameArr];
    if (_remindNameArray.count > 0) {
        _remindLabel.text = [_remindNameArray componentsJoinedByString:@","];
    }
}
-(void)seeVisibel:(int)visibel userArray:(NSArray *)userArray selLabelsArray:(NSMutableArray *)selLabelsArray mailListArray:(NSMutableArray *)mailListArray{
    _visible = visibel+1;
    _selLabelsArray = selLabelsArray;
    _mailListUserArray = mailListArray;
    _visibleLabel.text = _visibelArray[visibel];
    if (_visible == 3 || _visible == 4) {
        NSMutableArray * uArray = [NSMutableArray array];
        NSMutableArray * userIdArray = [NSMutableArray array];
        for (TFJunYou_UserObject * selUser in userArray) {
            TFJunYou_UserObject *user = [[TFJunYou_UserObject sharedInstance] getUserById:selUser.userId];
            [uArray addObject:user];
            [userIdArray addObject:selUser.userId];
        }
        _userIdArray = userIdArray;
        _userArray = uArray;
    }
    switch (_visible) {
        case 1:
        case 3:
        case 4:
            _remindWhoBtn.enabled = YES;
            _remindArray = [NSArray array];
            _remindLabel.text = @"";
            break;
        case 2:
            _remindWhoBtn.enabled = NO;
            _remindArray = nil;
            _remindLabel.text = @"";
            break;
        default:
            break;
    }
}
#pragma mark - 点击发布调用的方法
-(void)actionSave{
    [audioPlayer stop];
    audioPlayer = nil;
    [videoPlayer stop];
    videoPlayer = nil;
    [self hideKeyboard];
    if(self.dataType == weibo_dataType_image) {
        if (_images.count <=0 && _remark.text.length <= 0) {
            [g_App showAlert:Localized(@"JXAlert_InputSomething")];
            return;
        }
        else if(_images.count <= 0 && _remark.text.length > 0) {
            if ([_remark.text isEqualToString:Localized(@"addMsgVC_Mind")]) {
                [g_App showAlert:Localized(@"JXAlert_InputSomething")];
                return;
            }
            NSString *str = [_remark.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (str.length <= 0) {
                [g_App showAlert:@"请输入有效内容"];
                return;
            }
            [g_server addMessage:_remark.text type:1 data:nil flag:3 visible:_visible lookArray:_userIdArray coor:_coor location:_locStr remindArray:_remindArray lable:nil isAllowComment:self.notReplyBtn.selected toView:self];
        }else if(_images.count > 0){
            if ([_remark.text isEqualToString:Localized(@"addMsgVC_Mind")]){
                _remark.text = @"";
            }
            [g_server uploadFile:_images audio:audioFile video:videoFile file:fileFile type:self.dataType+1 validTime:@"-1" timeLen:_timeLen toView:self gifDic:self.gifDataDic];
        }
    }
    else if (self.dataType == weibo_dataType_share) {
        NSDictionary *dict = @{
                               @"sdkUrl" : self.shareUr,
                               @"sdkIcon" : self.shareIcon,
                               @"sdkTitle": self.shareTitle
                               };
        [g_server addMessage:_remark.text type:dataType data:dict flag:3 visible:_visible lookArray:_userIdArray coor:_coor location:_locStr remindArray:_remindArray lable:nil isAllowComment:self.notReplyBtn.selected toView:self];
    }
    else{
        if (_images.count <= 0 && audioFile.length <= 0 && videoFile.length <= 0 && fileFile.length <= 0) {
            [g_App showAlert:Localized(@"JX_AddFile")];
            return;
        }
        if ([_remark.text isEqualToString:Localized(@"addMsgVC_Mind")]){
            _remark.text = @"";
        }
        [g_server uploadFile:_images audio:audioFile video:videoFile file:fileFile type:self.dataType+1 validTime:@"-1" timeLen:_timeLen toView:self gifDic:self.gifDataDic];
    }
}
- (BOOL) hideKeyboard {
    [_remark resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}
-(void)onAddVideo{
    [self hideKeyboard];
    TFJunYou_ActionSheetVC *actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JXTFJunYou_myMediaVC_LoationMedia"),Localized(@"JX_RecordVideo")]];
    actionVC.delegate = self;
    actionVC.tag = 2457;
    [self presentViewController:actionVC animated:NO completion:nil];
}
#pragma mark - 发送视频
- (void)photosViewController:(UIViewController *)viewController media:(TFJunYou_MediaObject *)media {
    [_images removeAllObjects];
    media.userId = g_server.myself.userId;
    media.isVideo = [NSNumber numberWithBool:YES];
    [media insert];
    NSString* file = media.fileName;
    UIImage *image = [TFJunYou_FileInfo getFirstImageFromVideo:file];
    videoFile = [file copy];
    [_images addObject:image];
    TFJunYou_SelectCoverVC *vc = [[TFJunYou_SelectCoverVC alloc] initWithVideo:videoFile];
    vc.delegate = self;
    [g_navigation pushViewController:vc animated:YES];
    [self showVideos];
}
- (void)touchAtlasButtonReturnCover:(UIImage *)img{
    _iv.image = img;
    [self saveImgCover:img];
}
- (void)selectImage:(UIImage *)img toView:(TFJunYou_SelectCoverVC *)view{
    _iv.image = img;
    [self saveImgCover:img];
}
-(void)onSelMedia:(TFJunYou_MediaObject*)p{
}
-(void)onAddFile{
    [self hideKeyboard];
    TFJunYou_MyFile* vc = [[TFJunYou_MyFile alloc]init];
    vc.delegate = self;
    vc.didSelect = @selector(onSelFile:);
    [g_navigation pushViewController:vc animated:YES];
}
-(void)onSelFile:(NSString*)file{
    fileFile = [file copy];
    [self showFiles];
}
-(void)onAddAudio{
    [self hideKeyboard];
    TFJunYou_AudioRecorderViewController * audioRecordVC = [[TFJunYou_AudioRecorderViewController alloc] init];
    audioRecordVC.delegate = self;
    audioRecordVC.maxTime = 60;
    [g_navigation pushViewController:audioRecordVC animated:YES];
}
#pragma mark TFJunYou_audioRecorder delegate
-(void)TFJunYou_audioRecorderDidFinish:(NSString *)filePath TimeLen:(int)timenlen{
    TFJunYou_MediaObject* p = [[TFJunYou_MediaObject alloc]init];
    p.userId = g_server.myself.userId;
    p.fileName = filePath;
    p.isVideo = [NSNumber numberWithBool:NO];
    p.timeLen = [NSNumber numberWithInt:timenlen];
    self.timeLen = timenlen;
    audioFile = [filePath copy];
    [self showAudios];
    filePath = nil;
}
-(void)newVideo:(recordVideoViewController *)sender;
{
    if( ![[NSFileManager defaultManager] fileExistsAtPath:sender.outputFileName] )
        return;
    NSString* file = sender.outputFileName;
    TFJunYou_MediaObject* p = [[TFJunYou_MediaObject alloc]init];
    p.userId = g_server.myself.userId;
    p.fileName = file;
    p.isVideo = [NSNumber numberWithBool:YES];
    p.timeLen = [NSNumber numberWithInt:sender.timeLen];
    videoFile = [file copy];
    file = [NSString stringWithFormat:@"%@.jpg",[file stringByDeletingPathExtension]];
    [_images addObject:[UIImage imageWithContentsOfFile:file]];
    [self showVideos];
    file = nil;
}
-(void)onSelLocation:(TFJunYou_MapData*)location{
    _coor = (CLLocationCoordinate2D){[location.latitude doubleValue],[location.longitude doubleValue]};
    if (location.title.length > 0) {
        _locStr = [NSString stringWithFormat:@"%@ %@",location.title,location.subtitle];
    }else{
        _locStr = location.subtitle;
    }
    [self.locBtn setTitle:_locStr forState:UIControlStateSelected];
    self.locBtn.selected = YES;
}
-(UIButton*)createButton:(NSString*)title icon:(NSString*)icon action:(SEL)action parent:(UIView*)parent{
    UIButton* btn = [UIFactory createButtonWithImage:icon
                           highlight:nil
                              target:self
                            selector:action];
    btn.titleEdgeInsets = UIEdgeInsetsMake(45, -60, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    btn.titleLabel.font = g_factory.font10;
    [parent addSubview:btn];
    return btn;
}
-(void)onDelVideo{
    videoFile = nil;
    [self showVideos];
}
-(void)onDelAudio{
    audioFile = nil;
    [self showAudios];
}
-(void)actionQuit{
    [super actionQuit];
    if(self.delegate != nil && [self.delegate respondsToSelector:self.didSelect])
        [self.delegate performSelectorOnMainThread:self.didSelect withObject:self waitUntilDone:NO];
}
@end
