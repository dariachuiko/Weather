//
//  WeatherViewController.h
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
#import "ParentViewController.h"

@interface WeatherViewController : ParentViewController

@property (weak, nonatomic) IBOutlet UIImageView *currentWeatherImage;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *humudutyValue;
@property (weak, nonatomic) IBOutlet UILabel *windValue;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescription;

@property (strong, nonatomic) WeatherModel *weatherModel;

@end
