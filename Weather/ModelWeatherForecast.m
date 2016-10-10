//
//  ModelWeatherForecast.m
//  Weather
//
//  Created by dchuiko on 10/8/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "ModelWeatherForecast.h"

@implementation ModelWeatherForecast

- (instancetype)initWithJSON:(NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        NSString* tmp;
        tmp = [jsonData objectForKey:@"dt"];
        _date =[NSDate dateWithTimeIntervalSince1970:tmp.doubleValue];
        
        tmp = [jsonData objectForKey:@"humidity"];
        _humidity = tmp.doubleValue;
        
        tmp = [jsonData objectForKey:@"pressure"];
        _pressure = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"speed"];
        _windSpeed = tmp.doubleValue;
        _windSpeed = _windSpeed * (3600.0/1609.34);
        
        
        tmp = [jsonData valueForKeyPath:@"temp.day"];
        _dayTemp = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"temp.night"];
        _nightTemp = tmp.doubleValue;
        
        NSArray* a = [jsonData valueForKeyPath:@"weather"];
        NSDictionary* weatherDict = [a firstObject];
        
        _weatherDescription = [weatherDict valueForKey:@"description"];
        _weatherIcon = [weatherDict valueForKey:@"icon"];
        _weatherSummary = [weatherDict valueForKey:@"main"];
        NSNumber* n =[weatherDict valueForKey:@"id"];
        _weatherID = n.stringValue;
        
    }
    return self;
}

@end
