//
//  WeatherModel.m
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

- (instancetype)initWithJSON:(NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        NSString* tmp;
        
        NSString* lat = [jsonData valueForKeyPath:@"coord.lat"];
        NSString* lon = [jsonData valueForKeyPath:@"coord.lon"];
        
        if (lat && lon) {
            double latitude = [lat doubleValue];
            double longitude = [lon doubleValue];
            _coordinates = CLLocationCoordinate2DMake(latitude, longitude);
        }
        
        _date = [jsonData valueForKeyPath:@"dt"];
        
        tmp = [jsonData valueForKeyPath:@"main.humidity"];
        _humidity = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.temp"];
        _temp = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.temp_max"];
        _tempMax = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.temp_min"];
        _tempMin = tmp.doubleValue;
        
        tmp = [jsonData valueForKeyPath:@"main.pressure"];
        _pressure = tmp.doubleValue;
        // convert pressure from hPa to inHg
        _pressure *= (29.92 / 1013.25);
        

        _locationName = [jsonData valueForKey:@"name"];
        
        tmp = [jsonData valueForKeyPath:@"sys.sunrise"];
        int sunrise = tmp.intValue;
        _sunrise = [NSDate dateWithTimeIntervalSince1970:sunrise];
        
        tmp = [jsonData valueForKeyPath:@"sys.sunset"];
        int sunset = tmp.intValue;
        _sunset = [NSDate dateWithTimeIntervalSince1970:sunset];
        
        _locationCountry = [jsonData valueForKeyPath:@"sys.country"];
        

        NSArray* a = [jsonData valueForKeyPath:@"weather"];
        NSDictionary* weatherDict = [a firstObject];
        
        _weatherDescription = [weatherDict valueForKey:@"description"];
        _weatherIcon = [weatherDict valueForKey:@"icon"];
        _weatherSummary = [weatherDict valueForKey:@"main"];
        NSNumber* n =[weatherDict valueForKey:@"id"];
        _weatherID = n.stringValue;
                
        tmp = [jsonData valueForKeyPath:@"wind.deg"];
        _windDirection = tmp.intValue;
        
        
        tmp = [jsonData valueForKeyPath:@"wind.gust"];
        _windGust = tmp.doubleValue;
        _windGust = _windGust * (3600.0/1609.34);
        
        tmp = [jsonData valueForKeyPath:@"wind.speed"];
        _windSpeed = tmp.doubleValue;
        _windSpeed = _windSpeed * (3600.0/1609.34);
        
    }
    return self;
}

@end
