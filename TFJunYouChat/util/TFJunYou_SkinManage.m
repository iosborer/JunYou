#import "TFJunYou_SkinManage.h"
#import "UIImage+Tint.h"
SkinDictKey const SkinDictKeyName    = @"skinName";
SkinDictKey const SkinDictKeyColor   = @"skinColor";
SkinDictKey const SkinDictKeyIndex   = @"skinIndex";
static TFJunYou_SkinManage * _shareInstance = nil;
@interface TFJunYou_SkinManage ()
@property (nonatomic, strong) UIImage *navImage;
@end
@implementation TFJunYou_SkinManage
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[TFJunYou_SkinManage alloc] init];
    });
    return _shareInstance;
}
-(instancetype)init{
    if (self = [super init]) {
        [self makeThemeList];
        NSNumber * current = [g_default objectForKey:SkinDictKeyIndex];
        if (current == nil) {
            [g_default setObject:[NSNumber numberWithUnsignedInteger:SkinType_CobaltPaleGreen] forKey:SkinDictKeyIndex];
            [g_default synchronize];
            current = [NSNumber numberWithUnsignedInteger:SkinType_CobaltPaleGreen];
        }
        NSDictionary * skinDict = [self searchSkinByIndex:[current unsignedIntegerValue]];
        if(skinDict){
            _themeName = skinDict[SkinDictKeyName];
            _themeColor = skinDict[SkinDictKeyColor];
            _themeIndex = [skinDict[SkinDictKeyIndex] unsignedIntegerValue];
        }
    }
    return self;
}
-(void)makeThemeList{
    NSMutableArray * skinList = [NSMutableArray array];
    [skinList addObject:[self makeASkin:@"浅豆绿" color:HEXCOLOR(0x61D999) index:SkinType_PeaGreen]];
    [skinList addObject:[self makeASkin:@"清水蓝" color:HEXCOLOR(0x80BFFF) index:SkinType_ClearBlue]];
    [skinList addObject:[self makeASkin:@"珊瑚红" color:HEXCOLOR(0xFF8080) index:SkinType_CoralRed]];
    [skinList addObject:[self makeASkin:@"流霞粉" color:HEXCOLOR(0xFFA5C9) index:SkinType_NephelinePowder]];
    [skinList addObject:[self makeASkin:Localized(@"JX_Theme_ViridianGreen") color:HEXCOLOR(0x55BEB7) index:SkinType_CobaltPaleGreen]];
    [skinList addObject:[self makeASkin:@"葡萄紫" color:HEXCOLOR(0x6C53AB) index:SkinType_DarkPurple]];
    [skinList addObject:[self makeASkin:@"商务蓝" color:HEXCOLOR(0x3B5699) index:SkinType_BusinessBlue]];
    [skinList addObject:[self makeASkin:@"经典红" color:HEXCOLOR(0xfd504e) index:SkinType_ComposedRed]];
    NSMutableArray * skinNameList = [NSMutableArray array];
    for (NSDictionary * skinDict in skinList) {
        [skinNameList addObject:skinDict[SkinDictKeyName]];
    }
    _skinNameList = skinNameList;
    _skinList = skinList;
}
-(NSDictionary *)makeASkin:(NSString *)name color:(UIColor *)color index:(SkinType)skinType{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:name forKey:SkinDictKeyName];
    [dict setObject:color forKey:SkinDictKeyColor];
    [dict setObject:[NSNumber numberWithUnsignedInteger:skinType] forKey:SkinDictKeyIndex];
    return dict;
}
-(NSDictionary *)searchSkinByIndex:(NSInteger)index{
    for (int i = 0; i<_skinList.count; i++) {
        NSDictionary * skinDict = _skinList[i];
        if ([skinDict[SkinDictKeyIndex] unsignedIntegerValue] == index) {
            return skinDict;
        }
    }
    return nil;
}
-(void)switchSkinIndex:(NSUInteger)index{
    NSDictionary * skinDict = [self searchSkinByIndex:index];
    if(skinDict){
        _themeName = skinDict[SkinDictKeyName];
        _themeColor = skinDict[SkinDictKeyColor];
        _themeIndex = [skinDict[SkinDictKeyIndex] unsignedIntegerValue];
        self.navImage = nil;
        [g_default setObject:[NSNumber numberWithUnsignedInteger:_themeIndex] forKey:SkinDictKeyIndex];
        [g_default synchronize];
    }
}
-(UIImage *)themeImage:(NSString *)imageName{
    NSString * imageStr = [imageName copy];
    if ([imageName rangeOfString:@"@2x"].location != NSNotFound) {
        imageStr = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    }else if ([imageName rangeOfString:@"@3x"].location != NSNotFound){
        imageStr = [imageName stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
    }
    if(_themeIndex != 0){
        imageStr = [NSString stringWithFormat:@"%@_%tu",imageStr,_themeIndex];
    }
    UIImage * img = [UIImage imageNamed:imageStr];
    if (img) {
        return img;
    }else{
        return [UIImage imageNamed:imageName];
    }
}
-(NSString *)themeImageName:(NSString *)imageName{
    NSString * imageStr;
    if ([imageName rangeOfString:@"@2x"].location != NSNotFound) {
        imageStr = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    }else if ([imageName rangeOfString:@"@3x"].location != NSNotFound){
        imageStr = [imageName stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
    }
    imageStr = [NSString stringWithFormat:@"%@_%tu",imageStr,_themeIndex];
    return imageStr;
}
-(UIImage *)themeTintImage:(NSString *)imageName{
    if ([imageName isEqualToString:@"navBarBackground"] && self.navImage) {
        return self.navImage;
    }else {
        UIImage * tintImage = [[UIImage imageNamed:imageName] imageWithTintColor:self.themeColor];
        if ([imageName isEqualToString:@"navBarBackground"] && !self.navImage) {
            self.navImage = tintImage;
        }
        return tintImage;
    }
}
-(void)resetInstence{
    _shareInstance = [self init];
}
@end
