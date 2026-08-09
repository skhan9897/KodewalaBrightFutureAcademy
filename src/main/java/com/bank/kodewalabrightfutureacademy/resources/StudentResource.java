package com.bank.kodewalabrightfutureacademy.resources;

import com.bank.kodewalabrightfutureacademy.dao.StudentDAO;
import com.bank.kodewalabrightfutureacademy.model.Student;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.Consumes;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("/")
public class StudentResource {

    private final StudentDAO studentDAO = new StudentDAO();
    private final com.bank.kodewalabrightfutureacademy.dao.PlacementDAO placementDAO = new com.bank.kodewalabrightfutureacademy.dao.PlacementDAO();

    @GET
    @Path("admissions")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Student> getAllStudents() {
        return studentDAO.getAllStudents();
    }

    @GET
    @Path("placements")
    @Produces(MediaType.APPLICATION_JSON)
    public List<com.bank.kodewalabrightfutureacademy.model.Placement> getAllPlacements() {
        return placementDAO.getAllPlacements();
    }

    @POST
    @Path("register")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response registerStudent(Student student) {
        studentDAO.addStudent(student);
        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Student registered successfully");
        return Response.status(Response.Status.CREATED).entity(response).build();
    }
}
