<%
Dim CalendarBackground

Select Case Template
  Case "Black"
    CalendarBackground = "fuchsia"
  Case "Busted"
    CalendarBackground = "#FF8C00"
  case "Default"
    CalendarBackground = "Silver"
  Case "Clouds"
    CalendarBackground = "DodgerBlue"
  Case "Matthew1471"
    CalendarBackground = "#003399"
  Case "Matrix"
    CalendarBackground = "#003300"
  Case "Leaves"
    CalendarBackground = "#008000"
  Case "LightSea"
    CalendarBackground = "darkblue"
  Case "Lotus"
    CalendarBackground = "#8B0000"
  Case "Pebbles"
    CalendarBackground = "RoyalBlue"
  Case "Orange"
    CalendarBackground = "#ff6600"
  Case "Palm Tree"
    CalendarBackground = "#5CACEE"
  Case "Purple"
    CalendarBackground = "#9933FF"
  Case "Puzzle"
    CalendarBackground = "#5CACEE"
  Case "Red"
    CalendarBackground = "DarkOrange"
  Case "Sandy"
    CalendarBackground = "#FFCC66"
  Case "Snails"
    CalendarBackground = "#008000"
  Case "Stary"
    CalendarBackground = "RoyalBlue"
  Case "Sea"
    CalendarBackground = "DarkBlue"
  Case "Swimming Pool"
    CalendarBackground = "#5CACEE"
  Case "TotallyGreen"
    CalendarBackground = "#363"
  Case "WaterFall"
    CalendarBackground = "#536e55"
  Case Else
  CalendarBackground = ""
End select
%> 