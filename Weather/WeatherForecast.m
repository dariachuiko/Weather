//
//  WeatherForecast.m
//  Weather
//
//  Created by dchuiko on 10/8/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "WeatherForecast.h"
#import "ModelWeatherForecast.h"


@implementation WeatherForecast

- (instancetype)initWithJSON:(NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc]init];

        NSString* lat = [jsonData valueForKeyPath:@"coord.lat"];
        NSString* lon = [jsonData valueForKeyPath:@"coord.lon"];
        
        if (lat && lon) {
            double latitude = [lat doubleValue];
            double longitude = [lon doubleValue];
            _coordinates = CLLocationCoordinate2DMake(latitude, longitude);
        }

        _locationName = [jsonData valueForKey:@"city.name"];
        
        _locationCountry = [jsonData valueForKeyPath:@"country"];
        
        NSArray * array = [jsonData valueForKeyPath:@"list"];
        for (id day in array) {
            ModelWeatherForecast *model = [[ModelWeatherForecast alloc]initWithJSON:day];
            [tmpArray addObject:model];
        }
        self.forecast = tmpArray;
    }
    return self;
}

@end
