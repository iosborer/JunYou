#import "WKWebView+TFJunYou_SearchWebView.h"
@implementation WKWebView (TFJunYou_SearchWebView)
- (void)highlightAllOccurencesOfString:(NSString*)str index:(NSInteger)index  searchResultBlock:(SearchResultBlock)searchResultBlock {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SearchWebView" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self evaluateJavaScript:jsCode completionHandler:nil];
    NSString *startSearch = [NSString stringWithFormat:@"MyApp_HighlightAllOccurencesOfString('%@', '%ld')",str,index];
    __weak typeof(self) weakSelf = self;
    [self evaluateJavaScript:startSearch completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        [weakSelf evaluateJavaScript:@"MyApp_ScrollToFiristResult()" completionHandler:nil];
    }];
    [self evaluateJavaScript:@"MyApp_SearchResultCount"
           completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        searchResultBlock([result integerValue]);
    }];
}
- (void)scrollToIndex:(NSInteger)index {
    [self evaluateJavaScript:[NSString stringWithFormat:@"MyApp_ScrollToIndex(%ld)",index] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
}
- (void)scrollToUp {
    [self evaluateJavaScript:@"MyApp_SwitchToUp()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
}
- (void)scrollDown {
    [self evaluateJavaScript:@"MyApp_SwitchToDown()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
}
- (void)removeAllHighlights {
    [self evaluateJavaScript:@"MyApp_RemoveAllHighlights()" completionHandler:nil];
}
@end
