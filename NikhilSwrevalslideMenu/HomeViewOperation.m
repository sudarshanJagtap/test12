//
//  HomeViewOperation.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 15/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "HomeViewOperation.h"
#import "constant.h"

@implementation HomeViewOperation

-(NSDictionary *) dictionary {
    
// return @{@"rating":@"no",@"feature":@"open_now_status", @"address":@"",@"all_cuisine":@"andhra",@"sorting":@"no",@"delivery_status":@"no",@"action1":@"search"};
    
    return @{
             kParamNameFilter  : self.AddressCityState,
             
             };
}


-(void)callAPIWithParamter:(id)parameter success:(successBlock)sucess failure:(failedBlock)failure
{
  NSLog(@"%@",[self dictionary]);
  
    
        [[APIClient shared]POST:kServiceNameDirectryURL parameters:[self dictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
    
//    [[APIClient shared] GET:kServiceNameLogin parameters:[self dictionary]success:^(NSURLSessionDataTask *task, id responseObject) {
//        
    
        
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
