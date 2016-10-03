//
//  FilterOperations.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/21/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "FilterOperations.h"
#import "constant.h"
#import "RequestUtility.h"
@interface FilterOperations(){
  NSDictionary *params;
}

@end

@implementation FilterOperations

+(FilterOperations*)getSharedInstance{
  __strong static FilterOperations *sharedFilterOperations = nil;
  static dispatch_once_t onceToken1;
  dispatch_once(&onceToken1, ^{
    
    sharedFilterOperations = [[self alloc] init];
    
  });
  return sharedFilterOperations;
}

- (id)init
{
  self = [super init];
  if (self) {
    self.min_order_amount = @"no";
    self.ratings = 0;
    self.delivery_status = 0;
    self.sorting = @"no";
    self.selectedFeaturesArray = [[NSMutableArray alloc]init];
    self.selectedCusinesArray = [[NSMutableArray alloc]init];
    [self.selectedFeaturesArray addObject:@"open_now_status"];
  }
  return self;
}

-(void)callAPIWithParamter:(id)parameter success:(successBlock)sucess failure:(failedBlock)failure
{
  
  if ([RequestUtility sharedRequestUtility].isAsap) {
    NSLog(@"the params for the url are %@",parameter);
//    http://mailer.mobisofttech.co.in/ymoc_portal_dev_latest/android_api/schedule_user_filter.php
//    http://ymoc.mobisofttech.co.in/android_api/schedule_user_filter.php
    [[APIClient shared] GET:@"http://mailer.mobisofttech.co.in/ymoc_portal_dev_latest/android_api/schedule_user_filter.php" parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
      NSLog(@"the response for the url are %@",responseObject);
      [self validateAPIResponseWithData:responseObject success:sucess failure:failure];
      
    } failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
      
      [self validateAPIResponseWithData:responseObject success:sucess failure:failure];
      
    }];
  }else{
  NSLog(@"the params for the url are %@",parameter);
  
  [[APIClient shared] GET:kServiceNameDirectryURL parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
    NSLog(@"the response for the url are %@",responseObject);
    [self validateAPIResponseWithData:responseObject success:sucess failure:failure];
    
  } failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
    
    [self validateAPIResponseWithData:responseObject success:sucess failure:failure];
    
  }];
  }
}

-(void)parseData:(id)responseData success:(successBlock)success
{
  if (success) {
    success(true, responseData);
  }
}

-(void)parseNoData:(id)responseData success:(successBlock)success;
{
  if (success) {
    success(true, nil);
  }
}

@end















