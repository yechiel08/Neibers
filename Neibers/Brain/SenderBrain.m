//
//  SenderBrain.m
//  iBabySitter
//
//  Created by Yechiel Amar on 02/07/12.
//  Copyright (c) 2012 yramar08@gmail.com. All rights reserved.
//

#import "SenderBrain.h"
#import "NSString (MD5).h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"

#define REGISTRATION_FILE_NAME @"userdata.plist"
#define DEVICE_FILE_NAME @"deviceFiles.plist"
#define NEW_USER_FILE_NAME @"newUserFiles.plist"

@implementation SenderBrain

+ (NSString *)MD5String {
    
    // Create pointer to the string as UTF8
    const char *cstr = [self.superclass UTF8String];
    
    
 	// Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
	// Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(cstr, strlen(cstr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
		[output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

+(NSString *)getUDID{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"udid"]){
        return [userDefaults objectForKey:@"udid"];
    }
    
    NSString *uniqueIdentifier;
//    UIDevice *myDevice=[UIDevice currentDevice];
//    NSString *systemVersion=[myDevice systemVersion];
//    if ([[systemVersion substringToIndex:1]intValue]<5){
        uniqueIdentifier=[OpenUDID value];
//    }else{
//        //uniqueIdentifier = [UIDevice currentDevice].uniqueIdentifier;
//        CFUUIDRef uuid = CFUUIDCreate(NULL);
//        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
//        CFRelease(uuid);
//        //        (__bridge NSString *) uuidStr;
//        uniqueIdentifier=(__bridge NSString *) uuidStr;
//        NSLog(@"ios>=5 %@",uniqueIdentifier);
//    }
    NSLog(@"UDID is !%@!",uniqueIdentifier);
    
    [userDefaults setObject:uniqueIdentifier forKey:@"udid"];
    [userDefaults synchronize];
    
    return uniqueIdentifier;
}

+(void)addToken:(NSString *)tokenData{
    NSString *deviceToken = [NSString stringWithFormat:@"%@",tokenData];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    else {
        //        NSLog(@"no file NEW_USER_FILE_NAME");
        firstTimeDic = [[NSMutableDictionary alloc] init];
    }
    
    NSString *deviceUniqueIdentifierString=[OpenUDID value];
    NSLog(@"DEVICE UDID: %@",deviceUniqueIdentifierString);
    NSString *deviceTypeString = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] model]];
//    deviceTypeString = [deviceTypeString stringByReplacingOccurrencesOfString:@" " withString:@"++"];
    deviceTypeString = [deviceTypeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *deviceOperatingSystemString = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
    [firstTimeDic setObject:deviceUniqueIdentifierString forKey:KEY_DEVICE_UDID];
    [firstTimeDic setObject:deviceOperatingSystemString forKey:KEY_OPERATING_SYSTEM];
    [firstTimeDic setObject:deviceTypeString forKey:KEY_DEVICE_TYPE_NAME];
    [firstTimeDic setObject:deviceToken forKey:KEY_DEVICE_TOKEN];
    
    [firstTimeDic writeToFile:path atomically:YES];
}

+(void)addToken:(NSString *)tokenData :(NSString *)userID
/*  the method set in the file DEVICE_FILE_NAME the UDID and token and tye of the device (iphone or ipad)

*/
{
    
    if ((!tokenData)) {
        NSLog(@" nil recived");
        return;
    }
    
    
    NSString *deviceToken = [NSString stringWithFormat:@"%@",tokenData];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    else {
//        NSLog(@"no file NEW_USER_FILE_NAME");
        firstTimeDic = [[NSMutableDictionary alloc] init];
    }    
        
    NSString *str = [NSString stringWithFormat:@"%@%@", @"jdfy57yg4dgFGFGry533rtyhdfGTdfgdt345tythdFgdjkukiU",userID];
    NSLog(@"SIGNATURE MD5: %@", [str MD5String]);
    NSString *deviceMd5 = [str MD5String];
    NSString *deviceUniqueIdentifierString=[OpenUDID value];
    NSLog(@"DEVICE UDID: %@",deviceUniqueIdentifierString);
    NSString *deviceTypeString = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] model]];
//    deviceTypeString = [deviceTypeString stringByReplacingOccurrencesOfString:@" " withString:@"++"];
    deviceTypeString = [deviceTypeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *deviceOperatingSystemString = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
    [firstTimeDic setObject:deviceMd5 forKey:KEY_SIGNATURE_MD5];
    [firstTimeDic setObject:deviceUniqueIdentifierString forKey:KEY_DEVICE_UDID];
    [firstTimeDic setObject:deviceOperatingSystemString forKey:KEY_OPERATING_SYSTEM];
    [firstTimeDic setObject:deviceTypeString forKey:KEY_DEVICE_TYPE_NAME];
    [firstTimeDic setObject:deviceToken forKey:KEY_DEVICE_TOKEN];
    
    [firstTimeDic writeToFile:path atomically:YES];
}



+(BOOL)isItFirstTimeApplicationRunInTheDevice
/*  the method check if the it the first time the applicaiton is running in the decive.
If it is the first Time it save it, and the next tiem it will say itsn't the first time
return: YES it is the first time (next time it will be NO)
NO it isn't the first time
*/
{
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        if ([[firstTimeDic objectForKey:KEY_FIRST_TIME] isEqualToString:IT_IS_NOT_FIRST_TIME])
        {
//            NSLog(@"it isn't the first time");
            return NO; //it isn't the first time
        }
        else{
            [firstTimeDic setObject:IT_IS_FIRST_TIME forKey:KEY_FIRST_TIME];
            [firstTimeDic writeToFile:path atomically:YES];
            return YES;
        }
    }
    else {
//        NSLog(@"it is the first time");
        firstTimeDic = [[NSMutableDictionary alloc] init];
        [firstTimeDic setObject:IT_IS_FIRST_TIME forKey:KEY_FIRST_TIME];
        [firstTimeDic writeToFile:path atomically:YES];
        return  YES;
    }
}

+(BOOL)isItNotFirstTimeApplicationRunInTheDevice
/*  the method check if the it the first time the applicaiton is running in the decive.
If it is the first Time it save it, and the next tiem it will say itsn't the first time
return: YES it is the first time (next time it will be NO)
NO it isn't the first time
*/
{
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        if ([[firstTimeDic objectForKey:KEY_FIRST_TIME] isEqualToString:IT_IS_NOT_FIRST_TIME]){
            //            NSLog(@"it isn't the first time");
            [firstTimeDic setObject:IT_IS_NOT_FIRST_TIME forKey:KEY_FIRST_TIME];
            [firstTimeDic writeToFile:path atomically:YES];
            return NO; //it isn't the first time
        }
        else{
            [firstTimeDic setObject:IT_IS_FIRST_TIME forKey:KEY_FIRST_TIME];
            [firstTimeDic writeToFile:path atomically:YES];
            return YES;
        }
    }
    else {
        firstTimeDic = [[NSMutableDictionary alloc] init];
        NSLog(@"it is the first time");
        [firstTimeDic setObject:IT_IS_FIRST_TIME forKey:KEY_FIRST_TIME];
        [firstTimeDic writeToFile:path atomically:YES];
        return YES;
    }
}

