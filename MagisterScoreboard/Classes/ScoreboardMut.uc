class ScoreboardMut extends Mutator;

simulated function PostBeginPlay()
{
	Level.Game.ScoreBoardType = "MagisterScoreboard.ScoreBoard";
}

defaultproperties
{
     GroupName="KFScoreboardMut"
     FriendlyName="Magister Scoreboard"
     Description="Alters scoreboard to give more information."
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
