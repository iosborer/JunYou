@interface DepartObject : NSObject
@property (nonatomic,copy) NSString * departName;
@property (nonatomic,copy) NSString * departId;
@property (copy, nonatomic) NSString * parentId;
@property (copy, nonatomic) NSString * companyId;
@property (nonatomic,copy) NSString * createUserId;
@property (nonatomic,assign) NSInteger empNum;
@property (nonatomic, strong) NSString *noticeContent;
@property (nonatomic,strong) NSArray * employees;
@property (nonatomic,strong) NSArray * departes;
@property (strong, nonatomic) NSArray *children;
+(instancetype)departmentObjectWith:(NSDictionary *)nodeDict allData:(NSMutableArray *)allDict;
- (void)addChild:(id)child;
- (void)removeChild:(id)child;
@end
