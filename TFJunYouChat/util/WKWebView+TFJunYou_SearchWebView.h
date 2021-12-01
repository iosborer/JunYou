#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^SearchResultBlock)(NSInteger searchCount);
@interface WKWebView (TFJunYou_SearchWebView)
- (void)highlightAllOccurencesOfString:(NSString*)str index:(NSInteger)index searchResultBlock:(SearchResultBlock)searchResultBlock;
- (void)scrollToIndex:(NSInteger)index;
- (void)scrollToUp;
- (void)scrollDown;
- (void)removeAllHighlights;
@end
NS_ASSUME_NONNULL_END
