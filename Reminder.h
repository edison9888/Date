//
//  Reminder.h
//  Date
//
//  Created by lixiaoyu on 12-11-27.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Reminder : NSManagedObject

@property (nonatomic, retain) NSString * adress;
@property (nonatomic, retain) NSString * audioUrl;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSDate * sendTime;
@property (nonatomic, retain) NSDate * triggerTime;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * isBell;

@end
