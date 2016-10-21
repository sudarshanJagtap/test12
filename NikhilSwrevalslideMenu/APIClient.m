
//
//  MvelopeAPIClient.m
//  RestKitFinicity
//
//  Created by Vinayak Vanjari on 8/4/14.
//  Copyright (c) 2014 Finicity Org. All rights reserved.
//

#import "APIClient.h"
#import <AFNetworking/AFNetworking.h>
#import "AFXMLRequestSerializer.h"
#import "Constant.h"         //declare  constant header file 
#import "AppConstant.h"
  
//static NSString *kTraktBaseURLString = @"http://ymoc.mobisofttech.co.in/android_api/";
//static NSString *kTraktBaseURLString = @"http://mailer.mobisofttech.co.in/ymoc_portal_dev_latest/android_api/";          /// righting the base url here



@implementation APIClient

#pragma mark - init
+(instancetype) shared {
    
    static APIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseMain_url]];
        
    });
    return _sharedClient;
    
}

/**
 *  This is internal shared xml client object. We must maintain a different instance of API Client all together 
 *  for all the APIs that require XML body string
 *
 *  No outside class should call this shared client, only member methods that accept xml body should use this instance
 **/
+(instancetype) sharedXMLClient {
    static APIClient *_sharedXMLClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        _sharedXMLClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseMain_url]];
        _sharedXMLClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedXMLClient.requestSerializer = [AFXMLRequestSerializer serializer]; // This is our custom made serializer which accepts xml data
    });
      return _sharedXMLClient;
}


- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    return self;
}

#pragma mark - generic HTTP methods
-(NSURLSessionDataTask *) GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(APISuccessBlock)success
                      failure:(APIFailureBlock)failure {
       NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
   
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {

        id responseDictionary;
        
        NSError *err;
      if (responseObject!=nil) {
        responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&err];
      }else{
      success(task, responseDictionary);
      }
      

        if (error) {
            if (failure) {
                failure(task, error, responseDictionary);
            }
        } else {
            if (success) {
                success(task, responseDictionary);
           }
        }
    }];
    
    [task resume];
    
    return task;
}




-(NSURLSessionDataTask *) POST:(NSString *)URLString parameters:(id)parameters success:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        
        id responseDictionary;
       
        NSError *err;
        if (responseObject) {
        responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:kNilOptions
                                                                       error:&err];
        }
       

        if (error) {
            if (failure) {
                failure(task, error, responseDictionary);
            }
        } else {
            if (success) {
                success(task, responseDictionary);
            }
        }
    }];
    
    [task resume];
    
    return task;
    
    
}

-(NSURLSessionDataTask *) PUT:(NSString *)URLString parameters:(id)parameters success:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
       
        id responseDictionary = responseObject;

        if (error) {
            if (failure) {
                failure(task, error, responseDictionary);
            }
        } else {
            if (success) {
                success(task, responseDictionary);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

-(NSURLSessionDataTask *) xmlPOST:(NSString *)URLString parameters:(id)parameters success:(APISuccessBlock)success failure:(APIFailureBlock)failure {
    
    APIClient *xmlClient = [[self class] sharedXMLClient];
    
    NSURLSessionDataTask *task = [xmlClient POST:URLString parameters:parameters success:success failure:failure];
    
    return task;
    
}

@end
