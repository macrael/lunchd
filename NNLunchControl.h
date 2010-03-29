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
#import "NNNetworkSync.h"


@interface NNLunchControl : NSObject {\
	IBOutlet NNSlidingStackView *restaurantSSView;
	IBOutlet NNSlidingStackView *personSSView;
	
	NSMutableArray *people;
	NSMutableArray *restaurants;
	NNPerson *mePerson;
	
	//YOU
	NSString *myName;
	BOOL usedVeto;
	
	int DEBUGS;
}

@property (retain) NSMutableArray *restaurants;
@property (retain) NSMutableArray *people;

//- (void)addRestaurant:(NSString *)newRestaurant;

- (IBAction)imIn:(id)sender;
- (IBAction)imOut:(id)sender;


- (void)checkInWithAll:(id)sender;

- (NNRestaurant *)createNewRestaurantWithName:(NSString *)name;
- (NNPerson *)createNewPersonWithName:(NSString *)name;


- (IBAction)voteButtonPress:(id)sender;
- (IBAction)vetoButtonPress:(id)sender;

- (void)updateRestaurantPosition:(NNRestaurant *)restaurant;
- (void)updatePersonPosition:(NNPerson *)person;

- (void)dealWithMessage:(NNNMessage *)message;

- (NSArray *)rightDiffBetweenArray:(NSArray *)array1 andArray:(NSArray *)array2;

//- (NSMenu *)applicationDockMenu:(NSApplication *)sender;

- (IBAction)debugButtonClick:(id)sender;

@end
