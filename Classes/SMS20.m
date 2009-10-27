//
//	SMS 2.0 API
//  SMS20.m
//

#import "SMS20.h"


@interface SMS20 (Private)

- (BOOL) SendHttpMessageBody: (CFHTTPMessageRef) httpmessage;
- (NSDictionary*) GetContactList:(NSString*) data;

@end


@implementation SMS20Contact

@synthesize alias, userID,presence;
-init {
	alias = @"";
	userID = @"";
	presence = 0;
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SMS20Contact *copy = [[self class] allocWithZone: zone];
	copy.alias =[self alias];
	copy.userID = [self userID];
	copy.presence = [self presence];
	return copy;
}

@end


@implementation SMS20


@synthesize SessionID, MyAlias;

- (id)init
	{
		static id sharedInstance = nil;
		
		if(nil == sharedInstance)
		{
			SessionID = [NSString stringWithFormat:@""];
			m_TransId = 1;
			MyAlias = [NSString stringWithFormat:@""];
			sharedInstance = [super init];
		}
		else
		{
			[self release];
		}
		
		return [sharedInstance retain];  // critical retain!
	}

 
-(NSString*)Login: (NSString*)login Password: (NSString*)password {
	CFHTTPMessageRef requestmsg;
	NSURL * url = [NSURL URLWithString:@"http://impw.movistar.es/tmelogin/tmelogin.jsp"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) url, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("application/x-www-form-urlencoded"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("impw.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Lenght"), CFSTR("164"));
	
	NSString * bodyData = [NSString stringWithFormat:@"TM_ACTION=AUTHENTICATE&TM_PASSWORD=%@&SessionCookie=ColibriaIMPS_367918656&TM_LOGIN=%@&ClientID=WV%3AInstantMessenger-1.0.2309.16485%40COLIBRIA.PC-CLIENT",password, login];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);

	[self SendHttpMessageBody:requestmsg];
	
	//Session ID
	NSString *pic = @"<SessionID>";
	NSRange range = [dataresponse rangeOfString:pic];
	if (range.length == 0) {
		[pic release];
		return nil;
	} else {
		dataresponse = [dataresponse substringFromIndex:(range.location+11)];
		pic = @"</SessionID>";
		range = [dataresponse rangeOfString:pic];
		self.SessionID = [dataresponse substringToIndex:range.location];
		[pic release];
		return SessionID;
	}
}

