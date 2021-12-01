#import "TFJunYou_admobViewController.h"
@class DepartObject;
@protocol SelDepartDelegate <NSObject>
-(void)selNewDepartmentWith:(DepartObject *)newDepart;
@end
@interface TFJunYou_SelDepartViewController : TFJunYou_admobViewController
@property (nonatomic, strong) DepartObject * oldDepart;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, weak) id delegate;
@end
