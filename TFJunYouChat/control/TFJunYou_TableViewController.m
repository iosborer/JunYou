#import <QuartzCore/QuartzCore.h>
#import "TFJunYou_TableViewController.h"
#import "AppDelegate.h"
//#import "myNearViewController.h"
#import "TFJunYou_Label.h"
#import "TFJunYou_TableView.h"
//#import "TFJunYou_MainViewController.h"
#import "MJRefreshBaseView.h"
#import "UIImage+Tint.h"

#define REFRESH_HEADER_HEIGHT 60
#define HEIGHT_STATUS_BAR 20


@implementation TFJunYou_TableViewController

@synthesize heightFooter,heightHeader,tableHeader,tableFooter,isGotoBack,footerBtnLeft,footerBtnMid,footerBtnRight,headerTitle,isFreeOnClose,isShowHeaderPull,isShowFooterPull,tableView=_table;
@synthesize header=_header;
@synthesize footer=_footer;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        [self setupStrings];
        
        
    }
    return self;
}

//- (id)initWithStyle:(UITableViewStyle)style {
//    self = [super initWithStyle:style];
//    if (self != nil) {
//        [self setupStrings];
//    }
//    return self;
//}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self createTableView];
    [[self view] addSubview:_table];
}

-(void)createTableView{
    if(_table == nil){
//        CGRect frame = CGRectMake(0, -70, self.view.frame.size.width, self.view.frame.size.height - 49);
        _table       = [[TFJunYou_TableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _table.frame =CGRectMake(0,heightHeader,self_width,self_height-heightHeader-heightFooter);
        _table.touchDelegate = self;
        _table.delegate      = self;
        _table.dataSource    = self;
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _table.sectionIndexColor = [UIColor grayColor]; //?????????????????????????????????
        _table.sectionIndexBackgroundColor = [UIColor clearColor];
        [_table setAutoresizesSubviews:YES];
        [_table setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        _table.estimatedRowHeight = 0;
        _table.estimatedSectionFooterHeight = 0;
        _table.estimatedSectionHeaderHeight = 0;
        
        [self.view addSubview:_table];
    
        
        [self addFooter];
        [self addHeader];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"CurrentController = %@",[self class]);
//    UIView *view = g_window.subviews.lastObject;
//    NSLog(@"lastObject = %@",g_window.subviews.lastObject);
//    if (self.isGotoBack){
//        
//        if (self.view.frame.origin.x != 0) {
//            [UIView animateWithDuration:0.3 animations:^{
////                view.frame = CGRectMake(-85, 0, TFJunYou__SCREEN_WIDTH, self.view.frame.size.height);
//                [self resetViewFrame];
//            }];
//        }
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isGotoBack) {
//        self.view.frame = CGRectMake(TFJunYou__SCREEN_WIDTH, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
//        [self screenEdgePanGestureRecognizer];
    }
    //???????????????
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
//    }
    
    _wait = [ATMHud sharedInstance];
}

//??????????????????
-(void)screenEdgePanGestureRecognizer
{
    
    UIScreenEdgePanGestureRecognizer *screenPan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenPanAction:)];
    screenPan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenPan];
    
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:screenPan];
    
}
//??????????????????
-(void)screenPanAction:(UIScreenEdgePanGestureRecognizer *)screenPan
{
    
    CGPoint p = [screenPan translationInView:self.view];
    NSLog(@"p = %@",NSStringFromCGPoint(p));
    self.view.frame = CGRectMake(p.x, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    if (screenPan.state == UIGestureRecognizerStateEnded) {
        if (p.x > TFJunYou__SCREEN_WIDTH/2) {
            [self actionQuit];
        }else {
            [self resetViewFrame];
        }
    }
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
//    }
//}

- (void)setupStrings{
//    _pSelf = self;
    _oldRowCount = 0;
    _lastScrollTime = 0;
    _isLoading = NO;
    heightHeader=TFJunYou__SCREEN_TOP;
    heightFooter=TFJunYou__SCREEN_BOTTOM;
    isFreeOnClose = YES;
    [g_window endEditing:YES];
//    if(isIOS7){
//        self.view.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
//    }
}

- (void)objectDidDragged:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint offset = [sender translationInView:g_App.window];
        if(offset.y>20 || offset.y<-20)
            return;
        if(isGotoBack)
            [self actionQuit];
        else
            [self onGotoHome];
    }
    /*
     if (sender.state == UIGestureRecognizerStateChanged ||
     sender.state == UIGestureRecognizerStateEnded) {
     //????????????????????????????????????????????????????????????View????????????
     CGPoint offset = [sender translationInView:g_App.window];
     //??????????????????????????????draggableObj????????????
     [self.view setCenter:CGPointMake(self.view.center.x + offset.x, self.view.center.y + offset.y)];
     //?????????sender??????????????????????????????????????????????????????????????????????????????
     [sender setTranslation:CGPointMake(0, 0) inView:g_App.window];
     }
     */
}

