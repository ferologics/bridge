//
//  Discovery.h
//  Proxi
//
//  Created by master on 7/6/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTEventEmitter.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface Discovery : RCTEventEmitter<CBCentralManagerDelegate>

@property BOOL blueToothReady;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) CBCentralManager *central;

- (instancetype)init;

@end
