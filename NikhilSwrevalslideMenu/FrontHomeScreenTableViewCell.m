//
//  FrontHomeScreenTableViewCell.m
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 13/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "FrontHomeScreenTableViewCell.h"

@implementation FrontHomeScreenTableViewCell


- (void)awakeFromNib {
    // Initialization code
  self.dollarView.notSelectedImage = [UIImage imageNamed:@"oDollar.png"];
  self.dollarView.fullSelectedImage = [UIImage imageNamed:@"Dollar.png"];
  self.dollarView.rating = 0;
  self.dollarView.editable = YES;
  self.dollarView.maxRating = 5;
//  self.dollarView.delegate = self;
}

@end
