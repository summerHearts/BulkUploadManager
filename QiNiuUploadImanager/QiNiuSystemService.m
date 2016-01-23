//
//  SMKSystemService.m
//  QiNiuManager
//
//  Created by 佐毅 on 16/1/20.
//  Copyright © 2016年 上海乐住信息技术有限公司. All rights reserved.
//


#import "QiNiuSystemService.h"
#import "QiNiuUploadHelper.h"
#import "QiniuSDK.h"


@implementation QiNiuSystemService

+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure
{
    [QiNiuSystemService getQiniuUploadToken:^(NSString *token) {
        
        UIImage *sizedImage = [QiNiuSystemService OriginImage:image scaleToSize:CGSizeMake(1000, 1000) ];
        NSData *data = UIImageJPEGRepresentation(sizedImage, 0.3);
        if (!data) {
            if (failure) {
                failure();
            }
            return;
        }
        
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
        QNUploadManager *uploadManager = [[QNUploadManager alloc]initWithRecorder:nil];
        [uploadManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode == 200 && resp) {
                NSString *url;
                    url = [NSString stringWithFormat:@"%@%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], resp[@"key"]];
               
                if (success) {
                    success(url);
                }
            }
            else {
                if (failure) {
                    failure();
                }
            }
        } option:opt];
    } failure:^{
        if (failure) {
            failure();
        }
    }];
}

//上传图片
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block float totalProgress = 0.0f;
    __block float partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    QiNiuUploadHelper *uploadHelper = [QiNiuUploadHelper sharedInstance];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            [QiNiuSystemService uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }
    };

    [QiNiuSystemService uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}

//获取七牛的token
+ (void)getQiniuUploadToken:(void (^)(NSString *))success failure:(void (^)())failure{
//    [HotelRequest  requestHotelPicwindinfoManager:[HttpRequest requestOperationManager]
//                                          success:^(id responseObject) {
//                                            NSString * token = [NSString stringWithFormat:@"%@",responseObject[@"picwindinfo"]];
//                                              if (success) {
//                                                  success(token);
//                                              }
//                 
//    } failure:^(NSOperation *operation, NSError *error) {
//        if (failure) {
//            failure();
//        }
//    }];
}
// 获取七牛上传成功的key

+ (void)getQiniuUrlkey:(NSString *)key success:(void (^)(NSString *url))success failure:(void (^)())failure{

//    [HotelRequest requestHotelSubjectPicPathChangeWithPicpath:key
//                                                      manager:[HttpRequest requestOperationManager]
//                                                      success:^(id responseObject) {
//                                                          
//                                                          NSString *picUrl = responseObject[@"picurl"];
//                                                          if (success) {
//                                                              success(picUrl);
//                                                          }
//                                                       
//                                                      } failure:^(NSOperation *operation, NSError *error) {
//                                                          if (failure) {
//                                                              failure();
//                                                          }
//                                                      }];
}

// 获取七牛上传成功的成功后服务端返回的url
+ (void)getQiniuUrlKeyArray:(NSArray *)keyArray success:(void (^)(NSArray *array))success failure:(void (^)())failure{
    NSMutableArray *UrlArray = [[NSMutableArray alloc] init];
    
    __block NSUInteger currentIndex = 0;
    QiNiuUploadHelper *uploadHelper = [QiNiuUploadHelper sharedInstance];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [UrlArray addObject:url];
        currentIndex++;
        if ([UrlArray count] == [keyArray count]) {
            success([UrlArray copy]);
            return;
        }
        else {
            [QiNiuSystemService getQiniuUrlkey:url success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }
    };
    
    [QiNiuSystemService getQiniuUrlkey:keyArray[0] success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}
//压缩上传图片的大小比例
+ (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

@end