-(NSDictionary*)Connect: (NSString*)log Nickname: (NSString*)nick {
	NSDictionary *contactlist;
	CFHTTPMessageRef requestmsg;
	NSURL * url1 = [NSURL URLWithString:@"http://sms20.movistar.es/"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) url1, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("application/vnd.wv.csp.xml"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("sms20.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Expect"), CFSTR("100-continue"));
	
	//ClientCapability Request
	m_TransId = 1;
	NSString *peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><ClientCapability-Request><ClientID><URL>WV:InstantMessenger-1.0.2309.16485@COLIBRIA.PC-CLIENT</URL></ClientID><CapabilityList><ClientType>COMPUTER</ClientType><InitialDeliveryMethod>P</InitialDeliveryMethod><AcceptedContentType>text/plain</AcceptedContentType><AcceptedContentType>text/html</AcceptedContentType><AcceptedContentType>image/png</AcceptedContentType><AcceptedContentType>image/jpeg</AcceptedContentType><AcceptedContentType>image/gif</AcceptedContentType><AcceptedContentType>audio/x-wav</AcceptedContentType><AcceptedContentType>image/jpg</AcceptedContentType><AcceptedTransferEncoding>BASE64</AcceptedTransferEncoding><AcceptedContentLength>256000</AcceptedContentLength><MultiTrans>1</MultiTrans><ParserSize>300000</ParserSize><SupportedCIRMethod>STCP</SupportedCIRMethod><ColibriaExtensions>T</ColibriaExtensions></CapabilityList></ClientCapability-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++];
	NSString * bodyData = [NSString stringWithString:peticion];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//Service Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><Service-Request><ClientID><URL>WV:InstantMessenger-1.0.2309.16485@COLIBRIA.PC-CLIENT</URL></ClientID><Functions><WVCSPFeat><FundamentalFeat /><PresenceFeat /><IMFeat /><GroupFeat /></WVCSPFeat></Functions><AllFunctionsRequest>T</AllFunctionsRequest></Service-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];
	
	//UpdatePresence Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><UpdatePresence-Request><PresenceSubList xmlns=\"http://www.openmobilealliance.org/DTD/WV-PA1.2\"><OnlineStatus><Qualifier>T</Qualifier></OnlineStatus><ClientInfo><Qualifier>T</Qualifier><ClientType>COMPUTER</ClientType><ClientTypeDetail xmlns=\"http://imps.colibria.com/PA-ext-1.2\">PC</ClientTypeDetail><ClientProducer>Colibria As</ClientProducer><Model>TELEFONICA Messenger</Model><ClientVersion>1.0.2309.16485</ClientVersion></ClientInfo><CommCap><Qualifier>T</Qualifier><CommC><Cap>IM</Cap><Status>OPEN</Status></CommC></CommCap><UserAvailability><Qualifier>T</Qualifier><PresenceValue>AVAILABLE</PresenceValue></UserAvailability></PresenceSubList></UpdatePresence-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//GetList Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><GetList-Request /></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//GetPresence Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><GetPresence-Request><User><UserID>wv:%@@movistar.es</UserID></User></GetPresence-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,log];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);	
	[self SendHttpMessageBody:requestmsg];

	////Get Alias
	MyAlias = [NSString stringWithFormat:@""];
	NSString *pic = @"<PresenceValue>";
	NSRange range = [dataresponse rangeOfString:pic];
	if (range.length != 0) {
		dataresponse = [dataresponse substringFromIndex:(range.location+15)];
		pic = @"</PresenceValue>";
		range = [dataresponse rangeOfString:pic];
		MyAlias = [dataresponse substringToIndex:range.location];
	}

	//ListManage Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><ListManage-Request><ContactList>wv:%@/~pep1.0_privatelist@movistar.es</ContactList><ReceiveList>T</ReceiveList></ListManage-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,log];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//GetContacts
	contactlist = [NSDictionary dictionary];
	contactlist = [self GetContactList:dataresponse];
	
	//CreateList Request
	NSString *nicklist;
	if ([contactlist count] != 0) {
		NSString *nickname;
		id key;
		NSEnumerator * numerator = [contactlist keyEnumerator];
		nicklist = @"<NickList>";
		while (key = [numerator nextObject]) {
			SMS20Contact *Contact;
			Contact = [contactlist objectForKey:key];
			nickname = [NSString stringWithFormat:@"<NickName><Name>%@</Name><UserID>%@</userID></NickName>",Contact.alias,Contact.userID];
			nicklist = [nicklist stringByAppendingString:nickname];
		}
		nicklist = [nicklist stringByAppendingFormat:@"</NickList>"];
	} else {
		nicklist = @"<NickList />";
	}
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><CreateList-Request><ContactList>wv:%@/~PEP1.0_subscriptions@movistar.es</ContactList>%@</CreateList-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,log,nicklist];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//SubscribePresence Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><SubscribePresence-Request><ContactList>wv:%@/~PEP1.0_subscriptions@movistar.es</ContactList><PresenceSubList xmlns=\"http://www.openmobilealliance.org/DTD/WV-PA1.2\"><OnlineStatus /><ClientInfo /><FreeTextLocation /><CommCap /><UserAvailability /><StatusText /><StatusMood /><Alias /><StatusContent /><ContactInfo /></PresenceSubList><AutoSubscribe>T</AutoSubscribe></SubscribePresence-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,log];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//UpdatePresence Request
	if (nick.length != 0) {
		peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><UpdatePresence-Request><PresenceSubList xmlns=\"http://www.openmobilealliance.org/DTD/WV-PA1.2\"><Alias><Qualifier>T</Qualifier><PresenceValue>%@</PresenceValue></Alias></PresenceSubList></UpdatePresence-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,nick];
		bodyData = [NSString stringWithString:peticion];
		body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
		CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
		[self SendHttpMessageBody:requestmsg];

		MyAlias = nick;
	}
	
	return contactlist;
}

