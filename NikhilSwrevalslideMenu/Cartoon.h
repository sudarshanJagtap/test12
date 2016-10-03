//
//  Cartoon.h
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 13/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Cartoon : NSObject

@property (nonatomic,strong) NSString * Name;
@property (nonatomic,strong) NSString * CuisineString;
@property (nonatomic,strong) NSString * OrderAmount;
@property (nonatomic,strong) NSString * Fee;
@property (nonatomic,strong) NSString * DeliveryTime;

@property(nonatomic,strong) NSString * imageURLString ;
@property(nonatomic,strong) UIImage * image ;


@end
