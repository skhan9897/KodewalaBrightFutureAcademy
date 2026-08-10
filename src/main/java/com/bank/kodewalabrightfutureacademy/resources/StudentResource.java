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

@Path("/") // This combined with @ApplicationPath("/api") makes it /api/admissions etc.
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
        System.out.println("Received Registration Request for: " + student.getName());
        studentDAO.addStudent(student);
        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        return Response.status(Response.Status.CREATED).entity(response).build();
    }

    @POST
    @Path("confirm-payment")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response confirmPayment(Map<String, String> data) {
        String phone = data.get("phone");
        String paymentId = data.get("paymentId");
        System.out.println("Payment Confirmation Received: " + phone + " ID: " + paymentId);
        studentDAO.confirmPaymentAndApprove(phone, "Paid: " + paymentId);
        Map<String, String> response = new HashMap<>();
        response.put("status", "success");
        return Response.ok(response).build();
    }
}
