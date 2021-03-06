//
//  LeaderboardViewController.m
//  Falling Frank
//
//  Created by Jeremy Fox on 10/16/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LeaderboardCell.h"

static NSString* const kLeaderBoardCellID = @"LeaderboardCell";

@interface LeaderboardViewController ()
@property (nonatomic, retain) NSArray* scores;
@end

@implementation LeaderboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _scores = [[SQLiteManager sharedInstance] getPlayersWithOrderBy:PLAYER_SCORE desc:YES withRange:NSMakeRange(0, 10)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)]];
    [self.navigationItem setTitle:@"Top 10"];
    
    [self.tableView registerNib:[UINib nibWithNibName:kLeaderBoardCellID bundle:nil] forCellReuseIdentifier:kLeaderBoardCellID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderboardCell* cell = [tableView dequeueReusableCellWithIdentifier:kLeaderBoardCellID];
    Player* player = [self.scores objectAtIndex:indexPath.row];
    if (player) {
        cell.username.text = player.username;
        cell.score.text = player.formattedScore;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player* player = [self.scores objectAtIndex:indexPath.row];
    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"Check out my score in the iOS game Falling Frank", player.formattedScore] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)valueChanged:(id)sender
{
    switch (((UISegmentedControl*)sender).selectedSegmentIndex) {
        case 0:
            self.scores = [[SQLiteManager sharedInstance] getPlayersWithOrderBy:PLAYER_SCORE desc:YES withRange:NSMakeRange(0, 10)];
            break;
            
        case 1:
            self.scores = [[SQLiteManager sharedInstance] getPlayersWithOrderBy:PLAYER_SCORE desc:NO withRange:NSMakeRange(0, 10)];
            break;
            
        case 2:
            self.scores = [[SQLiteManager sharedInstance] getPlayersWithOrderBy:PLAYER_UPDATED_AT desc:YES withRange:NSMakeRange(0, 10)];
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

@end
