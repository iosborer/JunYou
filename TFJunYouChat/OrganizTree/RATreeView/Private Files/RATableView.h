#import <UIKit/UIKit.h>
@interface RATableView : UITableView
@property (nonatomic, nullable, weak) id<UITableViewDelegate> tableViewDelegate;
@property (nonatomic, nullable, weak) id<UIScrollViewDelegate> scrollViewDelegate;
@end
