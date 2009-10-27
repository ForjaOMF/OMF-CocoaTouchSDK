//
//  MMSSender.m
//  API MMSSender
//


#import "MMSSender.h"

@interface MMSSender (Private)

- (BOOL) SendHttpMessageHead: (CFHTTPMessageRef) httpmessage Tipo: (NSInteger) num;
- (BOOL) SendHttpMessageBody: (CFHTTPMessageRef) httpmessage;
- (void) ParserLine: (NSString *) line;
@end

@implementation MMSSender


- (BOOL) Login: (NSString *) login Password: (NSString *) password {
	CFHTTPMessageRef requestmsg;
	NSString *separator;
	boundary = [NSString stringWithFormat:@"-----------------------------7d811c60180"];
	NSURL * urlMMS = [NSURL URLWithString:@"http://multimedia.movistar.es"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef) urlMMS, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("multimedia.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("UA-CPU"), CFSTR("x86"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cache-Control"), CFSTR("no-cache"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	 
	if ([self SendHttpMessageHead:requestmsg Tipo:1]) {
		 //1.1.2 LOGIN
		 
		 urlMMS = [NSURL URLWithString: [NSString stringWithFormat:@"http://multimedia.movistar.es/do/dologin;jsessionid=%@",Login]];
		 requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlMMS, kCFHTTPVersion1_1);
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("http://multimedia.movistar.es/authenticate"));
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("UA-CPU"), CFSTR("x86"));
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("multimedia.movistar.es"));
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Lenght"), CFSTR("174"));
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cache-Control"), CFSTR("no-cache"));
		 NSString  * setcookie = [NSString stringWithFormat:@"JSESSIONID=%@",Login]; 
		 CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)setcookie);
		 NSString * bodyData = [NSString stringWithFormat:@"TM_ACTION=LOGIN&variant=mensajeria&locale=sp-SP&client=html-msie-7-winxp&directMessageView=&uid=&uidl=&folder=&remoteAccountUID=&login=l&TM_LOGIN=%@&TM_PASSWORD=%@",login,password];
		 NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
		 CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
		 
		if ([self SendHttpMessageHead: requestmsg Tipo:2]) {
			//1.1.3 CREATE
			urlMMS = [NSURL URLWithString:@"http://multimedia.movistar.es/do/multimedia/create?l=sp-SP&v=mensajeria"];
			requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef) urlMMS, kCFHTTPVersion1_1);
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("http://multimedia.movistar.es/do/messages/inbox"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("UA-CPU"), CFSTR("x86"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("multimedia.movistar.es"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("*/*"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
			separator = @",";
			NSRange range = [Cookie rangeOfString:separator];
			NSString * tempcookie = [Cookie substringToIndex:range.location];
			separator= @"; ";
			tempcookie = [tempcookie stringByAppendingString:separator];
			tempcookie = [tempcookie stringByAppendingString:setcookie];
			tempcookie = [tempcookie stringByAppendingString:separator];
			separator = @"skf";
			range = [Cookie rangeOfString:separator];
			User = [tempcookie stringByAppendingString:[Cookie substringFromIndex: range.location]];
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)User);
			
			if ([self SendHttpMessageHead:requestmsg Tipo:3]) {
				return TRUE;
			}
		 }
	 }
	return FALSE;
}
- (void) InsertImage: (NSString *) ObjName Path: (NSString *) ObjPath {
	
	
	CFHTTPMessageRef requestmsg;
	NSURL * urlMMS = [NSURL URLWithString:@"http://multimedia.movistar.es/do/multimedia/uploadEnd"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlMMS, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("http://multimedia.movistar.es/do/multimedia/upload?l=sp-SP&v=mensajeria"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("multipart/form-data; boundary=---------------------------7d811c60180"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("UA-CPU"), CFSTR("x86"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("*/*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("multimedia.movistar.es"));
	
	NSString * bodyData = [NSString stringWithFormat:@"%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: image/pjpeg\r\n\r\n",boundary,ObjPath];
	NSString * bodyData2 = [NSString stringWithFormat:@"\r\n%@--",boundary];	
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	NSData * body3 = [bodyData2 dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	NSMutableData * data2 = [NSMutableData alloc];
	[data2 setData: body];
	
	NSData * body2 = [[NSData alloc] initWithContentsOfFile:ObjPath];
	[data2 appendData:body2];
	[data2 appendData:body3];
	
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cache-Control"), CFSTR("no-cache"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)User);
	
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) data2);
	[data2 release];
	
	[self SendHttpMessageBody:requestmsg];
	
}
- (void) InsertAudio: (NSString *) ObjName Path: (NSString *) ObjPath {
	
	CFHTTPMessageRef requestmsg;
	NSURL * urlMMS = [NSURL URLWithString:@"http://multimedia.movistar.es/do/multimedia/uploadEnd"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlMMS, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("http://multimedia.movistar.es/do/multimedia/upload?l=sp-SP&v=mensajeria"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("multipart/form-data; boundary=---------------------------7d811c60180"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("UA-CPU"), CFSTR("x86"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("*/*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("multimedia.movistar.es"));
	
	NSString * bodyData = [NSString stringWithFormat:@"%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: audio/mid\r\n\r\n",boundary,ObjPath];
	NSString * bodyData2 = [NSString stringWithFormat:@"\r\n%@--",boundary];	
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	NSData * body3 = [bodyData2 dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	NSMutableData * data2 = [NSMutableData alloc];
	[data2 setData: body];
	
	NSData * body2 = [[NSData alloc] initWithContentsOfFile:ObjPath];
	[data2 appendData:body2];
	[data2 appendData:body3];
	
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cache-Control"), CFSTR("no-cache"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)User);
	
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) data2);
	[data2 release];
	[self SendHttpMessageBody:requestmsg];
		
}
- (void) InsertVideo: (NSString *) ObjName Path: (NSString *) ObjPath {
	CFHTTPMessageRef requestmsg;
	NSURL * urlMMS = [NSURL URLWithString:@"http://multimedia.movistar.es/do/multimedia/uploadEnd"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlMMS, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("http://multimedia.movistar.es/do/multimedia/upload?l=sp-SP&v=mensajeria"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("multipart/form-data; boundary=---------------------------7d811c60180"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("UA-CPU"), CFSTR("x86"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("*/*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("multimedia.movistar.es"));
	
	NSString * bodyData = [NSString stringWithFormat:@"%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: video/avi\r\n\r\n",boundary,ObjPath];
	NSString * bodyData2 = [NSString stringWithFormat:@"\r\n%@--",boundary];	
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	NSData * body3 = [bodyData2 dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	NSMutableData * data2 = [NSMutableData alloc];
	[data2 setData: body];
	
	NSData * body2 = [[NSData alloc] initWithContentsOfFile:ObjPath];
	[data2 appendData:body2];
	[data2 appendData:body3];
	
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cache-Control"), CFSTR("no-cache"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)User);
	
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) data2);
	
	[self SendHttpMessageBody:requestmsg];
}
- (BOOL) SendMessage: (NSString *) Subject To: (NSString *) number Text: (NSString *) Message {
	CFHTTPMessageRef requestmsg;
	NSString * code = [NSString stringWithFormat:@"-------------------------------7d8b32060180"];
	NSString * code2 = [NSString stringWithFormat:@"Content-Disposition: form-data; name"];
	NSURL * urlMMS = [NSURL URLWithString:@"http://multimedia.movistar.es/do/multimedia/send?l=sp-SP&v=mensajeria"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlMMS, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("multipart/form-data; boundary=-----------------------------7d8b32060180"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("http://multimedia.movistar.es/do/multimedia/show"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("multimedia.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("*/*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("UA-CPU"), CFSTR("x86"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cache-Control"), CFSTR("no-cache"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)User);
	NSString * bodyData = [NSString stringWithFormat:@"%@\r\n%@=\"basefolder\"\r\n\r\n\r\n%@\r\n%@=\"folder\"\r\n\r\n\r\n%@\r\n%@=\"id\"\r\n\r\n\r\n%@\r\n%@=\"public\"\r\n\r\n\r\n%@\r\n%@=\"name\"\r\n\r\n\r\n%@\r\n%@=\"url\"\r\n\r\n\r\n%@\r\n%@=\"owner\"\r\n\r\n\r\n%@\r\n%@=\"deferredDate\"\r\n\r\n\r\n%@\r\n%@=\"requestReturnReceipt\"\r\n\r\n\r\n%@\r\n%@=\"to\"\r\n\r\n%@\r\n%@\r\n%@=\"subject\"\r\n\r\n%@\r\n%@\r\n%@=\"text\"\r\n\r\n%@\r\n%@--",code,code2,code,code2,code,code2,code,code2,code,code2,code,code2,code,code2,code,code2,code,code2,code,code2,number,code,code2,Subject,code,code2,Message,code];
  	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	if ([self SendHttpMessageBody:requestmsg]) {
		NSString * pic = [NSString stringWithFormat:@"Tu mensaje ha sido enviado a:"];
		NSRange range = [dataresponse rangeOfString:pic];
		if (range.length != 0) {
			return TRUE;
		}
		
	}
	return FALSE;
}

- (void) Logout {
	CFHTTPMessageRef requestmsg;
	NSURL * urlMMS = [NSURL URLWithString:@"http://multimedia.movistar.es/do/logout?l=sp-SP&v=mensajeria"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlMMS, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("http://multimedia.movistar.es/do/messages/inbox"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Type"), CFSTR("application/x-www-form-urlencoded"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("UA-CPU"), CFSTR("x86"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("multimedia.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-Lenght"), CFSTR("16"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cache-Control"), CFSTR("no-cache"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)User);
	
	NSString * bodyData = [NSString stringWithFormat:@"TM_ACTION=LOGOUT"];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	[self SendHttpMessageHead:requestmsg Tipo:3];
	
}

- (void) dealloc {
	[super dealloc];
}


/* ******* PRIVATE METHODS ******* */

- (BOOL) SendHttpMessageHead: (CFHTTPMessageRef) httpmessage Tipo: (NSInteger) num {
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
					pic = @"; ";
					NSRange range = [setcookie rangeOfString:pic];
					Login = [setcookie substringToIndex: (range.location + 11)];
					res = TRUE;
				}
				done = TRUE;
			} else {
				cuerpo = [NSString stringWithCString: (char*)bufi length: bytesRead];
				msgRespuesta = (CFHTTPMessageRef) CFReadStreamCopyProperty(streamSMS, kCFStreamPropertyHTTPResponseHeader);
				NSData * therequest2 = (NSData *) CFHTTPMessageCopySerializedMessage(msgRespuesta);
				dataresponse = [NSString stringWithCString: [therequest2 bytes] length: [therequest2 length]];

				statusCode = CFHTTPMessageGetResponseStatusCode(msgRespuesta);
				if (statusCode == 302) {
					res = TRUE;
					if (num == 1) {
						setcookie = (NSString *) (CFHTTPMessageCopyHeaderFieldValue(msgRespuesta, CFSTR("set-cookie")));
						pic = @"; ";
						NSRange range = [setcookie rangeOfString:pic];
						Login = [setcookie substringToIndex: range.location];
						pic = @"=";
						range = [Login rangeOfString:pic];
						Login = [Login substringFromIndex: (range.location+1)];	
					} else {
						setcookie = (NSString *) (CFHTTPMessageCopyHeaderFieldValue(msgRespuesta, CFSTR("set-cookie")));
						pic = @";";
						NSRange range = [setcookie rangeOfString:pic];
						Cookie = [setcookie substringToIndex: range.location];
					}
				}
				done = TRUE;
			}
		}
	}
	
	return res;
}



- (BOOL) SendHttpMessageBody: (CFHTTPMessageRef) httpmessage {
	NSString * cuerpo;
	dataresponse = [NSString stringWithFormat:@"Cuerpo= \r\n"];
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
			} else if (bytesRead == 0) {
				done = TRUE;
			} else {
				cuerpo = [NSString stringWithCString: (char*)bufi length: bytesRead];
				dataresponse = [dataresponse stringByAppendingString:cuerpo];
				res = TRUE;
			}
			
		}
	}
	
	CFRelease(streamSMS);
	streamSMS = NULL;
	return res;
}

@end