+(NSMutableString *) AddNewUser: (int) login : (NSString *)userID
{
    NSMutableString *stringToSend = [[NSMutableString alloc] init];

//    if (![SenderBrain isCanSendInfoAboutDevice]) {
//        NSLog(@"can't send info");
//        [stringToSend appendFormat:@"can't send info"];
//        return stringToSend;   
//    }
    [SenderBrain addToken:appDelegate.deviceTokenSingture :userID];
    
    NSMutableDictionary *userProfileDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *pathsUser = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathUser=[NSString stringWithFormat:@"%@/%@",[pathsUser objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:pathUser]){
        userProfileDic = [[NSMutableDictionary alloc] initWithContentsOfFile:pathUser];
    }
    else {
        //        NSLog(@"no file NEW_USER_FILE_NAME");
        userProfileDic = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    

    //checking for exist of the user data as NEW_USER_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    else {
        //        NSLog(@"no file NEW_USER_FILE_NAME");
        firstTimeDic = [[NSMutableDictionary alloc] init];
    }
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
//        NSLog(@"screenSizeWidth: %f",screenSize.width);
//        NSLog(@"screenSizeHeight: %f",screenSize.height);
        
//        [stringToSend appendFormat:@"%@",PGN_SERVER_URL];
//        if (login == 0) {
//            [stringToSend appendFormat:@"%@",PGN_COMMAND_NEW_FACEBOOK_TWITTR];
//        }else if (login == 1) {
//            [stringToSend appendFormat:@"%@",PGN_COMMAND_NEW_FACEBOOK_TWITTR];
//        }else if (login == 2) {
//            [stringToSend appendFormat:@"%@",PGN_COMMAND_NEW_EMAIL_USER];
//        }
//        [stringToSend appendFormat:@"%@",PGN_COMMAND_EXT];
        
        [stringToSend appendFormat:@"%@=%@",URL_SIGNATURE_MD5,[firstTimeDic objectForKey:KEY_SIGNATURE_MD5]];
        [stringToSend appendFormat:@"&%@=%@",URL_DEVICE_ID,[firstTimeDic objectForKey:KEY_DEVICE_UDID]];
        [stringToSend appendFormat:@"&clientResolutionWidth=%f", screenSize.width];
        [stringToSend appendFormat:@"&clientResolutionHeight=%f", screenSize.height];        
        [stringToSend appendFormat:@"&%@=%@",URL_OPERATING_SYSTEM,[firstTimeDic objectForKey:KEY_OPERATING_SYSTEM]];
        [stringToSend appendFormat:@"&%@=%@",URL_DEVICE_TYPE_NAME,[firstTimeDic objectForKey:KEY_DEVICE_TYPE_NAME]];
        [stringToSend appendFormat:@"&%@=%@",URL_DEVICE_TOKEN,[firstTimeDic objectForKey:KEY_DEVICE_TOKEN]];
        [stringToSend appendFormat:@"&GoogleID=%@", @""];
        [stringToSend appendFormat:@"&FaceBookID=%@", @""];
        
//        NSLog(@"DEBUG !%@! link to send",stringToSend);
        
//        NSURL *urlOfTheServer = [NSURL URLWithString:stringToSend];
//        NSError *error = nil;
//        
//        NSString *returnString = [NSString stringWithContentsOfURL:urlOfTheServer encoding:NSUTF8StringEncoding error:&error];
//        NSString *accessTokenString = [NSString stringWithFormat:@"%@", returnString];
//        [firstTimeDic setObject:accessTokenString forKey:KEY_ACCESS_TOKEN];
//        
//        [firstTimeDic writeToFile:path atomically:YES];
//        NSLog(@"accessToken: %@",returnString);
        
//        NSLog(@"accessToken: %@",accessTokenString);
    return stringToSend;
}

+(void) UpdateUserReFreshDeviceToken
{
    if (![SenderBrain isCanSendInfoAboutDevice]) {
        NSLog(@"can't send info");
        return;   
    }
    
    NSMutableDictionary *newUserDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *pathsUser = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathUser=[NSString stringWithFormat:@"%@/%@",[pathsUser objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as NEW_USER_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:pathUser]){
        newUserDic = [[NSMutableDictionary alloc] initWithContentsOfFile:pathUser];
    }
    else {
        //        NSLog(@"no file NEW_USER_FILE_NAME");
        newUserDic = [[NSMutableDictionary alloc] init];
    }

    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
        
    //checking for exist of the user data as NEW_USER_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    else {
        //        NSLog(@"no file NEW_USER_FILE_NAME");
        firstTimeDic = [[NSMutableDictionary alloc] init];
    }
    NSString *deviceToken = [NSString stringWithFormat:@"%@",appDelegate.deviceTokenSingture];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSMutableString *stringToSend = [[NSMutableString alloc] init];
        
    [stringToSend appendFormat:@"%@",NEIBERS_SERVER_URL];
    [stringToSend appendFormat:@"%@",PGN_COMMAND_REFRESH_DEVICE];
    [stringToSend appendFormat:@"%@",PGN_COMMAND_EXT];
    
    [stringToSend appendFormat:@"%@=%@",URL_ACCESSTOKEN,[newUserDic objectForKey:KEY_ACCESS_TOKEN]];
    [stringToSend appendFormat:@"&%@=%@",URL_DEVICE_ID,[firstTimeDic objectForKey:KEY_DEVICE_UDID]];
    [stringToSend appendFormat:@"&%@=%@",URL_DEVICE_TOKEN,[firstTimeDic objectForKey:KEY_DEVICE_TOKEN]];
    [stringToSend appendFormat:@"&latitude=%@",appDelegate.lat];
    [stringToSend appendFormat:@"&longitude=%@",appDelegate.longt];
        
        NSLog(@"DEBUG !%@! link to send",stringToSend);
    
        NSURL *urlOfTheServer = [NSURL URLWithString:stringToSend];
        NSError *error = nil;
        
        NSString *returnString = [NSString stringWithContentsOfURL:urlOfTheServer encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"%@",returnString);
    returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([returnString isEqualToString:@"DeviceToken Changed"]) {   //DeviceToken Successfully changed
            NSLog(@"DeviceToken Changed");
        }
        else if ([returnString isEqualToString:@"DeviceToken Is The Same"]) { //DeviceToken Not changed
            NSLog(@"DeviceToken Is The Same");
        }
        else if ([returnString isEqualToString:@"DeviceID Does not exist"]) { //DeviceID Not exists
//            [SenderBrain AddNewUser];
            NSLog(@"DeviceID Does not exist");
//            [SenderBrain UpdateUserReFreshDeviceToken];
        }
        else {
            
        }
}

