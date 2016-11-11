//
//  RequestUtility.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/27/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "RequestUtility.h"
#import "ResponseUtility.h"
#import "Reachability.h"
#import "AppConstant.h"
@implementation RequestUtility
+ (RequestUtility *)sharedRequestUtility {
  __strong static RequestUtility *httpRequestUtility = nil;
  static dispatch_once_t onceToken1;
  dispatch_once(&onceToken1, ^{
    httpRequestUtility = [[self alloc] init];
  });
  return httpRequestUtility;
}

- (id)init
{
  self = [super init];
  if (self) {
    self.min_order_amount = @"no";
    self.ratings = 0;
    self.delivery_status = 0;
    self.sorting = @"no";
    self.isAsap = NO;
    self.selectedFeaturesArray = [[NSMutableArray alloc]init];
    self.selectedCusinesArray = [[NSMutableArray alloc]init];
    [self.selectedFeaturesArray addObject:@"open_now_status"];
    self.selectedAddressId = @"-1";
    self.isThroughGuestUser = NO;
  }
  return self;
}

-(void)doGetRequestfor:(NSString*)url withParameters:(NSDictionary*)params onComplete:(void (^)(bool status, NSDictionary  *response))completionBlock{
  
  url = [NSString stringWithFormat:@"%@%@",kBaseMain_url,url];
  
  if ([self isNetworkAvailable]) {
    NSURL *URL = [NSURL URLWithString:url];
    NSURLSessionConfiguration *configuration;
    configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.discretionary = NO;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:URL];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request1 completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
      if (data.length>0) {
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n\n The reponse from server is : %@ \n\n", responseString);
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&error];
        //if ([[responseDictionary valueForKey:kstatusparam] isEqualToString:ksuccessparam]) {
        completionBlock(YES,responseDictionary);
        //}else{
        //completionBlock(NO,responseDictionary);
        //}
      }else{
        NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc]init];
        [responseDictionary setValue:@"The request timed out" forKey:@"error"];
        completionBlock(NO,responseDictionary);
      }
    }];
    [task resume];
  }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkConnectivity"
                                                        object:nil];
  }
}


-(void)doPostRequestfor:(NSString*)url withParameters:(NSDictionary*)params onComplete:(void (^)(bool status,
                                                                                                 NSDictionary  *response))completionBlock{
  
  url = [NSString stringWithFormat:@"%@%@",kBaseMain_url,url];
  if ([self isNetworkAvailable]) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.discretionary = NO;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    if (params.count>0) {
      NSArray *key = [params allKeys];
      NSArray *values = [params allValues];
      NSMutableString *postData = [[NSMutableString alloc]init];
      for (int i =0; i<[key count]; i++) {
        NSString *str =[NSString stringWithFormat:@"%@=%@&",[key objectAtIndex:i],[values objectAtIndex:i]];
        [postData appendString:str];
      }
      postData = (NSMutableString*)[postData substringToIndex:[postData length]-1];
      NSData* data=[postData dataUsingEncoding:NSUTF8StringEncoding];
      [request setHTTPBody:data];
    }
    else{
      
    }
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (data.length>0) {
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n\n The reponse from server is : %@ \n\n", responseString);
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&error];
        completionBlock(YES,responseDictionary);
        
      }else{
        NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc]init];
        [responseDictionary setValue:@"The request timed out" forKey:@"error"];
        completionBlock(NO,responseDictionary);
      }
    }];
    
    [postDataTask resume];
  }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkConnectivity"
                                                        object:nil];
  }
}

- (BOOL)isNetworkAvailable
{
  //  CFNetDiagnosticRef dReference;
  //  dReference = CFNetDiagnosticCreateWithURL (kCFAllocatorDefault, (__bridge CFURLRef)[NSURL URLWithString:@"www.apple.com"]);
  //  CFNetDiagnosticStatus status;
  //  status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
  //  CFRelease (dReference);
  //  if ( status == kCFNetDiagnosticConnectionUp )
  //  {
  //    NSLog (@"Connection is Available");
  //    return YES;
  //  }
  //  else
  //  {
  //    NSLog (@"Connection is down");
  //    return NO;
  //  }
  BOOL retval = NO;
  Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
  NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
  if (networkStatus == NotReachable) {
    NSLog(@"There IS NO internet connection");
    retval = NO;
  } else {
    NSLog(@"There IS internet connection");
    retval = YES;
  }
  return retval;
}

-(NSString*)getFeaturNamefromSelectedTag:(int)SelectedTag{
  switch (SelectedTag) {
    case 0:
    return @"open_now_status";
    break;
    case 1:
    return @"free_delivery";
    break;
    case 2:
    return @"customize_food";
    break;
    
    default:
    return @"open_now_status";
    break;
  }
}

-(NSString*)getDisplayFeature:(NSString*)key{
  NSString *retval;
  if ([key isEqualToString:@"open_now_status"]) {
    retval = @"Open Now";
  }
  if ([key isEqualToString:@"free_delivery"]) {
    retval = @"Free Delivery";
  }
  if ([key isEqualToString:@"customize_food"]) {
    retval = @"Customize Menu";
  }
  return retval;
}

