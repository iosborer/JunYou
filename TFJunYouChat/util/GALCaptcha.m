#import "GALCaptcha.h"
#define kRandomColor  [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0];
#define kLineCount 6  
#define kLineWidth 1.0 
#define kCharCount 4   
#define kFontSize [UIFont systemFontOfSize:arc4random() % 5 + 15]
@implementation GALCaptcha
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor greenColor];
        [self showCaptcha];
    }
    return self;
}
- (void)refresh {
        [self showCaptcha];
        [self setNeedsDisplay];
}
-(void)showCaptcha
{
    self.CatArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    NSMutableString *getStr = [[NSMutableString alloc] initWithCapacity:kCharCount];
    self.CatString = [[NSMutableString alloc] initWithCapacity:kCharCount];
    for(int i = 0; i < kCharCount; i++)
    {
        NSInteger index = arc4random() % ([self.CatArray count] - 1);
        getStr = [self.CatArray objectAtIndex:index];
        self.CatString = (NSMutableString *)[self.CatString stringByAppendingString:getStr];
    }
}
#pragma mark 点击view时调用，因为当前类自身就是UIView，点击更换验证码可以直接写到这个方法中，不用再额外添加手势
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self showCaptcha];
    [self setNeedsDisplay];
}
#pragma mark 绘制界面（1.UIView初始化后自动调用； 2.调用setNeedsDisplay方法时会自动调用）
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.backgroundColor = kRandomColor;
    NSString *text = [NSString stringWithFormat:@"%@",self.CatString];
    CGSize cSize = [@"S" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}]; int width = rect.size.width / text.length - cSize.width;
    int height = rect.size.height - cSize.height;
    CGPoint point;
    float pX, pY;
    for (int i = 0; i < text.length; i++)
    {
        pX = arc4random() % width + rect.size.width / text.length * i;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        [textC drawAtPoint:point withAttributes:@{NSFontAttributeName:kFontSize}];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kLineWidth);
    for(int i = 0; i < kLineCount; i++)
    {
        UIColor *color = kRandomColor;
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextMoveToPoint(context, pX, pY);
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        CGContextStrokePath(context);
    }
}
@end