+(void) UpdateUserUpdateUser
{
    return;    
}

+(NSString *) UpdateNewUser: (NSString *)emailText : (NSString *)passwordText : (NSString *)nameText : (NSData *)image : (int)Status{
    
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as NEW_USER_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    else {
//        NSLog(@"no file NEW_USER_FILE_NAME");
        firstTimeDic = [[NSMutableDictionary alloc] init];
    }    
    
    NSString *email = emailText;
//    email = [email stringByReplacingOccurrencesOfString:@" " withString:@"++"];
//    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = passwordText;
//    password = [password stringByReplacingOccurrencesOfString:@" " withString:@"++"];
//    password = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *name = nameText;
//    name = [name stringByReplacingOccurrencesOfString:@" " withString:@"++"];
//    name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"image size: %d",[image length]);
    [firstTimeDic setObject:email forKey:KEY_USER_NAME];
    [firstTimeDic setObject:password forKey:KEY_PASSWORD];
    [firstTimeDic setObject:name forKey:KEY_FULLNAME];
    [firstTimeDic writeToFile:path atomically:YES];

    [firstTimeDic setObject:image forKey:KEY_SMALL_IMAGE];    
    [firstTimeDic writeToFile:path atomically:YES];

    if (Status == 0) {
        return [SenderBrain SendNewUser:email];
    } else if (Status == 1){
        return [SenderBrain updateUser];
    } else{
        return @"Not Vaild";
    }
}

+(NSString *)SendNewUser :(NSString *)userName
{
    [SenderBrain addToken:appDelegate.deviceTokenSingture :userName];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    NSMutableDictionary *firstTimeDic;
    NSString *status;
    NSMutableDictionary *userProfileDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *pathsDevice = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDevice=[NSString stringWithFormat:@"%@/%@",[pathsDevice objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:pathDevice]){
        userProfileDic = [[NSMutableDictionary alloc] initWithContentsOfFile:pathDevice];
    }
    else {
        //        NSLog(@"no file NEW_USER_FILE_NAME");
        userProfileDic = [[NSMutableDictionary alloc] init];
    }
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSData *imageSmallData = [firstTimeDic objectForKey:KEY_SMALL_IMAGE];
        
        // setting up the URL to post to
        NSString *url = [NSString stringWithFormat:@"http://neibers.org/Services/authenticateUser.php"];
        
        NSLog(@"UrlString: %@", url);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        NSMutableData *body = [NSMutableData data];
        
        //SIGNATURE_MD5
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",URL_SIGNATURE_MD5] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[userProfileDic objectForKey:KEY_SIGNATURE_MD5]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@=%@",URL_SIGNATURE_MD5,[userProfileDic objectForKey:KEY_SIGNATURE_MD5]);
        
        //DEVICE_ID
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",URL_DEVICE_ID] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[userProfileDic objectForKey:KEY_DEVICE_UDID]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@=%@",URL_DEVICE_ID,[userProfileDic objectForKey:KEY_DEVICE_UDID]);
        
        // clientResolutionWidth
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clientResolutionWidth\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%f",screenSize.width] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"clientResolutionWidth=%f",screenSize.width);
        
        // clientResolutionHeight
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"clientResolutionHeight\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%f",screenSize.height] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"clientResolutionHeight=%f",screenSize.height);
        
        //OPERATING_SYSTEM
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",URL_OPERATING_SYSTEM] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[userProfileDic objectForKey:KEY_OPERATING_SYSTEM]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@=%@",URL_OPERATING_SYSTEM,[userProfileDic objectForKey:KEY_OPERATING_SYSTEM]);
        
        //DEVICE_TYPE_NAME
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",URL_DEVICE_TYPE_NAME] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[userProfileDic objectForKey:KEY_DEVICE_TYPE_NAME]]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@=%@",URL_DEVICE_TYPE_NAME,[userProfileDic objectForKey:KEY_DEVICE_TYPE_NAME]);
        
        //DEVICE_TOKEN
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",URL_DEVICE_TOKEN] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[userProfileDic objectForKey:KEY_DEVICE_TOKEN]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@=%@",URL_DEVICE_TOKEN,[userProfileDic objectForKey:KEY_DEVICE_TOKEN]);
        
        //Full Name
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",URL_FULLNAME] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[firstTimeDic objectForKey:KEY_FULLNAME]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@=%@",URL_FULLNAME,[firstTimeDic objectForKey:KEY_FULLNAME]);
        
        //User Name
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",URL_USER_NAME] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[firstTimeDic objectForKey:KEY_USER_NAME]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@=%@",URL_USER_NAME,[firstTimeDic objectForKey:KEY_USER_NAME]);
        
        //image
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[@"Content-Disposition: form-data; name=\"ImageFile\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[NSData dataWithData:imageSmallData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        [request setHTTPMethod:@"POST"];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", returnString);
        returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([returnString isEqualToString:@"Missing Parameter"]) {   //DeviceToken Successfully changed
            NSLog(@"Missing Parameter");
            return @"Missing Parameter";
        }
        
        else if ([returnString isEqualToString:@"This email is already exist"]) { //DeviceID Not exists
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"eMail" message:@"User name already exists Please replace username or do login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            
            return @"UserName Exists";
        }
        else if ([returnString isEqualToString:@"invalid signature"]) { //DeviceToken Not changed
            return @"Not Valid";
        }
        else if ([returnString isEqualToString:@"Error occured"]) {
            return @"OK";
        }
        
        else if ([returnString isEqualToString:@"No Image"]) {
            return @"No Image";
        }
        
        else {
            
            // Create new SBJSON parser object
            SBJSON *parser = [[SBJSON alloc] init];
            
            //Print contents of json-string
            NSArray *authenticateUser = [parser objectWithString:returnString error:nil];

            if ([authenticateUser valueForKey:@"authenticateUser"]) {
                NSString *userAccessAndPass = [authenticateUser valueForKey:@"authenticateUser"];
                
                NSString *accessTokenString = [NSString stringWithFormat:@"%@", [userAccessAndPass valueForKey:@"accessToken"]];
                [firstTimeDic setObject:accessTokenString forKey:KEY_ACCESS_TOKEN];                
                
                [firstTimeDic writeToFile:path atomically:YES];
                
                // Prepare URL request
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://neibers.org/Services/getUserDetails.php?accessToken=%@",accessTokenString]]];
                
                // Perform request and get JSON back as a NSData object
                NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                // Get JSON as a NSString from NSData response
                NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                
                //Print contents of json-string
                NSArray *userDetils = [parser objectWithString:json_string error:nil];
                
                NSLog(@"%@",userDetils);

                appDelegate.userProfile = [userDetils valueForKey:@"getUserDetails"];
                
                [[NSUserDefaults standardUserDefaults] setValue:[appDelegate.userProfile valueForKey:@"mail"] forKey:@"Email"];
                [[NSUserDefaults standardUserDefaults] setValue:[appDelegate.userProfile valueForKey:@"name"] forKey:@"Name"];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@%@",NEIBERS_SERVER_URL,[appDelegate.userProfile valueForKey:@"image_path"]] forKey:@"Image Path"];
                //            [firstTimeDic setObject:[appDelegate.userProfileDetils valueForKey:@"IDUser"] forKey:@"IDUser"];
                //
                //            [firstTimeDic writeToFile:path atomically:YES];
                //
                //
                //            NSString *userName = [firstTimeDic objectForKey:KEY_USER_NAME];
                //            userName = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                //            NSString *name = [firstTimeDic objectForKey:KEY_FULLNAME];
                //            name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                //            NSString *phone = [firstTimeDic objectForKey:KEY_PHONE];
                //            phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                //            NSString *birthDate = [firstTimeDic objectForKey:KEY_BIRTH_DATE];
                //            birthDate = [birthDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                //
                //            [firstTimeDic setObject:userName forKey:KEY_USER_NAME];
                //            [firstTimeDic setObject:phone forKey:KEY_PHONE];
                //            [firstTimeDic setObject:name forKey:KEY_FULLNAME];
                //            [firstTimeDic setObject:birthDate forKey:KEY_BIRTH_DATE];
                //            
                //            [firstTimeDic writeToFile:path atomically:YES];
                
                returnString = @"AccessToken";
                //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"successfully registered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                // [alert show];
                return @"AccessToken";
            } else {
                return @"Error";
            }
        }
        status = returnString;
    }
    return status;
}

