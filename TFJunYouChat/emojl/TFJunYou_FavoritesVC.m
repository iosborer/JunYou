#import "TFJunYou_FavoritesVC.h"
#import "JLFacePackgeModel.h"
@interface TFJunYou_FavoritesVC ()<UIScrollViewDelegate>
@property (nonatomic, assign) int margin;
@property (nonatomic, assign) int tempN;
@property (nonatomic, assign) int maxPage;
@property (nonatomic, strong) UIScrollView *sv;
@property (nonatomic, strong) UIPageControl *pc;
@property (nonatomic, strong) NSMutableArray *delBtns;
@end
@implementation TFJunYou_FavoritesVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _delBtns = [NSMutableArray array];
    _margin = 18;
    _tempN = TFJunYou__SCREEN_WIDTH / (60 + _margin);
    if (((_tempN + 1) * 60 + _tempN * _margin) <= TFJunYou__SCREEN_WIDTH) {
        _tempN += 1;
    }
    _margin = (TFJunYou__SCREEN_WIDTH - _tempN * 60) / (_tempN + 1);
        [g_server faceClollectListType:@"1" View:self];
    [g_notify addObserver:self selector:@selector(refresh) name:kFavoritesRefresh object:nil];
}
-(void)create {
    int m = fmod([g_myself.favorites count], (_tempN * 2));
    _maxPage = (int)[g_myself.favorites count]/(_tempN*2);
    if(m != 0)
        _maxPage++;
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_delBtns removeAllObjects];
    _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20)];
    _sv.contentSize = CGSizeMake(WIDTH_PAGE*_maxPage, self.view.frame.size.height-20);
    _sv.pagingEnabled = YES;
    _sv.scrollEnabled = YES;
    _sv.delegate = self;
    _sv.showsVerticalScrollIndicator = NO;
    _sv.showsHorizontalScrollIndicator = NO;
    _sv.userInteractionEnabled = YES;
    _sv.minimumZoomScale = 1;
    _sv.maximumZoomScale = 1;
    _sv.decelerationRate = 0.01f;
    _sv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sv];
    int n = 0;
    int startX = (TFJunYou__SCREEN_WIDTH - _tempN * 60 - (_tempN - 1) * _margin) / 2;
    for(int i=0;i<_maxPage;i++){
        int x=WIDTH_PAGE*i + startX,y=0;
        for(int j=0;j<_tempN * 2;j++){
            if(n>=[g_myself.favorites count])
                break;
            TFJunYou_ImageView *iv = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(x, y+10, 60, 60)];
            iv.tag = n;
            JLFacePackgeModel *model = g_myself.favorites[n];
            NSString *url = model.path[0];
            [iv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Default_Gray"]];
            iv.delegate = self;
            iv.didTouch = @selector(actionSelect:);
            [_sv addSubview:iv];
            UILongPressGestureRecognizer *lg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureAction:)];
            [iv addGestureRecognizer:lg];
            TFJunYou_ImageView* del = [[TFJunYou_ImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iv.frame) - 15, iv.frame.origin.y - 5, 20, 20)];
            del.didTouch = @selector(onDelete:);
            del.delegate = self;
            del.tag = n;
            del.image = [UIImage imageNamed:@"delete"];
            del.hidden = YES;
            [_sv addSubview:del];
            [_delBtns addObject:del];
            if ((j + 1) % _tempN == 0) {
                x = WIDTH_PAGE*i + startX;
                y += 70;
            }else {
                x += 60 + _margin;
            }
            n++;
        }
    }
    _pc = [[UIPageControl alloc]initWithFrame:CGRectMake(100, self.view.frame.size.height-30, TFJunYou__SCREEN_WIDTH-200, 30)];
    _pc.numberOfPages  = _maxPage;
    _pc.pageIndicatorTintColor = [UIColor grayColor];
    _pc.currentPageIndicatorTintColor = [UIColor blackColor];
    _pc.userInteractionEnabled = NO;
    [_pc addTarget:self action:@selector(actionPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pc];
}
- (void)refresh {
    [g_server faceClollectListType:@"1" View:self];
    [self create];
}
-(void)actionSelect:(UIView*)sender
{
   JLFacePackgeModel *model = [g_myself.favorites objectAtIndex:sender.tag];
    NSString* s = model.path[0];
    if ([self.delegate respondsToSelector:@selector(selectFavoritWithString:)]) {
        [self.delegate selectFavoritWithString:s];
    }
}
- (void)longGestureAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSInteger n = gestureRecognizer.view.tag;
        for (NSInteger i = 0; i < _delBtns.count; i ++) {
            TFJunYou_ImageView *iv = _delBtns[i];
            if (i == n) {
                iv.hidden = !iv.hidden;
            }else {
                iv.hidden = YES;
            }
        }
    }
}
- (void)onDelete:(UIView *)view {
    NSInteger n = view.tag;
            JLFacePackgeModel *model = [g_myself.favorites objectAtIndex:n];
            NSString* s = model.id;
            [g_server faceClollectDeleteFaceClollect:s View:self];
            [g_myself.favorites removeObjectAtIndex:n];
            [self create];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (NSInteger i = 0; i < _delBtns.count; i ++) {
        TFJunYou_ImageView *iv = _delBtns[i];
        iv.hidden = YES;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/TFJunYou__SCREEN_WIDTH;
    int mod   = fmod(scrollView.contentOffset.x,TFJunYou__SCREEN_WIDTH);
    if( mod >= TFJunYou__SCREEN_WIDTH/2)
        index++;
    _pc.currentPage = index;
}
- (void) setPage
{
    _sv.contentOffset = CGPointMake(WIDTH_PAGE*_pc.currentPage, 0.0f);
    [_pc setNeedsDisplay];
}
-(void)actionPage{
    [self setPage];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if ([aDownload.action isEqualToString:act_userEmojiList]) {
        [g_myself.favorites removeAllObjects];
        [g_myself.favorites addObjectsFromArray:array1];
        [self create];
    }
     if ([aDownload.action isEqualToString:act_FaceClollectList]) {
            NSLog(@"----%@---%@", dict, array1);
            [g_myself.favorites removeAllObjects];
            for (NSDictionary *dict in array1) {
                JLFacePackgeModel *model =[JLFacePackgeModel mj_objectWithKeyValues:dict[@"face"]];
                model.id = dict[@"id"];
                [g_myself.favorites addObject:model];
            }
            [self create];
        }
    if([aDownload.action isEqualToString:act_FaceClollectDeleteFaceClollect]){
        [SVProgressHUD setMinimumDismissTimeInterval:2.0];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [g_server faceClollectListType:@"1" View:self];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    return hide_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    return hide_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
