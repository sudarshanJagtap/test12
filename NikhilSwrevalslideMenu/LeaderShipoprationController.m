//
//  LeaderShipoprationController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "LeaderShipoprationController.h"
#import "AppDelegate.h"

@implementation LeaderShipoprationController
-(void)callAPIWithParamter:(id)parameter success:(successBlock)sucess failure:(failedBlock)failure
{
  /*  [[APIClient shared] POST:kLeaderShip parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        [self validateAPIResponseWithData:responseObject success:sucess failure:failure];
    } failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    }];*/
}
-(void)parseData:(id)responseData success:(successBlock)success
{
    // [UserDetailController saveDataIntoUserDetail:responseData];
    if (success)
    {
        
        success(true,responseData);
    }
}

@end
