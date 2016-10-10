//
//  WeatherViewController.m
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.mainViewController.addRefreshButton setImage: [UIImage imageNamed:@"refresh.png"]  forState:UIControlStateNormal];
     self.mainViewController.addRefreshButton.tintColor= [UIColor whiteColor];

     self.currentTemperature.text = [NSString stringWithFormat:@"%.f%@",self.mainViewController.weather.temp, @"\u00B0"];
     self.weatherDescription.text = self.mainViewController.weather.weatherDescription;
     self.humudutyValue.text = [NSString stringWithFormat:@"%.f%@",self.mainViewController.weather.humidity, @"%"] ;
     self.windValue.text = [NSString stringWithFormat:@"%.f%@",self.mainViewController.weather.windSpeed, @"km/h"];
     self.mainViewController.selectedWeatherLabel.text = self.mainViewController.weather.locationName;
     self.lastUpdate.text = [self getLastUpdate];
}

- (NSString*)getLastUpdate  {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    return [formatter stringFromDate:self.mainViewController.lastUpdate];
}

@end
