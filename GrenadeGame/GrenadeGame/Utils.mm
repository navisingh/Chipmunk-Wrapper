//
//  Utils.mm
//
//  Created by Navi Singh on 3/4/11.
//  Copyright 2011 TheSinghs.org. All rights reserved.
//
#include <unistd.h>

#import "Utils.h"


void _DebugLog(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
	va_list ap;
	
	va_start (ap, format);
	if (![format hasSuffix: @"\n"]) {
		format = [format stringByAppendingString: @"\n"];
	}
	NSString *body =  [[NSString alloc] initWithFormat: format arguments: ap];
	va_end (ap);
	const char *threadName = [[[NSThread currentThread] name] UTF8String];
	NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
	if (threadName) {
		fprintf(stderr,"%s/%s (%s:%d) %s",threadName,funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
	} else {
		fprintf(stderr,"%p/%s (%s:%d) %s",[NSThread currentThread],funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
	}
	[body release];	
}


void saveNSLogToFile()
{
	//Neat way to send NSLog output to a log file in the device.  The file can then be sent to the developer.
	freopen([pathInDocumentDirectory(@"app.log") cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
//made into a nice class.

#define USE_DATE_FOR_LOGFILENAME
SaveNSLog::SaveNSLog(bool append, NSString *path)
{
	if (path == nil) 
	{
#ifndef USE_DATE_FOR_LOGFILENAME
		NSString *filename = @"app.log";
#else
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"yyyy-MM-dd"];
		NSDate *now = [[NSDate alloc] init];
		NSString *theDate = [dateFormat stringFromDate:now];
		
		NSString *filename =[NSString stringWithFormat:@"%@.log",theDate];	
#endif
		path = pathInDocumentDirectory(filename); 
	}
	
	stdErrSave = dup(STDERR_FILENO);
	freopen([path cStringUsingEncoding:NSASCIIStringEncoding],append ? "a+" : "w",stderr);
}

SaveNSLog::~SaveNSLog()
{
	fflush(stderr);
	dup2(stdErrSave, STDERR_FILENO);
	close(stdErrSave);
}

DeleteNSLog::DeleteNSLog(NSString *path)
{
#ifndef USE_DATE_FOR_LOGFILENAME 
	if (path == nil) 
	{
		NSString *filename = @"app.log";
		path = pathInDocumentDirectory(filename);
	}
	[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
#else
	NSArray *dd = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docsDir = [dd objectAtIndex:0];
	NSError *error;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsDir error:&error];
	for (NSString *file in files) {
		if ([file.pathExtension compare:@"log" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
			NSString *path = [docsDir stringByAppendingPathComponent:file];
			[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
		}
	}
#endif
}

NSString *pathInDocumentDirectory(NSString *fileName){
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:fileName];
}

bool isIPad()
{
	UIUserInterfaceIdiom idiom = UI_USER_INTERFACE_IDIOM();
	if (idiom == UIUserInterfaceIdiomPad) //ipad
		return true;
	return false;
}

