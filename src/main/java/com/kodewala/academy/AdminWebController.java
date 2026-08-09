package com.kodewala.academy;

import com.kodewala.academy.model.Student;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class AdminWebController {

    @GetMapping("/")
    public String splash() {
        return "index"; // Splash Screen
    }

    @GetMapping("/admin-web/dashboard")
    public String dashboard(Model model) {
        try {
            List<Student> students = FirebaseService.getAllStudents();
            model.addAttribute("students", students);
            return "admin-dashboard"; 
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "error";
        }
    }

    @PostMapping("/admin-web/approve/{id}")
    public String approveStudent(@PathVariable String id) {
        try {
            FirebaseService.updateStatus(id, "Approved");
            return "redirect:/admin-web/dashboard";
        } catch (Exception e) {
            return "error";
        }
    }

    @PostMapping("/admin-web/reject/{id}")
    public String rejectStudent(@PathVariable String id) {
        try {
            FirebaseService.updateStatus(id, "Rejected");
            return "redirect:/admin-web/dashboard";
        } catch (Exception e) {
            return "error";
        }
    }
}
