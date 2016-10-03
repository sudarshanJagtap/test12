//
//  AFXMLRequestSerialiser.m
//  RestKitFinicity
//
//  Created by Vinayak Vanjari on 8/4/14.
//  Copyright (c) 2014 Finicity Org. All rights reserved.
//

#import "AFXMLRequestSerializer.h"

@implementation AFXMLRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{

     NSParameterAssert(request);
 
    // for GET, HEAD, DELETE mothods just use superclass implementation
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (!parameters) {
        return mutableRequest;
    }
    
    
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    [mutableRequest setValue:[NSString stringWithFormat:@"application/xml; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    return mutableRequest;

    
}

@end
