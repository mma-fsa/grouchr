//
//  APIReponseDelegate.h
//  Grouchr
//
//  Created by Joel Drotos on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcherResponseHandler.h"

@protocol APIResponseDelegate <NSObject>
- (void) didAPIRespond:(NSObject*) handler;
@end
