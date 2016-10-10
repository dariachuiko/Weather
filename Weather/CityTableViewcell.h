//
//  CityTableViewcell.h
//  Weather
//
//  Created by dchuiko on 10/6/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesViewController.h"

@interface CityTableViewcell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *cityName;

@end
