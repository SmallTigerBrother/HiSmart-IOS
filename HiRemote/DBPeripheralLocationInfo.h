//
//  DBPeripheraLocationInfo.h
//  
//
//  Created by rick on 15/7/5.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBPeripheralLocationInfo : NSManagedObject

@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * peripheralUUID;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSNumber * dataType;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) NSString * timeZone;

@end