-(NSString*)Polling {
	CFHTTPMessageRef requestmsg;
	NSURL * url = [NSURL URLWithString:@"http://sms20.movistar.es"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) url, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("application/vnd.wv.csp.xml"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("sms20.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Expect"), CFSTR("100-continue"));
	NSString *peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID /></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><Polling-Request /></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID];
	NSString * bodyData = [NSString stringWithString:peticion];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];
	
	return dataresponse;
}

-(NSString*)AddContact: (NSString*)log Contact:(NSString*)contact {
	CFHTTPMessageRef requestmsg;
	NSURL * url = [NSURL URLWithString:@"http://sms20.movistar.es"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) url, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("application/vnd.wv.csp.xml"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("sms20.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Expect"), CFSTR("100-continue"));
	//Search Request
	NSString *peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><Search-Request><SearchPairList><SearchElement>USER_MOBILE_NUMBER</SearchElement><SearchString>%@</SearchString></SearchPairList><SearchLimit>50</SearchLimit></Search-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,contact];
	NSString * bodyData = [NSString stringWithString:peticion];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//GetPresence Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><GetPresence-Request><User><UserID>wv:%@@movistar.es</UserID></User><PresenceSubList xmlns=\"http://www.openmobilealliance.org/DTD/WV-PA1.2\"><OnlineStatus /><ClientInfo /><GeoLocation /><FreeTextLocation /><CommCap /><UserAvailability /><StatusText /><StatusMood /><Alias /><StatusContent /><ContactInfo /></PresenceSubList></GetPresence-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,contact];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//Get NickName
	NSRange range;
	NSString *alias,*pic, *temp;
	NSString *nick = @"Sin Nick";
	pic = @"<Presence>";
	range = [dataresponse rangeOfString:pic];
	if (range.length != 0) {
		//GetUserID
		pic = @"<UserID>";
		range = [dataresponse rangeOfString:pic];
		temp = [dataresponse substringFromIndex:range.location+8];
		pic = @"</UserID>";
		range = [temp rangeOfString:pic];
		temp = [temp substringToIndex:range.location];
		alias = [NSString stringWithFormat:@"wv:%@@movistar.es",contact];
		
		if ([temp compare:alias] == NSOrderedSame) {
			pic = @"<Alias>";
			range = [dataresponse rangeOfString:pic];
			if (range.length != 0) {
				dataresponse = [dataresponse substringFromIndex:range.location];
				pic = @"<PresenceValue>";
				range = [dataresponse rangeOfString:pic];
				if (range.length != 0) {
					nick = [dataresponse substringFromIndex:range.location+15];
					range = [nick rangeOfString:@"<"];
					nick = [nick substringToIndex:range.location];
				}
			}
		}
	}
	//ListManage Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><ListManage-Request><ContactList>wv:%@/~PEP1.0_subscriptions@movistar.es</ContactList><AddNickList><NickName><Name>%@</Name><UserID>wv:%@@movistar.es</UserID></NickName></AddNickList><ReceiveList>T</ReceiveList></ListManage-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,log,nick,contact];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//ListManage Request for PrivateList
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><ListManage-Request><ContactList>wv:%@/~PEP1.0_privatelist@movistar.es</ContactList><AddNickList><NickName><Name>%@</Name><UserID>wv:%@@movistar.es</UserID></NickName></AddNickList><ReceiveList>T</ReceiveList></ListManage-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,log,nick,contact];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	return nick;
	
}