-(NSString*)getMinimumOrderAmountfromRating:(int)rating{
  switch (rating) {
    case 0:
    return @"10";
    break;
    case 1:
    return @"100";
    break;
    case 2:
    return @"1000";
    break;
    case 3:
    return @"10000";
    break;
    case 4:
    return @"100000";
    break;
    
    default:
    return @"no";
    break;
  }
}

-(NSString*)getSortingKeyfromIndex:(int)index{
  switch (index) {
    case 0:
    return @" ";
    break;
    case 1:
    return @"order by ri.name asc";
    break;
    case 2:
    return @"order by rai.min_order_amount asc";
    break;
    case 3:
    return @"order by rai.min_order_amount desc";
    break;
    case 4:
    return @"order by rai.rating desc";
    break;
    case 5:
    return @"order by rai.delivery_time asc";
    break;
    case 6:
    return @"order by rdf.fee asc";
    break;
    default:
    return @"";
    break;
  }
}

-(NSDictionary*)getParamsForUserFilters{
  //  NSString *pp= [[NSMutableString alloc]init];
  //  NSString *str1 = [NSString stringWithFormat:@"{\"rating\":%d,",self.ratings];
  //  NSString *str2 = [NSString stringWithFormat:@"\"feature\":\"%@\",",[self.selectedFeaturesArray componentsJoinedByString:@","]];
  //  NSString *str3 = [NSString stringWithFormat:@"\"address\":\"%@\",",[ResponseUtility getSharedInstance].enteredAddress];
  //  NSString *str4 = [NSString stringWithFormat:@"\"all_cuisine\":\"%@\",",[self.selectedCusinesArray componentsJoinedByString:@","]];
  //  NSString *str5 = [NSString stringWithFormat:@"\"sorting\":\"%@\",",self.sorting];
  //  NSString *str6 = [NSString stringWithFormat:@"\"delivery_status\":\"%d\",",self.delivery_status];
  //
  //  NSString *str8 = [NSString stringWithFormat:@"\"min_order_amount\":\"%@\",",self.min_order_amount];
  //  NSString *str7 = [NSString stringWithFormat:@"\"action1\":\"%@\"}",@"search"];
  //  pp = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",str1,str2,str3,str4,str5,str6,str8,str7];
  //  NSDictionary *paramsValue = [[NSDictionary alloc]initWithObjectsAndKeys:pp,@"filter_val", nil];
  
  //  NSLog(@"%@",paramsValue);
  
  //  return paramsValue;
  if ([RequestUtility sharedRequestUtility].isAsap) {
    return [self getParamsForAsapUserFilters];
  }else{
    return [self getParamsForNormalUserFilters];
  }
  
}

-(NSDictionary*)getParamsForNormalUserFilters{
  NSString *pp= [[NSMutableString alloc]init];
  NSString *str1 = [NSString stringWithFormat:@"{\"rating\":%d,",self.ratings];
  NSString *str2 = [NSString stringWithFormat:@"\"feature\":\"%@\",",[self.selectedFeaturesArray componentsJoinedByString:@","]];
  NSString *str3 = [NSString stringWithFormat:@"\"address\":\"%@\",",[ResponseUtility getSharedInstance].enteredAddress];
  NSString *str4 = [NSString stringWithFormat:@"\"all_cuisine\":\"%@\",",[self.selectedCusinesArray componentsJoinedByString:@","]];
  NSString *str5 = [NSString stringWithFormat:@"\"sorting\":\"%@\",",self.sorting];
  NSString *str6 = [NSString stringWithFormat:@"\"delivery_status\":\"%d\",",self.delivery_status];
  
  NSString *str8 = [NSString stringWithFormat:@"\"min_order_amount\":\"%@\",",self.min_order_amount];
  NSString *str7 = [NSString stringWithFormat:@"\"action1\":\"%@\"}",@"search"];
  pp = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",str1,str2,str3,str4,str5,str6,str8,str7];
  NSDictionary *paramsValue = [[NSDictionary alloc]initWithObjectsAndKeys:pp,@"filter_val", nil];
  
  //  NSLog(@"%@",paramsValue);
  
  return paramsValue;
  
}

