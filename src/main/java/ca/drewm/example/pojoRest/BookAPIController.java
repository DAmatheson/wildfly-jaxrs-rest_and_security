package ca.drewm.example.pojoRest;

import javax.annotation.security.RolesAllowed;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;


@Path("book")
public class BookAPIController {
	
	@RolesAllowed("dataentry")
	@POST
    @Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
    public Response postBook(Book book) {
		System.out.println("Posted book: \n" + book.toString());
		
        return Response.
        		status(201).
        		entity(book.toString()).
        		build();
    }
	
	@RolesAllowed("admin")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Book getBook() {
		Book b = new Book();
		b.setTitle("Java EE 7: The Big Picture");
		b.setAuthor("Dr. Danny Coward");
		b.setPageCount(486);
		
		return b;
	}
}
