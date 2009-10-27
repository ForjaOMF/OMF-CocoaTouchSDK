//
//  AutoWP.m
//  Cocoa Touch API AutoWP
//


#import "AutoWP.h"


@implementation AutoWP

- (NSString *) SendAutoWP: (NSString *) login password: (NSString *) pass url: (NSString *) dir text: (NSString *) message; {
	
	//Message setup
	CFReadStreamRef streamSMS;
	NSString * resultado;
	CFHTTPMessageRef requestmsg;
	NSURL * urlcopiagenda = [NSURL URLWithString:@"http://open.movilforum.com/apis/autowap"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlcopiagenda, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("open.movilforum.com"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	NSString * bodyData = [NSString stringWithFormat:@"TME_USER=%@&TME_PASS=%@&WAP_Push_URL=%@&WAP_Push_Text=%@", login, pass, dir, message];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
    CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	//Stream setup
	streamSMS = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, requestmsg);
    CFRelease(requestmsg);
	
	if (!streamSMS) {
		resultado = [NSString stringWithFormat:@"Error to create the stream"];
		CFRelease(streamSMS);
		streamSMS=NULL;
		return resultado;
	}
	
	//Send the message 
	if (!CFReadStreamOpen(streamSMS)) {
		CFRelease(streamSMS);
		streamSMS = NULL;
		resultado = [NSString stringWithFormat:@"Error at open the stream"];
		return resultado;
	}
	
	//Check the response
	BOOL done = FALSE;
	
	while (!done) {
		if (CFReadStreamHasBytesAvailable(streamSMS)) {
			UInt8 buf[1024];
			CFIndex bytesRead = CFReadStreamRead(streamSMS, buf, sizeof(buf));
			if (bytesRead < 0) {
				CFStreamError error = CFReadStreamGetError(streamSMS);
				resultado = [NSString stringWithFormat:@"An error occurred Domain: %d Code: %d",error.domain, error.error];
				done = TRUE;
			//} else if (bytesRead == 0) {
			//	done = TRUE;
			} else {
				resultado = [NSString stringWithCString: (char*)buf length: bytesRead];
				done = TRUE;
			}
		}
	}
	
	CFRelease(streamSMS);
	streamSMS = NULL;
	
	return resultado;
}

@end
