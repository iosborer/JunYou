#import "TFJunYou_emojiViewController.h"
#import "menuImageView.h"
#import "TFJunYou_FaceViewController.h"
#import "TFJunYou_gifViewController.h"
#import "AppDelegate.h"
#import "TFJunYou_JLMenuView.h"
#import "JLFacePackgeModel.h"
#import "JLMyFacePackgeViewController.h"
#import "CYFacePackageViewController.h"
#import "JLSingleFaceViewController.h"
#import "TFJunYou_XLsn0wScrollUnderlineButton.h"
@interface TFJunYou_emojiViewController()
@property (nonatomic, strong)  TFJunYou_XLsn0wScrollUnderlineButton * barScrollUnderlineButton;
@property (nonatomic, strong) NSMutableArray *facePackages;
@property (nonatomic, strong) NSMutableArray *faceNames;
@property (nonatomic, strong) TFJunYou_EmojiPackgeVC *emojiPackgeVC;
@end
@implementation TFJunYou_emojiViewController
@synthesize delegate;
@synthesize faceView=_faceView;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xf0eff4);
        _faceView = [[TFJunYou_FaceViewController alloc]initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, self.frame.size.height-TFJunYou__SCREEN_BOTTOM+10)];
        [self addSubview:_faceView];
        _faceView.hidden   = NO;
        _gifView = [[TFJunYou_gifViewController alloc]initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, self.frame.size.height-TFJunYou__SCREEN_BOTTOM+10)];
        [self addSubview:_gifView];
        _gifView.hidden   = YES;
        _TFJunYou_FavoritesVC = [[TFJunYou_FavoritesVC alloc] init];
        _TFJunYou_FavoritesVC.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, self.frame.size.height-TFJunYou__SCREEN_BOTTOM+10);
        [self addSubview:_TFJunYou_FavoritesVC.view];
        _TFJunYou_FavoritesVC.view.hidden = YES;
        _emojiPackgeVC = [[TFJunYou_EmojiPackgeVC alloc] init];
        _emojiPackgeVC.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, self.frame.size.height-TFJunYou__SCREEN_BOTTOM+10);
        [self addSubview:_emojiPackgeVC.view];
        _emojiPackgeVC.view.hidden = YES;
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-TFJunYou__SCREEN_BOTTOM + 10, [UIScreen mainScreen].bounds.size.width, 40)];
        containerView.backgroundColor = [UIColor whiteColor];
        UIButton *settingBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [settingBtn setImage:[UIImage imageNamed:@"set_up"] forState:(UIControlStateNormal)];
        [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [addBtn setImage:[UIImage imageNamed:@"person_add_green"] forState:(UIControlStateNormal)];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        CGPoint point = CGPointMake(5 + 15 , 20);
        settingBtn.frame = CGRectMake(0, 0, 30, 30);
        settingBtn.center = point;
        CGPoint point1 = CGPointMake(35 + 15 + 5 , 20);
        addBtn.frame = CGRectMake(0, 0, 30, 30);
        addBtn.center = point1;
        [containerView addSubview:settingBtn];
        [containerView addSubview:addBtn];
        _barScrollUnderlineButton = [[TFJunYou_XLsn0wScrollUnderlineButton alloc] initWithFrame:(CGRectMake(80, 0, [UIScreen mainScreen].bounds.size.width - 80, 40))];
        [containerView addSubview:_barScrollUnderlineButton];
        __weak __typeof(self)weakSelf = self;
        _barScrollUnderlineButton.scrollUnderlineButtonBlock = ^(NSUInteger selectedIndex) {
            NSLog(@"selectedIndex = %ld", selectedIndex);
            if (selectedIndex < 3) {
            } else{
                 weakSelf.emojiPackgeVC.model = weakSelf.facePackages[selectedIndex-3];
            }
            [weakSelf selectType:(int)selectedIndex];
        };
        _barScrollUnderlineButton.normalColor = [UIColor blackColor];
        _barScrollUnderlineButton.selectedColor = [UIColor redColor];
        _barScrollUnderlineButton.selectedFont = [UIFont systemFontOfSize:16];
        _barScrollUnderlineButton.normalFont = [UIFont systemFontOfSize:16];
        _barScrollUnderlineButton.lineView.backgroundColor = [UIColor redColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        lineView.backgroundColor = HEXCOLOR(0XEFEFF4);
        ;
        [containerView addSubview:lineView];
        [self addSubview:containerView];
        _facePackages = [NSMutableArray array];
        _faceNames = [NSMutableArray array];
        [g_notify addObserver:self selector:@selector(refresh:) name:kFavoritesRefresh object:nil];
}
    return self;
}
- (void)settingBtnClick {
    JLMyFacePackgeViewController *vc = [[JLMyFacePackgeViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
- (void)addBtnClick {
    CYFacePackageViewController *vc = [[CYFacePackageViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
- (void)refresh:(NSNotification *)notification {
    if ([notification object] == nil) {
        return;
    }
    _emojiDataArray = [notification object];
    NSMutableArray *faceArray = [NSMutableArray array];
    for (NSDictionary *dict in _emojiDataArray) {
        [faceArray addObject:dict[@"face"]];
    }
    _facePackages = [JLFacePackgeModel mj_objectArrayWithKeyValuesArray:faceArray];
    _faceNames = [NSMutableArray array];
    [_faceNames removeAllObjects];
    [_faceNames addObjectsFromArray:@[@"表情",@"动画",@"自定义表情"]];
    for (JLFacePackgeModel *model in _facePackages) {
        [_faceNames addObject:model.name];
    }
        _barScrollUnderlineButton.currentIndex = 0;
        [self selectType:0];
     _barScrollUnderlineButton.titles = _faceNames;
}
-(void) dealloc{
    [g_notify removeObserver:self];
}
-(void)actionSegment:(UIButton*)sender{
    switch (sender.tag){
        case 0:
            _faceView.hidden   = NO;
            _gifView.hidden   = YES;
            _TFJunYou_FavoritesVC.view.hidden = YES;
            break;
        case 1:
            _faceView.hidden   = YES;
            _gifView.hidden   = NO;
            _TFJunYou_FavoritesVC.view.hidden = YES;
            break;
        case 2:
            _faceView.hidden   = YES;
            _gifView.hidden   = YES;
            _TFJunYou_FavoritesVC.view.hidden = NO;
            break;
        case 3:
            [g_notify postNotificationName:kSendInputNotifaction object:nil userInfo:nil];
            break;
    }
}
-(void)setDelegate:(id)value{
    if(delegate != value){
        delegate = value;
        _faceView.delegate = delegate;
        _gifView.delegate = delegate;
        _TFJunYou_FavoritesVC.delegate = delegate;
        _emojiPackgeVC.delegate = delegate;
    }
}
-(void)selectType:(int)n{
    [_tb selectOne:n];
    if (n == 2) {
        _faceView.hidden   = YES;
        _gifView.hidden   = YES;
        _TFJunYou_FavoritesVC.view.hidden = NO;
        _emojiPackgeVC.view.hidden = YES;
    }else if(n == 1) {
        _faceView.hidden   = YES;
        _gifView.hidden   = NO;
        _TFJunYou_FavoritesVC.view.hidden = YES;
        _emojiPackgeVC.view.hidden = YES;
    } else if(n == 0){
        _faceView.hidden   = NO;
        _gifView.hidden   = YES;
        _TFJunYou_FavoritesVC.view.hidden = YES;
        _emojiPackgeVC.view.hidden = YES;
    } else {
        _faceView.hidden   = YES;
        _gifView.hidden   = YES;
        _TFJunYou_FavoritesVC.view.hidden = YES;
        _emojiPackgeVC.view.hidden = NO;
    }
}
@end