+(NSString *)updateUser
{
    NSMutableDictionary *firstTimeDic;
    
    NSString *status;

    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSData *imageSmallData = [firstTimeDic objectForKey:KEY_SMALL_IMAGE];
        NSLog(@"imageSmallData: %d", imageSmallData.length);
        // setting up the URL to post to
        NSString *url = [NSString stringWithFormat:@"http://neibers.org/Services/changeUserDetails.php"];
        
        NSLog(@"UrlString: %@", url);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        NSMutableData *body = [NSMutableData data];
        
        // accessToken
        NSString *accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"accessToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:accessToken] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"accessToken: %@",[NSString stringWithString:accessToken]);

        //User Name
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",URL_USER_NAME] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[firstTimeDic objectForKey:KEY_USER_NAME]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@: %@",URL_USER_NAME,[NSString stringWithFormat:@"%@",[firstTimeDic objectForKey:KEY_USER_NAME]]);

        //Full Name
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",URL_FULLNAME] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[firstTimeDic objectForKey:KEY_FULLNAME]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@: %@",URL_FULLNAME,[NSString stringWithFormat:@"%@",[firstTimeDic objectForKey:KEY_FULLNAME]]);

        //image
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[@"Content-Disposition: form-data; name=\"ImageFile\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[NSData dataWithData:imageSmallData]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        [request setHTTPMethod:@"POST"];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", returnString);
        returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([returnString isEqualToString:@"Missing Parameter"]) {   //DeviceToken Successfully changed
            return returnString;
        }
        else if ([returnString isEqualToString:@"Not Valid"]) { //DeviceToken Not changed
            return returnString;
        }
        else if ([returnString isEqualToString:@"OK"]) {
            
            // Create new SBJSON parser object
            SBJSON *parser = [[SBJSON alloc] init];
            
            // Prepare URL request
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://neibers.org/Services/getUserDetails.php?accessToken=%@",[firstTimeDic objectForKey:KEY_ACCESS_TOKEN]]]];

            NSLog(@"%@",request);
            // Perform request and get JSON back as a NSData object
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            // Get JSON as a NSString from NSData response
            NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            //Print contents of json-string
            NSArray *userDetils = [parser objectWithString:json_string error:nil];
            NSLog(@"%@",userDetils);

            appDelegate.userProfile = [userDetils valueForKey:@"getUserDetails"];

            [[NSUserDefaults standardUserDefaults] setValue:[appDelegate.userProfile valueForKey:@"mail"] forKey:@"Email"];
            [[NSUserDefaults standardUserDefaults] setValue:[appDelegate.userProfile valueForKey:@"name"] forKey:@"Name"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@%@",NEIBERS_SERVER_URL,[appDelegate.userProfile valueForKey:@"image_path"]] forKey:@"Image Path"];
//            [firstTimeDic setObject:[appDelegate.userProfileDetils valueForKey:@"IDUser"] forKey:@"IDUser"];
//
//            [firstTimeDic writeToFile:path atomically:YES];
//            
//            NSString *userName = [appDelegate.userProfileDetils valueForKey:@"userEmail"];
////            userName = [userName stringByReplacingOccurrencesOfString:@"++" withString:@" "];
////            userName = [userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            userName = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
////            NSString *password = [appDelegate.userProfileDetils valueForKey:@"userPassword"];
////            password = [password stringByReplacingOccurrencesOfString:@"++" withString:@" "];
////            password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            NSString *name = [appDelegate.userProfileDetils valueForKey:@"userFullName"];
////            name = [name stringByReplacingOccurrencesOfString:@"++" withString:@" "];
////            name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//
//            [firstTimeDic setObject:userName forKey:KEY_USER_NAME];
////            [firstTimeDic setObject:password forKey:KEY_PASSWORD];
////            [firstTimeDic setObject:birthDate forKey:KEY_BIRTH_DATE];
//            [firstTimeDic setObject:name forKey:KEY_FULLNAME];
//            
//            [firstTimeDic writeToFile:path atomically:YES];
//            
//            
//            NSString *stringEncodingUrl = [[appDelegate.userProfileDetils valueForKey:@"UserImage"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//            NSURL *Imageurl = [NSURL URLWithString:stringEncodingUrl];
//            NSData *data =  [NSData dataWithContentsOfURL:Imageurl];
//            [firstTimeDic setObject:data forKey:KEY_SMALL_IMAGE];
//            [firstTimeDic writeToFile:path atomically:YES];
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"The change save" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
            returnString = @"AccessToken";

            return returnString;
        }
        
        else if ([returnString isEqualToString:@"No Image"]) {
            return returnString;

        }
        
        else {
            return @"Erorr";
        }
        status = returnString;
    }
    return status;
}

