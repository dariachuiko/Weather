//
//  NetworkManager.m
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

static NSString *const APPID = @"217ca612aaa93e9b8f652e860f06a7b9";
static NSString *const baseURL = @"http://api.openweathermap.org/data/";
static NSString *const apiVersion = @"2.5";

@interface DWCacheObject : NSObject

@property (nonatomic, strong) id       response;
@property (nonatomic, copy)   NSDate*  downloadTime;

@end

@implementation NetworkManager

+ (NetworkManager *) sharedInstance {
    static NetworkManager* sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        sharedAccountManagerInstance = [[self alloc]init];
    } );
    return sharedAccountManagerInstance;
}

- (void)getWeatherFromURL:(NSString*)url withParametrs:(NSDictionary*)parameters completion:(DWNetworkCompletionBlock)completionBlock {
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url
      parameters:parameters progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
                                completionBlock(responseObject, nil);
                                  }
         failure:^(NSURLSessionTask *operation, NSError *error) {
                                completionBlock(nil, error);
                }];

}
- (NSString*)normalizeString:(NSString*)str {
    NSArray* components = [str componentsSeparatedByString:@","];
    if (components.count == 0) {
        return str.lowercaseString;
    } else if (components.count == 1) {
        NSString* s = components[0];
        s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return s.lowercaseString;
    } else {
        NSMutableString* result = [NSMutableString new];
        
        for (int i=0; i < components.count-1; ++i) {
            NSString* s = components[i];
            s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [result appendString:s.lowercaseString];
            if (s.length > 0)
                [result appendString:@","];
        }
        
        NSString* s = components[components.count-1];
        s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [result appendString:s.lowercaseString];
        
        return result;
    }
}
- (void)getWeatherForCity:(NSString*)city completion:(DWNetworkCompletionBlock)completionBlock {
    NSString* normalizedCity = [self normalizeString:city];
    NSString* encodedCity = [normalizedCity stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters addEntriesFromDictionary:@{@"APPID": APPID,
                                            @"units": @"metric"}];
    NSString* url = [NSString stringWithFormat:@"%@/%@/weather?q=%@",baseURL, apiVersion, encodedCity];
    [self getWeatherFromURL:url withParametrs:parameters  completion:completionBlock];
}

- (void)getWeatherForLocation:(CLLocation*)location completion:(DWNetworkCompletionBlock)completionBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters addEntriesFromDictionary:@{@"APPID": APPID,
                                           @"units": @"metric"}];
    NSString* url = [NSString stringWithFormat:@"%@/%@/weather?lat=%.f&lon=%.f",baseURL, apiVersion, location.coordinate.latitude, location.coordinate.longitude];
    [self getWeatherFromURL:url withParametrs:parameters completion:completionBlock];
}

- (void)getForecastForCity:(NSString*)city  completion:(DWNetworkCompletionBlock)completionBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters addEntriesFromDictionary:@{@"APPID": APPID,
                                           @"units": @"metric"}];
    NSString* normalizedCity = [self normalizeString:city];
    NSString* encodedCity = [normalizedCity stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString* url = [NSString stringWithFormat:@"%@/%@/forecast/daily?q=%@",baseURL, apiVersion,encodedCity];
    [self getWeatherFromURL:url withParametrs:parameters completion:completionBlock];
}

- (void)getCitiesWithQuery:(NSString*)city completion:(DWNetworkCompletionBlock)completionBlock {
      NSString* url = [NSString stringWithFormat:@"http://api.geonames.org/searchJSON?name_startsWith=%@&maxRows=10&orderby=relevance&cities=cities5000&username=aron", city];
    NSString *encoded = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:encoded
      parameters:nil progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
                completionBlock(responseObject, nil);
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
                completionBlock(nil, error);
         }];

}

@end
