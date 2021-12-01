#import <UIKit/UIKit.h>
@class TFJunYou_TransferNoticeModel;
@interface TFJunYou_TransferNoticeCell : UITableViewCell
- (void)setDataWithMsg:(TFJunYou_MessageObject *)msg model:(id)tModel;
+ (float)getChatCellHeight:(TFJunYou_MessageObject *)msg;
@end
