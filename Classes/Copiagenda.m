//
//  Copiagenda.m
//  Copiagenda Cocoa API 
//

#import "Copiagenda.h"

@interface Copiagenda (Private)

- (BOOL) SendHttpMessageHead: (CFHTTPMessageRef) httpmessage;
- (BOOL) SendHttpMessageBody: (CFHTTPMessageRef) httpmessage;
- (void) ParserLine: (NSString *) line;
@end

@implementation Copiagenda

- (NSDictionary *) RetrieveContacts: (NSString *) login password: (NSString *) pass {
	
	NSString * pic;
    dictionary = [[NSMutableDictionary alloc] init];
	CFHTTPMessageRef requestmsg;
	NSURL * urlcopiagenda = [NSURL URLWithString:@"https://copiagenda.movistar.es/cp/ps/Main/login/Agenda"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlcopiagenda, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("copiagenda.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	NSString * bodyData = [NSString stringWithFormat:@"TM_ACTION=LOGIN&TM_LOGIN=%@&TM_PASSWORD=%@",login, pass];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
    
	if ([self SendHttpMessageHead:requestmsg]) {
		//REALLOCATE
		urlcopiagenda = [NSURL URLWithString: Location];
		requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef) urlcopiagenda, kCFHTTPVersion1_1);
		CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
		CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
		CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
		CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("copiagenda.movistar.es"));
		CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
		CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
		CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)Cookie);
		if ([self SendHttpMessageBody: requestmsg]) {
			pic = @"password";
			NSRange range = [dataresponse rangeOfString:pic];
			NSString * temporal = [dataresponse substringFromIndex: range.location];
			pic = @">";
			range = [temporal rangeOfString:pic];
			NSString * temporal2 = [temporal substringToIndex: range.location];
			pic = @"=";
			range = [temporal rangeOfString:pic];
			newPass = [temporal2 substringFromIndex: (range.location+1)];
			//REAUTHENTICATE
			urlcopiagenda = [NSURL URLWithString:@"https://copiagenda.movistar.es/cp/ps/Main/login/Authenticate"];
			requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlcopiagenda, kCFHTTPVersion1_1);
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("copiagenda.movistar.es"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Languaje"), CFSTR("es"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cache-Control"), CFSTR("no-cache"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)Cookie);
			bodyData = [NSString stringWithFormat:@"password=%@&u=%@&d=movistar.es",newPass,login];
			body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
			CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
			if ([self SendHttpMessageBody:requestmsg]) {
				pic = @"ApplicationFrame";
				NSRange range = [dataresponse rangeOfString:pic];
				temporal = [dataresponse substringFromIndex: range.location];
				pic = @"&t=";
				range = [temporal rangeOfString:pic];
				temporal2 = [temporal substringFromIndex: (range.location+3)];
				pic = @" />";
				range = [temporal2 rangeOfString:pic];
				reauth = [temporal2 substringToIndex: (range.location-1)];
				//DATA
				NSString * dir = [NSString stringWithFormat:@"https://copiagenda.movistar.es/cp/ps/PSPab/preferences/ExportContacts?d=movistar.es&c=yes&u=%@&t=%@",login,reauth];
				urlcopiagenda = [NSURL URLWithString:dir];
				requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlcopiagenda, kCFHTTPVersion1_1);
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322; Media Center 4.0; .NET CLR 2.0.50727)"));
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("copiagenda.movistar.es"));
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("https://copiagenda.movistar.es/cp/ps/Main/login/Verificacion?d=movistar.es"));
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Languaje"), CFSTR("es"));
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cache-Control"), CFSTR("no-cache"));
				CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)Cookie);
				bodyData = [NSString stringWithFormat:@"FileFormat=TEXT&charset=8859_1&delimiter=TAB"];
				body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
				CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
				if ([self SendHttpMessageBody:requestmsg]) {
					range = [dataresponse rangeOfString:@"<"];
					dataresponse = [dataresponse substringToIndex:range.location];
					//Build diccionary
					NSString * line;
					pic = @"\r\n";
					range = [dataresponse rangeOfString:pic];
					temporal2 = [dataresponse substringFromIndex:(range.location+2)];
					array = [[NSMutableArray alloc] init];
					range = [temporal2 rangeOfString:pic];
					while (range.length == 2) {
						line = [temporal2 substringToIndex:range.location];
						//Line proccess
						array = [[NSMutableArray alloc] init];
						[self ParserLine:line];
						//Add contact to dictionary
						[dictionary setObject:array forKey:[array objectAtIndex:2]];
						[array release];
						temporal2 = [temporal2 substringFromIndex:(range.location+2)];
						range = [temporal2 rangeOfString:pic];
					}
				}
			}
			
		}
	}
	return dictionary; 
}	

