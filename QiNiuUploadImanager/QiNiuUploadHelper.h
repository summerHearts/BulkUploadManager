//
//  SMKQiNiuUploadHelper.h
//  QiNiuManager
//
//  Created by 佐毅 on 16/1/20.
//  Copyright © 2016年 上海乐住信息技术有限公司. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface QiNiuUploadHelper : NSObject

/**
 *  成功回调
 */
@property (copy, nonatomic) void (^singleSuccessBlock)(NSString *);

/**
 *  失败回调
 */
@property (copy, nonatomic) void (^singleFailureBlock)();

+ (instancetype)sharedInstance;
@end