+(NSString *) checkUser: (NSString *)userNameText{
   
    NSString *status;

        NSMutableString *stringToSend = [[NSMutableString alloc] init];
        
        [stringToSend appendFormat:@"%@=%@",URL_USER_NAME,userNameText];
//        NSLog(@"DEBUG !%@! link to send",stringToSend);
        
        NSString *post = stringToSend;
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://neibers.org/Services/userEmailExist.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSLog(@"%@", request);
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", returnString);
    returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([returnString isEqualToString:@"true"]) { //DeviceID Not exists
            
        } 
        else if ([returnString isEqualToString:@"false"]) {
            
        }
        else {
            
        }
        status = returnString;
    return status;
}

+(NSString *) changePassword: (NSString *)oldPasswordText : (NSString *)newPasswordText
{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    NSString *status;
    
    NSMutableString *stringToSend = [[NSMutableString alloc] init];
    
    [stringToSend appendFormat:@"%@=%@",URL_ACCESSTOKEN,accessToken];
    [stringToSend appendFormat:@"&oldPassword=%@",oldPasswordText];
    [stringToSend appendFormat:@"&newPassword=%@",newPasswordText];
    NSLog(@"DEBUG !%@! link to send",stringToSend);
    
    NSString *post = stringToSend;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://neibers.org/Services/changePassword.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"%@", request);
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
    returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([returnString isEqualToString:@"true"]) { //DeviceID Not exists
        
    }
    else if ([returnString isEqualToString:@"false"]) {
        
    }
    else {
        
    }
    status = returnString;
    return status;
}

+(NSString *) checkUser: (NSString *)userNameText : (NSString *)passwordText{
    NSMutableDictionary *firstTimeDic;
    NSString *status;
    [SenderBrain AddNewUser:2 :userNameText];

    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];

    //checking for exist of the user data as NEW_USER_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    else {
        //        NSLog(@"no file NEW_USER_FILE_NAME");
        firstTimeDic = [[NSMutableDictionary alloc] init];
    }
        
        NSMutableString *stringToSend = [[NSMutableString alloc] init];
    

        [stringToSend appendFormat:@"%@=%@",URL_USER_NAME,userNameText];
        [stringToSend appendFormat:@"&%@=%@",URL_PASSWORD,passwordText];
        
        [firstTimeDic setObject:userNameText forKey:KEY_USER_NAME];
        [firstTimeDic setObject:passwordText forKey:KEY_PASSWORD];
        
        [firstTimeDic writeToFile:path atomically:YES];
        
        NSLog(@"DEBUG !%@! link to send",stringToSend);
        NSString *post = stringToSend;
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://neibers.org/Services/signIn.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSLog(@"%@", request);

        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", returnString);
    returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([returnString isEqualToString:@"Missing Parameter"]) {   //DeviceToken Successfully changed
            
        }
        else if ([returnString isEqualToString:@"Error with your login"]) { //DeviceToken Not changed
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Email or password incorrect" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles: nil];
            [alert show];
        }
         
        else if([returnString length] >= 40){
            NSString *accessTokenString = [NSString stringWithFormat:@"%@", returnString];
            [firstTimeDic setObject:accessTokenString forKey:KEY_ACCESS_TOKEN];
            
            [firstTimeDic writeToFile:path atomically:YES];
            
            // Create new SBJSON parser object
            SBJSON *parser = [[SBJSON alloc] init];
            
            // Prepare URL request
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://neibers.org/Services/getUserDetails.php?accessToken=%@",accessTokenString]]];
            NSLog(@"%@", request);

            // Perform request and get JSON back as a NSData object
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            // Get JSON as a NSString from NSData response
            NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            //Print contents of json-string
            NSArray *userDetils = [parser objectWithString:json_string error:nil];
            
            NSLog(@"%@",userDetils);

            appDelegate.userProfile = [userDetils valueForKey:@"getUserDetails"];
//
            [[NSUserDefaults standardUserDefaults] setValue:[appDelegate.userProfile valueForKey:@"mail"] forKey:@"Email"];
            [[NSUserDefaults standardUserDefaults] setValue:[appDelegate.userProfile valueForKey:@"name"] forKey:@"Name"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@%@",NEIBERS_SERVER_URL,[appDelegate.userProfile valueForKey:@"image_path"]] forKey:@"Image Path"];
//            [firstTimeDic setObject:[appDelegate.userProfileDetils valueForKey:@"IDUser"] forKey:@"IDUser"];
//            
//            [firstTimeDic writeToFile:path atomically:YES];
////            [NSString stringWithUTF8String:[[appDelegate.userProfileDetils valueForKey:@"userEmail"] bytes]];
////            NSString *userName = [appDelegate.userProfileDetils valueForKey:@"userEmail"];
//            NSString *userName =[appDelegate.userProfileDetils valueForKey:@"userEmail"];
////            userName = [userName stringByReplacingOccurrencesOfString:@"++" withString:@" "];
////            userName = [userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            userName = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
////            NSString *password = [appDelegate.userProfileDetils valueForKey:@"userPassword"];
////            password = [password stringByReplacingOccurrencesOfString:@"++" withString:@" "];
////            password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            NSString *name = [appDelegate.userProfileDetils valueForKey:@"userFullName"];
////            name = [name stringByReplacingOccurrencesOfString:@"++" withString:@" "];
////            name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            NSString *phone = [appDelegate.userProfileDetils valueForKey:@"userPhone"];
////            phone = [phone stringByReplacingOccurrencesOfString:@"++" withString:@" "];
////            phone = [phone stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            NSString *birthDate = [appDelegate.userProfileDetils valueForKey:@"userBirthDate"];
////            birthDate = [birthDate stringByReplacingOccurrencesOfString:@"++" withString:@" "];
////            birthDate = [birthDate stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            birthDate = [birthDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            
//            [firstTimeDic setObject:userName forKey:KEY_USER_NAME];
////            [firstTimeDic setObject:password forKey:KEY_PASSWORD];
//            [firstTimeDic setObject:phone forKey:KEY_PHONE];
//            [firstTimeDic setObject:birthDate forKey:KEY_BIRTH_DATE];
//            [firstTimeDic setObject:name forKey:KEY_FULLNAME];
//            
//            [firstTimeDic writeToFile:path atomically:YES];
//            
//            NSString *stringEncodingUrl = [[appDelegate.userProfileDetils valueForKey:@"UserImage"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//            NSURL *Imageurl = [NSURL URLWithString:stringEncodingUrl];
//            NSData *data =  [NSData dataWithContentsOfURL:Imageurl];
//            [firstTimeDic setObject:data forKey:KEY_SMALL_IMAGE];
//            [firstTimeDic writeToFile:path atomically:YES];

//            NSLog(@"accessToken: %@",returnString);
            
//            NSLog(@"accessToken: %@",accessTokenString);
//            [SenderBrain UpdateUserReFreshDeviceToken];
            returnString = @"AccessToken";            
        }
        else{
            
        }
        status = returnString;
    return status;
}

