#import <Foundation/Foundation.h>
#import "HBHttpImageDownloaderOperation.h"
@interface HBHttpImageDownloader : NSObject
+(HBHttpImageDownloader*) shareDownlader;
-(void) downBitmapWithURL:(NSString*)url
                                         process:(HBHttpImageDownloaderProcessBlock)process
                                        complete:(HBHttpImageDownloaderCompleteBlock)complete
                                          option:(HBHttpImageDownloaderOption)option
                                     valueReturn:(void(^)(id<HBHttpOperationDelegate>)) value;
-(void) downBitmapWithIndirectURL:(NSString *)url
                          process:(HBHttpImageDownloaderProcessBlock)process
                         complete:(HBHttpImageDownloaderCompleteBlock)complete
                           option:(HBHttpImageDownloaderOption)option
                      valueReturn:(void(^)(id<HBHttpOperationDelegate>)) value;
@end
