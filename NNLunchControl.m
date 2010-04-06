//
//  NNLunchControl.m
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNLunchControl.h"


@implementation NNLunchControl

@synthesize restaurants;
@synthesize people;
@synthesize mePerson;
@synthesize myDefaultRestaurants;

- (id) init
{
	self = [super init];
	if (self){
		DEBUGS = 0;
		
		NSLog(@"INININIT");
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *defaultResturants = [NSArray arrayWithObjects:@"Cafe Macs",@"Wahoo's",@"In'n'out",
									 @"Thai Pepper",@"Rio",@"BBQ",nil];
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys: defaultResturants,@"restaurants",nil];
		
		[defaults registerDefaults:appDefaults];
		
		
		NSMutableArray *defTemp = [[NSMutableArray alloc] initWithCapacity:5];
		for (NSString *restN in [defaults objectForKey:@"restaurants"]){
			NNRestDef *tmp = [[NNRestDef alloc] init];
			[tmp setRName:restN];
			[defTemp addObject:tmp];
		}
		[self setMyDefaultRestaurants:defTemp];
		
		mePerson = [[NNPerson alloc] initWithName:[defaults stringForKey:@"name"]];
		
		people = [[NSMutableArray alloc] init];
		restaurants = [[NSMutableArray alloc] init];
		restaurantList = [[NSMutableArray alloc] init];
		
		networkSync = [[NNNetworkSync alloc] initWithController:self];
		[networkSync startServer:self];
		[networkSync startSearching];
		
	}
	return self;
}

- (void) dealloc
{
	[myDefaultRestaurants release];
	[people release];
	[restaurants release];
	[super dealloc];
}

- (void)awakeFromNib
{
	NSLog(@"I HAVE AWOKEN");
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([mePerson name] == nil) {
		[self setTopView:whoView];
		ABPerson *aPerson = [[ABAddressBook sharedAddressBook] me];
		NSString *nameGuess = [aPerson valueForProperty:kABFirstNameProperty];
		NSLog(@"YOUR NAME IS %@",nameGuess);
		[nameField setStringValue:nameGuess];
		[nameField selectText:self];
		NSLog(@"DID I CHANGE THE VALUE: %@",[mePerson name]);

	}else {
		[self setTopView:inOrOutView];
	}

	//lets try putting a new view in the view. 
	NSArray *resturantNames = [defaults arrayForKey:@"restaurants"];
	for (NSString *rName in resturantNames){
		[self createNewRestaurantWithName:rName];
	}
}

- (IBAction)syncUpDefaults:(id)sender
{
	NSLog(@"SYNCING");
	NSMutableArray *defRests = [[NSMutableArray alloc] initWithCapacity:5];
	for (NNRestDef *rd in myDefaultRestaurants){
		if ([rd rName]) {
			[defRests addObject:[rd rName]];
		}
	}
	NSArray *newRests = [self rightDiffBetweenArray:restaurantList andArray:defRests];
	for (NSString *name in newRests){
		[self createNewRestaurantWithName:name];
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:defRests forKey:@"restaurants"];
	
}

- (IBAction)enterYourName:(id)sender
{
	[mePerson setName:[nameField stringValue]];
	[self setTopView:inOrOutView];
	[restaurantSSView updateAll];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[nameField stringValue] forKey:@"name"];
}


- (void)setTopView:(NSView *)newView
{
	[currentTopView removeFromSuperview];
	
	NSRect frame = [[theWindow contentView] bounds];
	frame.origin.x = 0;
	frame.origin.y = frame.size.height - [newView bounds].size.height;
	frame.size.height = [newView bounds].size.height;
	
	[newView setFrame:frame];
	
	[[theWindow contentView] addSubview:newView];
	currentTopView = newView;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSLog(@"GAMEON");
	
	//This may need to be synced. Otherwise you could restart the app and use 
	//your veto over and over again.
	//No, you can't because when you drop out, you send a I'm gone message out that erases your veto. 
	//probably just need a "you" card
	
	//probably want to set up a timer that will keep checking in? 
	//or are they all pushing info out. 
}

//---------

- (NNRestaurant *)createNewRestaurantWithName:(NSString *)name
{
	NNRestaurant *r = [[NNRestaurant alloc] initWithName:name];
	[restaurants addObject:r];
	NNRestaurantView *rView = [[NNRestaurantView alloc] initWithFrame:NSMakeRect(0, 0, 300, 60) andController:self];
	[rView setRepresentedRestaurant:r];
	[restaurantSSView addArrangedSubview:rView];
	//we always add to the bottom, then when things are changed, it updates?
	[restaurantList addObject:name];
	
	[self updateRestaurantPosition:r];
	
	[r addObserver:self
		forKeyPath:@"state"
		   options:0
		   context:NULL];
	
	return r;
}

