#import <Foundation/Foundation.h>
#define HBHttpImageDownloadStartNotification @"HBHttpImageDownloadStartNotification"
#define HBHttpImageDownloadStopNotification  @"HBHttpImageDownloadStopNotification"
typedef void(^HBHttpImageDownloaderProcessBlock)(NSUInteger,long long);
typedef void(^HBHttpImageDownloaderCompleteBlock)(UIImage*,NSData*,NSError*,BOOL);
typedef void(^HBHttpImageDownloaderCancelBlock)();
typedef enum {
    HBHttpImageDownloaderOptionRetry=1<<0,
    HBHttpImageDownloaderOptionLowPriority=1<<1,
    HBHttpImageDownloaderOptionUseCache=1<<3,
    HBHttpImageDownloaderOptionProgressiveDownload=1<<4
}HBHttpImageDownloaderOption;
@protocol HBHttpOperationDelegate <NSObject>
-(void) cancel;
@end
@interface HBHttpImageDownloaderOperation : NSOperation<HBHttpOperationDelegate>{
    BOOL _finished;
    BOOL _concurrent;
}
@property (nonatomic,readonly) NSURLRequest * request;
@property (nonatomic,readonly) HBHttpImageDownloaderOption option;
-(id)initWithURL:(NSURL*)url
         options:(HBHttpImageDownloaderOption)option
         process:(HBHttpImageDownloaderProcessBlock)process
        complete:(HBHttpImageDownloaderCompleteBlock)complete
          cancel:(void(^)())cancel;
-(void)retry;
@end
