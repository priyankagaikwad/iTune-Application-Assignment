//
//  iTuneStoreObject.m
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 03/11/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "iTuneDataManager.h"
#import "ApplicationData.h"
#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation iTuneDataManager

- (NSMutableArray *)populateApplicationInformationFromData:(NSData *)iTuneData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableArray *applicationRecords = [NSMutableArray array];

    if(iTuneData)
    {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:iTuneData options:kNilOptions error:nil];
        NSDictionary * feed = jsonData[@"feed"];
        NSArray * entries = feed[@"entry"];
        
        for (NSDictionary *entry in entries)
        {
            ApplicationData * appObject = [[ApplicationData alloc] initWithJsonData:entry];
            [applicationRecords addObject: appObject];
        }
        
        NSString *storedAppObjectInFile = [appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"ApplicationData.plist"];
        
        BOOL status = [NSKeyedArchiver archiveRootObject:applicationRecords toFile:storedAppObjectInFile];
        
        if(!status)
        {
            NSLog(@"Failured to Archive");
        }
    }
    else
    {
        applicationRecords = self.loadAllApplicationData; // [NSKeyedUnarchiver unarchiveObjectWithFile:loadApplicationObjectFromFile];
    }
    
    return applicationRecords;
}

- (NSMutableArray*) loadAllApplicationData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *filePathToStoreJson =[appDelegate.documentDirectoryPath stringByAppendingPathComponent:@"ApplicationData.plist"];
    NSMutableArray *applicationInfoObjects = [[NSMutableArray alloc] init];
    applicationInfoObjects = [NSKeyedUnarchiver unarchiveObjectWithFile:filePathToStoreJson];
    
    return applicationInfoObjects;
}

- (BOOL) doesApplicationCacheExists
{
    return [self loadAllApplicationData].count > 0;
}


@end