-(void)AuthorizeContact: (NSString*)user Transaction:(NSString*)transaction {
	CFHTTPMessageRef requestmsg;
	NSURL * url = [NSURL URLWithString:@"http://sms20.movistar.es"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) url, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("application/vnd.wv.csp.xml"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("sms20.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Expect"), CFSTR("100-continue"));
	
	//GetPresence Request
	NSString *peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><GetPresence-Request><User><UserID>%@</UserID></User><PresenceSubList xmlns=\"http://www.openmobilealliance.org/DTD/WV-PA1.2\"><OnlineStatus /><ClientInfo /><GeoLocation /><FreeTextLocation /><CommCap /><UserAvailability /><StatusText /><StatusMood /><Alias /><StatusContent /><ContactInfo /></PresenceSubList></GetPresence-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,user];
	NSString * bodyData = [NSString stringWithString:peticion];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//Status
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Response</TransactionMode><TransactionID>%@</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><Status><Result><Code>200</Code></Result></Status></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,transaction];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

	//PresenceAuth-User
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><PresenceAuth-User><UserID>%@</UserID><Acceptance>T</Acceptance></PresenceAuth-User></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,user];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];
	
}


-(void)DeleteContact: (NSString*)log Contact:(NSString*)contact {
	CFHTTPMessageRef requestmsg;
	NSURL * url = [NSURL URLWithString:@"http://sms20.movistar.es"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) url, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("application/vnd.wv.csp.xml"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("sms20.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Expect"), CFSTR("100-continue"));
	
	//ListManage Request to remove from Subscriptions
	NSString *peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><ListManage-Request><ContactList>wv:%@/~PEP1.0_subscriptions@movistar.es</ContactList><RemoveNickList><UserID>%@</UserID></RemoveNickList><ReceiveList>T</ReceiveList></ListManage-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,log,contact];
	NSString * bodyData = [NSString stringWithString:peticion];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];
	
	//ListManage Request to remove from PrivateList
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><ListManage-Request><ContactList>wv:%@/~PEP1.0_privatelist@movistar.es</ContactList><RemoveNickList><UserID>%@</UserID></RemoveNickList><ReceiveList>T</ReceiveList></ListManage-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,log,contact];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];
	
	//UnsubscribePresence Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><UnsubscribePresence-Request><User><UserID>%@</UserID></User></UnsubscribePresence-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,contact];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];
	
	//DeleteAttributeList Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><DeleteAttributeList-Request><UserID>%@</UserID><DefaultList>F</DefaultList></DeleteAttributeList-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,contact];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];
	
	//CancelAuth Request
	peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><CancelAuth-Request><UserID>%@</UserID></CancelAuth-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,contact];
	bodyData = [NSString stringWithString:peticion];
	body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

}

-(void)SendMessage: (NSString*)log Destination:(NSString*)destination Message:(NSString*)message {
	CFHTTPMessageRef requestmsg;
	NSURL * url = [NSURL URLWithString:@"http://sms20.movistar.es"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) url, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("application/vnd.wv.csp.xml"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("sms20.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Expect"), CFSTR("100-continue"));
	
	//SendMessage Request
	NSString *peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><SendMessage-Request><DeliveryReport>F</DeliveryReport><MessageInfo><ContentType>text/html</ContentType><ContentSize>148</ContentSize><Recipient><User><UserID>%@</UserID></User></Recipient><Sender><User><UserID>%@@movistar.es</UserID></User></Sender></MessageInfo><ContentData>&lt;span style=\"color:#000000;font-family:\"Microsoft Sans Serif\";font-style:normal;font-weight:normal;font-size:12px;\"&gt;%@&lt;/span&gt;</ContentData></SendMessage-Request></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++,destination,log,message];
	NSString * bodyData = [NSString stringWithString:peticion];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];

}

-(void)Disconnect {
	CFHTTPMessageRef requestmsg;
	NSURL * url = [NSURL URLWithString:@"http://sms20.movistar.es"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) url, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("application/vnd.wv.csp.xml"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("sms20.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Expect"), CFSTR("100-continue"));
	
	//Logout Request
	NSString *peticion = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><WV-CSP-Message xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.openmobilealliance.org/DTD/WV-CSP1.2\"><Session><SessionDescriptor><SessionType>Inband</SessionType><SessionID>%@</SessionID></SessionDescriptor><Transaction><TransactionDescriptor><TransactionMode>Request</TransactionMode><TransactionID>%d</TransactionID></TransactionDescriptor><TransactionContent xmlns=\"http://www.openmobilealliance.org/DTD/WV-TRC1.2\"><Logout-Request /></TransactionContent></Transaction></Session></WV-CSP-Message>",SessionID,m_TransId++];
	NSString * bodyData = [NSString stringWithString:peticion];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageBody:requestmsg];
	
	SessionID = @"";
	
}


