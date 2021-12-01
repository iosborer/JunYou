#import "TFJunYou_FaceViewController.h"
#import "SCGIFImageView.h"
#import "TFJunYou_MessageObject.h"
#define BEGIN_FLAG @"["
#define END_FLAG @"]"
@implementation TFJunYou_FaceViewController
@synthesize delegate=_delegate,shortNameArrayC,shortNameArrayE;
#define PAGE_COUNT 1
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];;
    shortNameArrayC = [[NSMutableArray alloc] init];
    shortNameArrayE = [[NSMutableArray alloc] init];
    self.imageArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < g_constant.emojiArray.count; i ++) {
        NSDictionary *dic = g_constant.emojiArray[i];
        NSString *str = dic[@"filename"];
        [self.imageArray addObject:str];
        str = [NSString stringWithFormat:@"[%@]",dic[@"english"]];
        [shortNameArrayE addObject:str];
        str = [NSString stringWithFormat:@"[%@]",dic[@"chinese"]];
        [shortNameArrayC addObject:str];
    }
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage rangeOfString:@"zh-"].location == NSNotFound) {    
        self.shortNameArray = shortNameArrayE;
    }else{
        self.shortNameArray = shortNameArrayC;
    }
    [self create];
    return self;
}
- (void)dealloc {
    [_imageArray removeAllObjects];
}
-(void)create{
    int iconWith = 32;
    int margin = 17;
    int tempN = TFJunYou__SCREEN_WIDTH / (iconWith+margin);
    NSInteger pageCount = self.imageArray.count / (tempN * 3 - 1);
    if (self.imageArray.count % (tempN * 3 - 1) != 0) {
        pageCount = pageCount + 1;
    }
    _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20)];
    _sv.contentSize = CGSizeMake(WIDTH_PAGE*pageCount, self.frame.size.height-20);
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
    [self addSubview:_sv];
    int startX = (TFJunYou__SCREEN_WIDTH - tempN * iconWith - (tempN + 1) * margin) / 2;
    int n = 0;
    NSString* s;
    for(int i=0;i<pageCount;i++){
        int x=WIDTH_PAGE*i + startX,y=0;
        for(int j=0;j<tempN * 3 - 1;j++){
            if(n>=[self.imageArray count])
                break;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x+margin, y+10, iconWith, iconWith);
            button.tag = n;
                s = [self.imageArray objectAtIndex:n];
                [button addTarget:self action:@selector(actionSelect:)forControlEvents:UIControlEventTouchUpInside];
                if( (j+1) % tempN == 0){
                    x = WIDTH_PAGE*i + startX;
                    y += 50;
                }else
                    x += (iconWith+margin);
            n++;
            UIImage * emojiImage = [UIImage imageNamed:s];
            if (!emojiImage)
                NSLog(@"kong:%@",s);
            [button setBackgroundImage:emojiImage forState:UIControlStateNormal];
            [_sv addSubview:button];
        }
        s = @"im_delete_button_press";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(actionDelete:)forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(_sv.frame.size.width * (i + 1) - 33-15, 115, 33, 23);
        [button setBackgroundImage:[UIImage imageNamed:s] forState:UIControlStateNormal];
        [_sv addSubview:button];
    }
    _pc = [[UIPageControl alloc]initWithFrame:CGRectMake(100, self.frame.size.height-30, TFJunYou__SCREEN_WIDTH-200, 30)];
    _pc.numberOfPages  = pageCount;
    _pc.pageIndicatorTintColor = [UIColor grayColor];
    _pc.currentPageIndicatorTintColor = [UIColor blackColor];
    [_pc addTarget:self action:@selector(actionPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_pc];
    UIButton *sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sendButton setFont:[UIFont systemFontOfSize:14]];
    sendButton.frame = CGRectMake(self.frame.size.width - 40 - 15, 115 + 23 + 12, 40, 23);
    [sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [sendButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateHighlighted)];
    sendButton.layer.cornerRadius = 5;
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.borderWidth = 1;
    sendButton.layer.borderColor = [UIColor lightGrayColor].CGColor;;
    [sendButton addTarget:self action:@selector(sendEmoji) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:sendButton];
}
- (void)sendEmoji {
    [g_notify postNotificationName:kSendInputNotifaction object:nil userInfo:nil];
}
-(void)actionSelect:(UIView*)sender
{
    NSString *imageName = self.imageArray[sender.tag];
    NSString* shortName = [self.shortNameArrayE objectAtIndex:sender.tag];
    if ([self.delegate respondsToSelector:@selector(selectImageNameString:ShortName:isSelectImage:)]) {
        [self.delegate selectImageNameString:imageName ShortName:shortName isSelectImage:YES];
    }
}
-(IBAction)actionDelete:(UIView*)sender{
    if ([self.delegate respondsToSelector:@selector(faceViewDeleteAction)]) {
        [self.delegate faceViewDeleteAction];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/320;
    int mod   = fmod(scrollView.contentOffset.x,320);
    if( mod >= 160)
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
@end
