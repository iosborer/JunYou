#import "UIImageView+HBHttpCache.h"
#import "UIImage+HBClass.h"
#import "HBHttpRequestCache.h"
@implementation UIImageView (HBHttpCache)
static char operationKey='a';
#pragma -mark 私有方法
-(void)cancel
{
    id<HBHttpOperationDelegate> operation=objc_getAssociatedObject(self, &operationKey);
    if(operation){
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
#pragma -mark 接口方法
-(void) setImageWithURL:(NSString*)url
{
    [self setImageWithURL:url layout:UIImageViewLayoutNone placeholderImage:nil process:nil complete:nil option:HBHttpImageDownloaderOptionUseCache|HBHttpImageDownloaderOptionRetry];
}
-(void) setImageWithURL:(NSString*)url
                 layout:(UIImageViewLayoutType)layout
{
    [self setImageWithURL:url layout:layout placeholderImage:nil process:nil complete:nil option:HBHttpImageDownloaderOptionUseCache|HBHttpImageDownloaderOptionRetry];
}
-(void) setImageWithURL:(NSString *)url
                 layout:(UIImageViewLayoutType)layout
       placeholderImage:(UIImage*)placeholderImage
{
      [self setImageWithURL:url layout:layout placeholderImage:placeholderImage process:nil complete:nil option:HBHttpImageDownloaderOptionUseCache|HBHttpImageDownloaderOptionRetry];
}
-(void) setImageWithURL:(NSString *)url
                 layout:(UIImageViewLayoutType)layout
       placeholderImage:(UIImage*)placeholderImage
                process:(HBHttpImageDownloaderProcessBlock) process
               complete:(HBHttpImageDownloaderCompleteBlock)complete
{
    [self setImageWithURL:url layout:layout placeholderImage:placeholderImage process:process complete:complete option:HBHttpImageDownloaderOptionUseCache|HBHttpImageDownloaderOptionRetry];
}
-(void) setImageWithURL:(NSString *)url
                 layout:(UIImageViewLayoutType)layout
       placeholderImage:(UIImage*)placeholderImage
                process:(HBHttpImageDownloaderProcessBlock)process
               complete:(HBHttpImageDownloaderCompleteBlock)complete
                 option:(HBHttpImageDownloaderOption)option
{
    self.image=placeholderImage;
    __block void(^block)(UIImage*);
    void(^download)()=^{
        [self cancel];
            [[HBHttpImageDownloader shareDownlader] downBitmapWithURL:url process:process complete:^(UIImage *image, NSData *data, NSError *error, BOOL success){
            if(block){
                block(image);
            }
            if(complete){
                if([NSThread isMainThread]){
                    if(complete){
                        complete(image,data,error,success);
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(complete){
                            complete(image,data,error,success);
                        }
                    });
                }
            }
        } option:option valueReturn:^(id<HBHttpOperationDelegate> operation) {
            objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
    };
    __weak UIImageView * wself=self;        
    if(layout==UIImageViewLayoutNone){
        block=^(UIImage * image){
            if(!wself) return;
            __strong UIImageView * sself=wself;         
            if([NSThread isMainThread]){
                sself.image=image;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    sself.image=image;
                });
            }
        };
        download(); 
    }else if(layout==UIImageViewLayoutLimit){
        NSMutableString * key=[NSMutableString stringWithString:url];
        [key appendFormat:@".limit"];
        block=^(UIImage * image){
            if(image){
                if(!wself) return;
                __strong UIImageView * sself=wself;
                UIImage * limitimage=[image getLimitImage:sself.frame.size];
                if([NSThread isMainThread]){
                    CGRect frame=sself.frame;
                    frame.size=limitimage.size;
                    sself.frame=frame;
                    sself.image=limitimage;
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CGRect frame=sself.frame;
                        frame.size=limitimage.size;
                        sself.frame=frame;
                        sself.image=limitimage;
                    });
                }if(option&HBHttpImageDownloaderOptionUseCache){
                    [[HBHttpRequestCache shareCache] storeBitmap:limitimage withKey:key complete:nil];
                }
            }
        };
        if(option&HBHttpImageDownloaderOptionUseCache){
            [[HBHttpRequestCache shareCache] getBitmap:key complete:^(UIImage *image) {
                if(!wself) return;
                __strong UIImageView * sself=wself;
                if(image){
                    CGRect frame=sself.frame;
                    frame.size=image.size;
                    sself.frame=frame;
                    sself.image=image;
                    if(complete){
                         complete(image,nil,nil,YES);
                    }
                }else{
                    download();
                }
            }];
        }else{
            download();
        }
    }else if(layout==UIImageViewLayoutClick){
        NSMutableString * key=[NSMutableString stringWithString:url];
        [key appendFormat:@".click"];
        block=^(UIImage * image){
            if(!wself) return;
            __strong UIImageView * sself=wself;
            if(image){
                UIImage * clickimage=[image getClickImage:sself.frame.size];
                if([NSThread isMainThread]){
                    sself.image=clickimage;
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sself.image=clickimage;
                    });
                }if(option&HBHttpImageDownloaderOptionUseCache){
                    [[HBHttpRequestCache shareCache] storeBitmap:clickimage withKey:key complete:nil];
                }
            }
        };
        if(option&HBHttpImageDownloaderOptionUseCache){
            [[HBHttpRequestCache shareCache] getBitmap:key complete:^(UIImage *image) {
                if(!wself) return;
                __strong UIImageView * sself=wself;
                if(image){
                    sself.image=image;
                    if(complete){
                        complete(image,nil,nil,YES);
                    }
                }else{
                    download();
                }
            }];
        }else{
            download();
        }
    }
 }