- (NNPerson *)createNewPersonWithName:(NSString *)name
{
	NNPerson *p = [[NNPerson alloc] initWithName:name];
	[people addObject:p];
	NNPersonView *pView = [[NNPersonView alloc] initWithFrame:NSMakeRect(0, 0, 300, 60) andController:self];
	[pView setRepresentedPerson:p];
	[personSSView addArrangedSubview:pView];
	
	[self updatePersonPosition:p];
	
	[p addObserver:self
		forKeyPath:@"state"
		   options:0
		   context:NULL];
	
	return p;
}


- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	NSLog(@"KddEYPATH CHANGE");
    if ([keyPath isEqual:@"state"]) {
		
		if ([[object class] isEqual:[NNRestaurant class]]){
			[self updateRestaurantPosition:object];
		}
		if ([[object class] isEqual:[NNPerson class]]){
			[self updatePersonPosition:object];
		}
    }else{
		[super observeValueForKeyPath:keyPath
							 ofObject:object
							   change:change
							  context:context];
	}
}


// -------CONTROL FUNCTIONS
// TOP LEVEL:
- (IBAction)imIn:(id)sender
{
	NSLog(@"YOU ARE IN");
	[mePerson setState:NNComingState];
	[restaurantSSView updateAll];
	[self setTopView:ininView];
}
- (IBAction)imOut:(id)sender
{
	NSLog(@"YOU ARE OUT");
	[mePerson setState:NNNotComingState];
	[self extricatePerson:mePerson];
	[restaurantSSView updateAll];
	[self setTopView:outoutView];
}


// Restraunts

- (IBAction)voteButtonPress:(id)sender
{
	NNRestaurant *rest = [(NNRestaurantView *)[sender superview] representedRestaurant];
	[[mePerson votes] addObject:[rest name]];
	[rest giveVote];
	//this needs to get the view to redraw. 
	[restaurantSSView updateAll];
}

- (IBAction)vetoButtonPress:(id)sender
{
	if ([mePerson veto] != nil){
		NSLog(@"HEY THERE CAN't VETO TWICE!");
		return;
	}
	NNRestaurant *rest = [(NNRestaurantView *)[sender superview] representedRestaurant];
	[rest giveVeto];
	[mePerson setVeto:[rest name]];
	[restaurantSSView updateAll];
}


//Add resturant goes to top of list. sorted by alphabet?
//When a resturant is chosen, it gets pushed to the bottom. 

- (void)updateRestaurantPosition:(NNRestaurant *)restaurant
{
	NSLog(@"UPDATE R FOR %@",[restaurant name]);
	//initial pass is just move to top and bottom for vote and veto.
	//for now assume it was just changed to need moving. 
	int curIndex = [restaurants indexOfObject:restaurant];
	
	if ([restaurant state] == NNVotedForState){
		//this has been voted for, move it to the top.
		if (curIndex == 0){
			return;
		}
		[restaurants removeObjectAtIndex:curIndex];
		[restaurants insertObject:restaurant atIndex:0];
		
		[restaurantSSView slideViewAtIndex:curIndex toIndex:0];
	}else if ([restaurant state] == NNVetoedState) {
		//move to the bottom. 
		if (curIndex == [restaurants count] -1){
			return;
		}
		[restaurants removeObjectAtIndex:curIndex];
		[restaurants addObject:restaurant];
		
		[restaurantSSView slideViewAtIndex:curIndex toIndex:[restaurants count] -1];
	}else {
		//need to move back to the middle. 
		//might be able to use this to generalize all of these just with this one.
		//that would keep the most voted ones at the top (what if I didn't even display the count?)
		//all things added are added in this state, so we will special case it. 
		
		if (curIndex == [restaurants count] -1 && curIndex >0){
			if ([[restaurants objectAtIndex:curIndex-1] state] != NNVetoedState) {
				return;
			}
		}
		
		int i;
		for (i = 0; i < [restaurants count]; i++){
			if ([[restaurants objectAtIndex:i] state] != NNVotedForState && i != curIndex){
				break;
			}
		}
		if (curIndex == i){
			return;
		}
		if (i == [restaurants count]){
			i--;
		}
		[restaurants removeObjectAtIndex:curIndex];
		[restaurants insertObject:restaurant atIndex:i];
		
		[restaurantSSView slideViewAtIndex:curIndex toIndex:i];
	}

}

