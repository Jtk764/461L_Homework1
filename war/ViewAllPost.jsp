<%@ page import="java.util.Collections" %> 
<%@ page import="com.googlecode.objectify.Objectify" %> 
<%@ page import="com.googlecode.objectify.ObjectifyService" %> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import= "blogspot.Blog" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
 <head>
 	<TITLE>R/IDKWHATIMDOING</TITLE>
   <link href="http://thomasf.github.io/solarized-css/solarized-dark.min.css" rel="stylesheet"></link>
 </head>
  <body>
 
<h1 style="color:blue;">Reading All The Stuff</h1>

<%
    String guestbookName = "default";

    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<p><a href="/Post.jsp">Click to post!</a></p>

<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.</p>
<%
    }
%>
<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.

    Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);

    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());

    if (greetings.isEmpty()) {
        %>
        <p>No messages.</p>
        <%
    } else {
        %>
        <p>Messages:</p>
        <%
        for (Entity greeting : greetings) {
        	pageContext.setAttribute("greeting_title",greeting.getProperty("title"));
            pageContext.setAttribute("greeting_content",greeting.getProperty("content"));
            pageContext.setAttribute("greeting_date",greeting.getProperty("date"));

            if (greeting.getProperty("user") == null) {
                %>
                <p>An anonymous person wrote on ${fn:escapeXml(greeting_date)}:</p>
                <%
            } else {
                pageContext.setAttribute("greeting_user",greeting.getProperty("user"));
                %>
                <p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
                <%
            }
            %>
            <blockquote>${fn:escapeXml(greeting_title)}</blockquote>
			<br></br>            
            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
            <%
        }
    }

%>


 

  </body>

</html>

 