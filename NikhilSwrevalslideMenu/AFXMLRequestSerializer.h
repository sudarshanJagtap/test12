//
//  AFXMLRequestSerialiser.h
//  RestKitFinicity
//
//  Created by Vinayak Vanjari on 8/4/14.
//  Copyright (c) 2014 Finicity Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/** @description: this class is similar to AFJSONRequestSerializer, 
 * extending functionality of AFHTTPRequestSerializer to support XML in API POST request body
 *
 * Pass the 'parameter' as XML String while using this AFXMLRequestSerializer
 *
 **/

@interface AFXMLRequestSerializer : AFHTTPRequestSerializer
    
@end
