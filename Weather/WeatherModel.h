//
//  WeatherModel.h
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherModel : NSObject

@property (nonatomic, strong) NSDate* date;

@property (nonatomic, strong) NSDate* sunrise;
@property (nonatomic, strong) NSDate* sunset;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@property (nonatomic, copy)   NSString* locationName;
@property (nonatomic, copy)   NSString* locationCountry;
@property (nonatomic, assign) double humidity;
@property (nonatomic, assign) double temp;
@property (nonatomic, assign) double tempMin;
@property (nonatomic, assign) double tempMax;
@property (nonatomic, assign) double pressure;
@property (nonatomic, assign) double rain;

@property (nonatomic, assign) double windSpeed;
@property (nonatomic, assign) double windGust;
@property (nonatomic, assign) int windDirection;

@property (nonatomic, copy)   NSString* weatherIcon;
@property (nonatomic, copy)   NSString* weatherDescription;
@property (nonatomic, copy)   NSString* weatherID;
@property (nonatomic, copy)   NSString* weatherSummary;

- (instancetype)initWithJSON:(NSDictionary*)jsonData;


@end
