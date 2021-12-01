#import <UIKit/UIKit.h>
@class TFJunYou_RecordModel;
NS_ASSUME_NONNULL_BEGIN
@interface TFJunYou_RecordCell : UITableViewCell
@property (nonatomic, strong) UIView *lineView;
- (void)setData:(TFJunYou_RecordModel *)model;
@end
NS_ASSUME_NONNULL_END
