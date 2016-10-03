
//
//  Validation.m
//  ClubEliteMainStoryBoard
//
//  Created by Ganesh Kulpe on 13/06/13.
//  Copyright (c) 2013 Ganesh Kulpe. All rights reserved.
//


#define ACCEPTABLE_CHARECTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#import "Validation.h"

@implementation Validation
+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)validateLenghtOfStringWithString:(NSString *)string greaterThanlength:(int)greaterThanlength lessThanlength:(int)lessThanlength
{
    if ([string length] > greaterThanlength && [string length] < lessThanlength)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL)compareStringWithString:(NSString *)firstString second:(NSString *)secondString
{
    if ([firstString isEqualToString:secondString])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL)allowStringWithNumberOnly:(NSString *)string
{
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![myCharSet characterIsMember:c])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

+ (BOOL)dontAllowSpecialCharacter:(NSString *)string
{
    NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS];
    
    if (![[string componentsSeparatedByCharactersInSet:acceptedInput] count] > 1)
        return NO;
    else
        return YES;
}
+ (BOOL)allowOnlySingleDecimalPoints:(NSString *)string
{
    NSArray *sep = [string componentsSeparatedByString:@"."];
    if([sep count] >= 2)
    {
        NSString *sepStr=[NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
        return !([sepStr length]>1);
    }
    return YES;
}
+ (BOOL)checkFiledIsNotEmpty:(NSString *)string
{
    if ([string length] <= 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
+(BOOL)validateEnterString:(NSString *)string FromGivenRegex:(NSString *)regex
{
	//NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	
	//regex = @"^1?([1-9])({9})";
	
	NSRegularExpression *regexxxx = [NSRegularExpression regularExpressionWithPattern:regex
                                                                               options:0
                                                                                 error:nil];
     NSUInteger numberOfMatches = [regexxxx numberOfMatchesInString:string
                                                            options:0
                                                              range:NSMakeRange(0, [string length])];
	if (numberOfMatches == 0)
	{
      return NO;
    }
    else
    return YES;



}

@end
