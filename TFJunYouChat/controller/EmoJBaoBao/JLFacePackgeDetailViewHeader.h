#import <UIKit/UIKit.h>
#import "JLFacePackgeModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface JLFacePackgeDetailViewHeader : UICollectionReusableView
@property (nonatomic, strong) JLFacePackgeModel *model;
@property (nonatomic, copy) void (^JLFacePackgeDetailViewAddCallBack)();
@end
NS_ASSUME_NONNULL_END
