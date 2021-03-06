<%
' --------------------------------------------------------------------------
'�Introduction : Upload Photo Popup Page.                                   �
'�Purpose      : Performs the picture upload for blog administrator.        �
'�Used By      : Admin/UploadPicture.asp.                                   �
'�Requires     : Includes/Header.asp, Admin.asp, Includes/Footer.asp.       �
'�               Templates/Config.asp.                                      �
'�Standards    : XHTML Strict.                                              �
'---------------------------------------------------------------------------

OPTION EXPLICIT

'*********************************************************************
'** Copyright (C) 2003-08 Matthew Roberts, Chris Anderson
'**
'** This is free software; you can redistribute it and/or
'** modify it under the terms of the GNU General Public License
'** as published by the Free Software Foundation; either version 2
'** of the License, or any later version.
'**
'** All copyright notices regarding Matthew1471's BlogX
'** must remain intact in the scripts and in the outputted HTML
'** The "Powered By" text/logo with the http://www.blogx.co.uk link
'** in the footer of the pages MUST remain visible.
'**
'** This program is distributed in the hope that it will be useful,
'** but WITHOUT ANY WARRANTY; without even the implied warranty of
'** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'** GNU General Public License for more details.
'**********************************************************************

'-- If your host does not support parent paths specify the full path here --'
Dim ServerPathToInstalledDirectory
ServerPathToInstalledDirectory = Server.MapPath("..\")
'ServerPathToInstalledDirectory = "C:\inetpub\wwwroot"
%>
<!-- #INCLUDE FILE="../Includes/Config.asp" -->
<!-- #INCLUDE FILE="Admin.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
 <title><%=SiteDescription%> - Add Picture</title>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

 <!--
 //= - - - - - - - 
 // Copyright 2004-08, Matthew Roberts
 // Copyright 2003, Chris Anderson
 // 
 // Usage Of This Software Is Subject To The Terms Of The License
 //= - - - - - - -
 -->

 <script type="text/javascript">
  function retinfo(filename) {
   //Inda: Use the functions from AddEntry.asp (RTF.js) to insert image markup
   if(window.opener.document.forms['AddEntry'].Content.selectionStart > -1) {
     //Mozilla
     window.opener.changeMozilla("img", true, false, "src", "Images/Articles/" + filename, "style", "border:none");
   } else if(document.selection && document.selection.createRange) {
     //IE
     window.opener.changeIE("img", true, false, "src", "Images/Articles/" + filename, "style", "border:none");
   } else {
     alert("Your browser is not supported.");
   }
   self.close();
  }
 </script>
 <% If Request.Querystring("Theme") <> "" Then Template = Request.Querystring("Theme") %>
 <!-- #INCLUDE FILE="../Templates/Config.asp" -->
 <%
 If TemplateURL = "" Then
  Response.Write "<link href=""" & SiteURL & "Templates/" & Template & "/Blogx.css"" type=""text/css"" rel=""stylesheet""/>"
 Else
  Response.Write "<link href=""" & TemplateURL & Template & "/Blogx.css"" type=""text/css"" rel=""stylesheet""/>"
 End If

If Request.Querystring("MainPage") = "" Then
 Records.Open "SELECT RecordID FROM Data ORDER BY RecordID DESC",Database, 0, 1
  Dim ArticleNumber
  If NOT Records.EOF Then ArticleNumber = Records("RecordID")+1
 Records.Close
Else
 ArticleNumber = "Main"
End If

'-- Check allowed file types --'
Records.Open "SELECT AllowedExtension, Picture FROM FileExtensions WHERE Picture=True;", Database, 0, 1
Dim AllowedTypesArray, AllowedTypes
AllowedTypesArray = Records.GetRows(-1,0,"AllowedExtension")

For Count = 0 To UBound(AllowedTypesArray,2)
 AllowedTypes = AllowedTypes & AllowedTypesArray(0,Count)
 If Count < UBound(AllowedTypesArray,2) Then AllowedTypes = AllowedTypes & ","
Next

Records.Close

On Error Resume Next

Dim Upload
Set Upload = Server.CreateObject("aspSmartUpload.SmartUpload")

 If Err.Number = "-2147221005" Then
  Message = "Error: This Page Requires<br/><a href=""http://foradvice.net/asp_smart_upload.htm"">aspSmartUpload</a>."
 ElseIf Err.Number <> 0 Then
  Message = "Error: " & CStr(Err.Description) & "(" & Err.Number & ")"
 Else

 Dim Message
 Upload.AllowedFilesList = AllowedTypes
 'Upload.MaxFileSize = 50000
 'Upload.TotalMaxFileSize = 200000
 Upload.Upload
 
  Count = 0
 
  Dim Counter
  For Counter = 1 To Upload.Files.Count
   If NOT Upload.Files.Item(Counter).IsMissing Then  
    Randomize
    Dim FileName
    FileName = "Entry" & ArticleNumber & "_" & Int(Rnd*9999)+1 & ".jpg"
    Upload.Files.Item(Counter).SaveAs ServerPathToInstalledDirectory & "\Images\Articles\" & Filename
    Count = Count + 1
   End If
  Next

  If Len(Message) = 0 AND Len(CStr(Err.Description)) > 0 Then Message = "<p align=""center"">Error : " & Err.Description & "</p>"

 End If

Set Upload = Nothing
On Error GoTo 0

If Len(FileName) <> 0 Then Response.Write " <meta http-equiv=""Refresh"" content=""4; url=JavaScript:retinfo('" & FileName & "');""/>"

Response.Write "</head>" & VbCrlf
Response.Write "<body style=""background-color: " & BackgroundColor & """>" & VbCrlf

 Response.Write " <p style=""text-align:center; font-family:Verdana, Arial, Helvetica"">"

  If (Len(Message) <> 0) Then
   Response.Write "  " & Message & VbCrlf
  ElseIf (Count <= 0) Then
   Response.Write "  Nothing was uploaded,<br/>Check you can write to both folders." & VbCrlf
  End If

 Response.Write " </p>" & VbCrlf

 Response.Write " <p style=""text-align:center; font-face:Verdana, Arial, Helvetica; font-size: medium"">"

 Response.Write "<a href=""JavaScript:"

  If Len(Filename) > 0 Then
   Response.Write "retinfo('" & FileName & "');" 
  Else
   Response.Write "self.close();"
  End If
 
 Response.Write """>Close Window</a></p>" & VbCrlf

 Response.Write "</body>" & VbCrlf
 Response.Write "</html>" & VbCrlf

 Database.Close
 Set Records = Nothing
 Set Database = Nothing
%>