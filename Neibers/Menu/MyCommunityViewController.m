//
//  MyCommunityViewController.m
//  Neibers
//
//  Created by Yechiel Amar on 09/09/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "MyCommunityViewController.h"
#import "SenderBrain.h"
#import "MyCommunityCell.h"
#import "MBProgressHUD.h"
#import "DetilyCommunityViewController.h"
#import "MessegeViewController.h"

@interface MyCommunityViewController ()

@end

@implementation MyCommunityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE];

    if (_fromMap) {
        _backButton.hidden = NO;
        _menuButton.hidden = YES;
    }else {
        _backButton.hidden = YES;
        _menuButton.hidden = NO;
        if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
        {
            UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
            
            [_menuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addGestureRecognizer:navigationBarPanGestureRecognizer];
        }
    }
    self.headerLabel.text = LocalizedString(@"My Communities");
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateHighlighted];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    return [articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommunityCell *myCommunityCell = [tableView dequeueReusableCellWithIdentifier:MY_COMMUNITY_CELL_ID];
    
    if (!myCommunityCell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MyCommunityCell" owner:self options:nil];
        //This returns all the top-level objects you can see in IB, there should be only one and it should be of type ArticleCell
        //So we'll grab the first one
        myCommunityCell = [topLevelObjects objectAtIndex:0];
    }
    
    //Now we just do some basic cell configuration by setting the data (object) for our view (ArticleCell)
    _article = [articles objectAtIndex:indexPath.row];
    [myCommunityCell setArticle:_article];
    return myCommunityCell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessegeViewController *messegeViewController = [[MessegeViewController alloc]init];
    messegeViewController.deteilCommunity = (Article *)[articles objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:messegeViewController animated:YES];
}

-(void)sendLink{
    communityArray = [SenderBrain getMyCommunity];
    
    NSLog(@"userArray count: %d",[communityArray count]);
    
//    [self loadArticle];

    [self performSelectorOnMainThread:@selector(loadArticle) withObject:nil waitUntilDone:YES];
}

-(void)loadArticle
{
    articles = [[NSMutableArray alloc] init];
    for (int i =0; i<[communityArray  count]; i++)
    {
        _article = [[Article alloc] initWithID:[[communityArray objectAtIndex:i]valueForKey:@"ID"] accessToken:[[communityArray objectAtIndex:i]valueForKey:@"accessToken"] imageFile:[[communityArray objectAtIndex:i]valueForKey:@"imageFile"] type:[[communityArray objectAtIndex:i]valueForKey:@"type"] numberType:[[communityArray objectAtIndex:i]valueForKey:@"numberType"] name:[[communityArray objectAtIndex:i]valueForKey:@"name"] address:[[communityArray objectAtIndex:i]valueForKey:@"address"] description:[[communityArray objectAtIndex:i]valueForKey:@"description"] link:[[communityArray objectAtIndex:i]valueForKey:@"link"] openClose:[[communityArray objectAtIndex:i]valueForKey:@"openCloseCommunity"] numberFriends:[[communityArray objectAtIndex:i]valueForKey:@"numberFriends"]];
        
        [articles addObject:_article];
    }
    NSLog(@"search list: %d", [articles count]);
    [_tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelectorInBackground:@selector(sendLink) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackButton:nil];
    [super viewDidUnload];
}

- (IBAction)backPress:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
