
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
    
    if(indexPath.row == 0  && nodeCount == 0  )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.appLabelName.text = @"Loading...";
        cell.detailLabel.text = @"";
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.isDecelerating = self.tableView.isDecelerating;
        cell.isDragging = self.tableView.isDragging;
        ApplicationData *appObject;
        if([self.filteredApplicationRecords count] && tableView == self.searchDisplayController.searchResultsTableView)
        {
            appObject = self.filteredApplicationRecords[indexPath.row];
        }
        else
        {
            appObject = self.applicationRecords[indexPath.row];
        }
        [cell setApplicationData:appObject forIndexPath:indexPath];
    }
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"appDetailsViewController"];
    
    detailViewController.currentIndexPath = indexPath;
    detailViewController.applicationRecordsForDetailView = self.applicationRecords;
    
    ApplicationData *appObject = self.applicationRecords[indexPath.row];
    
    detailViewController.appRecord = appObject;
    
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

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

#pragma mark - ParseDelegate
- (void)fetchJSONData
{
    if (_applicationRecords) {
        NSLog(@"Application record");
    }
    dispatch_async(queue ,^{
        NSData *iTuneApplicationData = [NSData dataWithContentsOfURL:JSONURL];
        _applicationRecords = [[iTuneDataManager alloc] populateApplicationInformationFromData:iTuneApplicationData];
        _filteredApplicationRecords = [NSMutableArray arrayWithCapacity:[_applicationRecords count]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredApplicationRecords removeAllObjects];
    NSString* predicateString = [NSString stringWithFormat:@"SELF.name CONTAINS[c] %@", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    self.filteredApplicationRecords = [NSMutableArray arrayWithArray:[_applicationRecords filteredArrayUsingPredicate:predicate]];
}

- (void)dealloc
{
    [self terminatePendingDownloading];
}

@end
