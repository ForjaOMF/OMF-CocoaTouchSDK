//
// SMS 2.0 API
//  SMS20.h
//

#import <UIKit/UIKit.h>


@interface SMS20 : NSObject {
	
	@private
	NSInteger m_TransId;
	NSString *SessionID;
	NSString *MyAlias;
	CFReadStreamRef streamSMS;
	NSString * dataresponse;
		
}

@property(nonatomic, retain) NSString *SessionID;
@property(nonatomic, retain) NSString *MyAlias;


-(NSString*) Login: (NSString*)login Password: (NSString*)password;
-(NSDictionary*)Connect: (NSString*)log Nickname: (NSString*)nick;
-(NSString*)Polling;
-(NSString*)AddContact: (NSString*)log Contact:(NSString*)contact;
-(void)AuthorizeContact: (NSString*)user Transaction:(NSString*)transaction;
-(void)DeleteContact: (NSString*)log Contact:(NSString*)contact;
-(void)SendMessage: (NSString*)log Destination:(NSString*)destination Message:(NSString*)message; 
-(void)Disconnect;
-(NSString*)Polling;
//EXtras

@end

@interface SMS20Helper : NSObject {

}
- (NSDictionary*) PresenceNotification: (NSString*) data;
- (NSString*) NewMessage: (NSString*) data;
- (NSString*) PresenceAuth: (NSString*) data;

@end

@interface SMS20Contact : NSObject <NSCopying>
{

	NSString *userID, *alias;
	bool present;
	uint presence;
}

@property(readwrite,copy) NSString *userID;
@property(readwrite,copy) NSString *alias;
@property(readwrite,assign) uint presence;

@end
