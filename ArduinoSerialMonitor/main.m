//
//  main.m
//  ArduinoSerialMonitor
//
//  Created by Joel Saltzman on 4/15/13.
//  Copyright (c) 2013 joelsaltzman.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAppDelegate.h"

//!!! note the * is not at the end !!!
#ifndef GENERAL_BOARD_PATH
#define GENERAL_BOARD_PATH "/dev/cu.usbserial"
#define BOARD_BAUD_RATE 9600
#endif

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        //print args
        for(int i=0; i<argc; i++){
            printf("arg %i %s\n", i, argv[i]);
        }
        
        //print defines
        printf("GENERAL_BOARD_PATH: %s\n", GENERAL_BOARD_PATH);
        printf("BOARD_BAUD_RATE: %i", BOARD_BAUD_RATE);
        
        
        SMAppDelegate *delegate = NULL;
        NSString *generalPortPath = NULL;
        NSNumber *baudRate = NULL;
        
        delegate = [SMAppDelegate new];
        generalPortPath = [NSString stringWithUTF8String:GENERAL_BOARD_PATH];//convert c type
        baudRate = [NSNumber numberWithInt:BOARD_BAUD_RATE];//convert c type
        
        [delegate setupForPort: generalPortPath];
        delegate.serialPort.baudRate = baudRate;
        [[NSRunLoop currentRunLoop] run];
        
    }
    return 0;
}

