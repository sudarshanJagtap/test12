//
//  Validation.h
//  ClubEliteMainStoryBoard
//
//  Created by Ganesh Kulpe on 13/06/13.
//  Copyright (c) 2013 Ganesh Kulpe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validation : NSObject
+ (BOOL)validateEmailWithString:(NSString*)email;
+ (BOOL)validateLenghtOfStringWithString:(NSString *)string greaterThanlength:(int)greaterThanlength lessThanlength:(int)lessThanlength;
+ (BOOL)compareStringWithString:(NSString *)firstString second:(NSString *)secondString;
+ (BOOL)allowStringWithNumberOnly:(NSString *)string;
+ (BOOL)dontAllowSpecialCharacter:(NSString *)string;
+ (BOOL)allowOnlySingleDecimalPoints:(NSString *)string;
+ (BOOL)checkFiledIsNotEmpty:(NSString *)string;
+(BOOL)validateEnterString:(NSString *)string FromGivenRegex:(NSString *)regex;
@end