- (void)stopLoading {
    _isLoading = NO;
    [_footer endRefreshing];
    [_header endRefreshing];
}

- (void)dealloc {
    NSLog(@"dealloc - %@",[self class]);
    [_header free];
    [_footer free];
    tableHeader = nil;
    tableFooter = nil;
    _footer = nil;
    _header = nil;
    self.title = nil;
    self.headerTitle = nil;
//    _table = nil;
//    [super dealloc];
}


-(void)createHeaderView{
    tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self_width, heightHeader)];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self_width, heightHeader)];
    if (THESIMPLESTYLE) {
        iv.image = [[UIImage imageNamed:@"navBarBackground"] imageWithTintColor:[UIColor whiteColor]];
    }else {
        iv.image = [g_theme themeTintImage:@"navBarBackground"];//[UIImage imageNamed:@"navBarBackground"];
    }
    iv.userInteractionEnabled = YES;
    [tableHeader addSubview:iv];
//    [iv release];

    TFJunYou_Label* p = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(40, TFJunYou__SCREEN_TOP - 15-17, self_width-40*2, 20)];
    p.backgroundColor = [UIColor clearColor];
    p.textAlignment   = NSTextAlignmentCenter;
    p.textColor       = THESIMPLESTYLE ? [UIColor blackColor] : [UIColor whiteColor];
    p.text = self.title;
    p.font = [UIFont systemFontOfSize:18.0];
    p.userInteractionEnabled = YES;
    p.didTouch = @selector(actionTitle:);
    p.delegate = self;
    p.changeAlpha = NO;
    [tableHeader addSubview:p];
//    [p release];

    self.headerTitle = p;

    if(isGotoBack){
        
        self.gotoBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP - 46, 46, 46)];
        [self.gotoBackBtn setBackgroundImage:[UIImage imageNamed:@"title_back_black_big"] forState:UIControlStateNormal];
        [self.gotoBackBtn addTarget:self action:@selector(actionQuit) forControlEvents:UIControlEventTouchUpInside];
        [self.gotoBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.gotoBackBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.gotoBackBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [self.tableHeader addSubview:self.gotoBackBtn];
    }
}

-(void)createFooterView{
    tableFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self_width, heightFooter)];
    tableFooter.backgroundColor = [UIColor whiteColor];

//    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,LINE_WH)];
//    line.backgroundColor = THE_LINE_COLOR;
//    [tableFooter addSubview:line];
//    [line release];
    
 
    UIButton* btn;
    if(isGotoBack)
        return;

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self_width-76)/2, (49-36)/2, 152/2, 72/2);
    [btn setBackgroundImage:[UIImage imageNamed:@"singing_button_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"singing_button_press"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onSing) forControlEvents:UIControlEventTouchUpInside];
    [tableFooter addSubview:btn];
    self.footerBtnMid = btn;

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self_width-53-5, (49-33)/2, 53, 66/2);
    [btn setBackgroundImage:[UIImage imageNamed:@"nearby_button_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nearby_button_press"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onBtnRight) forControlEvents:UIControlEventTouchUpInside];
    [tableFooter addSubview:btn];
    self.footerBtnRight = btn;
    self.footerBtnRight.hidden = YES;
}

-(TFJunYou_TableView*)getTableView{
    return _table;
}

-(void)createHeadAndFoot{
    if(heightHeader==0 && heightFooter==0)
        return;
    int heightTotal = self.view.frame.size.height;
    [self.view addSubview:_table];

    if(heightHeader>0){
        [self createHeaderView];
        [self.view addSubview:tableHeader];
//        [tableHeader release];
    }
    
    if(heightFooter>0){
        [self createFooterView];
        [self.view addSubview:tableFooter];
//        [tableFooter release];
        tableFooter.frame = CGRectMake(0,heightTotal-heightFooter,self_width,heightFooter);
    }
    _table.frame =CGRectMake(0,heightHeader,self_width,self_height-heightHeader-heightFooter);
    
}

