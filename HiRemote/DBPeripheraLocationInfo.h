//
//  DBPeripheraLocationInfo.h
//  
//
//  Created by minfengliu on 15/7/5.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBPeripheraLocationInfo : NSManagedObject

@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * peripheraUUID;
@property (nonatomic, retain) NSNumber * recordTime;
@property (nonatomic, retain) NSNumber * dataType;
@property (nonatomic, retain) NSString * remark;

@end
