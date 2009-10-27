//
//  SMSSender.h
//	Cocoa Touch API SMSSender
//

#import <UIKit/UIKit.h>


@interface SMSSender : NSObject {

	@private	
	CFReadStreamRef streamSMS;
}

- (NSString *) SendMessage: (NSString *) login pass: (NSString *) password destination: (NSString *) number text: (NSString *) message;


@end
