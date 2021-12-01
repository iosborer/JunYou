#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
@interface TFJunYou_DialogUtil : NSObject<MBProgressHUDDelegate> {
	long long expectedLength;
	long long currentLength;
}
+ (TFJunYou_DialogUtil *)sharedInstance;
+ (void)showDlgAlert:(NSString *) label;
- (void)showDlgCommon:(UIView *) view;
- (void)showDlg:(UIView *) view withLabel:(NSString *) label;
- (void)showDlg:(UIView *) view withLabel:(NSString *)label withDetail:(NSString *)detail;
- (void)showDlg:(UIView *) view withLabelDeterminate:(NSString *) label;
- (void)showDlg:(UIView *)view withLabelAnnularDeterminate:(NSString *) label;
- (void)showDlgWithLabelDeterminateHorizontalBar:(UIView *) view;
- (void)showDlg:(UIView *) view withImage:(NSString *) imgName withLabel:(NSString *) label;
- (void)showDldLabelMixed:(UIView *) view;
- (void)showDlg:(UIView *) view usingBlocks:(NSString *)label;
- (void)showDlg:(UIView *) view onWindow:(NSString *) label;
- (void)showDlg:(UIView *) view witgURL:(NSString *) url;
- (void)showDlgWithGradient:(UIView *) view;
- (void)showDlg:(UIView *) view textOnly:(NSString *) label;
- (void)showDlg:(UIView *) view withColor:(UIColor *) color;
@end
