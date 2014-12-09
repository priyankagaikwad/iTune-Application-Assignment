//
//  NSObject+ImageDownloader.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 14/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "ImageDownloader.h"
#import "ApplicationData.h"
#import "AppDelegate.h"

@class ApplicationData;
@class ApplicationCell;

@interface ImageDownloader()

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *imageURL;
@property(nonatomic) BOOL isIcon;
@property (strong, nonatomic) NSMutableArray *downloadTasks;
@property (strong ,nonatomic) NSURLSession *session;

@end

@implementation ImageDownloader : NSObject

AppDelegate *appDelegate;

- (void)startDownloading:(NSString *)imageURL saveAs:(NSString *)name isIcon:(BOOL)icon
{
    self.fileName = name;
    self.imageURL = imageURL;
    self.isIcon   = icon;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.allowsCellularAccess = NO;
    
    _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    self.downloadTask = [_session downloadTaskWithURL:[NSURL URLWithString:imageURL]];
    
    [_downloadTask resume];
}

- (void)stopDownloading
{
    [self.downloadTask cancel];
    [self.session invalidateAndCancel];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *directory;
    NSString *fileNameWithoutWhiteSpace = [_fileName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(self.isIcon)
    {
        directory = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"appIcons"];
    }
    else
    {
        directory = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"appImages"];
    }
    
    NSString *temp = [NSString stringWithFormat:@"%@%@",fileNameWithoutWhiteSpace, @".png"];
    NSString *destinationURL = [NSString stringWithFormat:@"%@/%@",directory, temp];
    
    NSError *error1;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:destinationURL] )
    {
        [[NSFileManager defaultManager] removeItemAtPath:destinationURL  error:NULL];
    }
    
    BOOL status = [[NSFileManager defaultManager] copyItemAtPath:location.path  toPath:destinationURL error:&error1];
    
    if (status && !error1)
    {
        if(self.isIcon)
        {
            [appDelegate.iconDictionary setValue:destinationURL forKey:self.imageURL];
        }
        else
        {
            [appDelegate.imageDictionary setValue:destinationURL forKey:self.imageURL];
        }
        if(self.completionHandler)
        {
            self.completionHandler([NSURL URLWithString:destinationURL]);
        }
    }
    else
    {
        NSLog(@"File copy failed: %@", [error1 localizedDescription]);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
        //NSLog(@"Task %@ completed successfully", task);
    }
    else
    {
        //NSLog(@"Task %@ completed with error : %@", task, [error localizedDescription]);
    }
    _downloadTask = nil;
}

-(void)dealloc
{
    [self.downloadTask cancel];
}

@end
