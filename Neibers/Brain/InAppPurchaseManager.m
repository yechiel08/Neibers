//
//  InAppPurchaseManager.m
//  evon
//
//  Created by Eli Ganem on 23/8/12.
//
//

#import "InAppPurchaseManager.h"
#import "Utils.h"

#define kInAppPurchaseTokensProductId @"com.Yechiel.Neibers.closedCommunity"

@implementation InAppPurchaseManager

static InAppPurchaseManager *sharedInstance = nil;

+ (InAppPurchaseManager *)sharedInstance
{
	@synchronized(self)
	{
		if (sharedInstance == nil)
		{
			if (!sharedInstance)
				sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

- (void)makeTransaction
{
    if ([self canMakePurchases])
    {
        [self loadStore];
        [self purchaseTokens];
    }
    else
    {
        [Utils showAlert:@"You are not allowed to make InApp purchases"];
    }
}

- (void)requestTokens
{
    NSSet *productIdentifiers = [NSSet setWithObjects:kInAppPurchaseTokensProductId, nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for (SKProduct *product in response.products)
    {
        NSLog(@"Product title: %@" , product.localizedTitle);
        NSLog(@"Product description: %@" , product.localizedDescription);
        NSLog(@"Product price: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestTokens];
}

// call this before making a purchase
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

// kick off the upgrade transaction
- (void)purchaseTokens
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseTokensProductId];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

// saves a record of the transaction by storing the receipt to disk
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseTokensProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"tokensTransactionReceipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// enable pro features
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kInAppPurchaseTokensProductId])
    {
//        [ProfileModel sharedInstance].tokensAvailable += 3;
//        [[ConnectionHandler sharedInstance] saveProfile:self segment:PSTokens];
    }
}

- (void)finishedLoading:(NSData*)data requestId:(int)reqId statusCode:(int)statusCode
{
    [Utils showAlert:@"Tokens were successdully purchased. Thank you!"];
}

// removes the transaction from the queue and posts a notification with the transaction result
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    NSLog(@"Transaction status %d", wasSuccessful);
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

// called when the transaction was successful
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

// called when a transaction has been restored and and successfully completed
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

// called when a transaction has failed
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        [Utils showAlert:transaction.error.description];
        NSLog(@"%@", transaction.error.description);
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

// called when the transaction status is updated
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

@end
