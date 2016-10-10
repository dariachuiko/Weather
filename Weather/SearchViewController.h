//
//  SearchViewController.h
//  Weather
//
//  Created by dchuiko on 10/4/16.
//  Copyright © 2016 dchuiko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityListProtocol <NSObject>

-(void)addNewCity:(NSString *)cityName;

@end

@interface SearchViewController : UIViewController < UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) id<CityListProtocol> searchDelegate;

- (IBAction)onCancelButtonTapped:(id)sender;

@end
