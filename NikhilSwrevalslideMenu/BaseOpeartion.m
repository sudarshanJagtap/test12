//
//  BaseOpeartion.m
//  Unicorn
//
//  Created by Vishnu Gupta on 17/12/15.
//  Copyright (c) 2015 Vishnu Gupta. All rights reserved.
//
#import "BaseOpeartion.h"
#import "CommonAlertViewController.h"

@implementation BaseOpeartion
-(void)callAPIWithParamter:(id)parameter success:(successBlock)sucess failure:(failedBlock)failure;
{
    //// method to be overridden in subclass class
}
//-(void)validateAPIResponseWithData:(id)responseData success:(successBlock)success failure:(failedBlock)failure
//{
//    if (responseData)
//    {
//        if ([[responseData valueForKey:@"code"] isEqualToString:kResponseCodeSucess])
//        {
//            [self parseData:responseData success:success];
//            if (self.blnShowAlertMsg)
//            {
//                if ([responseData valueForKey:@"message"]) {
//                    [self showErrorAlertWithMessage:[responseData valueForKey:@"message"] failure:nil];
//                }else if([responseData valueForKey:@"status"])
//                {
//                    [self showErrorAlertWithMessage:[responseData valueForKey:@"status"] failure:nil];
//                }
//                
//                
//                
//            }
//            
//        }
//        else if ([[responseData valueForKey:@"code"] isEqualToString:@"2"] && [[responseData valueForKey:@"flag"] isEqualToString:@"Unavailable"] && [[responseData valueForKey:@"status"] isEqualToString:@"success"])
//        {
//            [self parseData:responseData success:success];
//            if (self.blnShowAlertMsg)
//            {
//                
//            }
//        }
//        
//        else
//        {
//            [self showErrorAlertWithMessage:[responseData valueForKey:@"message"] failure:failure];
//        }
//    }
//    else{
//        [self showErrorAlertWithMessage:[responseData valueForKey:@"message"] failure:failure];
//
//
//    }
//}
-(void)showErrorAlertWithMessage:(NSString *)errorMessage failure:(failedBlock)failure
{
    
    if (!errorMessage)
    {
        errorMessage = kErrorMessage;
        
    }
    [CommonAlertViewController showAlertDialogueWithMessage:errorMessage andTitle:nil fromController:nil];
    if (failure)
    {
        failure(FALSE,errorMessage);
    }
}
-(void)parseData:(id)responseData success:(successBlock)success
{
     //// method to be overridden in subclass class
}

-(void)parseNoData:(id)responseData success:(successBlock)success{

}

-(void)validateAPIResponseWithData:(id)responseData success:(successBlock)success failure:(failedBlock)failure
{
    if (responseData)
    {
        if ([[responseData valueForKey:@"code"] isEqualToString:@"1"])
        {
            [self parseData:responseData success:success];
            if (true) //to display the alert message we create
            {
//                [self showErrorAlertWithMessage:[responseData valueForKey:@"status"] failure:nil];
                
            }
            
        }
        else
        {
          [self parseNoData:responseData success:success];
//            [self showErrorAlertWithMessage:[responseData valueForKey:@"status"] failure:failure];
        }
    }
    else{
      [self parseNoData:responseData success:success];
//        [self showErrorAlertWithMessage:[responseData valueForKey:@"status"] failure:failure];
      
        
    }
}
@end
