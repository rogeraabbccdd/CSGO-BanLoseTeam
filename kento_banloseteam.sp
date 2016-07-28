//***************INCLUDE***************
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>

//***************DEFINE***************
#define TR 2
#define CT 3

//***************HANDLE***************
new Handle:BLT_TIME = INVALID_HANDLE;
new Handle:BLT_ROUND = INVALID_HANDLE;

//***************PLUGIN INFO***************
public Plugin:myinfo =
{
	name = "[CS:GO] Ban Lose Team",
	author = "Kento, CamerDisco",
	version = "1.1",
	description = "Ban Lose Team Players",
	url = ""
};

//***************NYAN CAT***************
//░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//░░░░░░░░░░▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄░░░░░░░░░
//░░░░░░░░▄▀░░░░░░░░░░░░▄░░░░░░░▀▄░░░░░░░
//░░░░░░░░█░░▄░░░░▄░░░░░░░░░░░░░░█░░░░░░░
//░░░░░░░░█░░░░░░░░░░░░▄█▄▄░░▄░░░█░▄▄▄░░░
//░▄▄▄▄▄░░█░░░░░░▀░░░░▀█░░▀▄░░░░░█▀▀░██░░
//░██▄▀██▄█░░░▄░░░░░░░██░░░░▀▀▀▀▀░░░░██░░
//░░▀██▄▀██░░░░░░░░▀░██▀░░░░░░░░░░░░░▀██░
//░░░░▀████░▀░░░░▄░░░██░░░▄█░░░░▄░▄█░░██░
//░░░░░░░▀█░░░░▄░░░░░██░░░░▄░░░▄░░▄░░░██░
//░░░░░░░▄█▄░░░░░░░░░░░▀▄░░▀▀▀▀▀▀▀▀░░▄▀░░
//░░░░░░█▀▀█████████▀▀▀▀████████████▀░░░░
//░░░░░░████▀░░███▀░░░░░░▀███░░▀██▀░░░░░░
//░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

//***************OnPluginStart***************
public OnPluginStart()
{
	//Events
    HookEvent("cs_intermission", OnMatchEnd);
    //or "cs_win_panel_match" ???
	
	//CVARS
    BLT_TIME = CreateConVar("sm_banloseteam_time", "30", "Ban Time.");
    BLT_ROUND = CreateConVar("sm_banloseteam_round", "16", " How Many Round Need To Win The Match.");
	
    AutoExecConfig(true, "kento_banloseteam");
    
    LoadTranslations("kento.banloseteam.phrases");
}

//***************OnMatchEnd***************
//******Special Thanks To CamerDisco******
public OnMatchEnd (Handle:event, const String:name[], bool:dontBroadcast)
{
    new Client = GetClientOfUserId(GetEventInt(event, "userid"));
    
    char BLT_MESSEGE[100];
    Format(BLT_MESSEGE, sizeof(BLT_MESSEGE), "%T", "Kick Messege");
    
    char BLT_REASON[100];
    Format(BLT_REASON, sizeof(BLT_REASON), "%T", "Ban Reason");
    
    //TR WIN
    if (CS_GetTeamScore(TR) == BLT_ROUND)
	{
        //Kick CT
        if (GetClientTeam(Client) == CT)
        {
            if ( IsClientConnected(Client) && !IsFakeClient(Client) )
            {
                BanClient(Client, BLT_TIME, BANFLAG_AUTO, BLT_REASON, BLT_MESSEGE);
                PrintToChatAll("%t", "Loser has been kicked");  
            }
        }
        
        else if (GetClientTeam(Client) == TR)
        {
            return Plugin_Handled;
        }
	}
    
    //CT WIN
    else if (CS_GetTeamScore(CT) == BLT_ROUND)
	{
        //Kick TR
        if (GetClientTeam(Client) == TR)
        {
            if ( IsClientConnected(Client) && !IsFakeClient(Client) )
            {
                BanClient(Client, BLT_TIME, BANFLAG_AUTO, BLT_REASON, BLT_MESSEGE);
                PrintToChatAll("%t", "Loser has been kicked");  
            }
        }
        else if (GetClientTeam(Client) == CT)
        {
            return Plugin_Handled;
        }
	}
    
    return Plugin_Handled;
}