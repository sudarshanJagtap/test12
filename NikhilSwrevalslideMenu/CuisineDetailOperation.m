//
//  CuisineDetailOperation.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/24/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "CuisineDetailOperation.h"
#import "constant.h"
#import "RequestUtility.h"
@implementation CuisineDetailOperation
@synthesize selectedId;
-(NSDictionary *) dictionary {
  return @{
           @"rest_id"  : [RequestUtility sharedRequestUtility].selectedUfrespo.ufp_id,
           
           
           
           };
}




-(void)callAPIWithParamter:(id)parameter success:(successBlock)sucess failure:(failedBlock)failure
{
  //    [[APIClient shared]GET:kServiceNameLogin parameters:[self dictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
  NSLog(@"%@",[self dictionary]);
  [[APIClient shared] GET:@"rest_menu.php" parameters:[self dictionary]success:^(NSURLSessionDataTask *task, id responseObject) {
    
    if ([responseObject valueForKey:@"category_list"]){
       sucess(true, responseObject);
    }
    
//    [self validateAPIResponseWithData:responseObject success:sucess failure:failure];
    
    
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

@implementation CuisineDetailResponse


@end