/* ******* PRIVATE METHODS ******* */


- (NSDictionary*) GetContactList:(NSString*) data {
	NSMutableDictionary* result = [NSMutableDictionary dictionary];
	NSString *pic, *limit;
	NSRange range, nick;	
	NSInteger i = 0;
	pic = @"<NickList>";
	range = [data rangeOfString:pic];
	if (range.length != 0) {
		limit = @"<NickName>";
		nick = [data rangeOfString:limit];
		do {
			i++;
			NSString *user;
			NSString *name;
			//Get Name
			pic = @"<Name>";
			range = [data rangeOfString:pic];
			name = [data substringFromIndex:range.location+6];
			pic = @"<";
			range = [name rangeOfString:pic];
			name = [name substringToIndex:range.location];
			//Get UserID
			pic = @"<UserID>";
			range = [data rangeOfString:pic];
			user = [data substringFromIndex:range.location+8];
			pic = @"<";
			range = [user rangeOfString:pic];
			user = [user substringToIndex:range.location];

			//Create Contact
			SMS20Contact *Contact = [[SMS20Contact alloc] init];
			[Contact setAlias:name];
			[Contact setUserID:user];
			[Contact setPresence:0];
			[result setObject:Contact forKey:user];
			pic = @"</NickName>";
			range = [data rangeOfString:pic];
			data = [data substringFromIndex:(range.location+10)];
			nick = [data rangeOfString:limit];
		} while (nick.length != 0);
	}
	return result;
}

- (BOOL) SendHttpMessageBody: (CFHTTPMessageRef) httpmessage {
	NSString * cuerpo;
	dataresponse = [NSString stringWithFormat:@""];
	streamSMS = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, httpmessage);
	BOOL res = FALSE;
	if (!streamSMS) {
		CFRelease(streamSMS);
		streamSMS=NULL;
		return res;
	}
	if (!CFReadStreamOpen(streamSMS)) {
		CFRelease(streamSMS);
		streamSMS = NULL;
		return res;
	}
	BOOL done = FALSE;
	while (!done) {
		UInt8 bufi[4096];
		CFIndex bytesRead = CFReadStreamRead(streamSMS, bufi, sizeof(bufi));
		switch (bytesRead) {
			case -1:
				done=TRUE;
				break;
			case 0:
				done=TRUE;
				break;
			default:
				cuerpo = [NSString stringWithCString: (char*)bufi length: bytesRead];
				dataresponse = [dataresponse stringByAppendingString:cuerpo];
				res = TRUE;
		}
	}
	CFRelease(streamSMS);
	streamSMS = NULL;
	return res;
}

- (void)dealloc
{
	[SessionID release];
	[MyAlias release];
	[dataresponse release];
	[super dealloc];
}

@end

@implementation SMS20Helper

// POLLING: New Message
- (NSString*) NewMessage: (NSString*) data {
	NSRange range;
	NSString *limit = @"<Sender>";
	NSString *user, *message;
	range = [data rangeOfString:limit];
	data = [data substringFromIndex:range.location+8];
	limit = @"<UserID>";
	range = [data rangeOfString:limit];
	data = [data substringFromIndex:range.location+8];
	//Get userID
	limit = @"</UserID>";
	range = [data rangeOfString:limit];
	user = [data substringToIndex:range.location];
	//Get message
	limit = @"<ContentData>";
	range = [data rangeOfString:limit];
	data = [data substringFromIndex:range.location+13];
	limit = @";\">";
	range = [data rangeOfString:limit];
	if (range.length != 0) {
		data = [data substringFromIndex:range.location+3];
		limit = @"&lt;/span>";
		range = [data rangeOfString:limit];
	} else {
		limit = @"</ContentData>";
		range = [data rangeOfString:limit];
	}
	message = [data substringToIndex:range.location];
	message = [message stringByAppendingString:user];
	return message;
}


