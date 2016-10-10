//
//  ModelWeatherForecast.h
//  Weather
//
//  Created by dchuiko on 10/8/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelWeatherForecast : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy)   NSString* weatherIcon;
@property (nonatomic, copy)   NSString* weatherDescription;
@property (nonatomic, copy)   NSString* weatherID;
@property (nonatomic, copy)   NSString* weatherSummary;
@property (nonatomic, assign) double humidity;
@property (nonatomic, assign) double dayTemp;
@property (nonatomic, assign) double nightTemp;
@property (nonatomic, assign) double pressure;
@property (nonatomic, assign) double windSpeed;

- (instancetype)initWithJSON:(NSDictionary *)jsonData;

@end
