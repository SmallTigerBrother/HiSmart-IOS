//
//  DBPeriphera.h
//  
//
//  Created by minfengliu on 15/7/5.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBPeriphera : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * avatarPath;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * battery;

@end