-(void) setImageWithIndirectURL:(NSString *)indirectURL
{
    [self setImageWithURL:indirectURL layout:UIImageViewLayoutNone placeholderImage:nil process:nil complete:nil option:HBHttpImageDownloaderOptionRetry|HBHttpImageDownloaderOptionUseCache];
}
-(void) setImageWithIndirectURL:(NSString *)indirectURL
                         layout:(UIImageViewLayoutType)layout
{
    [self setImageWithURL:indirectURL layout:layout placeholderImage:nil process:nil complete:nil option:HBHttpImageDownloaderOptionRetry|HBHttpImageDownloaderOptionUseCache];
}
-(void) setImageWithIndirectURL:(NSString *)indirectURL
                         layout:(UIImageViewLayoutType)layout
               placeholderImage:(UIImage *)placeholderImage
{
     [self setImageWithURL:indirectURL layout:layout placeholderImage:placeholderImage process:nil complete:nil option:HBHttpImageDownloaderOptionRetry|HBHttpImageDownloaderOptionUseCache];
}
-(void) setImageWithIndirectURL:(NSString *)indirectURL
                         layout:(UIImageViewLayoutType)layout
               placeholderImage:(UIImage *)placeholderImage
                        process:(HBHttpImageDownloaderProcessBlock)process
                       complete:(HBHttpImageDownloaderCompleteBlock)complete
{
    [self setImageWithURL:indirectURL layout:layout placeholderImage:placeholderImage process:process complete:complete option:HBHttpImageDownloaderOptionRetry|HBHttpImageDownloaderOptionUseCache];
}
-(void) setImageWithIndirectURL:(NSString *)indirectURL
                         layout:(UIImageViewLayoutType)layout
               placeholderImage:(UIImage *)placeholderImage
                        process:(HBHttpImageDownloaderProcessBlock)process
                       complete:(HBHttpImageDownloaderCompleteBlock)complete
                         option:(HBHttpImageDownloaderOption)option
{
    self.image=placeholderImage;
    __block void(^block)(UIImage*);
    void(^download)()=^{
        [self cancel];
        [[HBHttpImageDownloader shareDownlader] downBitmapWithIndirectURL:indirectURL process:process complete:^(UIImage * image, NSData * data, NSError * error, BOOL  success) {
            if(block){
                block(image);
            }
            if(complete){
                complete(image,data,error,success);
            }
        } option:option valueReturn:^(id<HBHttpOperationDelegate> operation) {
            objc_setAssociatedObject(self, &operationKey, operation,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
    };
    __weak UIImageView * wself=self;             
    if(layout==UIImageViewLayoutNone){
        block=^(UIImage * image){
            if(!wself) return;
            __strong UIImageView * sself=wself;          
            if([NSThread isMainThread]){
                sself.image=image;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    sself.image=image;
                });
            }
        };
        download();
    }else if(layout==UIImageViewLayoutLimit){
        NSMutableString * key=[NSMutableString stringWithString:indirectURL];
        [key appendFormat:@".limit"];
        block=^(UIImage * image){
            if(!wself) return;
            __strong UIImageView * sself=wself;
            if(image){
                UIImage * limitimage=[image getLimitImage:sself.frame.size];
                if([NSThread isMainThread]){
                    CGRect frame=sself.frame;
                    frame.size=limitimage.size;
                    sself.frame=frame;
                    sself.image=limitimage;
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CGRect frame=sself.frame;
                        frame.size=limitimage.size;
                        sself.frame=frame;
                        sself.image=limitimage;
                    });
                }if(option&HBHttpImageDownloaderOptionUseCache){
                    [[HBHttpRequestCache shareCache] storeBitmap:limitimage withKey:key complete:nil];
                }
            }
        };
        if(option&HBHttpImageDownloaderOptionUseCache){
                [[HBHttpRequestCache shareCache] getBitmap:key complete:^(UIImage *image) {
                if(!wself) return;
                __strong UIImageView * sself=wself;
                if(image){
                    CGRect frame=sself.frame;
                    frame.size=image.size;
                    sself.frame=frame;
                    sself.image=image;
                    if(complete){
                        complete(image,nil,nil,YES);
                    }
                }else{
                    download();
                }
            }];
        }else{
            download();
        }
    }else if(layout==UIImageViewLayoutClick){
        NSMutableString * key=[NSMutableString stringWithString:indirectURL];
        [key appendFormat:@".click"];
        block=^(UIImage * image){
            if(!wself) return;
            __strong UIImageView * sself=wself;
            if(image){
                UIImage * clickimage=[image getClickImage:sself.frame.size];
                if([NSThread isMainThread]){
                    sself.image=clickimage;
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sself.image=clickimage;
                    });
                }if(option&HBHttpImageDownloaderOptionUseCache){
                    [[HBHttpRequestCache shareCache] storeBitmap:clickimage withKey:key complete:nil];
                }
            }
        };
        if(option&HBHttpImageDownloaderOptionUseCache){
            [[HBHttpRequestCache shareCache] getBitmap:key complete:^(UIImage *image) {
                if(!wself) return;
                __strong UIImageView * sself=wself;
                if(image){
                    sself.image=image;
                    if(complete){
                        complete(image,nil,nil,YES);
                    }
                }else{
                    download();
                }
            }];
        }else{
            download();
        }
    }
}
-(void) setImageWithCacheKey:(NSString *)key layout:(UIImageViewLayoutType)layout
                                   placeholderImage:(UIImage *)placeholderImage
{
    NSMutableString * Key=[NSMutableString stringWithString:key];
    if(layout==UIImageViewLayoutLimit){
        [Key appendFormat:@".limit"];
    }else if(layout==UIImageViewLayoutClick){
        [Key appendFormat:@".click"];
    }
    UIImage * image=[[HBHttpRequestCache shareCache] getBitmapFromMemory:Key];
    if(image){
        self.image=image;
        if(layout==UIImageViewLayoutLimit){
            CGRect frame=self.frame;
            frame.size=image.size;
            self.frame=frame;
        }
    }else{
        self.image=placeholderImage;
    }
}
@end
