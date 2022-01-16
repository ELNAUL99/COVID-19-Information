<%@ Page Language="C#" Inherits="COVID19.Default" %>
<!DOCTYPE html> 
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net"%>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="COVID19" %>
<html>
<head runat="server">
	<title> Coronavirus update </title>
    <link rel="stylesheet" href="Covid_style.css" type="text/css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
    <div class="header">
        <div class="glyphicon" style="font-size:40px;cursor:pointer; position: fixed; left:15px; top:10px; color:#e1e1e1" onclick="openNav()">&#xe056; </div>
        <div class="name"><span style="color:white">CORONA</span><span style="color:red">0</span><span style="color:white">METER</span></div>
    </div>
    <div id="mySidenav" class="sidenav">
      <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
      <a href="Covid_frontpage.html">Home</a>
      <a href="News.html">News</a>
      <a href="Prevention.html">Prevention</a>
      <a href="Infected.html">Infected</a>
      <a href="Contact.html">Contact</a>
    </div>
    <script>
    function openNav() {
      document.getElementById("mySidenav").style.width = "340px";
    }

    function closeNav() {
      document.getElementById("mySidenav").style.width = "0";
    }
    </script>
    <div class="pandemic">COVID-19 CORONAVIRUS PANDEMIC</div>
    <div class="lastupdate">Last updated: October 30, 2020, 14:30 GMT</div>
    <div class="bar"></div>
    <div class="bar" style="left:90%"></div>    
	<form id="form1" runat="server">
        <%
        Func<string, string, string> convertDate = (string date, string format) =>
        {
            if (date != "" && date != null)
            {
                return DateTime.ParseExact(date, "yyyy-MM-dd", null).ToString(format ?? "dd/MM/yyyy");
            }
            return null;
        };
        List<string> countries = new List<string>();
        var selectedCountry = Request["country"];
        var selectedDate = Request["date"];
        var error="";
        OutputInfo outputInfo;
        Database newCases= new Database();
           
        var jsonPath = Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "covidData.json");
        string json = File.ReadAllText(jsonPath);
        var settings = new JsonSerializerSettings {NullValueHandling = NullValueHandling.Ignore, MissingMemberHandling = MissingMemberHandling.Ignore};
        outputInfo = JsonConvert.DeserializeObject<OutputInfo>(json, settings);
        countries = outputInfo.GetAllCountries();
            
        if (selectedCountry == "Country") 
        {
            error = "Country should be selected!!!";
            selectedCountry="";
        }
        else if(selectedDate == "")
        {
            error = " Date should be selected!!!";
        }
        else
        {
            if (selectedCountry != null && selectedDate != null)
            {
                var formatedDate = convertDate(selectedDate, null);
                newCases = outputInfo.GetCase(selectedCountry, formatedDate);
            }
            else
            {
                newCases = null;
            }
        }
        %>
        <div class="textsearch">
        <p>Country:</p>
        <p>Date:</p>
        </div>
        <select name="country" class="searchform" style="top:230px">
            <option value="">Country</option>
            <% foreach (string country in countries)
               { %>
                <option
                    value="<%: country %>"
                    <%: country == selectedCountry ? "selected" : "" %>>
                    <%: country %>
                </option>
            <% } %>    
        </select>
        <input type="date" name="date" class="searchform" style="top:350px" max="<%:DateTime.Today.ToString("dd-MM-yyyy")%>""
                value="<%: selectedDate %>""/>
        <% if (error != "")
                  { %>
                <div style="position:absolute;top:480px;left:35%;color:red;font-size:30px">
                    <%: error %>
                </div>
            <% } %>
        <button class="buttonsearch">Search</button>
        <div style="position:absolute;top:500px;left:35%">
            <h2> <%=selectedCountry%>   <%=selectedDate%></h2>
            <div>
                <p>Country code: <span><%: newCases?.GeoId %></span></p>
                <p>Population data (2019): <span><%: newCases?.PopData2019 %></span></p>
                <p>Continent: <span><%: newCases?.ContinentExp %></span></p>
                <p>New deaths: <span><%: newCases?.Deaths > 0 ? "+" : "" %><%: newCases?.Deaths %></span></p>
                <p>New cases: <span> <%: newCases?.Cases > 0 ? "+" : "" %><%: newCases?.Cases %></span></p>
            </div>
        </div>
	</form>
</body>
</html>
