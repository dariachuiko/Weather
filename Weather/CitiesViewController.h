//
//  CitiesViewController.h
//  Weather
//
//  Created by dchuiko on 9/30/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"
#import "SearchViewController.h"

@interface CitiesViewController : ParentViewController < UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource, CityListProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * cityList;

@end