-(void) onGotoHome{
//    if(self.view.frame.origin.x == 260){
//        [g_App.leftView onClick];
//        return;
//    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
//    self.view.frame = CGRectMake (260, 0, self_width, self.view.frame.size.height);
    g_App.mainVc.view.frame  = CGRectMake (260, 0, g_App.mainVc.view.frame.size.width, g_App.mainVc.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)actionQuit{
    [_wait stop];
    [g_server stopConnection:self];
    [g_window endEditing:YES];
    [g_notify removeObserver:self];

    [_header removeFromSuperview];
    [_footer removeFromSuperview];
    _header = nil;
    _footer = nil;

//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [UIView beginAnimations:nil context:context];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.2];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(doQuit)];
    
    [g_navigation dismissViewController:self animated:YES];
    
//    self.view.frame = CGRectMake (TFJunYou__SCREEN_WIDTH, 0, self_width, self.view.frame.size.height);
//    NSInteger index = g_window.subviews.count;
//    if (index - 2 >= 0) {
//        UIView *view = g_window.subviews[index - 2];
//        view.frame = CGRectMake (0, 0, self_width, self.view.frame.size.height);
//    }
//    [UIView commitAnimations];
}

-(void)doQuit{
    [self.view removeFromSuperview];
//    if(isFreeOnClose)
//        _pSelf = nil;
}

-(void)onSing{
//    [g_App.leftView onSing];
}

-(void)onBtnRight{
//    [g_App.leftView onNear];
}

-(void)actionTitle:(TFJunYou_Label*)sender{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//????????????????????????
-(void)scrollToPageUp{
    if(_isLoading)
        return;
    NSLog(@"scrollToPageUp");
    _page = 0;
    [self getServerData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
}

-(void)scrollToPageDown{
    if(_isLoading)
        return;
    _page++;
    [self getServerData];
}

-(void)setIsShowHeaderPull:(BOOL)b{
    _header.hidden = !b;
    isShowHeaderPull  = b;
}

-(void)setIsShowFooterPull:(BOOL)b{
    _footer.hidden = !b;
    isShowFooterPull = b;
}

-(void)getServerData{
    
}

- (void)addFooter
{
    if(_footer){
//        [_footer free];
//        return;
    }
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    __weak TFJunYou_TableViewController *weakSelf = self;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [weakSelf scrollToPageDown];
//        NSLog(@"%@----????????????????????????", refreshView.class);
    };
    _footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        
        // ??????????????????????????????Block
//        NSLog(@"%@----????????????", refreshView.class);
    };
    _footer.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // ????????????????????????????????????????????????block
        switch (state) {
            case MJRefreshStateNormal:
//                NSLog(@"%@----????????????????????????", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
//                NSLog(@"%@----???????????????????????????????????????", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
//                NSLog(@"%@----??????????????????????????????", refreshView.class);
                break;
            default:
                break;
        }
    };
}

- (void)addHeader
{
    if(_header){
//        [_header free];
//        return;
    }
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    __weak TFJunYou_TableViewController *weakSelf = self;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // ????????????????????????????????????Block
        [weakSelf scrollToPageUp];
    };
    _header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // ??????????????????????????????Block
//        NSLog(@"%@----????????????", refreshView.class);
    };
    _header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // ????????????????????????????????????????????????block
        switch (state) {
            case MJRefreshStateNormal:
//                NSLog(@"%@----????????????????????????", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
//                NSLog(@"%@----???????????????????????????????????????", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
//                NSLog(@"%@----??????????????????????????????", refreshView.class);
                break;
            default:
                break;
        }
    };
}

-(void)setTitle:(NSString *)value{
    self.headerTitle.text = value;
    [super setTitle:value];
}
//????????????
- (void)moveSelfViewToLeft{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(-85, 0, TFJunYou__SCREEN_WIDTH, self.view.frame.size.height);
    }];
}

//??????
- (void)resetViewFrame{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, self.view.frame.size.height);
    }];
}

-(void)doAutoScroll:(NSIndexPath*)indexPath{
    if(_oldRowCount == [self tableView:_table numberOfRowsInSection:indexPath.section])//????????????????????????????????????????????????????????????????????????????????????
        return;
    if([[NSDate date] timeIntervalSince1970]-_lastScrollTime<0.5)//??????????????????
        return;
    if(isShowHeaderPull && !isShowFooterPull){//????????????????????????
        if(indexPath.row == 0){
            _oldRowCount = (int)[self tableView:_table numberOfRowsInSection:indexPath.section];
            NSLog(@"doAutoScroll=%d",_oldRowCount);
            [self scrollToPageUp];
            _lastScrollTime = [[NSDate date] timeIntervalSince1970];
//            _isLoading = YES;
            return;
        }
    }
    if(isShowFooterPull){//?????????????????????
        if(indexPath.row == [self tableView:_table numberOfRowsInSection:indexPath.section]-1){
            _oldRowCount = (int)[self tableView:_table numberOfRowsInSection:indexPath.section];
            NSLog(@"doAutoScroll=%d",_oldRowCount);
            [self scrollToPageDown];
//            _isLoading = YES;
            _lastScrollTime = [[NSDate date] timeIntervalSince1970];
            return;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ??????????????????
    tableView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.userInteractionEnabled = YES;
    });
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
