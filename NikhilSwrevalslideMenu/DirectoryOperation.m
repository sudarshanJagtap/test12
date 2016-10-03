//
//  DirectoryOperation.m
//  Socyto
//
//  Created by Sunny Gupta on 23/03/16.
//  Copyright © 2016 Sunny Gupta. All rights reserved.
//

#import "DirectoryOperation.h"

@implementation DirectoryOperation
-(void)callAPIWithParamter:(id)parameter success:(successBlock)sucess failure:(failedBlock)failure
{
    [[APIClient shared]POST:kServiceNameDirectory parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
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
