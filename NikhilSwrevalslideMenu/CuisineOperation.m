//
//  CuisineOperation.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 16/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "CuisineOperation.h"
#import "constant.h"

@implementation CuisineOperation

-(NSDictionary *) dictionary {
    return @{
             kParamNameAddress  : self.AddressCityState,
             
             
             
             };
}




-(void)callAPIWithParamter:(id)parameter success:(successBlock)sucess failure:(failedBlock)failure
{
    //    [[APIClient shared]GET:kServiceNameLogin parameters:[self dictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"%@",[self dictionary]);
    [[APIClient shared] GET:kServiceNameCuisine parameters:[self dictionary]success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
        [self validateAPIResponseWithData:responseObject success:sucess failure:failure];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
        
        [self validateAPIResponseWithData:responseObject success:sucess failure:failure];
    }];
    
}
-(void)parseData:(id)responseData success:(successBlock)success
{
    if (success) {
        success(true, responseData);
    }
}

@end
