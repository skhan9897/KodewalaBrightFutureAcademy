package com.kodewala.academy;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import com.google.cloud.firestore.Firestore;
import com.kodewala.academy.model.Student;
import com.kodewala.academy.model.Placement;
import com.kodewala.academy.model.Batch;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;

import javax.servlet.ServletContext;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

public class FirebaseService {
    private static Firestore db;

    public static void initialize(ServletContext context) {
        try {
            if (FirebaseApp.getApps().isEmpty()) {
                InputStream serviceAccount = context.getResourceAsStream("/WEB-INF/serviceAccountKey.json");

                if (serviceAccount == null) {
                    System.err.println("Firebase Error: serviceAccountKey.json not found in WEB-INF");
                    return;
                }

                FirebaseOptions options = new FirebaseOptions.Builder()
                        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                        .setStorageBucket("com-bank-kodewalaacademy-57959.firebasestorage.app")
                        .build();

                FirebaseApp.initializeApp(options);
            }
            db = FirestoreClient.getFirestore();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static List<Student> getAllStudents() throws ExecutionException, InterruptedException {
        List<Student> students = new ArrayList<>();
        if (db == null) return students;

        ApiFuture<QuerySnapshot> query = db.collection("admissions").get();
        QuerySnapshot querySnapshot = query.get();

        for (QueryDocumentSnapshot doc : querySnapshot.getDocuments()) {
            Student s = new Student();
            s.setId(doc.getId());
            s.setStudentId(doc.getString("studentId"));
            s.setBatchNumber(doc.getString("batchNumber"));
            s.setName(doc.getString("name"));
            s.setPhone(doc.getString("phone"));
            s.setEmail(doc.getString("email"));
            s.setQualification(doc.getString("qualification"));
            s.setPaymentMethod(doc.getString("paymentMethod"));
            s.setImageUrl(doc.getString("imageUrl"));
            s.setStatus(doc.getString("status"));
            s.setPaymentStatus(doc.getString("paymentStatus"));
            s.setZoomLink(doc.getString("zoomLink"));
            s.setZoomRecordingUrl(doc.getString("zoomRecordingUrl"));
            s.setTimestamp(doc.contains("timestamp") ? doc.getLong("timestamp") : 0L);
            students.add(s);
        }
        return students;
    }

    public static void updateStatus(String docId, String newStatus) throws ExecutionException, InterruptedException {
        if (db == null) return;
        Map<String, Object> updates = new HashMap<>();
        updates.put("status", newStatus);

        if ("Approved".equals(newStatus)) {
            ApiFuture<QuerySnapshot> query = db.collection("admissions")
                    .whereNotEqualTo("studentId", null)
                    .get();
            int approvedCount = query.get().size() + 1;

            String studentId = String.format("KA%02d", approvedCount);

            java.util.Calendar cal = java.util.Calendar.getInstance();
            String month = new java.text.SimpleDateFormat("MMM").format(cal.getTime()).toUpperCase();
            String year = new java.text.SimpleDateFormat("yy").format(cal.getTime());
            String batchId = "KA-BATCH-" + studentId.replace("KA", "") + "-" + month + year;

            updates.put("studentId", studentId);
            updates.put("batchNumber", batchId);
        }

        db.collection("admissions").document(docId).update(updates).get();
    }

    public static void verifyPayment(String docId, String newPaymentStatus) throws ExecutionException, InterruptedException {
        if (db == null) return;
        db.collection("admissions").document(docId).update("paymentStatus", newPaymentStatus).get();
    }

    public static void updateZoomDetails(String docId, String zoomLink, String zoomRecordingUrl) throws ExecutionException, InterruptedException {
        if (db == null) return;
        Map<String, Object> updates = new HashMap<>();
        updates.put("zoomLink", zoomLink);
        updates.put("zoomRecordingUrl", zoomRecordingUrl);
        updates.put("status", "Approved");
        db.collection("admissions").document(docId).update(updates).get();
    }

    public static void deleteStudent(String docId) throws ExecutionException, InterruptedException {
        if (db == null) return;
        db.collection("admissions").document(docId).delete().get();
    }

    public static void addPlacement(Placement p) throws ExecutionException, InterruptedException {
        if (db == null) return;
        Map<String, Object> data = new HashMap<>();
        data.put("name", p.getName());
        data.put("ctc", p.getCtc());
        data.put("role", p.getRole());
        data.put("education", p.getEducation());
        data.put("imageUrl", p.getImageUrl());
        data.put("isHighest", p.isHighest());
        data.put("timestamp", System.currentTimeMillis());
        db.collection("placements").add(data).get();
    }

    public static List<Placement> getAllPlacements() throws ExecutionException, InterruptedException {
        List<Placement> list = new ArrayList<>();
        if (db == null) return list;
        QuerySnapshot qs = db.collection("placements").orderBy("timestamp", com.google.cloud.firestore.Query.Direction.DESCENDING).get().get();
        for (QueryDocumentSnapshot doc : qs.getDocuments()) {
            Placement p = doc.toObject(Placement.class);
            p.setId(doc.getId());
            list.add(p);
        }
        return list;
    }

    public static void deletePlacement(String id) throws ExecutionException, InterruptedException {
        if (db == null) return;
        db.collection("placements").document(id).delete().get();
    }

    public static void addBatch(Batch b) throws ExecutionException, InterruptedException {
        if (db == null) return;
        Map<String, Object> data = new HashMap<>();
        data.put("batchName", b.getBatchName());
        data.put("zoomLink", b.getZoomLink());
        data.put("description", b.getDescription());
        data.put("isActive", true);
        db.collection("batches").add(data).get();
    }

    public static List<Batch> getAllBatches() throws ExecutionException, InterruptedException {
        List<Batch> list = new ArrayList<>();
        if (db == null) return list;
        QuerySnapshot qs = db.collection("batches").get().get();
        for (QueryDocumentSnapshot doc : qs.getDocuments()) {
            Batch b = doc.toObject(Batch.class);
            b.setId(doc.getId());
            list.add(b);
        }
        return list;
    }

    public static void deleteBatch(String id) throws ExecutionException, InterruptedException {
        if (db == null) return;
        db.collection("batches").document(id).delete().get();
    }
}
