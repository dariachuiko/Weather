//
//  CitiesViewController.m
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "CitiesViewController.h"
#import "NetworkManager.h"
#import "Constants.h"
#import "CityTableViewcell.h"


@interface CitiesViewController ()

@end

@implementation CitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
    self.cityList = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cityList"]) {
        [self.cityList addObjectsFromArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"cityList"]];
    }
    if (!self.cityList.count && !self.mainViewController.currentCity) {
        self.mainViewController.pageViewController.view.userInteractionEnabled = NO;
    }
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self findPresentedWeatherRow] inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mainViewController.addRefreshButton setImage: [UIImage imageNamed:@"plus.png"]  forState:UIControlStateNormal];
    self.mainViewController.addRefreshButton.tintColor= [UIColor whiteColor];
    self.mainViewController.selectedWeatherLabel.text = @"Location";
}

- (void)addNewCity:(NSString *)cityName {

    [self.cityList addObject:cityName];
     self.mainViewController.useCurrentLocations = NO;
    [self.mainViewController selectCity:cityName];
    [self reloadTable];
     NSInteger newRow = 0;
    
    if (self.mainViewController.currentCity) {
        newRow =  [self.cityList count] ;
    } else {
        newRow =  [self.cityList count] - 1;
    }
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:newRow inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)findPresentedWeatherRow {
    NSInteger row = 0;
    if (self.cityList.count > 0 && !self.mainViewController.useCurrentLocations) {
        row = [self.cityList indexOfObject:self.mainViewController.selectedCity];
        row ++;
    }
    return row;
}

- (void)reloadTable {
    [self.tableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:self.cityList forKey:@"cityList"];
}

#pragma mark - UITableViewDelegate, DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.mainViewController.currentCity) {
         return [self.cityList count] + 1;
    } else {
         return [self.cityList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     static NSString *cellIdentifier = @"cityCell";
     CityTableViewcell *cell = (CityTableViewcell*)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if(cell == nil) {
         cell = [[CityTableViewcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     }
     if (self.mainViewController.currentCity) {
         if (indexPath.row == 0 ) {
             cell.cityName.text = self.mainViewController.currentCity;
            [cell.deleteButton setImage: [UIImage imageNamed:@"location.png"]  forState:UIControlStateNormal];
        
         } else {
             cell.cityName.text = [self.cityList objectAtIndex:indexPath.row - 1];
             cell.deleteButton.tag = indexPath.row - 1;
             [cell.deleteButton addTarget:self action:@selector(deleteCity:) forControlEvents:UIControlEventTouchUpInside];
         }
     } else {
            cell.cityName.text =  [self.cityList objectAtIndex:indexPath.row];
            cell.deleteButton.tag = indexPath.row;
            [cell.deleteButton addTarget:self action:@selector(deleteCity:) forControlEvents:UIControlEventTouchUpInside];
     }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.row == 0 && self.mainViewController.currentCity) {
        self.mainViewController.useCurrentLocations = YES;
        [self.mainViewController selectCity:self.mainViewController.currentCity];
     } else {
         self.mainViewController.useCurrentLocations = NO;
         NSString *city = self.mainViewController.currentCity ? [self.cityList objectAtIndex:indexPath.row - 1] : [self.cityList objectAtIndex:indexPath.row];
         [self.mainViewController selectCity:city];
     }
}

- (void)deleteCity:(UIButton*)sender {
    [self.cityList removeObjectAtIndex:sender.tag];
        if (self.cityList.count) {
            NSInteger row = self.tableView.indexPathForSelectedRow.row - 1;
            if (row < 0) {
                row = 0;
            }
            [self reloadTable];
            [self.mainViewController selectCity:[self.cityList objectAtIndex:row]];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self reloadTable];
        }
}

@end