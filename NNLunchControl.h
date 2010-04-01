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


@interface NNLunchControl : NSObject {
	IBOutlet NNSlidingStackView *restaurantSSView;
	IBOutlet NNSlidingStackView *personSSView;
	
	NSMutableArray *people;
	NSMutableArray *restaurants;
	NNPerson *mePerson;
	
	NSMutableArray *restaurantList;
	
	//YOU
	NSString *myName;
	
	//TOP FIELDS
	NSView *currentTopView;
	IBOutlet NSView *whoView;
	IBOutlet NSView *inOrOutView;
	IBOutlet NSView *ininView;
	IBOutlet NSView *outoutView;
	
	IBOutlet NSWindow *theWindow;
	
	IBOutlet NSTextField *nameField;
	
	int DEBUGS;
}

@property (retain) NSMutableArray *restaurants;
@property (retain) NSMutableArray *people;
@property (retain) NNPerson *mePerson;

//- (void)addRestaurant:(NSString *)newRestaurant;

- (IBAction)imIn:(id)sender;
- (IBAction)imOut:(id)sender;


- (void)checkInWithAll:(id)sender;

- (NNRestaurant *)createNewRestaurantWithName:(NSString *)name;
- (NNPerson *)createNewPersonWithName:(NSString *)name;

- (IBAction)enterYourName:(id)sender;

- (IBAction)voteButtonPress:(id)sender;
- (IBAction)vetoButtonPress:(id)sender;

- (void)updateRestaurantPosition:(NNRestaurant *)restaurant;
- (void)updatePersonPosition:(NNPerson *)person;

- (void)dealWithMessage:(NNNMessage *)message;

- (void)setTopView:(NSView *)newView;
- (void)extricatePerson:(NNPerson *)thePerson;
- (NSArray *)rightDiffBetweenArray:(NSArray *)array1 andArray:(NSArray *)array2;
- (id)objectWithName:(NSString *)name fromArray:(NSArray *)array;

//- (NSMenu *)applicationDockMenu:(NSApplication *)sender;

- (IBAction)debugButtonClick:(id)sender;

@end
