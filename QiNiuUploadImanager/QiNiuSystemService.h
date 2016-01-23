//
//  SMKSystemService.h
//  QiNiuManager
//
//  Created by 佐毅 on 16/1/20.
//  Copyright © 2016年 上海乐住信息技术有限公司. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QiniuSDK.h"

@interface QiNiuSystemService : NSObject

/**
 *  上传图片
 *
 *  @param image    需要上传的image
 *  @param progress 上传进度block
 *  @param success  成功block 返回url地址
 *  @param failure  失败block
 */
+ (void)uploadImage:(UIImage *)image
           progress:(QNUpProgressHandler)progress
            success:(void (^)(NSString *url))success
            failure:(void (^)())failure;

/**
 *   上传多张图片,按队列依次上传
 *
 *  @param imageArray 存放image的数字
 *  @param progress   上传到七牛的进度
 *  @param success    成功block  返回key
 *  @param failure    失败block
 */
+ (void)uploadImages:(NSArray *)imageArray
            progress:(void (^)(CGFloat))progress
             success:(void (^)(NSArray *))success
             failure:(void (^)())failure;

/**
 *  获取七牛上传token
 *
 *  @param success 成功block  返回token
 *  @param failure 失败block
 */
+ (void)getQiniuUploadToken:(void (^)(NSString *token))success failure:(void (^)())failure;

/**
 *  获取七牛上传成功的key
 *
 *  @param key     上传成功之后返回图片对应的key
 *  @param success 成功block 返回url地址
 *  @param failure 失败block
 */
+ (void)getQiniuUrlkey:(NSString *)key success:(void (^)(NSString *url))success failure:(void (^)())failure;

/**
 *  获取七牛上传成功的成功后服务端返回的url
 *
 *  @param keyArray 上传成功之后返回图片对应的key数组
 *  @param success  成功block 返回url地址数组
 *  @param failure  失败block
 */
+ (void)getQiniuUrlKeyArray:(NSArray *)keyArray success:(void (^)(NSArray *array))success failure:(void (^)())failure;


/**
 *  将图片压缩为需要的比例
 *
 *  @param  image 需要处理的图片
 *  @param  size  图片返回大小
 *
 *  @return image
 */
+(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

@end
