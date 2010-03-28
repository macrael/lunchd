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
#import "NNRestaurantView.h"
#import "NNSlidingStackView.h"


@interface NNLunchControl : NSObject {
	IBOutlet NSTableView *peopleTable;
	IBOutlet NSTableView *restaurantsTable;
	
	IBOutlet NNSlidingStackView *restaurantSSView;
	
	IBOutlet NNRestaurantView *restaurantTemplate;
	
	NSMutableArray *people;
	NSMutableArray *restaurants;
	
	//YOU
	NSString *myName;
	BOOL usedVeto;
}

@property (retain) NSMutableArray *restaurants;
@property (retain) NSMutableArray *people;

//- (void)addRestaurant:(NSString *)newRestaurant;

- (IBAction)imIn:(id)sender;
- (IBAction)imOut:(id)sender;


- (void)checkInWithAll:(id)sender;


- (IBAction)voteButtonPress:(id)sender;
- (IBAction)vetoButtonPress:(id)sender;

- (void)updateRestaurantPosition:(NNRestaurant *)restaurant;


//- (NSMenu *)applicationDockMenu:(NSApplication *)sender;

- (IBAction)debugButtonClick:(id)sender;

@end
