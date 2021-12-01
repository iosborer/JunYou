#import "TFJunYou_admobViewController.h"
@protocol VisibelDelegate <NSObject>
-(void)seeVisibel:(int)visibel userArray:(NSArray *)userArray selLabelsArray:(NSMutableArray *)selLabelsArray mailListArray:(NSMutableArray *)mailListArray;
@end
@interface WhoCanSeeViewController : TFJunYou_admobViewController
@property (nonatomic,weak) id<VisibelDelegate> visibelDelegate;
@property (nonatomic,assign) int type;
@property (nonatomic, strong) NSMutableArray *selLabelsArray;
@property (nonatomic, strong) NSMutableArray *mailListUserArray;
@end
