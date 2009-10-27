//
//  Localizame.h
//  API Cocoa Touch Localizame
//


#import <UIKit/UIKit.h>


@interface Localizame : NSObject {
	
@private
	CFReadStreamRef streamSMS;
	NSString* Cookie;
	NSString * dataresponse;
	UInt32 statusCode;
	
}

- (BOOL) Login: (NSString *) login password: (NSString *) pass;
- (NSString *) Locate: (NSString*) number;
- (BOOL) Authorize: (NSString*) number;
- (BOOL) Unauthorize: (NSString*) number;
- (BOOL) Logout;

@end

