<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="blogSpot.Blog" %>

<%@ page import="java.util.List" %>

<%@ page import="java.util.Collections" %>

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

<%@ page import="com.googlecode.objectify.*" %>

 


<html>
 <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />


  <head>

  </head>

 

  <body>

 

<%

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "default";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<p>Hello!

<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to include your name with blogs you post.</p>

<%

    }

%>

 

<%

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);

    // Run an ancestor query to ensure we see the most up-to-date

    // view of the Greetings belonging to the selected Guestbook.

   ObjectifyService.register(Blog.class);

List<Blog> blogs = ObjectifyService.ofy().load().type(Blog.class).list();   

// Collections.sort(blogs); 

    if (blogs.isEmpty()) {

        %>

        <p>There are no Blogs.</p>

        <%

    } else {

        %>

        <p>Blogs: </p>

        <%

        for (Blog blog : blogs) {

            pageContext.setAttribute("blog_Title",

                                     blog.getContent());

     

           {

                pageContext.setAttribute("blog_user",

                                         blog.getUser());

                %>

                <p><b>${fn:escapeXml(blog_user.nickname)}</b> posted:</p>

                <%

            

            %>

            <blockquote>${fn:escapeXml(blog_content)}</blockquote>

            <%

        }

    }

%>

 

    <form action="/sign" method="post">

      <div><textarea name="content" rows="3" cols="60"></textarea></div>

      <div><input type="submit" value="Post Greeting" /></div>

      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>

    </form>

 

  </body>

</html>

 