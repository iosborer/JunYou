#import "HBImageScroller.h"
#import "HBHttpRequestCache.h"
#import "TFJunYou_DialogUtil.h"
#import "HBHttpImageDownloader.h"
#import "TFJunYou_ActionSheetVC.h"
@interface HBImageScroller () <TFJunYou_ActionSheetVCDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) TFJunYou_ActionSheetVC *actionVC;
@end
@implementation HBImageScroller
@synthesize imageView=_imageView,controller;
#pragma -mark 覆盖父类的方法
#pragma -mark 事件响应方法
-(void)longPressAction:(UIGestureRecognizer*)sender
{
    if(sender.state==UIGestureRecognizerStateBegan){
        if(self.controller){
            self.actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"HBImageScroller_SavePhone"),Localized(@"HBImageScroller_ShareTo")]];
            self.actionVC.delegate = self;
            [g_App.window addSubview:self.actionVC.view];
        }else{
            self.actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"HBImageScroller_SavePhone")]];
            self.actionVC.delegate = self;
            [g_App.window addSubview:self.actionVC.view];
        }
    }
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}
-(void)imageTapTwoAction:(UIGestureRecognizer*)recognizer
{
        if(max)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [self setImageFrameAndContentSize];
            self.contentSize=self.frame.size;
            [UIView commitAnimations];
            max=NO;
        }else{
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            CGSize size=self.contentSize;
            size.width=_beginImageSize.width*_scale;
            size.height=_imgScale*size.width;
            float x=0,y=0;
            if (size.height<self.frame.size.height) {
                y=(self.frame.size.height-size.height)/2;
                size.height=self.frame.size.height;
            }
            if (size.width<self.frame.size.width) {
                x=(self.frame.size.width-size.width)/2;
                size.width=self.frame.size.width;
            }
            self.contentSize=size;
            _imageView.frame= CGRectMake(x, y, size.width, size.height);
            LocationRegion region=[self getLocationRegion:[recognizer locationInView:self]];
            switch (region) {
                case RegionTopLeft:
                    break;
                case RegionBottomLeft:
                    [self scrollRectToVisible:CGRectMake(0, self.contentSize.height-self.frame.size.height, self.frame.size.width, self.frame.size.height) animated:NO];
                    break;
                case RegionTopRight:
                    [self scrollRectToVisible:CGRectMake(self.contentSize.width-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
                    break;
                case RegionBottomRight:
                    [self scrollRectToVisible:CGRectMake(self.contentSize.width-self.frame.size.width, self.contentSize.height-self.frame.size.height, self.frame.size.width, self.frame.size.height) animated:NO];
                    break;
                default:
                    break;
            }
            [UIView commitAnimations];
            max=YES;
        }
}
-(void)imageTapOnceAction:(UIGestureRecognizer*)recognizer
{
    if(_tapOnceAction&&_target&&[_target respondsToSelector:_tapOnceAction])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_tapOnceAction withObject:_imageView];
#pragma clang diagnostic pop
}
#pragma -mark 回调方法
- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if(index==0){
        UIImageWriteToSavedPhotosAlbum(_imageView.image, self,@selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }else if(index==1){
    }
}
-(void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo 
{
    if(error){
        [[TFJunYou_DialogUtil sharedInstance] showDlg:self textOnly:Localized(@"JX_SaveFiled")];
    }else{
        [[TFJunYou_DialogUtil sharedInstance] showDlg:self textOnly:Localized(@"JX_SaveSuessed")];
    }
}
#pragma -mark 私有方法
-(CGRect)getFrameForImageView
{
    CGSize  size=_imageView.image.size;
    CGRect rect=self.frame;
    CGRect frame;
    float imgScale=size.height/size.width;
    float viewScale=rect.size.height/rect.size.width;
    float width=size.width,height=size.height;
    if(imgScale<viewScale&&size.width>rect.size.width){
        width=rect.size.width;
        height=width*imgScale;
        _scale=rect.size.height/height;
    }else if(imgScale>=viewScale&&size.height>rect.size.height){
        height=rect.size.height;
        width=height/imgScale;
        _scale=rect.size.width/width;
    }else{
         _scale=rect.size.width/width;
    }
    float x=0,y=0;
    if (width<rect.size.width) {
        x=(rect.size.width-width)/2;
    }if(height<rect.size.height){
        y=(rect.size.height-height)/2;
    }
    frame=CGRectMake(x, y, width, height);
    return frame;
}
-(void)setImageFrameAndContentSize
{
    CGRect frame=[self getFrameForImageView];
    _imageView.frame=frame;
    _beginImageSize=_imageView.frame.size;
    _imgScale=_imageView.image.size.height/_imageView.image.size.width;
    self.contentSize=self.frame.size;
}
-(LocationRegion)getLocationRegion:(CGPoint)point
{
    float width=self.frame.size.width;
    float height=self.frame.size.height;
    if(point.x<width/2)
    {
        if(point.y<height/2)
            return RegionTopLeft;
        else
            return RegionBottomLeft;
    }
    else
    {
        if(point.y<height/2)
            return RegionTopRight;
        else
            return RegionBottomRight;
    }
}
#pragma -mark 接口方法
-(id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if(self)
    {
        _imageView=[[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imageView];
        UITapGestureRecognizer * tapOnce=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapOnceAction:)];
        tapOnce.numberOfTapsRequired=1;
        tapOnce.numberOfTouchesRequired=1;
        [self addGestureRecognizer:tapOnce];
        _imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer* tapTwo=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapTwoAction:)];
        tapTwo.numberOfTapsRequired=2;
        tapTwo.numberOfTouchesRequired=1;
        [tapOnce requireGestureRecognizerToFail:tapTwo];
        [_imageView addGestureRecognizer:tapTwo];
        self.delegate = self;
        self.minimumZoomScale = 1;
        self.maximumZoomScale = 3;
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds=YES;
        max=NO;
        _tapOnceAction=nil;
        _target=nil;
        self.contentSize=self.frame.size;
    }
    return self;
}
-(id)initWithImage:(UIImage*)image andFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        [self setImage:image];
    }
    return self;
}
-(void)setImage:(UIImage*)image
{
    _imageView.image=image;
    [self setImageFrameAndContentSize];
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}
-(void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url andSmallImage:nil];
}
-(void)setImageWithURL:(NSString*)url  andSmallImage:(UIImage*)image
{
    UIImage* image1;
    if (image.images.count > 0) {
        UIImage *image2 = [[HBHttpRequestCache shareCache] getBitmapFromMemory:url];
        if (image2.images.count > 0) {
            image1 = image2;
        }else{
            [[HBHttpRequestCache shareCache] clearOneCache:url];
            [[HBHttpRequestCache shareCache] storeBitmapToMemory:image withKey:url];
            image1 = image;
        }
    }else{
        image1 = [[HBHttpRequestCache shareCache] getBitmapFromMemory:url];
    }
    if(image1){
        _imageView.image=image1;
        [self setImageFrameAndContentSize];
        _imageView.userInteractionEnabled=YES;
        UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPress];
    }else{
        UIImage *image1=[[HBHttpRequestCache shareCache] getBitmapFromDisk:url];
        if(image1){
            _imageView.image=image1;
            [self setImageFrameAndContentSize];
            _imageView.userInteractionEnabled=YES;
            UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
            [self addGestureRecognizer:longPress];
        }else{
            _imageView.image=image;
            [self setImageFrameAndContentSize];
            _imageView.userInteractionEnabled=NO;
            UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            indicator.frame=CGRectMake((self.frame.size.width-20)/2, (self.frame.size.height-20)/2, 20, 20);
            [self addSubview:indicator];
            [indicator startAnimating];
            [[HBHttpImageDownloader shareDownlader] downBitmapWithURL:url process:nil complete:^(UIImage *image, NSData *data, NSError *error, BOOL finish) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator stopAnimating];
                    [indicator removeFromSuperview];
                    _imageView.image=image;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self setImageFrameAndContentSize];
                    } completion:^(BOOL finished) {
                        _imageView.userInteractionEnabled=YES;
                        UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
                        [self addGestureRecognizer:longPress];
                    }];
                });
            } option:HBHttpImageDownloaderOptionUseCache valueReturn:nil];
        }
    }
}
-(void)addTarget:(id)target tapOnceAction:(SEL)action
{
    _target=target;
    _tapOnceAction=action;
}
-(void)reset
{
    [self setImageFrameAndContentSize];
}
@end
