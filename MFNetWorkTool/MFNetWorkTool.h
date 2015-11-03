//
//  MFNetWorkTool.h
//  Text3
//
//  Created by apple on 15/10/18.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^isSuccess)(NSData *data, NSURLResponse *response);
typedef void(^isfail)(NSError *error);

@interface MFNetWorkTool : NSObject

+(instancetype)shareNetWorkTool;

-(NSURLResponse *)getResponseWithFilepath:(NSString *)filePath;

-(NSData *)getHTTPBodyWithFilepath:(NSString *)filePath andFileKey:(NSString *)fileKey andDidFileName:(NSString *)nameString;

-(void)sendPOSTRequestWithUrlString:(NSString *)urlString andParamater:(NSDictionary *)paramater isSuccess:(isSuccess)isSuccess isfail:(isfail)isFail;

-(void)sendPOSTRequestWithTransmitPictureWithURL:(NSString *)urlString andFilePath:(NSString *)filePath andUserFile:(NSString *)userfile andFileName:(NSString *)fileName;

-(NSData *)getHTTPBodyWithPathDict:(NSDictionary *)pathDict andUserFile:(NSString *)userFile andParamater:(NSDictionary *)paramater;

-(void)sendPOSTRequestWithTransmitMorePictureWithURL:(NSString *)urlString andPathDict:(NSDictionary *)pathDict andUserFile:(NSString *)userFile andParamater:(NSDictionary *)paramater andSuccess:(isSuccess)success andfail:(isfail)fail;
@end
