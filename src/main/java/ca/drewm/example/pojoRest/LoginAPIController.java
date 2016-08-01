package ca.drewm.example.pojoRest;

import javax.annotation.security.PermitAll;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("login")
@PermitAll
public class LoginAPIController {
	
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public Response login(LoginModel login, @Context HttpServletRequest req) {
		
	    String username = login.getUsername();
	    String password = login.getPassword();

	    if (req.getUserPrincipal() == null) {
	        try {
	            req.login(username, password);
	            System.out.println("Logged in as: " + getUserName(req));
	            //req.getSession().setAttribute("Test", "Test");
	        } catch(ServletException e) {
	            e.printStackTrace();
	            
	            return Response.status(Response.Status.UNAUTHORIZED).build();
	        }

	    } else if (!username.equals(req.getUserPrincipal().toString())) {
	        try {
	        	System.out.println("Logging out as: " + getUserName(req));
	        	
	        	req.logout();
	        	req.login(username, password);
	        	
	        	System.out.println("Logged in as: " + getUserName(req));
	        } catch (ServletException e) {
	        	e.printStackTrace();
	        	
	        	return Response.status(Response.Status.UNAUTHORIZED).build();
	        }
	    } else {
	    	req.getServletContext().log("Skip logging in because already logged in as: " + getUserName(req));
	    }

	    req.getServletContext().log("Authentication Demo: successfully retrieved User Profile from DB for " + username);
	    
	    return Response.ok().build();
	}
	
	private String getUserName(HttpServletRequest req) {
		return req != null ? req.getUserPrincipal().toString() : null;
	}
}
