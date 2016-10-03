//
//  ImageDownloadOperation.m
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 13/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ImageDownloadOperation.h"

@implementation ImageDownloadOperation
- (void)main {
    
    NSLog(@"Download started for %@",self.cartoon.imageURLString );
    
    
    NSString * urlString = [self.cartoon.imageURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    UIImage * image = [UIImage imageWithData:data];
    
    self.cartoon.image = image;
    
    [self performSelectorOnMainThread:@selector(notify) withObject:nil waitUntilDone:NO];
    
    NSLog(@"Download Finished for %@",self.cartoon.imageURLString );
    
}

- (void)notify {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CARTOON_IMAGE_DOWNLOAD_FINISHED" object:self.cartoon];
}
@end
