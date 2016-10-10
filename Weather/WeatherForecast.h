//
//  WeatherForecast.h
//  Weather
//
//  Created by dchuiko on 10/8/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ModelWeatherForecast.h"

@interface WeatherForecast : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, copy)   NSString* locationName;
@property (nonatomic, copy)   NSString* locationCountry;

@property (nonatomic, strong) NSArray * forecast;

- (instancetype)initWithJSON:(NSDictionary*)jsonData;

@end
