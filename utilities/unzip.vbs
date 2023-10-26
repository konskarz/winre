With CreateObject("Shell.Application")
	.NameSpace(Wscript.Arguments(1)).CopyHere .NameSpace(Wscript.Arguments(0)).Items
End With
