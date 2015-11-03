//
//  MFNetWorkTool.m
//  Text3
//
//  Created by apple on 15/10/18.
//  Copyright © 2015年 apple. All rights reserved.
//

#define kboundary @"boundary"
#import "MFNetWorkTool.h"

@implementation MFNetWorkTool

-(void)sendPOSTRequestWithTransmitMorePictureWithURL:(NSString *)urlString andPathDict:(NSDictionary *)pathDict andUserFile:(NSString *)userFile andParamater:(NSDictionary *)paramater andSuccess:(isSuccess)success andfail:(isfail)fail{
    
//    NSMutableString *str = [NSMutableString stringWithString:urlString];
//    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *headerStr = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kboundary];
    [request setValue:headerStr forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = [self getHTTPBodyWithPathDict:pathDict andUserFile:userFile andParamater:paramater];
    
    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
//        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if (data && !error) {
            success(data, response);
        } else {
            fail(error);
        }
        
    }]resume];
    
}

//传多文件获取data
-(NSData *)getHTTPBodyWithPathDict:(NSDictionary *)pathDict andUserFile:(NSString *)userFile andParamater:(NSDictionary *)paramater{
    
    NSMutableData *data = [NSMutableData data];
    
    [pathDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *fileName = obj;
        NSString *filePath = key;
        
        NSMutableString *str = [NSMutableString stringWithFormat:@"--%@\r\n", kboundary];
        [str appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", userFile, fileName];
        [str appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
        
        [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *pathStr = [NSString stringWithFormat:@"%@", filePath];
        NSData *fileData = [pathStr dataUsingEncoding:NSUTF8StringEncoding];
        [data appendData:fileData];
    }];
    
    [paramater enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *nameKey = key;
        NSString *value = obj;
        
        NSMutableString *str = [NSMutableString stringWithFormat:@"\r\n--%@\r\n", kboundary];
        [str appendFormat:@"Content-Disposition: form-data; name=%@", nameKey];
        [str appendFormat:@"%@", value];
        [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *footerStr = [NSString stringWithFormat:@"\r\n--%@--", kboundary];
        [data appendData:[footerStr dataUsingEncoding:NSUTF8StringEncoding]];
        
    }];
    
    return data;
    
}

//上传文件
-(void)sendPOSTRequestWithTransmitPictureWithURL:(NSString *)urlString andFilePath:(NSString *)filePath andUserFile:(NSString *)userfile andFileName:(NSString *)fileName{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *type = [NSString stringWithFormat:@"	multipart/form-data; boundary=%@", kboundary];
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"--%@\r\n", kboundary];
    [str appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", userfile, fileName];
    NSURLResponse *response = [[MFNetWorkTool shareNetWorkTool] getResponseWithFilepath:filePath];
    [str appendFormat:@"Content-Type: %@\r\n\r\n", response.MIMEType];
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *fileStr = [NSString stringWithFormat:@"%@", filePath];
    NSData *fileData = [fileStr dataUsingEncoding:NSUTF8StringEncoding];
    [data appendData:fileData];
    
    NSMutableString *strM = [NSMutableString stringWithFormat:@"\r\n--%@--", kboundary];
    NSData *dataM = [strM dataUsingEncoding:NSUTF8StringEncoding];
    [data appendData:dataM];
//    NSData *data1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", data1);
//    request.HTTPBody = data;
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    }];
    

    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }] resume];
}

//发送一个普通请求 返回参数
-(void)sendPOSTRequestWithUrlString:(NSString *)urlString andParamater:(NSDictionary *)paramater isSuccess:(isSuccess)isSuccess isfail:(isfail)isFail{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSMutableString *strM = [NSMutableString stringWithFormat:@""];
    [paramater enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *nameKey = key;
        NSString *nameValue = obj;
        [strM appendString:[NSString stringWithFormat:@"%@=%@&", nameKey, nameValue]];
    }];
    [strM deleteCharactersInRange:NSMakeRange(strM.length - 1, 1)];
    NSData *data = [strM dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            if (isSuccess) {
                isSuccess(data, response);
            }
        } else {
            if (isFail) {
                isFail(error);
            }
        }
        
    }] resume];
    
}

//获取请求体内容
-(NSData *)getHTTPBodyWithFilepath:(NSString *)filePath andFileKey:(NSString *)fileKey andDidFileName:(NSString *)nameString{
    
    NSURLResponse *response = [[MFNetWorkTool shareNetWorkTool] getResponseWithFilepath:filePath];
    
    if (!nameString) {
        nameString = response.suggestedFilename;
    }
    NSString *contentType = response.MIMEType;
    NSMutableString *str = [NSMutableString stringWithFormat:@"--%@\r\n", kboundary];
    [str appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", fileKey, nameString];
    [str appendFormat:@"Content-Type: %@\r\n\r\n", contentType];
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *strFile = [NSString stringWithFormat:@"%@", filePath];
    NSData *fileData = [strFile dataUsingEncoding:NSUTF8StringEncoding];
    [data appendData:fileData];
    
    NSString *footer = [NSString stringWithFormat:@"\r\n--%@--", kboundary];
    [data appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}

//传入一个路径，返回response
-(NSURLResponse *)getResponseWithFilepath:(NSString *)filePath{
    
    NSString *stringRes = [NSString stringWithFormat:@"file://%@", filePath];
    NSURL *url = [NSURL URLWithString:[stringRes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    
    return response;
}

+(instancetype)shareNetWorkTool{
    static id _instance;
    static dispatch_once_t onceToKen;
    dispatch_once(&onceToKen, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
