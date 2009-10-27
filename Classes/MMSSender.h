//
//  MMSender.h
//  API MMSSender
//


#import <UIKit/UIKit.h>


@interface MMSSender : NSObject {
	
@private
	CFReadStreamRef streamSMS;
	NSString * Login;
	NSString * User;
	NSString * Cookie;
	NSString * Server;
	NSString * dataresponse;
	NSString * boundary;
}

- (BOOL) Login: (NSString *) login Password: (NSString *) password;
- (void) InsertImage: (NSString *) ObjName Path: (NSString *) ObjPath;
- (void) InsertAudio: (NSString *) ObjName Path: (NSString *) ObjPath;
- (void) InsertVideo: (NSString *) ObjName Path: (NSString *) ObjPath;
- (BOOL) SendMessage: (NSString *) Subject To: (NSString *) number Text: (NSString *) Message;
- (void) Logout;

@end
