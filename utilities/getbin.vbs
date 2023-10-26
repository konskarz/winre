With CreateObject("WinHttp.WinHttpRequest.5.1")
	WScript.Echo vbCRLF & "Get: " & Wscript.Arguments(0)
	.Open "GET", Wscript.Arguments(0), false
	.setRequestHeader "User-Agent", WScript.ScriptName
	.Send
	WScript.Echo .getAllResponseHeaders
	If .Status = 200 Then
		ResponseBody = .ResponseBody
		With CreateObject("ADODB.Stream")
			.Open
			.Type = 1 '//binary
			.Write ResponseBody
			.Position = 0
			.SaveToFile Wscript.Arguments(1), 2
		End With
	End If
End With
