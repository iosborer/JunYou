#import "HBShowImageControl.h"
#import "NSStrUtil.h"
#import "UIImageView+HBHttpCache.h"
#import "TFJunYou_ObjUrlData.h"
#import "JSONKit.h"
@implementation HBShowImageControl
@synthesize delegate,bFirstSmall,smallTag,bigTag,controller,larges;
#pragma -mark 覆盖父类的方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
#pragma -mark 私有方法
-(void)layoutImages
{
    int count=(int)[_imgurls count];
    if(count==1) {
        if (bFirstSmall) {
            [self drawLessThree];
        } else {
            [self drawSingleImage:[_imgurls objectAtIndex:0]];
        }
    }
    else if(count<=3)
        [self drawLessThree];
    else if(count==4)
        [self drawFour];
    else
        [self drawMoreFour];
    [self drawFile];
}
-(void)drawFile
{
    if([_files count]>0){
        float y;
        int imgCount=(int)[_imgurls count];
        if(imgCount==0){
            y=0;
        }else if(imgCount==1){
            y=MAX_HEIGHT;
        }else{
            y=([_imgurls count]/4+1)*(IMAGE_SPACE+IMAGE_SIZE);
        }
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, y+5, 44, 29)];
        imageView.image=[UIImage imageNamed:@"f_attach"];
        [self addSubview:imageView];
        UIImageView * countView=[[UIImageView alloc]initWithFrame:CGRectMake(22, 10, 18, 18)];
        countView.image=[UIImage imageNamed:@"f_attach_count"];
        UILabel * countLabel=[[UILabel alloc]initWithFrame:CGRectMake(22, 10, 18, 18)];
        countLabel.backgroundColor=[UIColor clearColor];
        countLabel.textAlignment=NSTextAlignmentCenter;
        countLabel.textColor=[UIColor whiteColor];
        countLabel.font=[UIFont systemFontOfSize:12];
        countLabel.text=[NSString stringWithFormat:@"%ld",[_files count]];
        [imageView addSubview:countView];
        [imageView addSubview:countLabel];
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookFileAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled=YES;
    }
}
-(void)uploadFinish
{
    if(delegate&&[delegate respondsToSelector:@selector(showImageControlFinishLoad:)])
        [delegate showImageControlFinishLoad:self];
}
-(void)drawSingleImage:(TFJunYou_ObjUrlData*)url
{
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT)];
    [self addSubview:imageView];
    [self drawImage:imageView file:url];
    [self uploadFinish];
    return;
}
-(void)drawLessThree
{
    int count=(int)[_imgurls count];
    for(int i=0;i<count;i++)
    {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((IMAGE_SIZE+IMAGE_SPACE)*i, 0, IMAGE_SIZE, IMAGE_SIZE)];
        TFJunYou_ObjUrlData * file=[_imgurls objectAtIndex:i];
        [self addSubview:imageView];
        [self drawImage:imageView file:file];
        if(count-1==i){
            [self uploadFinish];
        }
    }
}
-(void)drawFour
{
    int count=(int)[_imgurls count];
    for(int i=0;i<count;i++)
    {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((IMAGE_SPACE+IMAGE_SIZE)*(i%2),(IMAGE_SPACE+IMAGE_SIZE)*(i/2), IMAGE_SIZE, IMAGE_SIZE)];
        TFJunYou_ObjUrlData * file=[_imgurls objectAtIndex:i];
        [self addSubview:imageView];
        [self drawImage:imageView file:file];
        if(i==count-1)
            [self uploadFinish];
    }
}
-(void)drawMoreFour
{
    int count=(int)[_imgurls count];
    for(int i=0;i<count;i++)
    {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake((IMAGE_SPACE+IMAGE_SIZE)*(i%3),(IMAGE_SPACE+IMAGE_SIZE)*(i/3), IMAGE_SIZE, IMAGE_SIZE)];
        TFJunYou_ObjUrlData * file=[_imgurls objectAtIndex:i];
        [self addSubview:imageView];
        [self drawImage:imageView file:file];
        if(i==count-1)
            [self uploadFinish];
    }
}
-(void)drawImage:(UIImageView*)imageView file:(TFJunYou_ObjUrlData*)file
{
    [_bigUrls addObject:file.url];
    [ _imageViews addObject:imageView];
    UIActivityIndicatorView * indicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((imageView.frame.size.width-20)/2, (imageView.frame.size.height-20)/2, 20, 20)];
    [imageView addSubview:indicator];
    [indicator startAnimating];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:file.url] placeholderImage:[UIImage imageNamed:@"Default_Gray"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookImageAction:)];
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:tap];
        imageView.image = image;
    }];
}
#pragma -mark 事件响应方法
-(void)lookFileAction:(UIGestureRecognizer*)sender
{
    if(delegate&&[delegate respondsToSelector:@selector(lookFileAction:files:)]){
        [delegate lookFileAction:self files:_files];
    }
}
-(void)lookImageAction:(UIGestureRecognizer*)sender
{
    if(delegate&&[delegate respondsToSelector:@selector(lookImageAction:)])
        [delegate lookImageAction:self];
    _imageList=[[HBImageViewList alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_imageList addTarget:self tapOnceAction:@selector(dismissImageAction:)];
    int index=(int)[_imageViews indexOfObject:sender.view];
    UIImageView * view=(UIImageView*)sender.view;
    TFJunYou_ObjUrlData* p = [larges objectAtIndex:index];
    NSString * url=p.url;
    p = nil;
    _util=[[NSImageUtil alloc]init];
    int count=(int)[_imageViews count];
    for(int i=0;i<count;i++){
        UIImage * image=((UIImageView*)[_imageViews objectAtIndex:i]).image;
        if(image){
            [_images addObject:image];
        }
    }
    [_util showBigImageWithUrl:url fromView:view complete:^(UIView * backView) {
        [backView setHidden:YES];
        [_imageList addImagesURL:larges withSmallImage:_images];
        [_imageList setIndex:index];
        [self.window addSubview:_imageList];
        [UIApplication sharedApplication].statusBarHidden = YES;
    }];
}
-(void)dismissImageAction:(UIImageView*)sender
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    int index=(int)[_imageList.imageViews indexOfObject:sender.superview];
    if (index < 0) {
        return;
    }
    UIImageView * view=[_imageViews objectAtIndex:index];
    [_imageList removeFromSuperview];
     NSString * url=[_bigUrls objectAtIndex:index];
    [_util goBackToView:view withImageUrl:url];
}
#pragma -mark 接口方法
-(void)setImagesFileStr:(NSString*)fileStr
{
    if(fileStr==nil)
        return;
    if ([fileStr isKindOfClass:[NSArray class]]) {
        if(((NSArray*)fileStr).count==0)
            return;
        id object=[((NSArray*)fileStr) objectAtIndex:0];
        if([object isKindOfClass:[TFJunYou_ObjUrlData class]]){
            [self setImagesWithFiles:(NSArray*)fileStr];
            return;
        }
        fileStr = [fileStr JSONString];
    } 
    NSArray *objArr = [TFJunYou_ObjUrlData getDataArray:fileStr];
    [self setImagesWithFiles:objArr];
}
-(void)setImagesWithFiles:(NSArray*)files1
{
    NSMutableArray * images=[[NSMutableArray alloc]init];
    NSMutableArray * files=[[NSMutableArray alloc]init];
    int count=(int)[files1 count];
    for(int i=0;i<count;i++){
        TFJunYou_ObjUrlData * data =[files1 objectAtIndex:i];
        if ([data.url isKindOfClass:[NSString class]]) {
            if([data.url length]>0){
                NSArray * array=[data.mime componentsSeparatedByString:@"/"];
                NSString * mime=[array objectAtIndex:0];
                if([mime isEqualToString:@"image"])
                    [images addObject:data];
                else{
                    [files addObject:data];
                }
            }
        }
    }
    _imgurls=images;
    _files=files;
    _bigUrls=[[NSMutableArray alloc]init];
    _images=[[NSMutableArray alloc]init];
    _imageViews=[[NSMutableArray alloc]init];
    for(UIView * view in self.subviews)
        [view removeFromSuperview];
    [self layoutImages];
}
+(float)heightForFileStr:(NSString*)fileStr
{
    if(fileStr==nil)
        return 0;
    if ([fileStr isKindOfClass:[NSArray class]]) {
        if(((NSArray*)fileStr).count==0)
            return 0;
        id object=[((NSArray*)fileStr) objectAtIndex:0];
        if([object isKindOfClass:[TFJunYou_ObjUrlData class]]){
            return [self heightForFiles:(NSArray*)fileStr];
        }
        fileStr = [fileStr JSONString];
    }
    NSArray *objArr = [TFJunYou_ObjUrlData getDataArray:fileStr];
    return [self heightForFiles:objArr];
}
+(float)heightForFiles:(NSArray*)files1
{
    int imageCount=0;
    int count=(int)[files1 count];
    for(int i=0;i<count;i++){
        TFJunYou_ObjUrlData * data =[files1 objectAtIndex:i];
        NSArray * array=[data.mime componentsSeparatedByString:@"/"];
        NSString * mime=[array objectAtIndex:0];
        if([mime isEqualToString:@"image"])
            imageCount++;
    }
    float offset;
    if(imageCount==count){
        offset=0;
    }else{
        offset=40;
    }
    if(imageCount==0)
        return offset;
    else if(imageCount==1){
        return  MAX_HEIGHT+offset;
    }else{
        if (imageCount % 3 == 0) {
            return (imageCount/3)*(IMAGE_SIZE+IMAGE_SPACE)+offset;
        }else {
            return (imageCount/3+1)*(IMAGE_SIZE+IMAGE_SPACE)+offset;
        }
    }
}
@end
