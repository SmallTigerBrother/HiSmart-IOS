//
//  DBDeviceRecord.h
//  
//
//  Created by minfengliu on 15/7/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBDeviceRecord : NSManagedObject

@property (nonatomic, retain) NSString * voicePath;
@property (nonatomic, retain) NSNumber * recoderTimestamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * voiceTime;
@property (nonatomic, retain) NSString * peripheraUUID;

@end
