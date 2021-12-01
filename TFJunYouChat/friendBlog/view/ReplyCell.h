#import <UIKit/UIKit.h>
#import "HBCoreLabel.h"
@interface ReplyCell : UITableViewCell
@property(nonatomic,retain) HBCoreLabel * label;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property(nonatomic,assign) int pointIndex;
@end
