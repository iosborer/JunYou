#import <UIKit/UIKit.h>
#import "DepartObject.h"
@interface OrganizTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView * arrowView;
@property (nonatomic) BOOL arrowExpand;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *additionButton;
@property (nonatomic, strong) UILabel *noticeLab;
@property (strong, nonatomic) DepartObject *organizObject;
@property (nonatomic, copy) void (^additionButtonTapAction)(id sender);
@property (nonatomic, copy) void (^noticeLabTapAction)(DepartObject *dataObj);
- (void)setupWithData:(DepartObject *)dataObj level:(NSInteger)level expand:(BOOL)expand;
@end
