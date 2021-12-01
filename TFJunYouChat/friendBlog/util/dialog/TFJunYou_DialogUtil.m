#import "TFJunYou_DialogUtil.h"
@implementation TFJunYou_DialogUtil
+ (TFJunYou_DialogUtil *) sharedInstance
{
    static TFJunYou_DialogUtil *sharedInstance = nil ;
    static dispatch_once_t onceToken;  
    dispatch_once (&onceToken, ^ {     
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
+ (void)showDlgAlert:(NSString *) label {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Localized(@"JX_Tip") message:label delegate:self  cancelButtonTitle:NSLocalizedStringFromTable(@"str_common_sure", @"local", nil) otherButtonTitles:nil, nil];
    [alertView setBackgroundColor:[UIColor clearColor]];
    [alertView show];
}
- (void)showDlgCommon:(UIView *) view {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.delegate = self;
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)showDlg:(UIView *) view withLabel:(NSString *) label {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.delegate = self;
	hud.labelText = label;
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)showDlg:(UIView *) view withLabel:(NSString *)label withDetail:(NSString *)detail {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
    hud.delegate = self;
	hud.labelText = label;
	hud.detailsLabelText = detail;
	hud.square = YES;
    [hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)showDlg:(UIView *) view withLabelDeterminate:(NSString *) label{
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.mode = MBProgressHUDModeDeterminate;
	hud.delegate = self;
	hud.labelText = label;
	[hud showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:hud animated:YES];
}
- (void)showDlg:(UIView *)view withLabelAnnularDeterminate:(NSString *) label {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.mode = MBProgressHUDModeAnnularDeterminate;
	hud.delegate = self;
	hud.labelText = label;
	[hud showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:hud animated:YES];
}
- (void)showDlgWithLabelDeterminateHorizontalBar:(UIView *) view  {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
	hud.delegate = self;
	[hud showWhileExecuting:@selector(myProgressTask:) onTarget:self withObject:hud animated:YES];
}
- (void)showDlg:(UIView *) view withImage:(NSString *) imgName withLabel:(NSString *) label {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
	hud.mode = MBProgressHUDModeCustomView;
	hud.delegate = self;
	hud.labelText = label;
	[hud show:YES];
	[hud hide:YES afterDelay:2];
}
- (void)showDldLabelMixed:(UIView *) view {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.delegate = self;
	hud.labelText = @"Connecting";
	hud.minSize = CGSizeMake(135.f, 135.f);
	[hud showWhileExecuting:@selector(myMixedTask:) onTarget:self withObject:hud animated:YES];
}
- (void)showDlg:(UIView *) view usingBlocks:(NSString *)label {
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.labelText = label;
	[hud showAnimated:YES whileExecutingBlock:^{
		[self myTask];
	} completionBlock:^{
		[hud removeFromSuperview];
	}];
#endif
}
- (void)showDlg:(UIView *) view onWindow:(NSString *) label {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view.window];
	[view.window addSubview:hud];
	hud.delegate = self;
	hud.labelText = label;
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)showDlg:(UIView *) view witgURL:(NSString *) url {
	NSURL *URL = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection start];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.delegate = self;
}
- (void)showDlgWithGradient:(UIView *) view {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.dimBackground = YES;
	hud.delegate = self;
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)showDlg:(UIView *) view textOnly:(NSString *) label {
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = label;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1];
}
- (void)showDlg:(UIView *) view withColor:(UIColor *) color {
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];
	hud.color = color;
	hud.delegate = self;
	[hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
#pragma mark -
#pragma mark Execution code
- (void)myTask {
	sleep(1);
}
- (void)myProgressTask:(MBProgressHUD *) hud {
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		hud.progress = progress;
		usleep(50000);
	}
}
- (void)myMixedTask:(MBProgressHUD *) hud {
	sleep(2);
	hud.mode = MBProgressHUDModeDeterminate;
	hud.labelText = @"Progress";
	float progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		hud.progress = progress;
		usleep(50000);
	}
	hud.mode = MBProgressHUDModeIndeterminate;
	hud.labelText = @"Cleaning up";
	sleep(2);
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = @"Completed";
	sleep(2);
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[hud removeFromSuperview];
	hud = nil;
}
@end
