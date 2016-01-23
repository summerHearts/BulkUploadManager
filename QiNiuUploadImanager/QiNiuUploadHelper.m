//
//  SMKQiNiuUploadHelper.m
//  QiNiuManager
//
//  Created by 佐毅 on 16/1/20.
//  Copyright © 2016年 上海乐住信息技术有限公司. All rights reserved.
//


#import "QiNiuUploadHelper.h"
static QiNiuUploadHelper *_sharedInstance ;

@implementation QiNiuUploadHelper

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[QiNiuUploadHelper alloc] init];
    });
    return _sharedInstance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _sharedInstance;
}


+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
        
    });
    return _sharedInstance;
}


@end
