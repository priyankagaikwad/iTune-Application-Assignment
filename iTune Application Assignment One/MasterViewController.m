
//
//  ViewController.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ApplicationData.h"
#import "ApplicationCell.h"
#import "iTuneDataManager.h"
#import "ImageDownloader.h"
#import "DetailViewSwipe.h"
#import "AppDelegate.h"

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define JSONURL [NSURL URLWithString:@"https://itunes.apple.com/us/rss/newfreeapplications/limit=2/json"]

@class ApplicationCell;

@interface MasterViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) NSMutableArray *filteredApplicationRecords;

@end

@implementation MasterViewController

AppDelegate *appDelegate;
static NSString *cellIdentifier = @"ApplicationCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.applicationRecords = [[NSMutableArray alloc] init];
    [self.view addSubview:_loadingView];
    
    [_dataLoadingIndicator startAnimating];
    
    [_loadingView setHidden:YES];
    [self.tableView reloadData];
    
    _applicationRecords = [[iTuneDataManager alloc] loadAllApplicationData];
    
    // Parse json
    if(appDelegate.hasInternetConnection)
        [self fetchJSONData];
    if([_applicationRecords count] > 0)
    {
        self.filteredApplicationRecords = [NSMutableArray arrayWithCapacity:[_applicationRecords count]];
    }
    self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self terminatePendingDownloading];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger nodeCount = [self.applicationRecords count];
    
    if (nodeCount == 0) {
        return 1;
    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [self.filteredApplicationRecords count];
    else
        return [self.applicationRecords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationCell *cell = nil;
    NSUInteger nodeCount = [self.applicationRecords count];
    ApplicationData *appObject;
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.isDecelerating = self.tableView.isDecelerating;
    cell.isDragging = self.tableView.isDragging;
    
    if(indexPath.row == 0  && nodeCount == 0  )
    {
        cell.appLabelName.text = @"Loading...";
        cell.detailLabel.text = @"";
    }
    
    else if(tableView == self.tableView)
    {
        appObject = self.applicationRecords[indexPath.row];
        [cell setApplicationData:appObject forIndexPath:indexPath];
    }
    else
    {
        appObject = self.filteredApplicationRecords[indexPath.row];
        [cell setApplicationData:appObject forIndexPath:indexPath];
    }
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"appDetailsViewController"];
    
    detailViewController.currentIndexPath = indexPath;
    
    ApplicationData *appObject;
    
    if([self.filteredApplicationRecords count] && tableView == self.searchDisplayController.searchResultsTableView)
    {
        detailViewController.applicationRecordsForDetailView = self.filteredApplicationRecords;
        appObject = self.filteredApplicationRecords[indexPath.row];
        detailViewController.appRecord = appObject;

    }
    else
    {
        detailViewController.applicationRecordsForDetailView = self.applicationRecords;
        appObject = self.applicationRecords[indexPath.row];
        detailViewController.appRecord = appObject;
    }
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)loadIconForOnScreenRows
{
    [self.tableView reloadData];
}

#pragma mark - ScrollingDelegates
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self loadIconForOnScreenRows];
        NSLog(@"scrollViewDidEndDragging");
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadIconForOnScreenRows];
}

- (void)terminatePendingDownloading
{
    ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopDownloading" object:imageDownloader];
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredApplicationRecords removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[c] %@", searchText];
    
    self.filteredApplicationRecords = [NSMutableArray arrayWithArray:[self.applicationRecords filteredArrayUsingPredicate:resultPredicate]];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

#pragma mark - ParseDelegate
- (void)fetchJSONData
{
    dispatch_async(queue ,^{
        NSData *iTuneApplicationData = [NSData dataWithContentsOfURL:JSONURL];
        _applicationRecords = [[iTuneDataManager alloc] populateApplicationInformationFromData:iTuneApplicationData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}


- (void)dealloc
{
    [self terminatePendingDownloading];
}

@end
