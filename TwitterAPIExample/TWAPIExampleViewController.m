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
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];   
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"count", nil];
    
    TWRequest *tweetRequest = [[TWRequest alloc] initWithURL:url parameters:parameters requestMethod:TWRequestMethodGET];    
    
    ACAccountType *twitterAccountType = [self.store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accounts = [self.store accountsWithAccountType:twitterAccountType];
    
    if([accounts count] == 0) {
        // We need to get the user to add an account!
        // This is pretty cheap, but we'll zap them out to the Settings app, where they can add an account.
        // When they return, we'll re-run viewDidLoad to get access to the account.
        // TODO: Show a nice UI to your users to add/select which account they wish to use.
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
        [self viewDidLoad];
        return;
    }
    
    ACAccount *account = [accounts objectAtIndex:0];
    //TODO: We should let the user choose which account they're using
    
    tweetRequest.account = account;
    
    [tweetRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        // Request completed and we have data
        // Output it!
        
        NSError *jsonError = nil;
        id timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
        
        if(timelineData == NULL) {
            NSString *myString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"Conversion to object failed.");
            NSLog(@"%d", [urlResponse statusCode]);
            NSLog(@"%@", myString);
            NSLog(@"%@", [jsonError localizedDescription]);
            abort();
            // TODO: Show a graceful error message here
        }
        
        NSDictionary *timelineDict = (NSDictionary*) timelineData;
        NSLog(@"%@", timelineDict);
        self.tweetLabel.text = [[(NSArray*)timelineDict objectAtIndex:0] objectForKey:@"text"];
    }];
}

@end
