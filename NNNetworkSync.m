//
//  NNNetworkSync.m
//  lunchd
//
//  Created by MacRae Linton on 3/28/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNNetworkSync.h"

#define LUNCH_SERVICE_PORT 2764

static const unsigned int MessageHeaderSize = sizeof(UInt64);
NSTimeInterval SocketTimeout = 30;

@implementation NNNetworkSync

- (id)initWithController:(NNLunchControl *)control
{
	self = [super init];
	if (self) {
		controller = control;
	}
	return self;
}

- (IBAction)startServer:(id)sender
{
	NSLog(@"Starting SErVER");
	
	connectedSockets = [[NSMutableArray alloc] initWithCapacity:5];
	
	// Start listening socket
    NSError *error;
    listeningSocket = [[AsyncSocket alloc] initWithDelegate:self];
    if ( ![listeningSocket acceptOnPort:LUNCH_SERVICE_PORT error:&error] ) {
        NSLog(@"Failed to create listening socket");
        return;
    }
	
    // Advertise service with bonjour
    NSString *serviceName = [NSString stringWithFormat:@"Lunchd on %@", 
							 [[NSProcessInfo processInfo] hostName]];
    netService = [[NSNetService alloc] initWithDomain:@"" 
												 type:@"_lunchd._tcp." 
												 name:serviceName 
												 port:2763];
    netService.delegate = self;
    [netService publish];
	
}

- (void)startSearching
{
	netBrowser = [[NSNetServiceBrowser alloc] init];
	[netBrowser setDelegate:self];
	[netBrowser searchForServicesOfType:@"_lunchd._tcp." inDomain:@""];
}

-(void)broadcastMessage:(NNNMessage *)message
{
	for (AsyncSocket *sock in connectedSockets){
		[self sendMessage:message onSocket:sock];
	}
}

#pragma mark Sending/Receiving Messages
-(void)sendMessage:(NNNMessage *)message onSocket:(AsyncSocket*)socket{
    NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:message];
    UInt64 header[1];
    header[0] = [messageData length]; 
    header[0] = CFSwapInt64HostToLittle(header[0]);  // Send header in little endian byte order
    [socket writeData:[NSData dataWithBytes:header length:MessageHeaderSize] withTimeout:SocketTimeout tag:(long)0];
    [socket writeData:messageData withTimeout:SocketTimeout tag:(long)1];
}

#pragma mark Socket Delegate Methods.

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	NSLog(@"Accepted Socket");
	[connectedSockets addObject:newSocket];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"Accepted client %@:%hu", host, port);
	
	[self sendMessage:[controller currentMessage] onSocket:sock];
	
	[sock readDataToLength:MessageHeaderSize withTimeout:SocketTimeout tag:(long)0];
}

//- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
//{
//	[sock readDataToLength:MessageHeaderSize withTimeout:SocketTimeout tag:(long)0];
//}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	if ( tag == 0 ) {
        // Header
        UInt64 header = *((UInt64*)[data bytes]);
        header = CFSwapInt64LittleToHost(header);  // Convert from little endian to native
        [sock readDataToLength:(CFIndex)header withTimeout:SocketTimeout tag:(long)1];
    }
    else if ( tag == 1 ) { 
        // Message body. Pass to controller
        if ( controller && [controller respondsToSelector:@selector(dealWithMessage:fromSocket:)] ) {
            NNNMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [controller dealWithMessage:message fromSocket:sock];
        }
        
        // Begin listening for next message
        [sock readDataToLength:MessageHeaderSize withTimeout:SocketTimeout tag:(long)0];
    }
    else {
        NSLog(@"Unknown tag in read of socket data %d", tag);
    }}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSLog(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort]);
	//probably send this to the controller so it can deal with the ramifications.
	[controller lostConnectionToSocket:sock];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[connectedSockets removeObject:sock];
}

#pragma mark Net Service Browser Delegate Methods

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more
{
	//for now, lets not keep track of services?
	NSLog(@"FOUND SERVICE!");
	[aService setDelegate:self];
	[aService resolveWithTimeout:30];
	if (!more){
		NSLog(@"DONE GETTING PEOPLE FOR NOW:");
	}
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more
{
	
}


#pragma mark Net SerVice Delegate Methods

-(void)netServiceDidResolveAddress:(NSNetService *)service
{
	//Might want to do a check here, if we already know about this address, then they already know about us and there is no need for a second connection.
	NSError *error;
	NSLog(@"Resolved Service with addresses %@",[service addresses]);
	AsyncSocket *sock = [[[AsyncSocket alloc] initWithDelegate:self] autorelease];
	[sock connectToAddress:[[service addresses] lastObject] error:&error];
}

-(void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"Could not resolve: %@", errorDict);
}

@end



@implementation NNNMessage

@synthesize tag;
@synthesize state;
@synthesize name;
@synthesize veto;
@synthesize votes;
@synthesize restaurantList;

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self){
		[self setTag:[aDecoder decodeIntForKey:@"tag"]];
		[self setState:[aDecoder decodeIntForKey:@"state"]];
		[self setName:[aDecoder decodeObjectForKey:@"name"]];
		[self setVeto:[aDecoder decodeObjectForKey:@"veto"]];
		[self setVotes:[aDecoder decodeObjectForKey:@"votes"]];
		[self setRestaurantList:[aDecoder decodeObjectForKey:@"restaurantList"]];
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInt:[self tag] forKey:@"tag"];
	[aCoder encodeInt:[self state] forKey:@"state"];
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:veto forKey:@"veto"];
	[aCoder encodeObject:votes forKey:@"votes"];
	[aCoder encodeObject:restaurantList forKey:@"restaurantList"];
}

@end
