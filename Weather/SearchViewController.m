//
//  SearchViewController.m
//  Weather
//
//  Created by dchuiko on 10/4/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import "SearchViewController.h"
#import "NetworkManager.h"

@interface SearchViewController ()

@property (strong, nonatomic)  NSMutableArray *cities;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.cities = [[NSMutableArray alloc]init];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 1) {
        DWNetworkCompletionBlock completion = ^(NSDictionary* dict, NSError* error) {
            [self getCityListWithDictionary:dict];
        };
        [[NetworkManager sharedInstance] getCitiesWithQuery:searchText completion:completion];
    }
    else {
        [self.cities removeAllObjects];
        [self.searchTableView reloadData];
    }
}

- (void)getCityListWithDictionary:(NSDictionary *)dict {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSArray *geonames = [dict objectForKey:@"geonames"];
    for (id name in geonames) {
        [tempArray addObject:[NSString stringWithFormat:@"%@", [name objectForKey:@"toponymName"]]];
    }
    self.cities = tempArray;
    [self.searchTableView reloadData];
}
#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"citySearchCell";
    UITableViewCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text =  [self.cities objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self.searchDelegate addNewCity:[self.cities objectAtIndex:indexPath.row]];
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCancelButtonTapped:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
