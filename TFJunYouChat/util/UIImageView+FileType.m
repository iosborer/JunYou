#import "UIImageView+FileType.h"
@implementation UIImageView (FileType)
-(void)setFileType:(NSInteger)fileType{
    NSString * imageStr = nil;
    switch (fileType) {
        case 1://图片
            imageStr = @"picturefile";
            break;
        case 2:
            imageStr = @"music";
            break;
        case 3:
            imageStr = @"video";
            break;
        case 4:
            imageStr = @"ppt";
            break;
        case 5:
            imageStr = @"excel";
            break;
        case 6:
            imageStr = @"word";
            break;
        case 7:
            imageStr = @"zip";
            break;
        case 8:
            imageStr = @"txt";
            break;
        case 9:
            imageStr = @"unkown";
            break;
        case 10:
            imageStr = @"pdf";
            break;
        default:
            imageStr = @"unkown";
            break;
    }
    self.image = [UIImage imageNamed:imageStr];
}
@end