+(void) PasswordRestore: (NSString *)userNameText {
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSMutableString *stringToSend = [[NSMutableString alloc] init];
        
        [stringToSend appendFormat:@"%@=%@",URL_USER_NAME,userNameText];
        NSLog(@"DEBUG !%@! link to send",stringToSend);
        
        NSString *post = stringToSend;
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://neibers.org/Services/passwordRestore.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSLog(@"%@", request);
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", returnString);
        returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([returnString isEqualToString:@"Missing Parameter"]) {   //DeviceToken Successfully changed
            
        }
        else if ([returnString isEqualToString:@"Not Exist"]) { //DeviceToken Not changed
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"email not exists" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if ([returnString isEqualToString:@"OK"] || ([returnString isEqualToString:@"\nOK"])) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"the password sent to your email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

+(void) sendPublishPhoto: (NSString *)userNameText : (NSData *)image {
    
    // setting up the URL to post to
    NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/photos",userNameText];
//    NSLog(@"DEBUG !https://graph.facebook.com/%@/photos?%@! link to send",userNameText,stringToSend);

    NSLog(@"UrlString: %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    NSMutableData *body = [NSMutableData data];
    
    // accessToken
    NSString *accessToken = [NSString stringWithFormat:@"%@",[FBSession activeSession].accessTokenData];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:accessToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Click to Movon (http://movon.co/)"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //image
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[@"Content-Disposition: form-data; name=\"picture\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:image]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [request setHTTPMethod:@"POST"];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", returnString);
    returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([returnString isEqualToString:@"Missing Parameter"]) {   //DeviceToken Successfully changed
//        return returnString;
    }
    else if ([returnString isEqualToString:@"Not Valid"]) { //DeviceToken Not changed
//        return returnString;
    }
    else if ([returnString isEqualToString:@"OK"]) {
        
    }
}

//+(void) sendPublishFeed: (NSString *)userNameText: (NSString *)headlineText: (NSString *)linkImageText {
//    NSMutableDictionary *firstTimeDic;
//    
//    //found the path of DEVICE_FILE_NAME
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
//    
//    //checking for exist of the user data as DEVICE_FILE_NAME
//    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
//        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
//        NSMutableString *stringToSend = [[NSMutableString alloc] init];
//        
//        [stringToSend appendFormat:@"access_token=%@",appDelegate.session.accessToken];
//        [stringToSend appendFormat:@"&description=קבלו דיל חדש מבית Pricer"];
//        [stringToSend appendFormat:@"&picture=%@",linkImageText];
//        [stringToSend appendFormat:@"&link=%@",@""];
//        [stringToSend appendFormat:@"&name=%@",headlineText];
//        NSLog(@"DEBUG !https://graph.facebook.com/%@/feed?%@! link to send",userNameText,stringToSend);
//        
//        NSString *post = stringToSend;
//        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//        
//        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/feed",userNameText]]];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody:postData];
//        
//        //        NSLog(@"%@", request);
//        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", returnString);
//        
//        if ([returnString isEqualToString:@"Missing Parameter"]) {   //DeviceToken Successfully changed
//            
//        }
//        else if ([returnString isEqualToString:@"Not Exists"]) { //DeviceToken Not changed
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"email not exists" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//        else if ([returnString isEqualToString:@"OK"]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"the password sent to your email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//        else {
//            
//        }
//    }
//}

+(void) sendPublishFeed: (NSString *)userNameText {
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSMutableString *stringToSend = [[NSMutableString alloc] init];
        
        [stringToSend appendFormat:@"access_token=%@",[FBSession activeSession].accessTokenData];
        [stringToSend appendFormat:@"&description=Watch my new movie on MoVoN! Download it NOW for Free! \n http://movon.co/"];
        [stringToSend appendFormat:@"&picture=%@",@""];
        [stringToSend appendFormat:@"&link=%@",@"http://movon.co/"];
        [stringToSend appendFormat:@"&name=Movon"];
        NSLog(@"DEBUG !https://graph.facebook.com/%@/feed?%@! link to send",userNameText,stringToSend);
        
        NSString *post = stringToSend;
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/feed",userNameText]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        //        NSLog(@"%@", request);
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", returnString);
        returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([returnString isEqualToString:@"Missing Parameter"]) {   //DeviceToken Successfully changed
            
        }
        else if ([returnString isEqualToString:@"Not Exists"]) { //DeviceToken Not changed
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"email not exists" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if ([returnString isEqualToString:@"OK"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"the password sent to your email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else {
            
        }
    }
}

+(NSArray *)getUserFaceBook{
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    
    
    
    
    NSString *stringUrl = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@",
                           FBSession.activeSession.accessTokenData];
    NSLog(@"%@",stringUrl);
    
    NSString* escapedUrlString = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    NSLog(@"%@",url);
    
    // Prepare URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",request);
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    
    return catagory;
}
//_numberTypeLabel
+(NSString *)setNewCommunity:(NSString *)numberType : (NSString *)type : (NSString *)name : (NSString *)address : (NSString *)Description : (NSString *)link : (NSString *)openCloseCommunity : (NSString *)lat : (NSString *)lon : (NSData *)image
{
    NSMutableDictionary *firstTimeDic;
    
    NSString *status;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        // setting up the URL to post to
        NSString *url = [NSString stringWithFormat:@"http://neibers.org/Services/setNewCommunity.php"];
        
        NSLog(@"UrlString: %@", url);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        NSMutableData *body = [NSMutableData data];
        
        // accessToken
        NSString *accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"accessToken\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:accessToken] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"accessToken: %@",[NSString stringWithString:accessToken]);
        
        //numberType
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"numberType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",numberType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"numberType: %@",[NSString stringWithFormat:@"%@",numberType]);
        
        //type
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",type] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"type: %@",[NSString stringWithFormat:@"%@",type]);
        
        //name
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",name] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"name: %@",[NSString stringWithFormat:@"%@",name]);
        
        //address
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",address] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"address: %@",[NSString stringWithFormat:@"%@",address]);
        
        //Description
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",Description] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Description: %@",[NSString stringWithFormat:@"%@",Description]);
        
        //link
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"link\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",link] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"link: %@",[NSString stringWithFormat:@"%@",link]);
        
        //openCloseCommunity
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"openCloseCommunity\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",openCloseCommunity] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"openCloseCommunity: %@",[NSString stringWithFormat:@"%@",openCloseCommunity]);
        
        //lat
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lat\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",lat] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"lat: %@",[NSString stringWithFormat:@"%@",lat]);
        
        //lon
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lon\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",lon] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"lon: %@",[NSString stringWithFormat:@"%@",lon]);
        
        //image
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[@"Content-Disposition: form-data; name=\"ImageFile\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:image]];
        NSLog(@"image: %d",[image length]);

        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        [request setHTTPBody:body];
        
        [request setHTTPMethod:@"POST"];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", returnString);
        returnString = [returnString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([returnString isEqualToString:@"Missing Parameter"]) {   //DeviceToken Successfully changed
            return returnString;
        }
        else if ([returnString isEqualToString:@"Not Valid"]) { //DeviceToken Not changed
            return returnString;
        }
        else if ([returnString isEqualToString:@"OK"]) {
            
            return returnString;
        }
        
        else if ([returnString isEqualToString:@"No Image"]) {
            return returnString;
            
        }
        
        else {
            return @"Erorr";
        }
        status = returnString;
    }
    return status;
}

