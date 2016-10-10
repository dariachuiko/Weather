//
//  ForecastViewController.m
//  Weather
//
//  Created by dchuiko on 10/8/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "ForecastViewController.h"
#import "ForecastTableViewCell.h"
#import "ModelWeatherForecast.h"

@interface ForecastViewController ()

@end

@implementation ForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"forecastCell";
    ForecastTableViewCell *cell = (ForecastTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[ForecastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ModelWeatherForecast * mod = [self.mainViewController.forecast.forecast objectAtIndex:indexPath.row + 1];
    cell.day.text = [self getDayFromDate:mod.date];
    cell.shortDescription.text = mod.weatherDescription;
    cell.dayTemp.text  = [NSString stringWithFormat:@"%.f%@", mod.dayTemp, @"\u00B0"];
    cell.nightTemp.text  = [NSString stringWithFormat:@"%.f%@", mod.nightTemp, @"\u00B0"];
    return cell;
}

- (NSString*)getDayFromDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    return [formatter stringFromDate:date];
}
@end
