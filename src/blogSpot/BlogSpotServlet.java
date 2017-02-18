package blogspot;


import com.google.appengine.api.datastore.DatastoreService;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.datastore.DatastoreServiceFactory;

import com.google.appengine.api.datastore.Entity;

import com.google.appengine.api.datastore.Key;

import com.google.appengine.api.datastore.KeyFactory;

import com.google.appengine.api.users.User;

import com.google.appengine.api.users.UserService;

import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

import java.io.IOException;

import java.util.Date;

 

import javax.servlet.http.HttpServlet;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

public class BlogSpotServlet extends HttpServlet {
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)

            throws IOException {

        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        if(user != null) {
        	resp.setContentType("text/html");
        } else {
        	resp.sendRedirect(userService.createLoginURL(req.getRequestURI()));
        }
    }
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
        // We have one entity group per Guestbook with all Greetings residing

        // in the same entity group as the Guestbook to which they belong.

        // This lets us run a transactional ancestor query to retrieve all

        // Greetings for a given Guestbook.  However, the write rate to each

        // Guestbook should be limited to ~1/second.

        Key guestbookKey = KeyFactory.createKey("Guestbook", "default");
        
        String title = req.getParameter("title");
        String content = req.getParameter("content");

        Date date = new Date();

        Entity greeting = new Entity("Greeting", guestbookKey);

        greeting.setProperty("user", user);

        greeting.setProperty("date", date);
        greeting.setProperty("title", title);
        greeting.setProperty("content", content);

 

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        datastore.put(greeting);

 

        resp.sendRedirect("/");
	}

	
	public void doSubscribe(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
        // We have one entity group per Guestbook with all Greetings residing

        // in the same entity group as the Guestbook to which they belong.

        // This lets us run a transactional ancestor query to retrieve all

        // Greetings for a given Guestbook.  However, the write rate to each

        // Guestbook should be limited to ~1/second.

        Key userkey = KeyFactory.createKey("User", "default");
        
        String title = user.toString();


        Entity user1 = new Entity("User", userkey);

        user1.setProperty("user", user);


 

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        datastore.put(user1);

 

        resp.sendRedirect("/");
	}
	
	public void doUnubscribe(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
        // We have one entity group per Guestbook with all Greetings residing

        // in the same entity group as the Guestbook to which they belong.

        // This lets us run a transactional ancestor query to retrieve all

        // Greetings for a given Guestbook.  However, the write rate to each

        // Guestbook should be limited to ~1/second.

        Key userkey = KeyFactory.createKey("User", "default");
        
        String title = user.toString();


        Entity user1 = new Entity("User", userkey);

        user1.setProperty("user", user);


 

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        datastore.delete(user1.getKey());

 

        resp.sendRedirect("/");
	}
}