- (NSArray *) SearchByName: (NSString *) name contacts: (NSDictionary*) addressbook {
	NSString * contact;
	NSRange range;
	id key;
	NSEnumerator * numerator = [addressbook keyEnumerator];
	while (key = [numerator nextObject]) {
		contact = [NSString stringWithFormat:@"%@",[key description]];
		range = [contact rangeOfString:name options:NSCaseInsensitiveSearch];
		if (range.length != 0) {
			return [addressbook objectForKey:key];
		}
	}
	return nil;
}

- (void) dealloc {
	[dictionary release];
	[super dealloc];
}


/* ******* PRIVATE METHODS ******* */

- (BOOL) SendHttpMessageHead: (CFHTTPMessageRef) httpmessage {
	BOOL res = FALSE;
	streamSMS = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, httpmessage);
	CFRelease(httpmessage);
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
	CFHTTPMessageRef msgRespuesta;
	NSString * setcookie;
	NSString * cookie_s;
	NSString * cookie_skf;
	NSString * pic;
	NSString * cuerpo;
	
	BOOL done = FALSE;
	UInt32 statusCode;
	while (!done) {
		if (CFReadStreamHasBytesAvailable(streamSMS)) {
			UInt8 bufi[4096];
			CFIndex bytesRead = CFReadStreamRead(streamSMS, bufi, sizeof(bufi));
			if (bytesRead < 0) {
				done = TRUE;
			} else if (bytesRead == 0) {
				msgRespuesta = (CFHTTPMessageRef) CFReadStreamCopyProperty(streamSMS, kCFStreamPropertyHTTPResponseHeader);
				NSData * therequest = (NSData *) CFHTTPMessageCopySerializedMessage(msgRespuesta);
				dataresponse = [NSString stringWithCString: [therequest bytes] length: [therequest length]];
				statusCode = CFHTTPMessageGetResponseStatusCode(msgRespuesta);
				if (statusCode == 302) {
					setcookie = (NSString *) (CFHTTPMessageCopyHeaderFieldValue(msgRespuesta, CFSTR("set-cookie")));
					Location = (NSString *) (CFHTTPMessageCopyHeaderFieldValue(msgRespuesta, CFSTR("location")));
					pic = @"; ";
					NSString * skf = @"skf";
					NSRange range = [setcookie rangeOfString:pic];
					cookie_s = [setcookie substringToIndex: range.location];
					range = [setcookie rangeOfString:skf];
					cookie_skf = [setcookie substringFromIndex: range.location];
					pic = @";";
					range = [cookie_skf rangeOfString:pic];
					cookie_skf = [cookie_skf substringToIndex: range.location];
					pic = @"; ";
					Cookie = [cookie_s stringByAppendingString:pic];
					Cookie = [Cookie stringByAppendingString:cookie_skf]; 
					res = TRUE;
					done = TRUE;
				}
			} else {
				cuerpo = [NSString stringWithCString: (char*)bufi length: bytesRead];
				msgRespuesta = (CFHTTPMessageRef) CFReadStreamCopyProperty(streamSMS, kCFStreamPropertyHTTPResponseHeader);
				statusCode = CFHTTPMessageGetResponseStatusCode(msgRespuesta);
				if (statusCode != 302) {
					done = TRUE;
				
				}
			}
			
		}
	}

	return res;
}

- (BOOL) SendHttpMessageBody: (CFHTTPMessageRef) httpmessage {
	streamSMS = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, httpmessage);
	CFRelease(httpmessage);
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
		if (CFReadStreamHasBytesAvailable(streamSMS)) {
			UInt8 bufi[4096];
			CFIndex bytesRead = CFReadStreamRead(streamSMS, bufi, sizeof(bufi));
			if (bytesRead < 0) {
				done = TRUE;
			} else {
				dataresponse = [NSString stringWithCString: (char*)bufi length: bytesRead];
				res = TRUE;
				done = TRUE;
			}
			
		}
	}
	
	CFRelease(streamSMS);
	streamSMS = NULL;
	return res;
}

- (void) ParserLine: (NSString *) line {
	NSString * temp;
	NSRange range;
	NSString * campo;
	temp = @",";
	range = [line rangeOfString: temp];
	while (range.length != 0) {
	    campo = [line substringToIndex:range.location];
		campo = [campo stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		if ([campo length] != 0) {
			[array addObject:campo];
		}
		line = [line substringFromIndex:(range.location+1)];
		range = [line rangeOfString: temp];
	}
}

@end
