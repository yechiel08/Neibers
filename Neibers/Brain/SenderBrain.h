//
//  SenderBrain.h
//  iBabySitter
//
//  Created by Yechiel Amar on 02/07/12.
//  Copyright (c) 2012 yramar08@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "AppDelegate.h"
#include "OpenUDID.h"
#import "Extentions.h"

#define KEY_SIGNATURE_MD5 @"SignatureKey"
#define KEY_PUSH_NOTIFICATION @"pushNotifiacationKey"
#define KEY_DEVICE_TOKEN @"deviceTokenKey"
#define KEY_DEVICE_UDID @"deviceUDIDKey"
#define KEY_DEVICE_TYPE_NAME @"deviceTypeKey"
#define KEY_OPERATING_SYSTEM @"operatingSystemKey"
#define KEY_ACCESS_TOKEN @"accessTokenKey"

#define KEY_USER_NAME @"UserNameKey"
#define KEY_PASSWORD @"PasswordKey"
#define KEY_FULLNAME @"FullNameKey"
#define KEY_PHONE @"Phone"
#define KEY_BIRTH_DATE @"birthDate"
#define KEY_SMALL_IMAGE @"smallImageKey"
#define KEY_FACEBOOK_ID @"facebookIdKey"

#define KEY_FIRST_TIME @"firstTimeKey"
#define IT_IS_NOT_FIRST_TIME @"itIsNotFirstTime"
#define IT_IS_FIRST_TIME @"itIsFirstTime"

#define ENABLE_PUSH_NOTIFICATION @"enable"
#define DISABLE_PUSH_NOTIFICATION @"disable"

/* 
 //link for sending
 http://the-pricer.com/Services/authenticate.asp?signature=XXX&userId=111&operatingSystem=XXX&deviceTypeName=XXX&deviceID=XXX&deviceToken=XXX

*/

#define URL_ACCESSTOKEN @"accessToken"

#define URL_SIGNATURE_MD5 @"signature"
#define URL_DEVICE_ID @"DeviceID"
#define URL_OPERATING_SYSTEM @"operatingSystem"
#define URL_DEVICE_TYPE_NAME @"deviceTypeName"
#define URL_DEVICE_TOKEN @"DeviceToken"
#define URL_USER_NAME @"userEmail"
#define URL_PASSWORD @"userPassword"
#define URL_FULLNAME @"userFullName"

#define NEIBERS_SERVER_URL @"http://neibers.org/Services/"
#define PGN_COMMAND_NEW_EMAIL_USER @"authenticateUser"
#define PGN_COMMAND_REFRESH_DEVICE @"reFreshDeviceToken"
#define PGN_COMMAND_UPDATE_USER @"RegistereUser"
#define PGN_COMMAND_EXT @".asp?"


@interface SenderBrain : NSObject
{
    
}

+(void)addToken:(NSString *)tokenData :(NSString *)userID;
+(void)addToken:(NSString *)tokenData;
+(void)setPushNotificationEnable;
+(void)setNoPushNotificationEnable;
+(BOOL)isPushNotificaitonEnable;

+(BOOL)isItFirstTimeApplicationRunInTheDevice;
+(BOOL)isItNotFirstTimeApplicationRunInTheDevice;
+(void)createFileIfNeeded;

+(NSMutableString *) AddNewUser: (int) login : (NSString *)userID;
+(void) UpdateUserReFreshDeviceToken;
+(NSString *) UpdateNewUser: (NSString *)emailText : (NSString *)passwordText : (NSString *)nameText : (NSData *)image : (int)Status;
//+(NSString *) UpdateFaceBook_userEmail:(NSString *)emailText FaceBookId:(NSString *)faceBookID userFullName:(NSString *)nameText userPhone:(NSString *)phoneText userBirthDate:(NSString *)birthDateText ImageData:(NSData *)image;
//+(NSString *)SendNewFaceBookUser :(NSString *)userName;
//+(void) sendPublishFeed: (NSString *)userNameText: (NSString *)headlineText: (NSString *)linkImageText;
+(void) sendPublishFeed: (NSString *)userNameText;
+(void) sendPublishPhoto: (NSString *)userNameText : (NSData *)image;

+(NSArray *)getUserFaceBook;
//+(NSString *) AddToFavorites: (NSString *)idMovOn;
//+(NSString *) RemoveFromFavorites: (NSString *)idMovOn;
//+(NSArray *)getMovFavoritesList;
//+(NSString *) RemoveMovon: (NSString *)idMovOn;
//+(NSString *) FlagMovon: (NSString *)idMovOn :(NSString *)IDReason;
//
//+(NSArray *)getMovUserList:(NSString *)userId;
//+(NSArray *)getMovDetails:(NSString *)IDMov;
//+(NSArray *)getMovMainList:(NSString *)mode :(NSString *)pageId :(NSString *)Src;
//+(NSMutableArray *)getUserList:(NSString *)src;
//+(NSMutableArray *)getTagsList:(NSString *)src;

//+(NSString *)SendNewUser :(NSString *)userName;
+(NSString *) updateUser;
+(NSString *) checkUser: (NSString *)userNameText;
+(NSString *) checkUser: (NSString *)userNameText : (NSString *)passwordText;
+(NSString *) changePassword: (NSString *)oldPasswordText : (NSString *)newPasswordText;
//+(NSString *)setNewMov: (NSString *)exposure;
+(void) PasswordRestore: (NSString *)userNameText;
//+(NSString *) setMovData: (NSString *)IDMov : (NSString *)actionType : (NSString *)paramValue : (NSString *)paramValue2;
//+(NSArray *)getCommentsList: (NSString *)IDMov;
+(NSString *)setNewCommunity:(NSString *)_numberType : (NSString *)type : (NSString *)name : (NSString *)address : (NSString *)Description : (NSString *)link : (NSString *)openCloseCommunity : (NSString *)lat : (NSString *)lon : (NSData *)image;
+(NSArray *)getMapCommunity;
+(NSArray *)getMyCommunity;

+(BOOL)isCanSendInfoAboutDevice;
+(NSString *)getUDID;
+ (NSString *)MD5String;
@end
