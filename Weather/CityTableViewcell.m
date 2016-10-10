//
//  CityTableViewcell.m
//  Weather
//
//  Created by dchuiko on 10/6/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "CityTableViewcell.h"

@implementation CityTableViewcell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.leftImage.image =  [UIImage imageNamed:@"check.png"] ;
        self.contentView.alpha = 1.f;
    } else {
         self.leftImage.image =  [UIImage imageNamed:@"uncheck.png"] ;
        self.contentView.alpha = 0.6f;
    }
}

@end
