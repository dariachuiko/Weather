//
//  MainViewController.h
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
#import "WeatherForecast.h"
#import "SearchViewController.h"

@interface MainViewController : UIViewController <UIPageViewControllerDataSource,
UIPageViewControllerDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addRefreshButton;
@property (weak, nonatomic) IBOutlet UILabel *selectedWeatherLabel;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) WeatherModel *weather;
@property (strong, nonatomic) WeatherForecast *forecast;
@property (strong, nonatomic) NSString *selectedCity;
@property (strong, nonatomic) NSString *currentCity;
@property (strong,nonatomic) NSDate *lastUpdate;
@property (nonatomic, assign) BOOL useCurrentLocations;


-(void)selectCity:(NSString*)newCity;

- (IBAction)onAddRefreshButtonTapped:(id)sender;

@end
