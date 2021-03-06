<% OPTION EXPLICIT 

PageTitle = "Installed Themes"

'-- If your host does not support parent paths specify the full path here --'
Dim ServerPathToInstalledDirectory
If TemplateURL = "" Then ServerPathToInstalledDirectory = Server.MapPath(".") Else ServerPathToInstalledDirectory = Server.MapPath("..\")
'ServerPathToInstalledDirectory = "C:\inetpub\wwwroot"
%>
<!-- #INCLUDE FILE="Includes/Header.asp" -->
<div id="content">

<!-- Start Installed Themes Information -->
<div class="entry">
<h3 class="entryTitle">About The Themes</h3>
<div class="entryBody">
<p>The following theme templates are installed :</p>
<p>
<%
On Error Resume Next

	Dim Folder, Folders, ThemePath, Status, JPEG, GIF

	Set FSO = Server.CreateObject("Scripting.FileSystemObject")
	Set Folder = FSO.GetFolder(ServerPathToInstalledDirectory & "\Templates\")
    Set Folders = Folder.SubFolders

	If Err = 0 Then
     For Each Folder in Folders 
      Response.Write Folder.Name
      If Template = Folder.Name Then Response.Write " (<b>Current</b>)"
      Response.Write "<br/>" & VbCrlf
     Next
	Else
	Response.Write "<center><b>This website does not support the FSO<br/>I cannot dynamically tell you what themes are installed</b></center>"
	FSODisabled = True
	End If
%>
</p>
</div>
</div>

<!-- Start Make Your Own Information -->
<div class="entry">
<h3 class="entryTitle">About Making Themes / Legacy Mode</h3>
<div class="entryBody">
<p>For instructions (& Samples) on how to make your own theme, click <a href="Templates/BlankTemplate.zip">here</a></p>
<p>To see what a typical SimpleGeek.com BlogX page looked like, <a href="?LegacyMode">tag ?LegacyMode on to the URL of a page</a>.</p>
</div>
</div>

<!-- Start Individual Breakdown -->

<%
If FSODisabled = False Then

        For Each Folder in Folders

	'---Map The Physical System Path---'
	ThemePath = ServerPathToInstalledDirectory & "\Templates\" & Folder.Name 
	Status = ""

 If FSO.FileExists(ServerPathToInstalledDirectory & "\Templates\" & Folder.Name & "\Info.txt") Then 

	' Get a handle to the file
	Dim ThemeFile	
	Set ThemeFile = FSO.GetFile(ServerPathToInstalledDirectory & "\Templates\" & Folder.Name & "\Info.txt")

	' Open the file
	Dim ThemeTextStream

        ' Read the file line by line
	Set ThemeTextStream = ThemeFile.OpenAsTextStream(1, -2)
        Dim ThemeName
        Dim ThemeDesc
        Dim AuthorName, AuthorURL

	Do While Not ThemeTextStream.AtEndOfStream
		If ThemeTextStream.Readline = "*" Then
                ThemeName = ThemeTextStream.Readline
                ThemeDesc = ThemeTextStream.Readline
                
 		If ThemeTextStream.Readline = "*" Then
                AuthorName = ThemeTextStream.Readline
                AuthorURL  = ThemeTextStream.Readline
                Else
                AuthorName = ""
                AuthorURL = ""
                Status = "No Author Information"
                End If

                Else
                ThemeName = Folder.Name
                ThemeDesc = ""
                AuthorURL = ""
                AuthorName = ""
                Status = "No Theme Information (File Broken)"
                End If
	Loop
        
        ThemeTextStream.Close
	Set ThemeTextStream = nothing
	Set ThemeFile = Nothing
	
 Else
        ThemeName = Folder.Name
        ThemeDesc = ""
        AuthorURL = ""
        AuthorName = ""
	Status = "No Theme Information (File Not Found)"
 End If
%>
<!-- Start Information On <%=ThemeName%> -->
<div class="entry">
<h3 class="entryTitle">About <a href="?Theme=<%=Folder.Name%>"><%=ThemeName%></a><%If Template = Folder.Name Then Response.Write " (<b>Current</b>)"%></h3>
<div class="entryBody">
<p><b>Name</b> : <%=ThemeName%></p>
<% 
If ThemeDesc <> "" Then Response.Write "<p><b>Description</b> : " & ThemeDesc & "</p>"

If FSO.FileExists(ThemePath & "\Background.jpg") Then JPEG = True Else JPEG = False
If FSO.FileExists(ThemePath & "\Background.gif") Then GIF = True Else GIF = False

If (JPEG <> False) Or (GIF <> False) Then Response.Write "<p><b>Background</b> :<br/>"

If JPEG = True Then Response.Write "<a href=""Templates/" & Folder.Name & "/Background.jpg""><img alt=""" & Folder.Name & " Background"" width=""100"" height=""100"" src=""Templates/" & Folder.Name & "/Background.jpg""/></a></p>"

If GIF = True Then Response.Write "<a href=""Templates/" & Folder.Name & "/Background.gif""><img alt=""" & Folder.Name & " Background"" width=""100"" height=""100"" src=""Templates/" & Folder.Name  & "/Background.gif""/></a></p>"

If Len(AuthorName) > 0 Then Response.Write "<p><b>Author Information</b> : "
If Len(AuthorURL) > 0 Then Response.Write "<a href=""" & AuthorURL & """>" 
If Len(AuthorName) > 0 Then Response.Write AuthorName 
If Len(AuthorURL) > 0 Then Response.Write "</a></p>"

If Status <> "" Then Response.Write "<p> <b>Error</b> : " & Status & "</p>"
%>
<p>&nbsp;</p>
</div>
</div>
<%
Next

End If

Set FSO = Nothing
Set Folder = Nothing
Set Folders = Nothing

On Error GoTo 0
%>
</div>
<!-- #INCLUDE FILE="Includes/NAV.asp" -->
<!-- #INCLUDE FILE="Includes/Footer.asp" -->