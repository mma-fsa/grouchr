//
//  ComplaintParser.h
//  Grouchr
//
//  Created by Joel Drotos on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Complaint.h"

@interface ComplaintParser : NSObject
+ (Complaint*) parseComplaint: (NSDictionary *)json;
@end
