//
//  NNNetworkSync.h
//  lunchd
//
//  Created by MacRae Linton on 3/28/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "NNLunchControl.h"

@class NNNMessage;
@class NNLunchControl;

@interface NNNetworkSync : NSObject {
	AsyncSocket *listeningSocket;
	NNLunchControl *controller;
	NSNetService *netService;
	NSNetServiceBrowser *netBrowser;
	NSMutableArray *connectedSockets;
}
- (id)initWithController:(NNLunchControl *)control;
- (IBAction)startServer:(id)sender;
- (void)startSearching;
- (void)sendMessage:(NNNMessage *)message onSocket:(AsyncSocket*)socket;

@end


@interface NNNMessage : NSObject <NSCoding> {
	int tag;
	int state;
	NSString *name;
	NSString *veto;
	NSArray *votes;
	NSArray *restaurantList;
	
}

@property (assign) int tag;
@property (assign) int state;
@property (copy) NSString *name;
@property (copy) NSString *veto;
@property (retain) NSArray *votes;
@property (retain) NSArray *restaurantList;

@end