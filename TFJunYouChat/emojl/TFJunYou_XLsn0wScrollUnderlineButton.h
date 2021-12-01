#import <UIKit/UIKit.h>
typedef void(^ScrollUnderlineButtonBlock)(NSUInteger selectedIndex);
@interface TFJunYou_XLsn0wScrollUnderlineButton : UIView
@property (nonatomic, copy) ScrollUnderlineButtonBlock scrollUnderlineButtonBlock;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) UIEdgeInsets lineEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets cursorEdgeInsets;
-(void)reloadData;
@end
@interface TFJunYou_XLsn0wScrollUnderlineButtonCell : UICollectionViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIFont *normalFont;
@end
