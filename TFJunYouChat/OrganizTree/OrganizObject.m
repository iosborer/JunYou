#import "OrganizObject.h"
#import "TFJunYou_UserObject.h"
@implementation OrganizObject
-(id)initWithDict:(NSDictionary *)nodeDict
{
    self = [super init];
    if (self) {
        if (nodeDict[@"nickname"] != nil)
            self.nodeName = nodeDict[@"nickname"];
        if (nodeDict[@"userId"] != nil)
            self.userId = nodeDict[@"userId"];
    }
    return self;
}
-(void)setChildren:(NSArray *)children{
    if ([children[0] isKindOfClass:[OrganizObject class]]) {
        _children = children;
        return;
    }
    NSMutableArray *childArray = [NSMutableArray array];
    for (NSDictionary * childDict in children) {
        OrganizObject * organiz = [OrganizObject organizObjectWithDict:childDict];
        [childArray addObject:organiz];
    }
    _children = [NSArray arrayWithArray:childArray];
}
+(id)organizObjectWithDict:(NSDictionary *)nodeDict
{
    return [[self alloc] initWithDict:nodeDict];
}
- (void)addChild:(id)child
{
    NSMutableArray *children = [self.children mutableCopy];
    [children insertObject:child atIndex:0];
    _children = [children copy];
}
- (void)removeChild:(id)child
{
    NSMutableArray *children = [self.children mutableCopy];
    [children removeObject:child];
    _children = [children copy];
}
@end
