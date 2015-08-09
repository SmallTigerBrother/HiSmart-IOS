//
//  DBDeviceRecord.h
//  
//
//  Created by minfengliu on 15/7/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBPeripheralRecord : NSManagedObject

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * peripheralUUID;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) NSString * recordFileUrl;
@property (nonatomic, retain) NSString * md5Code;

@end