+(NSArray *)getMapCommunity{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    
    // Prepare URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://neibers.org/Services/getMapCommunity.php"]]];
    
    NSLog(@"%@",request);
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    json_string = [json_string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    
    return [catagory valueForKey:@"getMapCommunity"];
}


+(NSArray *) getMyCommunity{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://neibers.org/Services/getMyCommunity.php?accessToken=%@",accessToken];
    NSLog(@"%@",stringUrl);
    
    NSString* escapedUrlString = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    NSLog(@"%@",url);
    
    // Prepare URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",request);
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    json_string = [json_string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    
    return [catagory valueForKey:@"getMyCommunity"];
}

+(NSString *) RemoveFromFavorites: (NSString *)idMovOn{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    NSString *status;
    
    NSMutableString *stringToSend = [[NSMutableString alloc] init];
    
    [stringToSend appendFormat:@"%@=%@",URL_ACCESSTOKEN,accessToken];
    [stringToSend appendFormat:@"&MovOnID=%@",idMovOn];
    NSLog(@"http://movon.co/Services/RemoveFromFavorites.asp?%@! link to send",stringToSend);
    
    NSString *post = stringToSend;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://movon.co/Services/RemoveFromFavorites.asp"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
    
    if ([returnString isEqualToString:@"OK"]) { //DeviceID Not exists
        
    }
    else if ([returnString isEqualToString:@"Not Valid"]) {
        
    }
    else {
        
    }
    status = returnString;
    return status;
}

+(NSString *) RemoveMovon: (NSString *)idMovOn{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    NSString *status;
    
    NSMutableString *stringToSend = [[NSMutableString alloc] init];
    
    [stringToSend appendFormat:@"%@=%@",URL_ACCESSTOKEN,accessToken];
    [stringToSend appendFormat:@"&IDMov=%@",idMovOn];
    NSLog(@"http://movon.co/Services/RemoveMovOn.asp?%@! link to send",stringToSend);
    
    NSString *post = stringToSend;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://movon.co/Services/RemoveMovOn.asp"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
    
    if ([returnString isEqualToString:@"OK"]) { //DeviceID Not exists
        
    }
    else if ([returnString isEqualToString:@"Not Valid"]) {
        
    }
    else {
        
    }
    status = returnString;
    return status;
}

+(NSString *) FlagMovon: (NSString *)idMovOn :(NSString *)IDReason{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    NSString *status;
    
    NSMutableString *stringToSend = [[NSMutableString alloc] init];
    
    [stringToSend appendFormat:@"%@=%@",URL_ACCESSTOKEN,accessToken];
    [stringToSend appendFormat:@"&IDMov=%@",idMovOn];
    [stringToSend appendFormat:@"&IDReason=%@",IDReason];
    NSLog(@"http://movon.co/Services/FlagMovOn.asp?%@! link to send",stringToSend);
    
    NSString *post = stringToSend;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://movon.co/Services/FlagMovOn.asp"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
    
    if ([returnString isEqualToString:@"OK"]) { //DeviceID Not exists
        
    }
    else if ([returnString isEqualToString:@"Not Valid"]) {
        
    }
    else {
        
    }
    status = returnString;
    return status;
}

+(NSArray *)getMovFavoritesList {
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://movon.co/Services/getMovFavoritesList.asp?accessToken=%@",accessToken];
    NSLog(@"%@",stringUrl);
    
    NSString* escapedUrlString = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    NSLog(@"%@",url);
    
    // Prepare URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",request);
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    
    return [catagory valueForKey:@"getMovFavoritesList"];
}

+(NSArray *)getMovUserList:(NSString *)userId{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://movon.co/Services/getMovUserList.asp?accessToken=%@&UserID=%@",accessToken,userId];
    NSLog(@"%@",stringUrl);
    
    NSString* escapedUrlString = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    NSLog(@"%@",url);
    
    // Prepare URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",request);
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    
    return [catagory valueForKey:@"getMovUserList"];
}

+(NSArray *)getMovDetails:(NSString *)IDMov{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://movon.co/Services/getMovDetails.asp?accessToken=%@&IDMov=%@",accessToken,IDMov];
    NSLog(@"%@",stringUrl);
    
    NSString* escapedUrlString = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    NSLog(@"%@",url);
    
    // Prepare URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",request);
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    
    return [catagory valueForKey:@"getMovDetails"];
}

+(NSArray *)getMovMainList:(NSString *)mode :(NSString *)pageId :(NSString *)Src{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    NSMutableString *stringToSend = [[NSMutableString alloc] init];
    
    [stringToSend appendFormat:@"%@=%@",URL_ACCESSTOKEN,accessToken];
    [stringToSend appendFormat:@"&Mode=%@",mode];
    [stringToSend appendFormat:@"&Page=%@",pageId];
    if (!StringIsNilOrEmpty(Src)) {
        NSString *src = Src;
        //    param = [param stringByReplacingOccurrencesOfString:@" " withString:@"++"];
        src = [src stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        src = [src stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [stringToSend appendFormat:@"&Src=%@",src];
    }
    NSLog(@"http://movon.co/Services/getMovMainList.asp?%@! link to send",stringToSend);
    
    NSString *post = stringToSend;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://movon.co/Services/getMovMainList.asp"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
        
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];

    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    NSLog(@"getMovMainList: %@",[catagory valueForKey:@"getMovMainList"]);
    return [catagory valueForKey:@"getMovMainList"];
}

+(NSMutableArray *)getUserList:(NSString *)src{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://movon.co/Services/getUserList.asp?accessToken=%@&Src=%@",accessToken,src];
    NSLog(@"%@",stringUrl);
    
    NSString* escapedUrlString = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    NSLog(@"%@",url);
    
    // Prepare URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",request);
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    
    return [catagory valueForKey:@"getUserList"];
}

+(NSMutableArray *)getTagsList:(NSString *)src{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://movon.co/Services/getTagsList.asp?accessToken=%@&Src=%@",accessToken,src];
    NSLog(@"%@",stringUrl);
    
    NSString* escapedUrlString = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:escapedUrlString];
    NSLog(@"%@",url);
    
    // Prepare URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@",request);
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    
    return [catagory valueForKey:@"getTagsList"];
}

+(NSString *) setMovData: (NSString *)IDMov : (NSString *)actionType : (NSString *)paramValue : (NSString *)paramValue2{
    
    
    
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    NSString *status;
    
    NSMutableString *stringToSend = [[NSMutableString alloc] init];
    
    
    
    
    
    NSString *param = paramValue;
    
    if ([paramValue isEqualToString:@""]) { 
        paramValue=@"^^^";
        NSLog(@"in 'if'====%@",paramValue);
        param=@"^^^";
    }
    

    
//    param = [param stringByReplacingOccurrencesOfString:@" " withString:@"++"];
    param = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    param = [param stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [stringToSend appendFormat:@"%@=%@",URL_ACCESSTOKEN,accessToken];
    [stringToSend appendFormat:@"&IDMov=%@",IDMov];
    [stringToSend appendFormat:@"&ActionType=%@",actionType];
    [stringToSend appendFormat:@"&ParamValue=%@",param];

    NSLog(@"paramValue====%@",param);
    NSLog(@"paramValue====%@",param);
    NSLog(@"stringToSend====%@",stringToSend);
    
    
    
    
    
    
    
    
    if (!StringIsNilOrEmpty(paramValue2)) {
        [stringToSend appendFormat:@"&ParamValue2=%@",paramValue2];
    }
    NSLog(@"http://movon.co/Services/setMovData.asp?%@! link to send",stringToSend);
    
    NSString *post = stringToSend;
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://movon.co/Services/setMovData.asp"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
    
    if ([returnString isEqualToString:@"true"]) { //DeviceID Not exists
        
    }
    else if ([returnString isEqualToString:@"false"]) {
        
    }
    else {
        
    }
    status = returnString;
    return status;
}

+(NSArray *)getCommentsList: (NSString *)IDMov{
    NSMutableDictionary *firstTimeDic;
    NSString *accessToken = [[NSString alloc] init];
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        accessToken = [firstTimeDic objectForKey:KEY_ACCESS_TOKEN];
    }
    
    // Create new SBJSON parser object
    SBJSON *parser = [[SBJSON alloc] init];
    
    // Prepare URL request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://movon.co/Services/getCommentsList.asp?accessToken=%@&IDMov=%@",accessToken,IDMov]]];
    
    NSLog(@"%@",request);
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    if (response != nil) {
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //Print contents of json-string
    NSArray *catagory = [parser objectWithString:json_string error:nil];
    
    return [catagory valueForKey:@"getDealsList"];
}

+(void)setPushNotificationEnable
{
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [firstTimeDic setObject:ENABLE_PUSH_NOTIFICATION forKey:KEY_PUSH_NOTIFICATION];
        [firstTimeDic writeToFile:path atomically:YES];
    }
}

+(void)setNoPushNotificationEnable
{
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [firstTimeDic setObject:DISABLE_PUSH_NOTIFICATION forKey:KEY_PUSH_NOTIFICATION];
        [firstTimeDic writeToFile:path atomically:YES];
    }
}

+(BOOL)isPushNotificaitonEnable
/*  the funciton check if push notificaiton is enable in the dictionery of th e file DEVICE_FILE_NAME
return YES if there a push notificaiton enable
NO otherwise
*/
{
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        if ([[firstTimeDic objectForKey:KEY_PUSH_NOTIFICATION] isEqualToString:ENABLE_PUSH_NOTIFICATION]) {
            return YES;
        }
        [firstTimeDic setObject:DISABLE_PUSH_NOTIFICATION forKey:KEY_PUSH_NOTIFICATION];
        //  [firstTimeDic writeToFile:path atomically:YES];
    }
    return NO;
}

