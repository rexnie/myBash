# $language = "python"
# $interface = "1.0"

def Main():

	objTab = crt.GetScriptTab()
	objTab.Screen.Synchronous = True
	objTab.Screen.IgnoreEscape = True
	
	objTab.Screen.Send("\n\n")

	result = objTab.Screen.WaitForStrings(["ISAM:Press 'f' to enter UBOOT prompt", "Welcome to ISAM reborn!"], 300)
	
	if (result == 1):
		objTab.Screen.Send("ftest\n")
	if (result == 2):
		objTab.Screen.Send("\n")
		objTab.Screen.WaitForString("isam-reborn login:")
		objTab.Screen.Send("root\n")
		objTab.Screen.WaitForString("Password:")
		objTab.Screen.Send("2x2=4\n")

Main()
