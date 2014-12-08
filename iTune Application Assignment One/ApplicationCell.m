//
//  ApplicationCell.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "ApplicationCell.h"
#import "ApplicationData.h"
#import "AppDelegate.h"
#import "ImageDownloader.h"

#define kAppNameLabel_Font         [UIFont fontWithName: @"Helvetica-Bold" size: 17.0]
#define kAppNameSubtitle_Font         [UIFont fontWithName: @"Helvetica" size: 14.0]
#define kAppIcon_Margin_L          10.0
#define kAppNameLabel_Margin_L     10.0
#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@class ImageDownloader;
@interface ApplicationCell()


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoading;
@property (copy) void (^sessionCompletionHandler)();
@property (nonatomic, strong) ImageDownloader *imageDownloader;
@property (nonatomic, strong) ApplicationData *appData;
@property (nonatomic, strong) UITableView *parentTableView;
@property (nonatomic, strong) NSMutableDictionary *downloadInProgress;
@property (strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSURL *destinationUrlForAppIcons;

@end

@implementation ApplicationCell

AppDelegate *appDelgate;
UIActivityIndicatorView *activityIndicator;
- (UITableView *)findParentTableView
{
    UITableView *tableView = nil;
    UIView *view = self;
    while (view!=nil)
    {
        if([view isKindOfClass:[UITableView class]])
        {
            tableView = (UITableView *)view;
        }
        view = [view superview];
    }
    return  tableView;
}

- (void)refreshViews
{
    appDelgate = [[UIApplication sharedApplication] delegate];

    __weak ApplicationCell *weak = self;
    weak.appLabelName.text = _appData.name;
    self.detailLabel.text = _appData.artistName;
    _detailLabel.textColor = [UIColor lightGrayColor];
    self.appIcon.image = [UIImage imageNamed:@"whiteBackground"];


    NSString *appIconStoredPath = [appDelgate.iconDictionary valueForKey:_appData.iconURL];
    UIImage *image = [UIImage imageWithContentsOfFile:appIconStoredPath];
    if(!image && appDelgate.hasInternetConnection )
    {
           // if(_isDecelerating == NO && _isDragging == NO)
            {
                if(_imageDownloader == nil)
                {
                    _imageDownloader = [[ImageDownloader alloc] init];
                    _imageDownloader.appData = self.appData;
                    
                    _imageDownloader.completionHandler = ^(NSURL *localPath){
                        dispatch_async(dispatch_get_main_queue(), ^{
                        weak.appIcon.image = [UIImage imageWithContentsOfFile:localPath.path];
                        [activityIndicator stopAnimating];
                        [weak.parentTableView reloadData];
                        });
                    };
                }
                [_imageDownloader startDownloading:_appData.iconURL saveAs:_appData.name isIcon:YES];
            }
    }
    else if(image)
    {
        self.appIcon.image = image;
        [activityIndicator stopAnimating];

    }
    else if(!appDelgate.hasInternetConnection)
    {
    }
}

- (void)didMoveToSuperview
{
    if(self.superview)
    {
        self.parentTableView = [self findParentTableView];
    }
}

- (void)setApplicationData:(ApplicationData *)applicationData forIndexPath:(NSIndexPath *)indexPath
{
     activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(25,25); //_appIcon.center;
    [_appIcon addSubview:activityIndicator];
    [_appIcon bringSubviewToFront:activityIndicator];
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped = YES;
    
    [self createDirectoryToStoreAppIcons];
    
    _indexPath = indexPath;
    self.appData = applicationData;
    [self refreshViews];
}

- (UILabel *)detailTextLabel
{
    return self.detailLabel;
}

- (void)createDirectoryToStoreAppIcons
{
    NSError *error;
    
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *documentsDirectoryForAppIcons = [urls objectAtIndex:0];
    
    NSString *appIconPath = [[documentsDirectoryForAppIcons absoluteString] stringByAppendingPathComponent:@"appIcons"];
    
    NSURL * appIconURLPath = [NSURL URLWithString:appIconPath];
    
    if(![[NSFileManager defaultManager] createDirectoryAtURL:appIconURLPath withIntermediateDirectories:NO attributes:nil error:&error])
    {
//        NSLog(@"AppIconDirectory Creating error : %@", error);
    }
}

@end
