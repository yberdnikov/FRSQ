//
//  FTARestaurantsViewController.m
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import "FTARestaurantsViewController.h"
#import "FTARestaurantTableViewCell.h"
#import <CoreData/CoreData.h>
#import <RestKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "FTAConstants.h"
#import "FTARestaurantViewController.h"
#import <INTULocationManager/INTULocationManager.h>

@interface FTARestaurantsViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation FTARestaurantsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Restaurants", nil);
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.contentTableView registerNib:[UINib nibWithNibName:@"FTARestaurantTableViewCell" bundle:nil]
                forCellReuseIdentifier:[FTARestaurantTableViewCell reuseIdentifier]];
    self.contentTableView.tableFooterView = [UIView new];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self detectUserLocation];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController)
        return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FTAVenue"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    [fetchRequest setFetchBatchSize:20.0f];
    
    // Setup fetched results
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    [_fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    BOOL fetchSuccessful = [_fetchedResultsController performFetch:&error];
    if (!fetchSuccessful)
    {
        NSAssert(NO, @"Fetch is not successful");
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FTARestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FTARestaurantTableViewCell reuseIdentifier]];
    
    cell.venue = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FTARestaurantViewController *restaurantViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"restaurantViewController"];
    restaurantViewController.venue = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [self.navigationController pushViewController:restaurantViewController animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.contentTableView reloadData];
}

#pragma mark - Location detection

- (void)detectUserLocation
{
    __weak __typeof(self) weakSelf = self;
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                                                     timeout:10.0f
                                                        delayUntilAuthorized:YES
                                                                       block:
     ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
         __typeof(weakSelf) strongSelf = weakSelf;
         
         if (status == INTULocationStatusSuccess)
             [strongSelf loadRestaurantsForLocation:currentLocation];
         else
         {
             [SVProgressHUD dismiss];
             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                         message:NSLocalizedString(@"Unable to detect your location", nil)
                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         }
     }];
}

#pragma mark - Server API communication

- (void)loadRestaurantsForLocation:(CLLocation *)currentLocation
{
    NSDictionary *params = @{@"client_id" : FTAClientIDKey,
                             @"client_secret" : FTAClientSecretKey,
                             @"venuePhotos" : @1,
                             @"ll" : [NSString stringWithFormat:@"%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.latitude],
                             @"v" : @20130815,
                             @"query" : @"pizza"};
    
    __weak __typeof(self) weakSelf = self;
    [[RKObjectManager sharedManager] getObjectsAtPath:@"venues/explore" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        __typeof(weakSelf) strongSelf = weakSelf;
        
        [SVProgressHUD dismiss];
        [strongSelf.fetchedResultsController performFetch:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FTARestaurantsDataReceivedNotification object:nil];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

@end
