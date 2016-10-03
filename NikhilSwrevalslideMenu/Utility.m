
//
//  Utility.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/28/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "Utility.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation Utility

- (NSString *)GetOurIpAddress
{
  NSString *address = @"error";
  struct ifaddrs *interfaces = NULL;
  struct ifaddrs *temp_addr = NULL;
  int success = 0;
  success = getifaddrs(&interfaces);
  if (success == 0) {
    temp_addr = interfaces;
    while(temp_addr != NULL) {
      if(temp_addr->ifa_addr->sa_family == AF_INET) {
        if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
          address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
        }
      }
      temp_addr = temp_addr->ifa_next;
    }
  }
  freeifaddrs(interfaces);
  return address;
}

-(NSString*)getCurrentDate{
  NSDate *todayDate = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
  NSLog(@"Today formatted date is %@",convertedDateString);
  return convertedDateString;
}

-(NSString*)getCurrentAsapDate{
  NSDate *todayDate = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"dd-MM-yy"];
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

-(NSString *)getRandomPINString
{
  NSMutableString *returnString = [NSMutableString stringWithCapacity:10];
  
  NSString *numbers = @"0123456789";
  
  // First number cannot be 0
  [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
  
  for (int i = 1; i < 10; i++)
  {
    [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
  }
  
  return returnString;
}

@end
