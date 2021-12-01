//
//  JLFacePackgeModel.h
//  TFJunYouChat
//
//  Created by JayLuo on 2019/12/10.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLFacePackgeModel : NSObject

@property (nonatomic , assign) NSInteger              clollectNumber;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , copy) NSString              * desc;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , assign) NSInteger              modifyTime;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * faceName;
@property (nonatomic , copy) NSString              * faceId;
@property (nonatomic , assign) NSInteger              number;
@property (nonatomic , copy) NSArray              * path;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , assign) NSInteger              type;

@end

NS_ASSUME_NONNULL_END
