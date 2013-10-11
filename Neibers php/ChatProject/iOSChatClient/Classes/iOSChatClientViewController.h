#import <UIKit/UIKit.h>

@interface iOSChatClientViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, NSXMLParserDelegate>	{
	IBOutlet UITextField *messageText;
	IBOutlet UIButton *sendButton;
	IBOutlet UITableView *messageList;
	int lastId;
	
	NSMutableData *receivedData;
	
	NSMutableArray *messages;
	
	NSTimer *timer;
	
	NSXMLParser *chatParser;
	NSString *msgAdded;
	NSMutableString *msgUser;
	NSMutableString *msgText;
	int msgId;
	Boolean inText;
	Boolean inUser;
}

@property (nonatomic,retain) UITextField *messageText;
@property (nonatomic,retain) UIButton *sendButton;
@property (nonatomic,retain) UITableView *messageList;

- (IBAction)sendClicked:(id)sender;

@end

