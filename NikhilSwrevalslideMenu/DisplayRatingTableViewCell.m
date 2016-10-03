//
//  DisplayRatingTableViewCell.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/27/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "DisplayRatingTableViewCell.h"

@implementation DisplayRatingTableViewCell

- (void)awakeFromNib {
    // Initialization code
  self.ratingsVw.notSelectedImage = [UIImage imageNamed:@"star23.png"];
  //  self.globalRatingView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
  self.ratingsVw.fullSelectedImage = [UIImage imageNamed:@"star12.png"];
  self.ratingsVw.editable = NO;
  self.ratingsVw.maxRating = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
