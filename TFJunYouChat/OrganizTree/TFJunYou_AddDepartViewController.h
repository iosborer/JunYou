#import "TFJunYou_admobViewController.h"
typedef enum {
    OrganizAddCompany = 1,
    OrganizAddDepartment = 2,
    OrganizUpdateDepartmentName = 3,
    OrganizSearchCompany = 4,
    OrganizUpdateCompanyName = 5,
    OrganizModifyEmployeePosition = 6,
} OrganizAddType;
@protocol AddDepartDelegate <NSObject>
-(void)inputDelegateType:(OrganizAddType)organizType text:(NSString *)updateStr;
@end
@interface TFJunYou_AddDepartViewController : TFJunYou_admobViewController
@property (weak,nonatomic) id <AddDepartDelegate> delegate;
@property (assign,nonatomic) OrganizAddType type;
@property (copy,nonatomic) NSString * oldName;
@end
