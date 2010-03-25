//
//  NNLunchControl.h
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NNRestaurant.h"
#import "NNPerson.h"


@interface NNLunchControl : NSObject {
	IBOutlet NSTableView *peopleTable;
	IBOutlet NSTableView *restaurantsTable;
	
	NSMutableArray *people;
	NSMutableArray *restaurants;
	
	//YOU
	NSString *myName;
	BOOL usedVeto;
}

@property (retain) NSMutableArray *restaurants;
@property (retain) NSMutableArray *people;

- (void)addRestaurant:(NSString *)newRestaurant;

- (IBAction)imIn:(id)sender;
- (IBAction)imOut:(id)sender;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

- (void)checkInWithAll:(id)sender;

- (IBAction)restaurantClickAction:(id)sender;
- (void)voteForRestaurant:(NNRestaurant *)restaurant;
- (void)vetoRestaurant:(NNRestaurant *)restaurant;

//- (NSMenu *)applicationDockMenu:(NSApplication *)sender;

@end
