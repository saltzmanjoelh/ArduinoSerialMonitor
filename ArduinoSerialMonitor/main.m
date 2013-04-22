//
//  main.m
//  ArduinoSerialMonitor
//
//  Created by Joel Saltzman on 4/15/13.
//  Copyright (c) 2013 joelsaltzman.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "SMAppDelegate.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {

        
        NSApplication *application = [NSApplication sharedApplication];
        SMAppDelegate *delegate = NULL;
        NSString *generalPortPath = NULL;
        NSNumber *baudRate = NULL;
        
        delegate = [SMAppDelegate new];
        [application setDelegate:delegate];
        generalPortPath = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"GENERAL_BOARD_PORT_PATH"];
        if(!generalPortPath){
            NSLog(@"GENERAL_BOARD_PORT_PATH was not set in the ArduinoSerialMonitor-Info.plist");
        }
        baudRate = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"BOARD_BAUD_RATE"];
        if(!baudRate){
            NSLog(@"BOARD_BAUD_RATE was not set in the ArduinoSerialMonitor-Info.plist");
        }
        
        [delegate setupForPort: generalPortPath];
        delegate.serialPort.baudRate = baudRate;

        
        [[NSRunLoop currentRunLoop] run];
        
        NSLog(@"done");
    }
    return 0;
}

