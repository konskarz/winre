REM cls & cscript //nologo wudlg.vbs wudlg.txt

REM criteria = "IsInstalled=0"
REM criteria = "IsAssigned=1"
REM criteria = criteria & " and Type='Software'"
REM criteria = criteria & " and Type='Driver'"
REM criteria = criteria & " and AutoSelectOnWebSites=1"
REM criteria = "UpdateID!='adc29b1a-fd5f-4c47-844a-cac5d120cfd9'"
If WScript.Arguments.Count > 1 Then criteria = WScript.Arguments(1) Else criteria = "IsInstalled=0"

REM KB890830 - The Microsoft Windows Malicious Software Removal Tool
REM KB2267602 - Definition Update for Windows Defender
If WScript.Arguments.Count > 2 Then ignore = WScript.Arguments(2) Else ignore = "KB890830;KB2267602"

WScript.Echo vbCRLF & "Windows update download list generator search criteria: " & criteria
Set updates = CreateObject("Microsoft.Update.Session").CreateUpdateSearcher().Search(criteria).Updates

If Not updates.Count > 0 Then WScript.Quit(1)
Dim urls()
urlscount = 0

For Each update In updates
	ProcUpd update
Next

Function ProcUpd(update)
	title = update.Title
	For Each str In Split(ignore, ";")
		If InStr(1,title,str,1) > 0 Then
			WScript.Echo vbCRLF & "Ignore: " & title
			Exit Function
		End If
	Next
	WScript.Echo vbCRLF & "Title: " & title
	ProcDlc update.DownloadContents
	For Each bundle In update.BundledUpdates
		ProcDlc bundle.DownloadContents
	Next
End Function

Function ProcDlc(contents)
	For Each dc In contents
		If Not dc.IsDeltaCompressedContent Then
			WScript.Echo "Download: " & dc.DownloadUrl
			ReDim Preserve urls(urlscount)
			urls(urlscount) = dc.DownloadUrl
			urlscount = urlscount + 1
		End If
	Next
End Function

If Not urlscount > 0 Then WScript.Quit(1)
If WScript.Arguments.Count > 0 Then filename = WScript.Arguments(0) Else filename = WScript.ScriptName & ".txt"

WScript.Echo vbCRLF & "Write: " & urlscount & " urls to " & filename
Set textfile = CreateObject("Scripting.FileSystemObject").CreateTextFile(filename, True)

For Each url In urls
	textfile.WriteLine url
Next
textfile.Close
