#import "TFJunYou_Emoji.h"
#import "TFJunYou_FaceViewController.h"
#import "TFJunYou_emojiViewController.h"
#import "webpageVC.h"
#import "TFJunYou_ActionSheetVC.h"
#import <CoreText/CoreText.h>
@interface TFJunYou_Emoji () <TFJunYou_ActionSheetVCDelegate>
@property (nonatomic, strong) TFJunYou_ActionSheetVC *actionVC;
@end
@implementation TFJunYou_Emoji
@synthesize maxWidth,faceHeight,faceWidth,offset;
#define BEGIN_FLAG @"["
#define END_FLAG @"]"
#define AT_FLAG @"@"
static NSMutableArray *faceArray;
static NSMutableArray *imageArrayC;
static NSMutableArray *imageArrayE;
static NSMutableArray *shortNameArrayC;
static NSMutableArray *shortNameArrayE;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(shortNameArrayC==nil){
            shortNameArrayC = g_faceVC.shortNameArrayC;
            shortNameArrayE = g_faceVC.shortNameArrayE;
        }
        data = [[NSMutableArray alloc] init];
        faceWidth  = 23;
        faceHeight = 23;
        _top       = 0;
        offset     = 0;
        maxWidth   = TFJunYou__SCREEN_WIDTH-INSETS-HEAD_SIZE - 100;
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.textAlignment = NSTextAlignmentLeft;
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(void)dealloc{
}
- (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}
-(void)getImageRange:(NSString*)message  array: (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    NSRange atRange = [message rangeOfString:AT_FLAG];
    self.contentEmoji = [self isContainsEmoji:message];
    if (((range.length>0 && range1.length>0) || atRange.length>0) && range1.location > range.location) {
        if (range.length>0 && range1.length>0) {
            if (range.location > 0) {
                NSString *str = [message substringToIndex:range.location];
                NSString *str1 = [message substringFromIndex:range.location];
                [array addObject:str];
                [self getImageRange:str1 array:array];
            }else {
                NSString *emojiString = [message substringWithRange:NSMakeRange(range.location + 1, range1.location - 1)];
                BOOL isEmoji = NO;
                NSString *str;
                NSString *str1;
                for (NSMutableDictionary *dic in g_constant.emojiArray) {
                    NSString *emoji = [dic objectForKey:@"english"];
                    if ([emoji isEqualToString:emojiString]) {
                        isEmoji = YES;
                        break;
                    }
                }
                if (isEmoji) {
                    self.contentEmoji = YES;
                    str = [message substringWithRange:NSMakeRange(range.location, range1.location + 1)];
                    str1 = [message substringFromIndex:range1.location + 1];
                    [array addObject:str];
                }else{
                    NSString *posString = [message substringWithRange:NSMakeRange(range.location + 1, range1.location)];
                    NSRange posRange = [posString rangeOfString:@"["];
                    if (posRange.location != NSNotFound) {
                        str = [message substringToIndex:posRange.location + 1];
                        str1 = [message substringFromIndex:posRange.location + 1];
                        [array addObject:str];
                    }else{
                        str = [message substringToIndex:range1.location + 1];
                        str1 = [message substringFromIndex:range1.location + 1];
                        [array addObject:str];
                    }
                }
                [self getImageRange:str1 array:array];
            }
        } else if (atRange.length>0) {
            if (atRange.location > 0) {
                [array addObject:[message substringToIndex:atRange.location]];
                [array addObject:[message substringWithRange:NSMakeRange(atRange.location, 1)]];
                NSString *str=[message substringFromIndex:atRange.location+1];
                [self getImageRange:str array:array];
            }else{
                [array addObject:[message substringWithRange:NSMakeRange(atRange.location, 1)]];
                NSString *str=[message substringFromIndex:atRange.location+1];
                [self getImageRange:str array:array];
            }
        }else if (message != nil) {
            [array addObject:message];
        }
    }
    else if (range.length>0 && range1.length>0 && range1.location < range.location){
        NSString *str = [message substringToIndex:range1.location + 1];
        NSString *str1 = [message substringFromIndex:range1.location + 1];
        [array addObject:str];
        [self getImageRange:str1 array:array];
    }
    else if (message != nil) {
        [array addObject:message];
    }
}
#pragma mark ------------特殊字符-----------------
-(void)setAttributedTextRange:(NSString *)text{
    NSError *error = NULL;
    NSString * patren = @"[^0-9]";
    NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:patren options:0 error:&error];
    NSString * numberString = [reg stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@" "];
    NSArray * array = [numberString componentsSeparatedByString:@" "];
    NSMutableArray * numberArr = [[NSMutableArray alloc]init];
    NSMutableString * muText = [[NSMutableString alloc]initWithString:text];
    int plus = 0;
    for (int i = 0; i < [array count]; i++) {
        NSString * number = array[i];
        if (![number isEqualToString:@""] && number.length >5) {
            NSRange range = [text rangeOfString:number];
            [muText insertString:@" " atIndex:range.location +plus*2];
            [muText insertString:@" " atIndex:(range.location + range.length+1+plus*2)];
            [numberArr addObject:[NSNumber numberWithInteger:range.location]];
            [numberArr addObject:[NSNumber numberWithInteger:(range.location + range.length)]];
            plus++;
        }
    }
    text = muText;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber|NSTextCheckingTypeLink  error:&error];
    self.matches = [detector matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    [self highlightLinksWithIndex:NSNotFound];
    for (int i = 0; i < [numberArr count]; i++) {
        NSNumber * index = numberArr[i];
        [muText deleteCharactersInRange:NSMakeRange([index integerValue], 1)];
    }
    text = muText;
}
- (NSArray *)setTextWithAttribute:(NSString *)text attributedText:(NSMutableAttributedString *)attributedText regulaStr:(NSString *)regulaStr  {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    if (!arrayOfAllMatches || arrayOfAllMatches.count <= 0) {
        return nil;
    }
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSMutableArray *rangeArr=[[NSMutableArray alloc]init];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch;
        substringForMatch = [text substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    NSString *subStr=[text copy];
    NSUInteger index = 0;
    for (NSString *str in arr) {
        NSValue *value = [self rangesOfString:str inString:subStr];
        NSRange range = [value rangeValue];
        if ((range.location + range.length) < text.length) {
            subStr = [subStr substringFromIndex:range.location + range.length];
        }
        range.location += index;
        value = [NSValue valueWithRange:range];
        [rangeArr addObject:value];
        index = range.location + range.length;
    }
    self.matches = [NSMutableArray array];
    for(NSValue *value in rangeArr)
    {
        NSInteger index=[rangeArr indexOfObject:value];
        NSRange range=[value rangeValue];
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber|NSTextCheckingTypeLink  error:&error];
        [self.matches addObjectsFromArray:[detector matchesInString:text options:0 range:range]];
        NSString * urlStr = [[arr objectAtIndex:index] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [attributedText addAttribute:NSLinkAttributeName value:[NSURL URLWithString:urlStr] range:range];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
    }
    return rangeArr;
}
- (NSValue *)rangesOfString:(NSString *)searchString inString:(NSString *)str {
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSRange range;
    if ((range = [str rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
    }
    return [NSValue valueWithRange:range];
}
- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index <= range.location+range.length;
}
- (void)highlightLinksWithIndex:(CFIndex)index {
    if(self.contentEmoji){
        return;
    }
    NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
    int plus = 0;
    for (NSTextCheckingResult *match in self.matches) {
        if ([match resultType] == NSTextCheckingTypePhoneNumber||[match resultType] == NSTextCheckingTypeLink) {
            NSRange matchRange;
            if ([match resultType] == NSTextCheckingTypePhoneNumber) {
                matchRange = NSMakeRange(match.range.location -1 -2*plus, match.range.length);
                plus++;
            }else{
                matchRange = NSMakeRange(match.range.location -2*plus, match.range.length);
            }
            if (matchRange.location == 18446744073709551615 &&matchRange.length !=0) {
                matchRange.location =0;
            }
            if ((matchRange.location + matchRange.length) > attributedString.length) {
                matchRange.length = attributedString.length - matchRange.location;
            }
            if (matchRange.length <= attributedString.length) {
                if ([self isIndex:index inRange:matchRange]) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
                }
                else {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:matchRange];
                }
                if ([match resultType] == NSTextCheckingTypeLink) {
                    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
                }
            }
        }
    }
    self.attributedText = attributedString;
}
- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, [self.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (!attrs[(NSString*)kCTFontAttributeName]) {
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:self.font range:NSMakeRange(0, [self.attributedText length])];
        }
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName]) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:self.lineBreakMode];
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
        if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        }
        [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
    }];
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    CGRect textRect = [self textRect];
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    point = CGPointMake(point.x, textRect.size.height - point.y);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    NSUInteger idx = NSNotFound;
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        if (point.y > yMax) {
            break;
        }
        if (point.y >= yMin) {
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + textRect.size.width) {
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    CFRelease(frame);
    CFRelease(path);
    return idx;
}
- (CGRect)textRect {
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    return textRect;
}
- (void)setText:(NSString *)text {
    int faceIndex = 0;
    [data removeAllObjects];
    [self getImageRange:text array:data];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    for (int i=0;i<[data count];i++) {
         NSString *str=[data objectAtIndex:i];
         BOOL isFace = NO;
         NSInteger n;
         if ([str hasPrefix:BEGIN_FLAG]&&[str hasSuffix:END_FLAG]) {
              isFace = [shortNameArrayC indexOfObject:str] != NSNotFound;
              n = [shortNameArrayC indexOfObject:str];
              if (!isFace) {
                  isFace = [shortNameArrayE indexOfObject:str] != NSNotFound;
                  n = [shortNameArrayE indexOfObject:str];
              }
              if(isFace){
                  NSDictionary *dic = [g_constant.emojiArray objectAtIndex:n];
                  NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                  attach.image = [UIImage imageNamed:dic[@"filename"]];
                  attach.bounds = CGRectMake(0, 0, faceWidth, faceHeight);
                  NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
                  [attStr insertAttributedString:attachString atIndex:faceIndex];
                  faceIndex ++;
              }
        }
        if(!isFace) {
            if (str.length > 0) {
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                NSAttributedString *att = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : self.font,NSParagraphStyleAttributeName:paragraphStyle}];
                [attStr insertAttributedString:att atIndex:faceIndex];
                NSMutableString *string = [str mutableCopy];
                for (NSInteger i = 0; i < faceIndex; i ++) {
                    [string insertString:@" " atIndex:0];
                }
                NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z0-9]+)(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(([a-zA-Z0-9\\-]+\\.)+(com|cn|cc|top|xyz|edu|gov|mil|net|org|biz|info|name|museum|us|ca|uk)(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
                [self setTextWithAttribute:string attributedText:attStr regulaStr:regulaStr];
                regulaStr = @"((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$";
                [self setTextWithAttribute:string attributedText:attStr regulaStr:regulaStr];
            }
            faceIndex += str.length;
        }
    }
    self.attributedText = attStr;
    CGSize size1 = [self sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, size1.width, size1.height);
}
#pragma mark ---------------点击事件----------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.lastTouches = touches;
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    if (![self label:self didBeginTouch:touch onCharacterAtIndex:index]) {
        [super touchesBegan:touches withEvent:event];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    if (![self label:self didMoveTouch:touch onCharacterAtIndex:index]) {
        [super touchesMoved:touches withEvent:event];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.lastTouches) {
        return;
    }
    self.lastTouches = nil;
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    if (![self label:self didEndTouch:touch onCharacterAtIndex:index]) {
        [super touchesEnded:touches withEvent:event];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.lastTouches) {
        return;
    }
    self.lastTouches = nil;
    UITouch *touch = [touches anyObject];
    if (![self label:self didCancelTouch:touch]) {
        [super touchesCancelled:touches withEvent:event];
    }
}
- (void)cancelCurrentTouch {
    if (self.lastTouches) {
        [self label:self didCancelTouch:[self.lastTouches anyObject]];
        self.lastTouches = nil;
    }
}
#pragma mark -------------点击处理------------------
- (BOOL)label:(TFJunYou_Emoji *)label didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    [self highlightLinksWithIndex:charIndex];
    return YES;
}
- (BOOL)label:(TFJunYou_Emoji *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    [self highlightLinksWithIndex:charIndex];
    return YES;
}
- (BOOL)label:(TFJunYou_Emoji *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    [g_window endEditing:YES];
    [self highlightLinksWithIndex:NSNotFound];
    int plus = 0;
    for (NSTextCheckingResult *match in self.matches) {
        if ([match resultType] == NSTextCheckingTypePhoneNumber) {
            NSRange matchRange = NSMakeRange(match.range.location -1 -2*plus, match.range.length);
            if (matchRange.location == 18446744073709551615 &&matchRange.length !=0) {
                matchRange.location =0;
            }
            self.textCopy = match.phoneNumber;
            if ([self isIndex:charIndex inRange:matchRange]) {
                self.actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JX_Copy"),Localized(@"JXEmoji_CallPhone")]];
                self.actionVC.delegate = self;
                self.actionVC.tag = 1;
                [g_App.window addSubview:self.actionVC.view];
                break;
            }
            plus++;
        }else if ([match resultType] == NSTextCheckingTypeLink){
            NSRange matchRange = NSMakeRange(match.range.location -2*plus, match.range.length);
            self.textCopy = [NSString stringWithFormat:@"%@",match.URL];
            if ([self isIndex:charIndex inRange:matchRange]) {
                    webpageVC *webVC = [webpageVC alloc];
                    webVC.isGotoBack= YES;
                    webVC.isSend = YES;
                    webVC.url = self.textCopy;
                    webVC = [webVC init];
                    [g_navigation.navigationView addSubview:webVC.view];
                break;
            }
        }
    }
    return YES;
}
#pragma -mark actionSheet回调方法
- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    self.backgroundColor=[UIColor clearColor];
    if (actionSheet.tag==1) {
        if(index==0){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:self.textCopy];
        }else if(index==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.textCopy]]];
        }
    }else if (actionSheet.tag==2){
        if(index==1){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                webpageVC *webVC = [webpageVC alloc];
                webVC.isGotoBack= YES;
                webVC.isSend = YES;
                webVC.url = self.textCopy;
                webVC = [webVC init];
                [g_navigation.navigationView addSubview:webVC.view];
            });
            [actionSheet.view removeFromSuperview];
        }else if(index==0){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:self.textCopy];
        }
    }
}
- (BOOL)label:(TFJunYou_Emoji *)label didCancelTouch:(UITouch *)touch {
    [self highlightLinksWithIndex:NSNotFound];
    return YES;
}
@end