- (SMS20Contact*) UserPresenceNotification: (NSString*) data {
	NSRange range;
	NSString *user, *online, *useralias, *temp;
	useralias = nil;
	SMS20Contact *Contact = [[SMS20Contact alloc] init];
	temp = data;
	//get userID
	NSString *limit = @"<UserID>";
	range = [temp rangeOfString:limit];
	if (range.length != 0) {
		temp = [temp substringFromIndex:range.location+8];
		limit = @"</UserID>";
		range = [temp rangeOfString:limit];
		if (range.length != 0) {
			user = [temp substringToIndex:range.location];
			[Contact setUserID:user];
			//get presence
			limit = @"<OnlineStatus>";
			range = [temp rangeOfString:limit];
			if (range.length != 0) {
				limit = @"<PresenceValue>";
				range = [temp rangeOfString:limit];
				if (range.length != 0) {
					temp = [temp substringFromIndex:range.location+15];
					limit = @"</PresenceValue>";
					range = [temp rangeOfString:limit];
					if (range.length != 0) {
						NSLog(@"Viene con presencia");
						online = [temp substringToIndex:range.location];
						if ([online isEqualToString:@"T"]) {
							[Contact setPresence:1];
						} else {
							[Contact setPresence:0];
						}
					}
				}
			} else {
				[Contact setPresence:3];
			}
			//get alias
			limit = @"<Alias>";
			range = [data rangeOfString:limit];
			if (range.length != 0) {
				data = [data substringFromIndex:range.location];
				limit = @"<PresenceValue>";
				range = [data rangeOfString:limit];
				if (range.length != 0) {
					data = [data substringFromIndex:range.location+15];
					limit = @"</PresenceValue>";
					range = [data rangeOfString:limit];
					useralias = [data substringToIndex:range.location];
					[Contact setAlias:useralias];
				}
			}
		}
	}
	return Contact;
}

//POLLING: PresenceNotification
- (NSDictionary*) PresenceNotification: (NSString*) data {
	NSRange range;
	uint legible = 0;
	NSString *contactPresence, *limit;
	NSMutableDictionary* result = [NSMutableDictionary dictionary];
	SMS20Contact *persona;
	limit = @"<Presence>";
	range = [data rangeOfString:limit];
	while (range.length != 0) {
		data = [data substringFromIndex:range.location+10];
		limit = @"</Presence>";
		range = [data rangeOfString:limit];
		if (range.length != 0) {
			contactPresence = [data substringToIndex:range.location];
			persona = [self UserPresenceNotification:contactPresence];
			NSLog (@"Presencia leida:");
			NSLog ([persona alias]);
			NSLog([persona userID]);
			if ([persona userID] != @"") {
				[result setObject:persona forKey:[persona userID]];
				legible = 1;
			} 
		}
		limit = @"<Presence>";
		range = [data rangeOfString:limit]; 
	}
	if (legible == 1) { 
		return result;
	} else {
		return NULL;
	}
}

//POLLING: PresenceAuthorize
- (NSString*) PresenceAuth: (NSString*) data {
	NSRange range;
	NSString *resultado,*limit;
	limit = @"<TransactionID>";
	range = [data rangeOfString:limit];
	data = [data substringFromIndex:range.location+15];
	limit = @"</TransactionID>";
	range = [data rangeOfString:limit];
	resultado = [data substringToIndex:range.location];
	limit = @"<UserID>";
	range = [data rangeOfString:limit];
	data = [data substringFromIndex:range.location+8];
	limit = @"</UserID>";
	range = [data rangeOfString:limit];
	data = [data substringToIndex:range.location];
	resultado = [resultado stringByAppendingString:data];
	return resultado;	
}
@end

