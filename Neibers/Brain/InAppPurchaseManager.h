//
//  InAppPurchaseManager.h
//  evon
//
//  Created by Eli Ganem on 23/8/12.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
//#import "ConnectionHandler.h"
#import "Utils.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>//,ConnectionHandlerDelegate>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

+ (InAppPurchaseManager*)sharedInstance;
- (void)makeTransaction;
- (void)requestTokens;
- (BOOL)canMakePurchases;
- (void)loadStore;
- (void)purchaseTokens;

@end
