//
//  BaseOpeartion.h
//  Unicorn
//
//  Created by Vishnu Gupta on 17/12/15.
//  Copyright (c) 2015 Vishnu Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"
#import "APIResponseCode.h"
#import "Constant.h"


typedef void (^successBlock)(BOOL success, id response);
typedef void (^failedBlock)(BOOL failed,NSString *errorMessage);

@interface BaseOpeartion : NSObject
@property (assign)BOOL blnShowAlertMsg;
-(void)callAPIWithParamter:(id)parameter success:(successBlock)sucess failure:(failedBlock)failure;
-(void)validateAPIResponseWithData:(id)responseData success:(successBlock)success failure:(failedBlock)failure;
-(void)parseData:(id)responseData success:(successBlock)success;
-(void)parseNoData:(id)responseData success:(successBlock)success;
@end
