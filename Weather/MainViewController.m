
//
//  MainViewController.m
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherViewController.h"
#import "CitiesViewController.h"
#import "ForecastViewController.h"
#import "NetworkManager.h"
#import "Constants.h"
#import "SearchViewController.h"
#import "UIAlertController+Window.h"

@interface MainViewController () {
    CLLocationManager* lm;
    CLLocation* currentLocation;
    UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) NSArray *contentPageRestorationIDs;
@property (nonatomic, strong) UIAlertController *errorAlert;
@property (nonatomic, strong) SearchViewController * searchViewController;

@end

@implementation MainViewController

- (NSArray *)contentPageRestorationIDs
{
    if (!_contentPageRestorationIDs) {
        _contentPageRestorationIDs = @[@"CitiesViewController", @"WeatherViewController", @"ForecastViewController"];
    }
    
    return _contentPageRestorationIDs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.useCurrentLocations = [[NSUserDefaults standardUserDefaults] boolForKey:@"useCurrentLocations"];
    self.selectedCity = [[NSUserDefaults standardUserDefaults]  objectForKey:@"selectedCity"];
    if (self.selectedCity && !self.useCurrentLocations) {
        [self updateCurrentWeather];
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestToLocationService];
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(void)requestToLocationService {

        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        if (authStatus == kCLAuthorizationStatusDenied || authStatus == kCLAuthorizationStatusRestricted) {
            [self createPageViewControllerWithIndex:0];
            
        } else {
            if (lm == nil) {
                lm = [CLLocationManager new];
                lm.delegate = self;
                lm.desiredAccuracy = kCLLocationAccuracyKilometer;
                lm.distanceFilter = 1000.0;
            }
        
            if (authStatus == kCLAuthorizationStatusNotDetermined) {
                [lm requestWhenInUseAuthorization];
            } else {
                [lm startUpdatingLocation];
            }
        }

}


-(void)selectCity:(NSString*)newCity {
    self.selectedCity = newCity;
    [self updateCurrentWeather];
    self.pageViewController.view.userInteractionEnabled = YES;
}

-(void)updateCurrentWeather {
    NetworkManager *networkManager = [NetworkManager sharedInstance];
    DWNetworkCompletionBlock completion = ^(NSDictionary* dict, NSError* error) {
        self.weather = [[WeatherModel alloc]initWithJSON:dict];
        self.lastUpdate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:self.selectedCity forKey:@"selectedCity"];
        [[NSUserDefaults standardUserDefaults] setBool:self.useCurrentLocations forKey:@"useCurrentLocations"];
        [self createPageViewControllerWithIndex:1];
        [activityIndicator stopAnimating];
        [self updateForecast];
    };
    
    if (self.useCurrentLocations || !self.selectedCity) {
        [networkManager getWeatherForLocation:currentLocation completion:completion];
    } else {
        [networkManager getWeatherForCity:self.selectedCity completion:completion];
    }
    [activityIndicator startAnimating];
}

- (void)updateForecast {
     DWNetworkCompletionBlock completion = ^(NSDictionary* dict, NSError* error) {
         self.forecast = [[WeatherForecast alloc]initWithJSON:dict];
     };
    [[NetworkManager sharedInstance] getForecastForCity:self.weather.locationName completion:completion];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            /* just ignore this */
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            [lm startUpdatingLocation];
            break;
            
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [self createPageViewControllerWithIndex:0];
            self.pageViewController.view.userInteractionEnabled = NO;
            break;
    }
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    CLLocation* loc = locations.firstObject;
        if (loc.timestamp.timeIntervalSinceNow < -5*60)
            // ignore coordinates more than 5 minutes old
            return;
        if (loc.horizontalAccuracy > kCLLocationAccuracyKilometer)
            return;
        currentLocation = loc;
        [lm stopUpdatingLocation];
    DWNetworkCompletionBlock completion = ^(NSDictionary* dict, NSError* error) {
        self.currentCity = [[WeatherModel alloc]initWithJSON:dict].locationName;
        if (self.useCurrentLocations) {
           self.weather = [[WeatherModel alloc]initWithJSON:dict];
           self.lastUpdate = [NSDate date];
           [self createPageViewControllerWithIndex:1];
        }
        [activityIndicator stopAnimating];
        [self updateForecast];
    };
     [[NetworkManager sharedInstance] getWeatherForLocation:currentLocation completion:completion];
     [activityIndicator startAnimating];
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
    self.errorAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                               message:error.localizedDescription
                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [self.errorAlert addAction:okAction];
    [self presentViewController:self.errorAlert animated:YES completion:nil];

}

- (void)handleNetworkError:(NSError*)error {
    // Ignore errors generated when operations are cancelled
    if (error.code != -999 ) {
        self.errorAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                              message:error.localizedDescription
                                                       preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [self.errorAlert addAction:okAction];
        [self presentViewController:self.errorAlert animated:YES completion:nil];
    }
}

#pragma mark - Page View Controller Data Source

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.contentPageRestorationIDs.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    if ([[self.pageViewController.viewControllers objectAtIndex:0].restorationIdentifier isEqualToString: @"WeatherViewController"]) {
        return 1;
    } else {
        return 0;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    NSString *vcRestorationID = viewController.restorationIdentifier;
    NSUInteger index = [self.contentPageRestorationIDs indexOfObject:vcRestorationID];
    
    if (index == 0) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSString *vcRestorationID = viewController.restorationIdentifier;
    NSUInteger index = [self.contentPageRestorationIDs indexOfObject:vcRestorationID];
    
    if (index == self.contentPageRestorationIDs.count - 1) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index + 1];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (index >= self.contentPageRestorationIDs.count) {
        return nil;
    }

    ParentViewController *contentViewController = (ParentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:self.contentPageRestorationIDs[index]];
    contentViewController.mainViewController = self;
    
    return contentViewController;
}

-(void)createPageViewControllerWithIndex:(NSInteger)index{
    if (self.pageViewController) {
        return;
    }
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:index];
    
    [self.pageViewController setViewControllers:@[startingViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:^(BOOL finished) {
                                         
                                     }];
    
    self.pageViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (IBAction)onAddRefreshButtonTapped:(id)sender {
    if ([[self.pageViewController.viewControllers objectAtIndex:0].restorationIdentifier isEqualToString: @"CitiesViewController"]) {
        self.searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        self.searchViewController.searchDelegate = [self.pageViewController.viewControllers objectAtIndex:0];
        [self presentViewController:self.searchViewController animated:YES completion:nil];
    } else {
        [self updateCurrentWeather];
    }
}

@end
