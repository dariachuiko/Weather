//
//  ForecastTableViewCell.h
//  Weather
//
//  Created by dchuiko on 10/8/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *shortDescription;
@property (weak, nonatomic) IBOutlet UILabel *dayTemp;
@property (weak, nonatomic) IBOutlet UILabel *nightTemp;

@end
