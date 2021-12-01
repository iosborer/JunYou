#import <UIKit/UIKit.h>
#import "JLFacePackgeModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface JLMyFacePackgeCell : UICollectionViewCell
@property(nonatomic, strong) JLFacePackgeModel *model;
@property (nonatomic, copy) void (^JLMyFacePackgeCellDeleteCallBack)(NSString *faceName);
@end
NS_ASSUME_NONNULL_END
