#import <UIKit/UIKit.h>
#import "NSAttributedString+EmojiExtension.h"
#import "TFJunYou_EmojiTextAttachment.h"
@implementation NSAttributedString (EmojiExtension)
- (NSString *)getPlainString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[TFJunYou_EmojiTextAttachment class]]) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((TFJunYou_EmojiTextAttachment *) value).emojiTag];
                          base += ((TFJunYou_EmojiTextAttachment *) value).emojiTag.length - 1;
                      }
                  }];
    return plainString;
}
@end
