//
//  NetworkManager.h
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CLLocation;

typedef void (^DWNetworkCompletionBlock)(NSDictionary* dict, NSError* err);

@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)getWeatherForCity:(NSString*)city completion:(DWNetworkCompletionBlock)completionBlock;
- (void)getWeatherForLocation:(CLLocation*)location completion:(DWNetworkCompletionBlock)completionBlock;
- (void)getCitiesWithQuery:(NSString*)city completion:(DWNetworkCompletionBlock)completionBlock;
- (void)getForecastForCity:(NSString*)city  completion:(DWNetworkCompletionBlock)completionBlock;

@end
