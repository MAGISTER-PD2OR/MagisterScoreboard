class ScoreBoard extends KFMod.KFScoreBoardNew;
//автор M@GISTER - 2014 Year.
simulated event UpdateScoreBoard(Canvas Canvas)
{
	local PlayerReplicationInfo PRI, OwnerPRI;
	local int i,j, FontReduction, NetXPos, PlayerCount, HeaderOffsetY, HeadFoot, MessageFoot, PlayerBoxSizeY, BoxSpaceY, NameXPos, BoxTextOffsetY, OwnerOffset, HealthXPos, BoxXPos,KillsXPos, TitleYPos, BoxWidth, VetXPos, TempVetXPos, VetYPos;
	local float XL,YL, MaxScaling;
	local float deathsXL, AssistsXL, KillsXL, netXL, HealthXL, MaxNamePos, KillWidthX, HealthWidthX, TimeXL, TimeWidthX, TimeXPos, ScoreXPos, ScoreXL;
	local bool bNameFontReduction;
	local Material VeterancyBox, StarMaterial;
	local int TempLevel;
	local float AssistsXPos, AssistsWidthX;
	local float CashX;
	local string CashString;
	local string PlayerTime;

	OwnerPRI = KFPlayerController(Owner).PlayerReplicationInfo;
	OwnerOffset = -1;

	for (i = 0; i < GRI.PRIArray.Length; i++)
	{
		PRI = GRI.PRIArray[i];

		if ( !PRI.bOnlySpectator )
		{
			if ( PRI == OwnerPRI )
				OwnerOffset = i;

			PlayerCount++;
		}
	}

	PlayerCount = Min(PlayerCount, MAXPLAYERS);

	Canvas.Font = class'ROHud'.static.GetSmallMenuFont(Canvas);
	Canvas.StrLen("Test", XL, YL);
	BoxSpaceY = 0.25 * YL;
	PlayerBoxSizeY = 1.2 * YL;
	HeadFoot = 7 * YL;
	MessageFoot = 1.5 * HeadFoot;

	if ( PlayerCount > (Canvas.ClipY - 1.5 * HeadFoot) / (PlayerBoxSizeY + BoxSpaceY) )
	{
		BoxSpaceY = 0.125 * YL;
		PlayerBoxSizeY = 1.25 * YL;

		if ( PlayerCount > (Canvas.ClipY - 1.5 * HeadFoot) / (PlayerBoxSizeY + BoxSpaceY) )
		{
			if ( PlayerCount > (Canvas.ClipY - 1.5 * HeadFoot) / (PlayerBoxSizeY + BoxSpaceY) )
			{
				PlayerBoxSizeY = 1.125 * YL;
			}
		}
	}

	if (Canvas.ClipX < 512)
		PlayerCount = Min(PlayerCount, 1+(Canvas.ClipY - HeadFoot) / (PlayerBoxSizeY + BoxSpaceY) );
	else
		PlayerCount = Min(PlayerCount, (Canvas.ClipY - HeadFoot) / (PlayerBoxSizeY + BoxSpaceY) );

	if (FontReduction > 1) // Меняет ширину поля если поставить 1, раньше было 2
		MaxScaling = 1; // Меняет ширину поля если поставить 1, раньше было 2
	else
		MaxScaling = 1.125; // Меняет ширину поля если поставить 1.125, раньше было 2.125

	PlayerBoxSizeY = FClamp((1.25 + (Canvas.ClipY - 0.67 * MessageFoot)) / PlayerCount - BoxSpaceY, PlayerBoxSizeY, MaxScaling * YL);

	bDisplayMessages = (PlayerCount <= (Canvas.ClipY - MessageFoot) / (PlayerBoxSizeY + BoxSpaceY));

	// Позиция элементов на панели
	HeaderOffsetY = 10 * YL; //10
	BoxWidth = 0.9 * Canvas.ClipX; //0.9
	BoxXPos = 0.5 * (Canvas.ClipX - BoxWidth); //0.5
	BoxWidth = Canvas.ClipX - 2 * BoxXPos; //2
	VetXPos = BoxXPos + 0.0001 * BoxWidth; //0.0001 - Veteran icon
	NameXPos = BoxXPos + 0.025 * BoxWidth; //0.025 - Name player
	ScoreXPos = BoxXPos + 0.35 * BoxWidth; //0.35 - Cash
	AssistsXPos = BoxXPos + 0.50 * BoxWidth; //0.50 - Assists
	KillsXPos = BoxXPos + 0.65 * BoxWidth; //0.65 - Kills
	TimeXPos = BoxXPos + 0.75 * BoxWidth; //0.75 - Time
	HealthXpos = BoxXPos + 0.85 * BoxWidth; //0.85 - Health
	NetXPos = BoxXPos + 0.95 * BoxWidth; //0.95 - Ping
	
	// Draw background boxes
	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.DrawColor = HUDClass.default.WhiteColor; //WhiteColor
	Canvas.DrawColor.A = 128; //128

	for (i = 0; i < PlayerCount; i++)
	{
		Canvas.SetPos(BoxXPos, HeaderOffsetY + (PlayerBoxSizeY + BoxSpaceY) * i);
		Canvas.DrawTileStretched(BoxMaterial, BoxWidth, PlayerBoxSizeY);
	}

	// Draw title
	Canvas.Style = ERenderStyle.STY_Normal;
	DrawTitle(Canvas, HeaderOffsetY, (PlayerCount + 1) * (PlayerBoxSizeY + BoxSpaceY), PlayerBoxSizeY);

	// Draw headers
	TitleYPos = HeaderOffsetY - 1.1 * YL;
	Canvas.StrLen(HealthText, HealthXL, YL);
	Canvas.StrLen(DeathsText, DeathsXL, YL);
	Canvas.StrLen(AssistsHeaderText, AssistsXL, YL);
	Canvas.StrLen(KillsText, KillsXL, YL);
	Canvas.StrLen(PointsText, ScoreXL, YL);
	Canvas.StrLen(TimeText, TimeXL, YL);
	Canvas.StrLen(NetText, NetXL, YL);
	Canvas.StrLen("INJURED", HealthWidthX, YL);

	// Draw text player
	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.SetPos(NameXPos, TitleYPos);
	Canvas.DrawText(PlayerText$":",true);

	// Draw text assists
	Canvas.SetPos(AssistsXPos - 0.5 * AssistsXL, TitleYPos);
	Canvas.DrawText(AssistsHeaderText$":",true);
	
	// Draw text kills
	Canvas.SetPos(KillsXPos - 0.5 * KillsXL, TitleYPos);
	Canvas.DrawText(KillsText$":",true);
	
	// Draw text cash
	Canvas.SetPos(ScoreXPos - 0.5 * ScoreXL, TitleYPos);
	Canvas.DrawText(PointsText$":",true);
		
	// Draw text time
	Canvas.SetPos(TimeXPos - 0.5 * TimeXL, TitleYPos);
	Canvas.DrawText(TimeText,true);

	// Draw text health
	Canvas.SetPos(HealthXPos - 0.5 * HealthXL, TitleYPos);
	Canvas.DrawText(HealthText$":",true);
	
	// Draw text ping
	Canvas.SetPos(NetXPos - 0.5 * NetXL, TitleYPos);
	Canvas.DrawText(NetText$":",true);

	// Draw player names
	MaxNamePos = 0.9 * (KillsXPos - NameXPos);
	for (i = 0; i < PlayerCount; i++)
	{
		Canvas.StrLen(GRI.PRIArray[i].PlayerName, XL, YL);

		if ( XL > MaxNamePos )
		{
			bNameFontReduction = true;
			break;
		}
	}

	if ( bNameFontReduction )
		Canvas.Font = GetSmallerFontFor(Canvas, FontReduction - 1);

	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.SetPos(0.5 * Canvas.ClipX, HeaderOffsetY + 4);
	BoxTextOffsetY = HeaderOffsetY + 0.5 * (PlayerBoxSizeY - YL);

	Canvas.DrawColor = HUDClass.default.WhiteColor;
	MaxNamePos = Canvas.ClipX;
	Canvas.ClipX = KillsXPos - 4.f;

	for (i = 0; i < PlayerCount; i++)
	{
		Canvas.SetPos(NameXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);

		if( i == OwnerOffset )
		{
			Canvas.DrawColor.G = 0;
			Canvas.DrawColor.B = 0;
		}
		else
		{
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
		}

		Canvas.DrawTextClipped(GRI.PRIArray[i].PlayerName);
	}

	Canvas.ClipX = MaxNamePos;
	Canvas.DrawColor = HUDClass.default.WhiteColor;

	if (bNameFontReduction)
		Canvas.Font = GetSmallerFontFor(Canvas, FontReduction);

	Canvas.Style = ERenderStyle.STY_Normal;
	MaxScaling = FMax(PlayerBoxSizeY, 30.f);

	// Draw each player's information
	for (i = 0; i < PlayerCount; i++)
	{
		Canvas.DrawColor = HUDClass.default.WhiteColor;
		
		// Display perks.
		if ( KFPlayerReplicationInfo(GRI.PRIArray[i])!=None && KFPlayerReplicationInfo(GRI.PRIArray[i]).ClientVeteranSkill != none )
		{
			if(KFPlayerReplicationInfo(GRI.PRIArray[i]).ClientVeteranSkillLevel == 6)
			{
				VeterancyBox = KFPlayerReplicationInfo(GRI.PRIArray[i]).ClientVeteranSkill.default.OnHUDGoldIcon;
                StarMaterial = class'HUDKillingFloor'.default.VetStarGoldMaterial;
				TempLevel = KFPlayerReplicationInfo(GRI.PRIArray[i]).ClientVeteranSkillLevel - 5;
			}
			else
			{
				VeterancyBox = KFPlayerReplicationInfo(GRI.PRIArray[i]).ClientVeteranSkill.default.OnHUDIcon;
				StarMaterial = class'HUDKillingFloor'.default.VetStarMaterial;
				TempLevel = KFPlayerReplicationInfo(GRI.PRIArray[i]).ClientVeteranSkillLevel;
			}

			if ( VeterancyBox != None )
			{
				TempVetXPos = VetXPos;
				VetYPos = (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY - PlayerBoxSizeY * 0.22;
				Canvas.SetPos(TempVetXPos, VetYPos);
				Canvas.DrawTile(VeterancyBox, PlayerBoxSizeY, PlayerBoxSizeY, 0, 0, VeterancyBox.MaterialUSize(), VeterancyBox.MaterialVSize());

				if(StarMaterial != none)
				{
					TempVetXPos += PlayerBoxSizeY - ((PlayerBoxSizeY/5) * 0.75);
					VetYPos += PlayerBoxSizeY - ((PlayerBoxSizeY/5) * 1.5);

					for ( j = 0; j < TempLevel; j++ )
					{
						Canvas.SetPos(TempVetXPos, VetYPos);
						Canvas.DrawTile(StarMaterial, (PlayerBoxSizeY/5) * 0.7, (PlayerBoxSizeY/5) * 0.7, 0, 0, StarMaterial.MaterialUSize(), StarMaterial.MaterialVSize());
						VetYPos -= (PlayerBoxSizeY/5) * 0.7;
					}
				}
			}
		}

		
		// Draw assists
		if( bDisplayWithKills )
		{
			Canvas.StrLen(KFPlayerReplicationInfo(GRI.PRIArray[i]).KillAssists, AssistsWidthX, YL);
			Canvas.SetPos(AssistsXPos - 0.5 * AssistsWidthX, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
			Canvas.DrawColor = Canvas.MakeColor(33,120,206,255);
			Canvas.DrawText(KFPlayerReplicationInfo(GRI.PRIArray[i]).KillAssists, true);
			Canvas.DrawColor = HUDClass.default.WhiteColor;
		    // Draw kills
			Canvas.StrLen(KFPlayerReplicationInfo(GRI.PRIArray[i]).Kills, KillWidthX, YL);
			Canvas.SetPos(KillsXPos - 0.5 * KillWidthX, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
			Canvas.DrawColor = Canvas.MakeColor(33,120,206,255);
			Canvas.DrawText(KFPlayerReplicationInfo(GRI.PRIArray[i]).Kills, true);
			Canvas.DrawColor = HUDClass.default.WhiteColor;
		}
		
		// Draw cash
		CashString = "Ј"@string(int(GRI.PRIArray[i].Score));
		
		if(GRI.PRIArray[i].Score >= 1000)
		{
            CashString = "Ј"@string(GRI.PRIArray[i].Score/1000.f)$"K";
		}
		
		Canvas.StrLen(CashString,CashX,YL);
		Canvas.SetPos(ScoreXPos - CashX/2 , (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
		Canvas.DrawColor = Canvas.MakeColor(255,255,125,255);
        Canvas.DrawText(CashString);
		Canvas.DrawColor = HUDClass.default.WhiteColor;
		
		// Draw time
		if( GRI.ElapsedTime<KFPlayerReplicationInfo(GRI.PRIArray[i]).StartTime ) // Login timer error, fix it.
			GRI.ElapsedTime = KFPlayerReplicationInfo(GRI.PRIArray[i]).StartTime;
		PlayerTime = FormatTime(GRI.ElapsedTime - KFPlayerReplicationInfo(GRI.PRIArray[i]).StartTime);
		Canvas.StrLen(PlayerTime, TimeWidthX, YL);
		Canvas.SetPos(TimeXPos - 0.5 * TimeWidthX, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
		Canvas.DrawColor = Canvas.MakeColor(33,120,206,255);
		Canvas.DrawText(PlayerTime, true);
		Canvas.DrawColor = HUDClass.default.WhiteColor;

		// Draw health
		Canvas.SetPos(HealthXpos - 0.5 * HealthWidthX, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY); // позиция здоровья на панеле по TAB

		if ( GRI.PRIArray[i].bOutOfLives )
		{
			Canvas.DrawColor = HUDClass.default.RedColor;
			Canvas.DrawText(OutText, true); // убрал пробелы в этом месте ("["
		}
		else
		{
			if( KFPlayerReplicationInfo(GRI.PRIArray[i]).PlayerHealth>=95 )
			{
				Canvas.DrawColor = HUDClass.default.GreenColor;
				Canvas.DrawText("   ["$KFPlayerReplicationInfo(GRI.PRIArray[i]).PlayerHealth$"]", true); // убрал пробелы в этом месте ("["
			}
			else if( KFPlayerReplicationInfo(GRI.PRIArray[i]).PlayerHealth>=50 )
			{
				Canvas.DrawColor = HUDClass.default.GoldColor;
				Canvas.DrawText("   ["$KFPlayerReplicationInfo(GRI.PRIArray[i]).PlayerHealth$"]", true); // убрал пробелы в этом месте ("["
			}
			else
			{
				Canvas.DrawColor = HUDClass.default.RedColor;
				Canvas.DrawText("   ["$KFPlayerReplicationInfo(GRI.PRIArray[i]).PlayerHealth$"]", true); // убрал пробелы в этом месте ("["
			}
		}
	}

	// Draw ping
	if (Level.NetMode == NM_Standalone)
		return;

	for (i=0; i<GRI.PRIArray.Length; i++)
		PRIArray[i] = GRI.PRIArray[i];

	DrawNetNewInfo(Canvas, FontReduction, HeaderOffsetY, PlayerBoxSizeY, BoxSpaceY, BoxTextOffsetY, OwnerOffset, PlayerCount, NetXPos); // заменил функцию DrawNetInfo из KFScoreBoard.uc на DrawNetNewInfo
	DrawMatchID(Canvas, FontReduction);
}

// Функция вывода пинга к draw ping
function DrawNetNewInfo(Canvas Canvas,int FontReduction,int HeaderOffsetY,int PlayerBoxSizeY,int BoxSpaceY,int BoxTextOffsetY,int OwnerOffset,int PlayerCount, int NetXPos)
{
	local float XL,YL;
	local int i;
	local bool bHaveHalfFont, bDrawFPH, bDrawPL;
	local int PlayerPing;
	local float AdminX,AdminY;
    local string AdministratorText;
	
	bDrawPL = false;
	bDrawFPH = false;
	bHaveHalfFont = false;
    AdministratorText = "[A]"; // когда администратор заходит в игре прописав в консоли adminlogin ник и пароль, где пинг в таблице по TAB заменяется на этот символ
	
	// draw admins
	if ( GRI.bMatchHasBegun )
	{
		Canvas.DrawColor = HUDClass.default.RedColor;
        Canvas.StrLen(AdministratorText,AdminX,AdminY);

		for ( i = 0; i < PlayerCount; i++ )
			if ( PRIArray[i].bAdmin )
				{
					Canvas.SetPos(NetXPos - AdminX/2, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
					Canvas.DrawText(AdministratorText);
				}
		if ( (OwnerOffset >= PlayerCount) && PRIArray[OwnerOffset].bAdmin )
		{
			Canvas.SetPos(NetXPos - AdminX/2, (PlayerBoxSizeY + BoxSpaceY) * PlayerCount + BoxTextOffsetY);
			Canvas.DrawText(AdministratorText);
		}
	}

	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.StrLen("Test", XL, YL);
	BoxTextOffsetY = HeaderOffsetY + 0.5*PlayerBoxSizeY;

	// if game hasn't begun, draw ready or not ready
	if ( !GRI.bMatchHasBegun )
	{
		for ( i=0;  i < PlayerCount; i++ )
		{
            PlayerPing = Min(999,4*PRIArray[i].Ping);
            Canvas.DrawColor = GetPingNewColor(PlayerPing);
			
			if ( bDrawPL )
			{
				Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 1.5 * YL);
				Canvas.DrawText(PingText@PlayerPing,true);
				Canvas.DrawColor = HUDClass.default.WhiteColor;

				Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.5 * YL);
				Canvas.DrawText(PLText@PRIArray[i].PacketLoss,true);
				Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY + 0.5 * YL);
			}
			else if ( bHaveHalfFont )
			{
				Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - YL);
				Canvas.DrawText(PingText@PlayerPing,true);
				Canvas.DrawColor = HUDClass.default.WhiteColor;
				Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
			}
			else
				Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.5*YL);
			if ( PRIArray[i].bReadyToPlay )
				Canvas.DrawText(ReadyText,true);
			else
				Canvas.DrawText(NotReadyText,true);
		}
		return;
	}

	// draw time and ping
	if ( Canvas.ClipX < 512 )
		PingText = "";
	else
	{
		PingText = Default.PingText;
	}
	if ( ((FPHTime == 0) || (!UnrealPlayer(Owner).bDisplayLoser && !UnrealPlayer(Owner).bDisplayWinner))
		&& (GRI.ElapsedTime > 0) )
		FPHTime = GRI.ElapsedTime;

	for ( i = 0; i < PlayerCount; i++ )
		if ( !PRIArray[i].bAdmin && !PRIArray[i].bOutOfLives )
 			{
                PlayerPing = Min(999,4*PRIArray[i].Ping);
                Canvas.DrawColor = GetPingNewColor(PlayerPing);

 				if ( bDrawPL )
 				{
					Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 1.9 * YL);
					Canvas.DrawText(PingText@PlayerPing,true);
				    Canvas.DrawColor = HUDClass.default.WhiteColor;

					Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.9 * YL);
					Canvas.DrawText(PLText@PRIArray[i].PacketLoss,true);
					Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY + 0.1 * YL);
					Canvas.DrawText(FPH@Clamp(3600*PRIArray[i].Score/FMax(1,FPHTime - PRIArray[i].StartTime),-999,9999),true);
					Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY + 1.1 * YL);
					Canvas.DrawText(FormatTime(Max(0,FPHTime - PRIArray[i].StartTime)),true);
				}
 				else if ( bDrawFPH )
 				{
					Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 1.5 * YL);
					Canvas.DrawText(PingText@PlayerPing,true);
				    Canvas.DrawColor = HUDClass.default.WhiteColor;

					Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.5 * YL);
					Canvas.DrawText(FPH@Clamp(3600*PRIArray[i].Score/FMax(1,FPHTime - PRIArray[i].StartTime),-999,9999),true);
					Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY + 0.5 * YL);
					Canvas.DrawText(FormatTime(Max(0,FPHTime - PRIArray[i].StartTime)),true);
				}
				else if ( bHaveHalfFont )
				{
					Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - YL);
					Canvas.DrawText(PingText@PlayerPing,true);
					Canvas.DrawColor = HUDClass.default.WhiteColor;

					Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
					Canvas.DrawText(FormatTime(Max(0,FPHTime - PRIArray[i].StartTime)),true);
				}
				else
				{
					Canvas.StrLen(PlayerPing, XL, YL);
					Canvas.SetPos(NetXPos - 0.5 * xL, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.5*YL);
					Canvas.DrawText(PlayerPing,true);
				}
			}
	if ( (OwnerOffset >= PlayerCount) && !PRIArray[OwnerOffset].bAdmin && !PRIArray[OwnerOffset].bOutOfLives )
	{
	    PlayerPing = Min(999,4*PRIArray[OwnerOffset].Ping);
        Canvas.DrawColor = GetPingNewColor(PlayerPing);

 		if ( bDrawFPH )
 		{
			Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 1.5 * YL);
			Canvas.DrawText(PingText@PlayerPing,true);
			Canvas.DrawColor = HUDClass.default.WhiteColor;

			Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.5 * YL);
			Canvas.DrawText(FPH@Min(999,3600*PRIArray[OwnerOffset].Score/FMax(1,FPHTime - PRIArray[OwnerOffset].StartTime)),true);
			Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY + 0.5 * YL);
			Canvas.DrawText(FormatTime(Max(0,FPHTime - PRIArray[OwnerOffset].StartTime)),true);
		}
		else if ( bHaveHalfFont )
		{
			Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - YL);
			Canvas.DrawText(PingText@PlayerPing,true);
			Canvas.DrawColor = HUDClass.default.WhiteColor;

			Canvas.SetPos(NetXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
			Canvas.DrawText(FormatTime(Max(0,FPHTime - PRIArray[OwnerOffset].StartTime)),true);
		}
		else
		{
			Canvas.StrLen(PlayerPing, XL, YL);
			Canvas.SetPos(NetXPos - 0.5 * XL, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY - 0.5 * YL);
			Canvas.DrawText(PlayerPing, true);
		}
	}
}

