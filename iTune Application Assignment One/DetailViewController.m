//
//  appDetailViewController.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 29/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"
#import "AppDelegate.h"
#import "ApplicationData.h"
#import "ImageDownloader.h"
#import "DetailViewSwipe.h"

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@class ImageDownloader;

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *appImage;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *appArtistName;
@property (weak, nonatomic) IBOutlet UILabel *appCategory;
@property (weak, nonatomic) IBOutlet UILabel *appReleaseDate;
@property (weak, nonatomic) IBOutlet UILabel *appPrice;
@property (weak, nonatomic) IBOutlet UILabel *appRights;
@property (weak, nonatomic) IBOutlet UIButton *appURLLink;
@property (strong, nonatomic) ImageDownloader *imageDownloader;

@end

@implementation DetailViewController

AppDelegate *appDelegate;
UIImageView *animatedImageView;
UIActivityIndicatorView  *indicator;
NSURLSessionDownloadTask *downloadTask;

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self createDirectoryToStoredAppImages];
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self loadUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)openURL:(id)sender
{
    UIWebView *webview = [[UIWebView alloc] init];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appRecord.link]];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_appRecord.link]]];
}

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender
{
    NSIndexPath * nextIndexPath = [[DetailViewSwipe alloc] nextIndexPath:self.currentIndexPath ];
    if([[DetailViewSwipe alloc] isNextIndexPath:nextIndexPath maxLimit:[self.applicationRecordsForDetailView count]])
    {
        ApplicationData *appObject = self.applicationRecordsForDetailView[nextIndexPath.row];
        self.appRecord = appObject;
        self.currentIndexPath = nextIndexPath;
        [self loadUI];
    }
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender
{
    NSIndexPath * previousIndexPath = [[DetailViewSwipe alloc] previousIndexPath:self.currentIndexPath ];
    if([[DetailViewSwipe alloc] isPreviousIndexPath:previousIndexPath maxLimit:[self.applicationRecordsForDetailView count]])
    {
        ApplicationData *appObject = self.applicationRecordsForDetailView[previousIndexPath.row];
        self.appRecord = appObject;
        self.currentIndexPath = previousIndexPath;
        [self loadUI];
    }
}

- (void) loadUI
{
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(120, 100);
    [_appImage addSubview:indicator];
    [indicator startAnimating];
    indicator.hidesWhenStopped = YES;
    
    [self refreshViews];
}

- (void)refreshViews
{
    __weak DetailViewController *weak = self;
    self.appName.text = _appRecord.name;
    self.appArtistName.text = _appRecord.artistName;
    self.appCategory.text = _appRecord.category;
    
    [_appURLLink setTitle:_appRecord.link forState:UIControlStateNormal];
    
    self.appRights.text = _appRecord.rights;
    self.appReleaseDate.text = _appRecord.releaseDate;
    self.appPrice.text = _appRecord.price;
    
    NSString *appIconStoredPath = [appDelegate.imageDictionary valueForKey:_appRecord.detailViewImageURL];
    _appImage.image = [UIImage imageWithContentsOfFile:appIconStoredPath];
    
    if(_appImage.image)
    {
        [indicator stopAnimating];
    }
    else if(!_appImage.image && appDelegate.hasInternetConnection)
    {
        if(self.imageDownloader == nil)
        {
            self.imageDownloader = [[ImageDownloader alloc] init];
            self.imageDownloader.appData = self.appRecord;
            
            self.imageDownloader.completionHandler = ^(NSURL *localPath) {
                UIImage *image = [UIImage imageWithContentsOfFile:localPath.path];
                if(image)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [indicator stopAnimating];
                        weak.appImage.image = image;
                    });
                }
            };
        }
        [self.imageDownloader startDownloading:_appRecord.detailViewImageURL saveAs:_appRecord.name isIcon:NO];
    }
    else if(!appDelegate.hasInternetConnection && !_appImage.image)
    {
        _appImage.image = [UIImage imageNamed:@"no_internet_connection.png"];
        [indicator stopAnimating];
    }
}

- (void)createDirectoryToStoredAppImages
{
    NSError *error;
    
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentDirectoryForAppImages = [urls objectAtIndex:0];
    
    NSString *appImagePath = [[documentDirectoryForAppImages absoluteString] stringByAppendingPathComponent:@"appImages"];
    
    NSURL *appImageURLPath = [NSURL URLWithString:appImagePath];
    
    if(![[NSFileManager defaultManager] createDirectoryAtURL:appImageURLPath withIntermediateDirectories:NO attributes:nil error:&error])
    {
        //        NSLog(@"Error while creating appImages directory : %@", error);
    }
}

- (void)dealloc
{
    [downloadTask cancel];
}

@end