-(NSDictionary*)getParamsForAsapUserFilters{
  NSString *pp= [[NSMutableString alloc]init];
  NSString *str1 = [NSString stringWithFormat:@"{\"rating\":%d,",self.ratings];
  NSString *str2 = [NSString stringWithFormat:@"\"feature\":\"%@\",",[self.selectedFeaturesArray componentsJoinedByString:@","]];
  NSString *str3 = [NSString stringWithFormat:@"\"address\":\"%@\",",[ResponseUtility getSharedInstance].enteredAddress];
  NSString *str4 = [NSString stringWithFormat:@"\"all_cuisine\":\"%@\",",[self.selectedCusinesArray componentsJoinedByString:@","]];
  NSString *str5 = [NSString stringWithFormat:@"\"sorting\":\"%@\",",self.sorting];
  NSString *str6 = [NSString stringWithFormat:@"\"delivery_status\":\"%d\",",self.delivery_status];
  
  NSString *str8 = [NSString stringWithFormat:@"\"min_order_amount\":\"%@\",",self.min_order_amount];
  NSString *str9 = [NSString stringWithFormat:@"\"schedule_date\":\"%@\",",[RequestUtility sharedRequestUtility].asapSchedule_date];
  NSString *str10 = [NSString stringWithFormat:@"\"schedule_time\":\"%@\",",[RequestUtility sharedRequestUtility].asapSchedule_time];
  NSString *str7 = [NSString stringWithFormat:@"\"action1\":\"%@\"}",@"search"];
  
  pp = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",str1,str2,str3,str4,str5,str6,str8,str9,str10,str7];
  NSDictionary *paramsValue = [[NSDictionary alloc]initWithObjectsAndKeys:pp,@"filter_val", nil];
  
  //  NSLog(@"%@",paramsValue);
  return paramsValue;
}

-(NSString*)getCurrentDate{
  NSDate *todayDate = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
  NSLog(@"Today formatted date is %@",convertedDateString);
  return convertedDateString;
}

-(NSString*)getCurrentTime{
  NSDate *now = [NSDate date];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"hh:mm";
  [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
  NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
  return [dateFormatter stringFromDate:now];
}


-(void)doYMOCPostRequestfor:(NSString*)url withParameters:(NSDictionary*)params onComplete:(void (^)(bool status, NSDictionary  *response))completionBlock{
  
  url = [NSString stringWithFormat:@"%@%@",kBaseMain_url,url];
  if ([self isNetworkAvailable]) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.discretionary = NO;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    if (params.count>0) {
      NSArray *key = [params allKeys];
      NSArray *values = [params allValues];
      NSMutableString *postData = [[NSMutableString alloc]init];
      for (int i =0; i<[key count]; i++) {
        //        NSString *str =[NSString stringWithFormat:@"%@=%@&",[key objectAtIndex:i],[values objectAtIndex:i]];
        //        [postData appendString:str];
        NSString *str =[NSString stringWithFormat:@"\"%@\":\"%@\",",[key objectAtIndex:i],[values objectAtIndex:i]];
        [postData appendString:str];
      }
      postData = (NSMutableString*)[postData substringToIndex:[postData length]-1];
      postData = (NSMutableString*)[NSString stringWithFormat:@"{%@}",postData];
      NSData* data=[postData dataUsingEncoding:NSUTF8StringEncoding];
      [request setHTTPBody:data];
    }
    else{
      
    }
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (data.length>0) {
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n\n The reponse from server is : %@ \n\n", responseString);
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&error];
        completionBlock(YES,responseDictionary);
        
      }else{
        NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc]init];
        [responseDictionary setValue:@"The request timed out" forKey:@"error"];
        completionBlock(NO,responseDictionary);
      }
    }];
    
    [postDataTask resume];
  }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkConnectivity"
                                                        object:nil];
  }
}


-(void)doYMOCStringPostRequest:(NSString*)url withParameters:(NSString*)params onComplete:(void (^)(bool status, NSDictionary  *response))completionBlock{
  
  url = [NSString stringWithFormat:@"%@%@",kBaseMain_url,url];
  if ([self isNetworkAvailable]) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.discretionary = NO;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    if (params.length>0) {
      //      NSArray *key = [params allKeys];
      //      NSArray *values = [params allValues];
      //      NSMutableString *postData = [[NSMutableString alloc]init];
      //      for (int i =0; i<[key count]; i++) {
      //        //        NSString *str =[NSString stringWithFormat:@"%@=%@&",[key objectAtIndex:i],[values objectAtIndex:i]];
      //        //        [postData appendString:str];
      //        NSString *str =[NSString stringWithFormat:@"\"%@\":\"%@\",",[key objectAtIndex:i],[values objectAtIndex:i]];
      //        [postData appendString:str];
      //      }
      //      postData = (NSMutableString*)[postData substringToIndex:[postData length]-1];
      //      postData = (NSMutableString*)[NSString stringWithFormat:@"{%@}",postData];
      NSData* data=[params dataUsingEncoding:NSUTF8StringEncoding];
      [request setHTTPBody:data];
    }
    else{
      
    }
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (data.length>0) {
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n\n The reponse from server is : %@ \n\n", responseString);
        self.afterPaymentResponseString = responseString;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&error];
        completionBlock(YES,responseDictionary);
        
      }else{
        NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc]init];
        [responseDictionary setValue:@"The request timed out" forKey:@"error"];
        completionBlock(NO,responseDictionary);
      }
    }];
    
    [postDataTask resume];
  }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkConnectivity"
                                                        object:nil];
  }
}
@end

@implementation AddtoCartData

@end

@implementation cart_data

@end

@implementation customization

@end

@implementation AllRestoCartData

@end
