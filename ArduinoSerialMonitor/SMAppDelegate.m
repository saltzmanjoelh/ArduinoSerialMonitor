//
//  SMAppDelegate.m
//  UnoIno
//
//  Created by Joel Saltzman on 4/15/13.
//  Copyright (c) 2013 joelsaltzman.com. All rights reserved.
//

#import "SMAppDelegate.h"

@implementation SMAppDelegate

//------------------------------------------
#pragma mark Properties
//------------------------------------------

//------------------------------------------
#pragma mark Methods
//------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        [self setupNotifications];
        [self setupForInput];
    }
    return self;
}
- (void)setupForInput
{
    // Read from stdin
    self.inHandle = [NSFileHandle fileHandleWithStandardInput];
    
    // Listen for incoming data notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputAvailable) name:NSFileHandleDataAvailableNotification object:self.inHandle];
    
    //waits in the background for input
    [self.inHandle waitForDataInBackgroundAndNotify];
}
- (void)inputAvailable
{
    //get the data from input
    NSData *data = [self.inHandle availableData];
    if ([data length] == 0) {
        return;
    }
    
    //send it to the serial
    [self.serialPort sendData:data];
    
    //wait for more input
    [self.inHandle waitForDataInBackgroundAndNotify];
}

- (void)setupForPort:(NSString *)portPath
{
    NSArray *ports = [[ORSSerialPortManager sharedSerialPortManager] availablePorts];
	for (ORSSerialPort *port in ports) {
        [port close];
        if([port.path isEqualToString:portPath]){
            self.serialPort = port;
        }
    }
    
    if(!self.serialPort){
        NSLog(@"Failed to find port: %@\nThis is what is available:\n%@", portPath, [[ports valueForKeyPath:@"path"] componentsJoinedByString:@"\n"]);
        return;
    }
    
    self.serialPort.baudRate = @9600;
    self.serialPort.delegate = self;
    [self.serialPort open];
}
- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if ([string length] == 0) return;
    printf("%s", string.UTF8String);
    
}
- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort
{
    NSLog(@"Serial port removed: %@", serialPort.path);
}



#pragma mark Notifications
- (void)setupNotifications
{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(serialPortsWereConnected:) name:ORSSerialPortsWereConnectedNotification object:nil];
    [nc addObserver:self selector:@selector(serialPortsWereDisconnected:) name:ORSSerialPortsWereDisconnectedNotification object:nil];
    
}
- (void)serialPortsWereConnected:(NSNotification *)notification
{
	NSArray *connectedPorts = [[notification userInfo] objectForKey:ORSConnectedSerialPortsKey];
	NSLog(@"Ports were connected: %@", connectedPorts);
}

- (void)serialPortsWereDisconnected:(NSNotification *)notification
{
	NSArray *disconnectedPorts = [[notification userInfo] objectForKey:ORSDisconnectedSerialPortsKey];
	NSLog(@"Ports were disconnected: %@", disconnectedPorts);
	
}
@end