- (void)updatePersonPosition:(NNPerson *)person
{
	//initial pass is just move to top and bottom for vote and veto.
	//for now assume it was just changed to need moving. 
	int curIndex = [people indexOfObject:person];
	
	if ([person state] == NNComingState){
		//this has been voted for, move it to the top.
		if (curIndex == 0){
			return;
		}
		[people removeObjectAtIndex:curIndex];
		[people insertObject:person atIndex:0];
		
		[personSSView slideViewAtIndex:curIndex toIndex:0];
	}else if ([person state] == NNNotComingState) {
		//move to the bottom. 
		if (curIndex == [people count] -1){
			return;
		}
		[people removeObjectAtIndex:curIndex];
		[people addObject:person];
		
		[personSSView slideViewAtIndex:curIndex toIndex:[people count] -1];
	}else {
		//need to move back to the middle. 
		//might be able to use this to generalize all of these just with this one.
		//that would keep the most voted ones at the top (what if I didn't even display the count?)
		//all things added are added in this state, so we will special case it. 
		
		if (curIndex == [people count] -1 && curIndex >0){
			if ([[people objectAtIndex:curIndex-1] state] != NNNotComingState) {
				return;
			}
		}
		
		int i;
		for (i = 0; i < [people count]; i++){
			if ([[people objectAtIndex:i] state] != NNComingState){
				break;
			}
		}
		if (curIndex == i){
			return;
		}
		[people removeObjectAtIndex:curIndex];
		[people insertObject:person atIndex:i];
		
		[personSSView slideViewAtIndex:curIndex toIndex:i];
	}
	
}

- (void)playWhoAreYou:(id)sender
{
	NSSound *whoareyou = [NSSound soundNamed:@"whoareyou"];
	[whoareyou play];
}


- (void)extricatePerson:(NNPerson *)thePerson
{
	for (NSString *restName in [thePerson votes]){
		NNRestaurant *rest = [self objectWithName:restName fromArray:restaurants];
		[rest takeVote];
	}
	[[thePerson votes] removeAllObjects];
	NNRestaurant *vRest = [self objectWithName:[thePerson veto] fromArray:restaurants];
	[vRest takeVeto];
	
	[thePerson setVeto:nil];
}


///////--------

- (void)dealWithMessage:(NNNMessage *)message fromSocket:(AsyncSocket *)socket
{
	NSString *personName = [message name];
	if (personName == nil){
		//This way, if you sent out before you had a name, nothing is recorded.
		//could error check here for if there is any other info, shouldln't be able to send any. 
		return;
	}
	NNPerson *thePerson = nil;
	for (NNPerson *person in people){
		if ([[person name] isEqualToString:personName]){
			thePerson = person;
		}
	}
	if (thePerson == nil){
		//create new person and add it to people. 
		thePerson = [self createNewPersonWithName:personName];
		[thePerson setSocket:socket];
	}else {
		//check and see if sockets match;
		BOOL isEq = [thePerson socket] == socket;
		if (isEq){
			NSLog(@"Sockets are literally equal");
		}else {
			NSLog(@"SOCKETS ARE NOT LITERALLY EQ");
		}
		isEq = [[thePerson socket] isEqual:socket];
		if (isEq){
			NSLog(@"Sockets Are EQUAL!");
		}else {
			NSLog(@"Sockets are NOT EQLA??");
		}
	}
	//check and see if they are coming, and if that matches. 
	
	//If they are not coming, remove their current stuff from the thing.
	if ([thePerson state] != [message state]){
		if ([message state] == NNNotComingState){
			[self extricatePerson:thePerson];
			[thePerson setState:[message state]];
			return;
		}
	}
	
	if ([thePerson state] != [message state]){
		[thePerson setState:[message state]];
	}
	
	//TODO: Optimization, might should have a dictionary of names to objects instead of just arrays. (how preserve ordering? Don't worry about it?)
	
	//get thir list and see if they have anything you don't have.
	NSArray *newRestaurants = [self rightDiffBetweenArray:restaurantList andArray:[message restaurantList]];
	for (NSString *rest in newRestaurants){
		[self createNewRestaurantWithName:rest];
	}
	
	//go through all their votes and if they have new ones, update those restaurats and display them. 
	NSArray *newVotes = [self rightDiffBetweenArray:[thePerson votes] andArray:[message votes]];
	for (NSString *vote in newVotes){
		NNRestaurant *rest = [self objectWithName:vote fromArray:restaurants];
		[rest giveVote];
	}
	[[thePerson votes] addObjectsFromArray:newVotes];
	
	//get their veto and axe a restaurant.
	if ([message veto]!= nil){
		if (![[thePerson veto] isEqualToString:[message veto]]){
			NNRestaurant *vRest = [self objectWithName:[message veto] fromArray:restaurants];
			[vRest giveVeto];
		}
		if ([thePerson veto] != nil) {
			NNRestaurant *vRest = [self objectWithName:[thePerson veto] fromArray:restaurants];
			[vRest takeVeto];
		}
	}
	[thePerson setVeto:[message veto]];
	
}


