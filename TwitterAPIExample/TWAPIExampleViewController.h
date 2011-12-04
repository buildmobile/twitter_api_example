//
//  TWAPIExampleViewController.h
//  TwitterAPIExample
//
//  Created by Andy White on 12/10/11.
//  Copyright (c) 2011 Sitepoint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface TWAPIExampleViewController : UIViewController
    @property (nonatomic, retain) ACAccountStore *store;
    @property (nonatomic, retain) UILabel *tweetLabel;
    
-(void)getTweet;

@end
