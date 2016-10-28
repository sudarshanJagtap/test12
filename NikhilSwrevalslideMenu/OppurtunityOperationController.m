//
//  OppurtunityOperationController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "OppurtunityOperationController.h"
#import "AppConstant.h"

@implementation OppurtunityOperationController
-(void)callAPIWithParamter:(id)parameter success:(successBlock)sucess failure:(failedBlock)failure
{
    [[APIClient shared] POST:kInvestMentOppurtunity parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        [self validateAPIResponseWithData:responseObject success:sucess failure:failure];
    } failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    }];
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