- (NNNMessage *)currentMessage
{
	NNNMessage *message = [[NNNMessage alloc] init];
	[message setName:[mePerson name]];
	[message setState:[mePerson state]];
	[message setVeto:[mePerson veto]];
	[message setVotes:[mePerson votes]];
	[message setRestaurantList:restaurantList];
	
	return message;
}


- (void)lostConnectionToSocket:(AsyncSocket *)socket
{
	for (NNPerson *person in people){
		if ([[person socket] isEqual:socket]){
			[person setState:NNNotComingState];
			[person setSocket:nil];
			[self extricatePerson:person];
			return;
		}
	}
}
- (void)broadcastMessageToAll
{
	NNNMessage *msg = [self currentMessage];
	
	
	for (NNPerson *person in people){
		[networkSync sendMessage:msg onSocket:[person socket]];
	}
}


//UTILITIES

//THis is a right diff, only finds what array 2 has that 1 does not have. 
- (NSArray *)rightDiffBetweenArray:(NSArray *)array1 andArray:(NSArray *)array2
{
	NSMutableArray *theDiff = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
	for ( id item in array2){
		if (![array1 containsObject:item]){
			[theDiff addObject:item];
		}
	}
	if ([theDiff count] == 0){
		theDiff = nil;
	}
	return theDiff;
}

- (id)objectWithName:(NSString *)name fromArray:(NSArray *)array
{
	for (id obj in array){
		if ([[obj name] isEqualToString:name]){
			return obj;
		}
	}
	return nil;
}


- (IBAction)debugButtonClick:(id)sender
{	
	//test message:
	if (DEBUGS == 0){
		NNNMessage *message = [[NNNMessage alloc] init];
		[message setTag:0];
		[message setName:@"Henry Taggart"];
		[message setState:NNUndefinedState];
		[message setVeto:@"Rio"];
		[message setVotes:[NSArray arrayWithObjects:@"BBQ",@"Thai Pepper",nil]];
		[message setRestaurantList:[NSArray arrayWithObjects:@"Cafe Macs",@"Wahoo's",@"In'n'out",
									@"Thai Pepper",@"Rio",@"BBQ",@"Hardee's",nil]];
		
		[self dealWithMessage:message fromSocket:nil];
	}
	if (DEBUGS == 1){
		NNNMessage *message = [[NNNMessage alloc] init];
		[message setTag:0];
		[message setName:@"James Dempsy"];
		[message setState:NNComingState];
		[message setVeto:@"BBQ"];
		[message setVotes:[NSArray arrayWithObjects:@"In'n'out",@"Thai Pepper",nil]];
		[message setRestaurantList:[NSArray arrayWithObjects:@"Cafe Macs",@"Wahoo's",@"In'n'out",
									@"Thai Pepper",@"Rio",@"BBQ",nil]];
		
		[self dealWithMessage:message fromSocket:nil];
	}
	if (DEBUGS == 2){
		NNNMessage *message = [[NNNMessage alloc] init];
		[message setTag:1];
		[message setName:@"Henry Taggart"];
		[message setState:NNNotComingState];
		
		[self dealWithMessage:message fromSocket:nil];
	}
	if (DEBUGS == 3){
		NNNMessage *message = [[NNNMessage alloc] init];
		[message setTag:1];
		[message setName:@"Kimo Sabe"];
		[message setState:NNNotComingState];
		
		[self dealWithMessage:message fromSocket:nil];
	}
	
	if (DEBUGS == 4){
		NNNMessage *message = [self currentMessage];
		NSLog(@"ME:\nname:%@\nstate:%d\nvotes:%@\nveto:%@",[message name],[message state],[message votes],[message veto]);
	}
	
	DEBUGS ++;
	
	NSLog(@"DONE WITH DEBUG DEAL");
}

@end

@implementation NNRestDef

- (NSString *)rName
{
	return rName;
}

- (void)setRName:(NSString *)newName
{
	[newName retain];
	[rName release];
	rName = newName;
	
	[[[NSApplication sharedApplication] delegate] syncUpDefaults:self];
}

- (id)copyWithZone:(NSZone *)zone
{
	NNRestDef *copy = [[NNRestDef allocWithZone:zone] init];
	[copy setRName: [self rName]];
	return copy;
}

@end
