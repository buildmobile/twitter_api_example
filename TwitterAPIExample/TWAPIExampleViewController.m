//
//  TWAPIExampleViewController.m
//  TwitterAPIExample
//
//  Created by Andy White on 12/10/11.
//  Copyright (c) 2011 Sitepoint. All rights reserved.
//

#import "TWAPIExampleViewController.h"

@implementation TWAPIExampleViewController

@synthesize store, tweetLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [self.store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.store requestAccessToAccountsWithType:twitterAccountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(!granted) {
            abort();
            // We didn't get access, so we'll show an error and exit.
        }
        return;
    }];
    
    self.tweetLabel = (UILabel*)[self.view viewWithTag:1];
    
    
    [self getTweet];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Twitter Interactions

-(void)getTweet
{
    // Specify the URL and parameters
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/public_timeline.json"];   
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"count", nil];
    
    // Create the TweetRequest object
    TWRequest *tweetRequest = [[TWRequest alloc] initWithURL:url parameters:parameters requestMethod:TWRequestMethodGET];    
    
    [tweetRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        // Request completed and we have data
        // Output it!
        
        NSError *jsonError = nil;
        id timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
        
        if(timelineData == NULL) {
            // There was an error changing the data to a Foundation Object,
            // so we'll output a bunch of debug information.
            NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"\n\nConversion to object failed.");
            NSLog(@"HTTP Response code: %d", [urlResponse statusCode]);
            NSLog(@"Output from server: %@", myString);
            NSLog(@"JSON Error: %@\n\n", [jsonError localizedDescription]);
            abort();
            // TODO: Show a graceful error message here
        }
        
        NSDictionary *timelineDict = (NSDictionary*) timelineData;
        NSLog(@"Foo!");
        NSLog(@"%@", timelineDict);
        
        self.tweetLabel.text = [[(NSArray*)timelineDict objectAtIndex:0] objectForKey:@"text"];

    }];
}

@end
