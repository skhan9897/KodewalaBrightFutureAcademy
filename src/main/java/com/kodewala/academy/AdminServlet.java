package com.kodewala.academy;

import com.kodewala.academy.model.Student;
import com.kodewala.academy.model.Placement;
import com.kodewala.academy.model.Batch;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        FirebaseService.initialize(getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            List<Student> students = FirebaseService.getAllStudents();
            List<Placement> placements = FirebaseService.getAllPlacements();
            List<Batch> batches = FirebaseService.getAllBatches();

            request.setAttribute("students", students);
            request.setAttribute("placements", placements);
            request.setAttribute("batches", batches);

            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String docId = request.getParameter("docId");

        try {
            if ("logout".equals(action)) {
                session.invalidate();
                response.sendRedirect("login");
                return;
            } else if ("approve".equals(action)) {
                FirebaseService.updateStatus(docId, "Approved");
            } else if ("verifyPayment".equals(action)) {
                FirebaseService.verifyPayment(docId, "Paid");
            } else if ("updateZoom".equals(action)) {
                String zoomLink = request.getParameter("zoomLink");
                String zoomRecordingUrl = request.getParameter("zoomRecordingUrl");
                FirebaseService.updateZoomDetails(docId, zoomLink, zoomRecordingUrl);
            } else if ("reject".equals(action)) {
                FirebaseService.updateStatus(docId, "Rejected");
            } else if ("delete".equals(action)) {
                FirebaseService.deleteStudent(docId);
            } else if ("addPlacement".equals(action)) {
                Placement p = new Placement();
                p.setName(request.getParameter("name"));
                p.setCtc(request.getParameter("ctc"));
                p.setRole(request.getParameter("role"));
                p.setEducation(request.getParameter("education"));
                p.setImageUrl(request.getParameter("imageUrl"));
                p.setHighest("on".equals(request.getParameter("isHighest")));
                FirebaseService.addPlacement(p);
            } else if ("deletePlacement".equals(action)) {
                FirebaseService.deletePlacement(request.getParameter("id"));
            } else if ("addBatch".equals(action)) {
                Batch b = new Batch();
                b.setBatchName(request.getParameter("batchName"));
                b.setZoomLink(request.getParameter("zoomLink"));
                b.setDescription(request.getParameter("description"));
                FirebaseService.addBatch(b);
            } else if ("deleteBatch".equals(action)) {
                FirebaseService.deleteBatch(request.getParameter("id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin");
    }
}
