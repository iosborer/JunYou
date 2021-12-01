#import "HWTFCodeView.h"
@interface HWTFCodeView ()
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) CGFloat itemMargin;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIControl *maskView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labels;
@property (nonatomic, strong) NSMutableArray<UIView *> *lines;
@end
@implementation HWTFCodeView
#pragma mark - 初始化
- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin
{
    if (self = [super init]) {
        self.itemCount = count;
        self.itemMargin = margin;
        [self configTextField];
    }
    return self;
}
- (void)configTextField
{
    self.backgroundColor = [UIColor clearColor];
    self.labels = @[].mutableCopy;
    self.lines = @[].mutableCopy;
    UITextField *textField = [[UITextField alloc] init];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    [self addSubview:textField];
    self.textField = textField;
    UIButton *maskView = [UIButton new];
    maskView.backgroundColor = HEXCOLOR(0x181E1F);
    [maskView addTarget:self action:@selector(clickMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:maskView];
    self.maskView = maskView;
    for (NSInteger i = 0; i < self.itemCount; i++)
    {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:41.5];
        [self addSubview:label];
        [self.labels addObject:label];
    }
    for (NSInteger i = 0; i < self.itemCount; i++)
    {
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        [self.lines addObject:line];
    }
    [self clickMaskView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.labels.count != self.itemCount) return;
    CGFloat temp = self.bounds.size.width - (self.itemMargin * (self.itemCount - 1));
    CGFloat w = temp / self.itemCount;
    CGFloat x = 0;
    for (NSInteger i = 0; i < self.labels.count; i++)
    {
        x = i * (w + self.itemMargin);
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(x, 0, w, self.bounds.size.height);
        UIView *line = self.lines[i];
        line.frame = CGRectMake(x, self.bounds.size.height - 1, w, 1);
    }
    self.textField.frame = self.bounds;
    self.maskView.frame = self.bounds;
}
#pragma mark - 编辑改变
- (void)tfEditingChanged:(UITextField *)textField
{
    if (textField.text.length > self.itemCount) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, self.itemCount)];
    }
    for (int i = 0; i < self.itemCount; i++)
    {
        UILabel *label = [self.labels objectAtIndex:i];
        if (i < textField.text.length) {
            label.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        } else {
            label.text = nil;
        }
    }
    if (textField.text.length >= self.itemCount) {
        [textField resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(codeView:inputFnish:)]) {
            [self.delegate codeView:self inputFnish:textField.text];
        }
    }
}
- (void)clickMaskView
{
    [self.textField becomeFirstResponder];
}
- (BOOL)endEditing:(BOOL)force
{
    [self.textField endEditing:force];
    return [super endEditing:force];
}
- (NSString *)code
{
    return self.textField.text;
}
@end
