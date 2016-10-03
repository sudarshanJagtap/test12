//
//  MvelopeAPIClient.h
//  RestKitFinicity
//
//  Created by Vinayak Vanjari on 8/4/14.
//  Copyright (c) 2014 Finicity Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>





/**
 *   Extending AFHTTPSessionManager, we'll maintain one API session in entire app.
 *   *IMP NOTE* : We Are Maintaining a different API session for APIs Which Require XML as POST Body parameter
 *
 *   Also, AFHTTPSessionManager Class dose not return response data in case of error/ failure in API. 
 *   We want the response data object for description of the error and errorMessage.
 *   Hence, this class copies implementation of GET,POST,PUT to achive above purpose
 *
 *   Also, this class converts XML response data into JSON dictionary with help of OFXMLMapper while returning success and failure blocks
 **/

@interface APIClient : AFHTTPSessionManager

typedef void (^APISuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^APIFailureBlock)(NSURLSessionDataTask *task, NSError *error, id responseObject);

/** 
 * Singleton Class 
 **/
+(instancetype) shared;

#pragma mark - Generic Methods
-(NSURLSessionDataTask *) GET:(NSString *)URLString parameters:(id)parameters success:(APISuccessBlock)success failure:(APIFailureBlock)failure;



-(NSURLSessionDataTask *) POST:(NSString *)URLString parameters:(id)parameters success:(APISuccessBlock)success failure:(APIFailureBlock)failure;

-(NSURLSessionDataTask *) PUT:(NSString *)URLString parameters:(id)parameters success:(APISuccessBlock)success failure:(APIFailureBlock)failure;

#pragma mark - Generic XML Methods
/**
 *  This method expects parameters to be XML String, which will be added to POST Body
 **/
-(NSURLSessionDataTask *) xmlPOST:(NSString *)URLString parameters:(id)parameters success:(APISuccessBlock)success failure:(APIFailureBlock)failure;

@end
