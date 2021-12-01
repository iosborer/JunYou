#import <UIKit/UIKit.h>
#import "JLFacePackgeModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface JLFacePackgeViewCell : UICollectionViewCell
@property(nonatomic, strong) NSString *path;
@property(nonatomic, strong) JLFacePackgeModel *model;
@property(nonatomic, assign) BOOL isSelectedImageHidden;
@property (nonatomic, copy) void (^JLFacePackgeViewCellCallBack)(NSString *idString, BOOL isSelected);
@end
NS_ASSUME_NONNULL_END