/* Returns a color value for the supplied ping */
function Color GetPingNewColor( int Ping)
{
    if(Ping >= 200)
    {
        return 	HUDClass.default.RedColor;
    }
    else if( Ping >= 100)
    {
        return HUDClass.default.GoldColor;
    }
    else if( Ping < 100)
    {
        return HUDClass.default.GreenColor;
    }
}

// Adjust for Kills, instead of cash.
simulated function bool InOrder( PlayerReplicationInfo P1, PlayerReplicationInfo P2 )
{
	local KFPlayerReplicationInfo P11,P22;

	P11 = KFPlayerReplicationInfo(P1);
	P22 = KFPlayerReplicationInfo(P2);

	if( P11==None || P22==None )
		return true;
	if( P1.bOnlySpectator )
	{
		if( P2.bOnlySpectator )
			return true;
		else return false;
	}
	else if ( P2.bOnlySpectator )
		return true;

	if( P11.Kills < P22.Kills )
		return false;
	else if( P11.Kills==P22.Kills )
	{
		// Kills is equal, go for assists.
		if( P11.KillAssists < P22.KillAssists )
		{
			return false;
		}
        else if( P11.KillAssists==P22.KillAssists )
		{
			if( P11.Score < P22.Score )
			{
                return false;
            }
            else if( P11.Score == P22.Score)
            {
               return (P1.PlayerName<P2.PlayerName); // Go for name.
            }
        }
	}
	return true;
}

defaultproperties
{
}