+(void)createFileIfNeeded
/* this function creat the file DEVICE_FILE_NAME if it isn't exist

*/
{
    NSMutableDictionary *firstTimeDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for unexisting of the  DEVICE_FILE_NAME
    if (!([[NSFileManager defaultManager]fileExistsAtPath:path])){
        firstTimeDic = [[NSMutableDictionary alloc] init];
        [firstTimeDic writeToFile:path atomically:YES];
    }
    
    
}

+(BOOL)isCanSendInfoAboutDevice
/*  the method check if there a UDID and token in the DEVICE_FILE_NAME
if all ok it return YES
otherwise NO
*/
{
    NSMutableDictionary *firstTimeDic;
    //found the path of DEVICE_FILE_NAME
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],DEVICE_FILE_NAME];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
        firstTimeDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
        if ([firstTimeDic objectForKey:KEY_DEVICE_TOKEN]==nil) {
            return NO;
        }
        if ([[firstTimeDic objectForKey:KEY_DEVICE_TOKEN] isEqualToString:@""]) {
            return NO;
        }
        
        if ([firstTimeDic objectForKey:KEY_DEVICE_UDID]==nil) {
            return NO;
        }
        /*        if ([[firstTimeDic objectForKey:KEY_DEVICE_UDID] isEqualToString:@""]) {
         return NO;
         } */
        
        //        if ([firstTimeDic objectForKey:KEY_DEVICE_TYPE]==nil) {
        //            return NO;
        //        }
        /*      if ([[firstTimeDic objectForKey:KEY_DEVICE_TYPE] isEqualToString:@""]) {
         return NO;
         } */
        return YES;
    }
    return NO;
}
@end
