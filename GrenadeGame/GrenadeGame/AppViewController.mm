//
//  GrenadeGameViewController.m
//  GrenadeGame
//
//  Created by Navi Singh on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppViewController.h"
#import "Game.h"

@implementation AppViewController

//since we are not using a view controller xib.
- (id) init{
	self = [super initWithNibName:nil bundle:nil];
	
	return self;
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

// We got to do this because we are not using a viewcontroller.xib
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
    [super loadView];
	CGRect  frame = [[UIScreen mainScreen] bounds];
    
    sparrowView_ = [ [ [SPView alloc] initWithFrame:frame] autorelease];
    sparrowView_.clipsToBounds = YES;
    [[self view] addSubview: sparrowView_];	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	SP_CREATE_POOL(pool);
	[SPStage setSupportHighResolutions:YES];
	
    
    NSArray *subviews = [sparrowView_ subviews];
    if ([subviews count] == 0) {
        Game *game = [Game stageWithController:self view:sparrowView_];
    }
	
	sparrowView_.frameRate = 30.0f;
    //	[SPAudioEngine start];
    //    [SPAudioEngine start:SPAudioSessionCategory_AmbientSound];
	
	SP_RELEASE_POOL(pool);
    
}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)archiveData 
{
	[Game archiveData:sparrowView_.stage];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [sparrowView_ stop];
	sparrowView_.frameRate = 5;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self archiveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	sparrowView_.frameRate = 30;
	[sparrowView_ start];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self archiveData];
}

@end
