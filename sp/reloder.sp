#pragma semicolon 1
#include <sourcemod>
#define PLUGIN_VERSION "1.0"

public Plugin myinfo = {
  name = "reloader",
  author = "Dominik Kłodziński",
  description = "Plugin reloader",
  version = PLUGIN_VERSION,
  url = ""
};

public OnPluginStart() {
	RegAdminCmd("sm_rel", CMD_ReloadPlugin, ADMFLAG_ROOT);
}
public Action CMD_ReloadPlugin(int client, int args) {
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	ClientCommand(client, "sm_rcon sm plugins unload %s", arg1);
	DataPack data = new DataPack();
	data.WriteCell(client);
	data.WriteString(arg1);
	data.Reset();
	CreateTimer(0.5, Reload, data);        
}
  
public Action Reload(Handle timer, DataPack data) {
	char sText[64];
	int client = data.ReadCell();
	data.ReadString(sText, sizeof(sText));
	delete data;
	ClientCommand(client, "sm_rcon sm plugins load %s", sText);
}