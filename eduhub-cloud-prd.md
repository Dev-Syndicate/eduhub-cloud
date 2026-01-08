# EduHub Cloud - Product Requirements Document

## 1. Executive Summary

**Product Name**: EduHub Cloud  
**Version**: 1.0 MVP  
**Target Users**: Students, Teachers, HODs, Campus Administrators  
**Platform**: Web + Mobile-Responsive  
**Tech Stack**: React/Next.js Frontend, FastAPI/Node.js Backend, Firebase Authentication, Firestore Database, Google Workspace APIs, Gemini API

EduHub Cloud is a unified campus productivity platform that integrates Google Workspace tools (Docs, Sheets, Slides, Calendar, Forms, Drive, Meet, Chat) into a single, role-based dashboard. It enables seamless academic collaboration, event management, complaint resolution, and campus communication while maintaining institutional control through granular role-based access.

---

## 2. Problem Statement

### Current Pain Points

1. **Fragmented Communication**: Students and teachers use scattered WhatsApp groups, individual emails, and disconnected calendars, causing missed announcements and deadline confusion.
2. **No Unified Academic Dashboard**: Assignment tracking, lecture notes, and resources are spread across multiple Google Docs/Sheets with no central visibility.
3. **Event Management Chaos**: Club events and hackathons rely on manual coordination through groups; no centralized registration, feedback, or analytics.
4. **Complaint Black Hole**: Campus service requests (hostel issues, WiFi problems, canteen feedback) disappear into WhatsApp without tracking or resolution visibility.
5. **Admin Overhead**: Campus administration manually tracks assignments, events, complaints, and policies across multiple documents without real-time analytics.
6. **Information Silos**: Students cannot easily find updated policies, exam timetables, lab bookings, or resources; old PDFs circulate instead of authoritative documents.

### Solution

EduHub Cloud consolidates all these workflows into one platform where:
- **Students** see personalized academic dashboards, complaint status, and event registrations.
- **Teachers** manage assignments, track student progress, and conduct live sessions.
- **HODs** oversee departmental academics, student complaints, and performance analytics.
- **Admins** manage all campus services, generate reports, and enforce policies.

---

## 3. Product Vision

A single-window campus hub that:
1. Eliminates communication fragmentation by centralizing announcements, calendars, and notifications.
2. Simplifies academic workflows by providing instant access to classes, assignments, and resources.
3. Streamlines event management with registration, feedback, and analytics.
4. Tracks and resolves campus complaints transparently.
5. Empowers admins with real-time insights into campus operations.

---

## 4. User Roles & Permissions

### 4.1 Admin (Campus Administrator)
**Responsibilities**:
- Manage all platform users, roles, and institutional settings.
- Oversee all campus services, complaints, and resolutions.
- Generate system-wide reports and analytics.
- Manage policies and circulars.

**Permissions**:
- Create/edit/delete users and roles.
- View all complaints and mark resolutions.
- Access all Sheets/Forms/Docs in campus-managed folders.
- Generate campus-wide reports (complaints, events, attendance).
- Publish announcements to all users.
- Manage event categories and approval workflows.

---

### 4.2 HOD (Head of Department)
**Responsibilities**:
- Oversee departmental academics, teachers, and student performance.
- Track and approve departmental events and activities.
- Review departmental complaints.
- Generate departmental reports.

**Permissions**:
- View all students and teachers in their department.
- Access departmental assignments and progress Sheets.
- View and manage departmental complaints.
- Approve departmental events and club activities.
- Access departmental policies and resources.
- Generate departmental analytics and reports.

---

### 4.3 Teacher
**Responsibilities**:
- Manage course content (lecture notes, assignments).
- Track student progress and provide feedback.
- Conduct live classes and doubt sessions.
- Manage course-specific Forms (quizzes, feedback).

**Permissions**:
- Create and manage shared Docs/Slides for lecture notes.
- Create and manage assignment Sheets for their courses.
- Create and manage Forms for quizzes and feedback.
- Schedule and host Google Meet sessions.
- Access student submission Sheets and provide feedback.
- View their course Chat spaces and student engagement.

---

### 4.4 Student
**Responsibilities**:
- Attend classes and submit assignments.
- Participate in clubs and events.
- View academic progress and resources.
- Submit service requests and complaints.

**Permissions**:
- View their enrolled courses and class schedules.
- Access lecture Docs/Slides and shared notes.
- View and submit assignments via assignment Sheets.
- Join Google Meet sessions for classes and doubt sessions.
- Register for events via Forms.
- Submit complaints via service request Forms.
- View their academic progress and performance.
- Access club and event information.

---

## 5. Core Modules

### 5.1 Module 1: Unified Academic Dashboard

**Overview**: A centralized view for students, teachers, and HODs to manage academic workflows.

#### Features for Students:
- **Today's Classes Card**:
  - Display classes for today from institutional Calendar.
  - Show class name, time, room, teacher name.
  - Quick link to join Google Meet (if session is live).
  - Quick access to shared lecture Docs/Slides.

- **My Courses**:
  - List of enrolled courses with course code, teacher name, and semester.
  - Quick links to course Docs, Sheets, Chat space, and Meet.

- **Assignment Tracker**:
  - Table showing all assignments across courses with:
    - Assignment name, course, due date, status (Not started, In progress, Submitted, Graded).
    - Score and feedback (when graded).
  - Filter by course or status.
  - Visual progress bar (days remaining).
  - Download submission link.

- **My Resources**:
  - Quick access to personal Drive folder (organized by course).
  - Previous-year question papers folder.
  - Class notes repository.

#### Features for Teachers:
- **My Classes**:
  - List of courses taught with student count and meet links.

- **Assignment Management**:
  - Create new assignment (form to input name, deadline, description).
  - View assignment responses in a Sheets-like table.
  - Mark submissions as graded, add scores and feedback.
  - Export responses as CSV.

- **Class Engagement**:
  - View attendance/participation from Forms (quizzes).
  - Quick stats on quiz performance (average score, pass rate).
  - Student slowest to submit assignments.

- **Meet Sessions**:
  - Schedule doubt-clearing sessions or recorded lectures.
  - Generate Meet link and share with students via Chat/Calendar.

#### Features for HODs:
- **Departmental Overview**:
  - Cards showing: Total students, Total courses, Total teachers, Average GPA, Assignment submission rate.

- **Course Analytics**:
  - Table of all courses with: course name, teacher, enrollment, average score, attendance rate.
  - Drill-down to see individual course performance.

- **Student Performance**:
  - Department-wide student list with: name, GPA, courses enrolled, assignment completion %.
  - Identify struggling students.

---

### 5.2 Module 2: Communication & Coordination

**Overview**: Centralized announcement, calendar, and messaging for campus coordination.

#### Features for All Users:
- **Announcement Feed**:
  - Aggregated from institutional Calendar (events) and Gmail labels (official announcements).
  - Sort by: Recent, Exam alerts, Club activities, Fee deadlines, Maintenance notices.
  - Push notifications for critical announcements (exam dates, fee deadlines).
  - Bookmark/save important announcements.

- **Unified Calendar**:
  - Display institutional Calendar with all events, exams, holidays, and deadlines.
  - Color-coded by event type (exam, club, maintenance, etc.).
  - Subscribe to specific calendars (courses, clubs, admin announcements).
  - Add events to personal calendars.
  - Sync with personal Google Calendar (one-way sync to platform).

- **Course Chat Spaces**:
  - Google Chat integration for each course.
  - Thread-based discussions for doubt-clearing.
  - File sharing within chat (linked to Drive).
  - Searchable message history.

#### Features for Teachers:
- **Create Announcements**:
  - Post course-specific announcements (linked to course Calendar).
  - Schedule announcement delivery (e.g., 1 hour before class).

#### Features for Admins:
- **Publish Campus Announcements**:
  - Create and schedule campus-wide announcements (exams, holidays, maintenance, etc.).
  - Add to institutional Calendar.
  - Optionally send email via Gmail integration.

---

### 5.3 Module 3: Clubs, Events & Campus Activities

**Overview**: Centralized event management with registration, feedback, and analytics.

#### Features for Event Organizers (Teachers/HODs/Admins):
- **Event Creation Form**:
  - Input: Event name, description, date, time, location, capacity, organizer name, contact, tags (technical, cultural, sports, etc.).
  - Auto-generate event page (backed by Google Sites or custom HTML).
  - Auto-create registration Form and responses Sheet.

- **Event Dashboard**:
  - Show all created events with stats: registered count, attendance, feedback rating.
  - Drill-down to see registered attendee list.
  - Export attendee list and feedback as CSV.

- **Event Deck Template**:
  - Pre-made Google Slides template for event presentations (problem, agenda, speakers, sponsors, rules, contact).
  - Auto-populate with event details.
  - Download or present directly.

#### Features for Students:
- **Event Directory**:
  - Browse all upcoming events filtered by: type (technical, cultural, sports), date, organizer.
  - Event cards showing: event name, date, capacity, registered count, rating.
  - Click to register via Form.
  - View attendee list and event feedback.

- **Event Registration**:
  - Simple Form-based registration (auto-linked to event).
  - Confirmation message with event details and Meet link (if virtual).
  - Calendar reminder for event date.

- **Event Feedback**:
  - Post-event Form for rating and feedback.
  - View aggregate feedback and event rating.

#### Features for Admins:
- **Event Approval Workflow** (optional):
  - Approve/reject new events from clubs/teachers before they go live.
  - Set event categories and manage event calendar.

---

### 5.4 Module 4: Complaint & Service Resolution

**Overview**: Centralized tracking and resolution of campus complaints and service requests.

#### Features for Students:
- **Submit Complaint/Request**:
  - Form with fields: category (hostel, WiFi, canteen, maintenance, academic, other), location, description, photo (optional), contact.
  - Auto-assign unique complaint ID.
  - Confirmation message with ID and expected resolution time.

- **Track Complaint Status**:
  - Dashboard showing all submitted complaints with status: Open, In progress, Resolved, Closed.
  - View last update timestamp and assigned admin/HOD name.
  - Reply/add comments to ongoing complaints.
  - Rate resolution and provide feedback.

#### Features for HODs/Admins:
- **Complaint Management Dashboard**:
  - Table of all complaints (or filtered by department) with: ID, category, location, status, submitter, date, priority.
  - Quick filters: status, category, date range, location, priority.

- **Complaint Details & Resolution**:
  - View full complaint details, history, and student comments.
  - Assign complaint to self or another admin.
  - Update status (Open → In progress → Resolved → Closed).
  - Add internal notes and resolution description.
  - Auto-generate confirmation email to student.

- **Analytics & Reports**:
  - Charts: Complaints by category, status distribution, average resolution time.
  - Heatmap: Complaint locations on campus (if location data available).
  - Export complaints and statistics as CSV/PDF.
  - Identify systemic issues (e.g., repeated WiFi complaints in certain areas).

#### Features for Admins:
- **System-Wide Complaint Governance**:
  - Set SLA (Service Level Agreement) timelines per category (e.g., WiFi issues: 24 hours, canteen feedback: 72 hours).
  - Auto-escalate overdue complaints.
  - Generate daily/weekly complaint reports for leadership.

---

### 5.5 Module 5: Policies & Resource Management

**Overview**: Centralized repository for institutional documents and policies.

#### Features for All Users:
- **Policy Library**:
  - Searchable database of campus policies (academic, hostel, conduct, etc.).
  - Documents backed by Google Docs (read-only access for students, edit access for admins).
  - Version history and "Last updated" timestamp.
  - PDF download option.
  - Breadcrumb navigation (Category → Policy).

- **Important Resources**:
  - Exam timetables (Sheets with calendar view).
  - Lab booking calendar.
  - Fee payment deadlines (Calendar + PDF).
  - Holiday calendar.
  - Campus map (embedded Google Map with key locations).

#### Features for Admins:
- **Publish & Manage Policies**:
  - Create new policy (backed by Google Docs).
  - Set publish date and auto-notify affected users.
  - Archive old policies.
  - Track policy version history.

---

### 5.6 Module 6: Personal Productivity

**Overview**: Personal task management and resource access for students.

#### Features for Students:
- **My Tasks**:
  - Sync assignments from teacher-created Sheets (read-only, auto-populate).
  - Add personal tasks (project todos, study goals, exam prep).
  - Filter by: course, due date, priority.
  - Mark tasks complete (for personal tasks only, assignment status reflects submission status).

- **My Resources Hub**:
  - Personal Drive folder overview (organized by course).
  - Suggested resources: recent lecture notes, uploaded documents, shared files.
  - Quick upload button to add files.
  - Search across personal Drive files.

---

## 6. Technical Architecture

### 6.1 Frontend Stack
- **Framework**: React 18+ / Next.js
- **UI Library**: Material-UI or Tailwind CSS
- **State Management**: Redux or Zustand
- **HTTP Client**: Axios or Fetch API
- **Real-time Updates**: Firebase Realtime Database listeners or Firestore snapshots
- **Calendar Component**: React Big Calendar or FullCalendar
- **Charts/Analytics**: Chart.js or Recharts
- **Google Integration**: Google APIs Client Library (JavaScript)

### 6.2 Backend Stack
- **Framework**: FastAPI (Python) or Node.js + Express
- **Database**: Firestore (Firebase)
- **Authentication**: Firebase Authentication (Google OAuth for campus SSO)
- **APIs**:
  - Google Workspace APIs: Calendar, Docs, Sheets, Slides, Drive, Forms, Chat, Meet
  - Gemini API (for AI-powered features like smart complaint summaries, event desc generation)
- **Background Jobs**: Celery (Python) or Bull (Node.js) for async tasks (e.g., report generation, notifications)
- **Deployment**: Firebase Hosting (Frontend) + Cloud Run / App Engine (Backend)

### 6.3 Database Schema (Firestore)

```
collections/
├── users/
│   ├── {userId}
│   │   ├── email: string
│   │   ├── name: string
│   │   ├── role: "student" | "teacher" | "hod" | "admin"
│   │   ├── department: string (for HODs, Teachers, Students)
│   │   ├── phoneNumber: string
│   │   ├── profilePhoto: string (Drive link)
│   │   ├── enrolledCourses: array of courseIds (for students)
│   │   ├── taughtCourses: array of courseIds (for teachers)
│   │   ├── createdAt: timestamp
│   │   └── updatedAt: timestamp
│
├── courses/
│   ├── {courseId}
│   │   ├── name: string
│   │   ├── code: string
│   │   ├── department: string
│   │   ├── semester: string
│   │   ├── teacherId: string
│   │   ├── teacherName: string
│   │   ├── description: string
│   │   ├── enrolledStudents: array of studentIds
│   │   ├── studentCount: number
│   │   ├── sharedDocId: string (Google Docs link for notes)
│   │   ├── assignmentSheetId: string (Google Sheets ID)
│   │   ├── chatSpaceId: string (Google Chat space ID)
│   │   ├── meetLink: string (Google Meet link)
│   │   ├── createdAt: timestamp
│   │   └── updatedAt: timestamp
│
├── assignments/
│   ├── {assignmentId}
│   │   ├── name: string
│   │   ├── courseId: string
│   │   ├── description: string
│   │   ├── dueDate: timestamp
│   │   ├── sheetId: string (Google Sheets ID for responses)
│   │   ├── teacherId: string
│   │   ├── createdAt: timestamp
│   │   └── submissions/
│   │       ├── {studentId}
│   │       │   ├── submittedAt: timestamp
│   │       │   ├── status: "not_started" | "in_progress" | "submitted" | "graded"
│   │       │   ├── score: number (optional)
│   │       │   ├── feedback: string (optional)
│   │       │   └── submissionLink: string (Drive link, optional)
│
├── events/
│   ├── {eventId}
│   │   ├── name: string
│   │   ├── description: string
│   │   ├── date: timestamp
│   │   ├── time: string (HH:MM format)
│   │   ├── location: string
│   │   ├── capacity: number
│   │   ├── tags: array (technical, cultural, sports, etc.)
│   │   ├── organizerId: string
│   │   ├── organizerName: string
│   │   ├── registrationFormId: string (Google Forms ID)
│   │   ├── responsesSheetId: string (Google Sheets ID)
│   │   ├── feedbackFormId: string (Google Forms ID)
│   │   ├── eventPageUrl: string (Sites or custom HTML)
│   │   ├── registeredCount: number
│   │   ├── feedbackRating: number (1-5, average)
│   │   ├── status: "draft" | "published" | "in_progress" | "completed" | "cancelled"
│   │   ├── meetLink: string (if virtual)
│   │   ├── createdAt: timestamp
│   │   └── updatedAt: timestamp
│
├── complaints/
│   ├── {complaintId}
│   │   ├── id: string (auto-generated, e.g., "COMP-2026-0001")
│   │   ├── studentId: string
│   │   ├── studentName: string
│   │   ├── studentContact: string
│   │   ├── category: string (hostel, WiFi, canteen, maintenance, academic, other)
│   │   ├── location: string
│   │   ├── description: string
│   │   ├── photoUrl: string (Drive link, optional)
│   │   ├── status: "open" | "in_progress" | "resolved" | "closed"
│   │   ├── priority: string (low, medium, high, critical)
│   │   ├── assignedToId: string (admin/HOD who owns it)
│   │   ├── resolutionNotes: string
│   │   ├── resolutionDate: timestamp
│   │   ├── rating: number (1-5, student feedback)
│   │   ├── createdAt: timestamp
│   │   ├── updatedAt: timestamp
│   │   └── comments/ (thread for communication)
│   │       ├── {commentId}
│   │       │   ├── userId: string
│   │       │   ├── text: string
│   │       │   ├── createdAt: timestamp
│
├── policies/
│   ├── {policyId}
│   │   ├── title: string
│   │   ├── category: string (academic, hostel, conduct, general)
│   │   ├── docId: string (Google Docs ID, read-only for students)
│   │   ├── publishedDate: timestamp
│   │   ├── effectiveDate: timestamp
│   │   ├── versionNumber: number
│   │   ├── summary: string
│   │   ├── createdAt: timestamp
│   │   └── updatedAt: timestamp
│
├── announcements/
│   ├── {announcementId}
│   │   ├── title: string
│   │   ├── content: string
│   │   ├── type: string (exam, event, maintenance, deadline, general)
│   │   ├── publishedBy: string (adminId)
│   │   ├── publishedDate: timestamp
│   │   ├── expiryDate: timestamp
│   │   ├── targetAudience: array (all, students, teachers, hods, admins, specific department)
│   │   ├── isPinned: boolean
│   │   └── createdAt: timestamp
│
└── notifications/
    ├── {notificationId}
    │   ├── userId: string
    │   ├── type: string (assignment_due, event_registration, complaint_update, announcement)
    │   ├── title: string
    │   ├── message: string
    │   ├── relatedItemId: string (assignmentId, eventId, complaintId, etc.)
    │   ├── isRead: boolean
    │   ├── createdAt: timestamp
    │   └── expiryDate: timestamp
```

### 6.4 Google Workspace API Integrations

| Module | Google API | Purpose |
|--------|-----------|---------|
| Academic Dashboard | Calendar API | Fetch class schedule |
| Academic Dashboard | Sheets API | Read/write assignment responses |
| Academic Dashboard | Docs API | Display lecture notes |
| Communication | Calendar API | Fetch institutional calendar |
| Communication | Gmail API | Send notifications |
| Communication | Chat API | Manage course Chat spaces |
| Communication | Meet API | Generate Meet links |
| Events | Forms API | Create registration/feedback forms |
| Events | Sheets API | Store registration responses |
| Events | Sites API | Create event pages (optional) |
| Policies | Docs API | Fetch and display policies |
| General | Drive API | Access and organize shared files |
| AI Features | Gemini API | Generate summaries, descriptions, insights |

### 6.5 Authentication & Authorization

- **Firebase Authentication**:
  - Google OAuth for campus email domain (e.g., @campus.edu).
  - Custom claims in Firebase for role assignment (student, teacher, hod, admin).
  - Token refresh and session management.

- **Authorization**:
  - Firestore security rules enforce role-based access.
  - Backend API endpoints check user role and department before serving data.
  - Google Workspace API calls made on behalf of users (OAuth 2.0 delegation).

---

## 7. User Workflows

### 7.1 Student Daily Workflow

1. **Login**: Google OAuth with campus email.
2. **Dashboard**: See today's classes, assignments due, and announcements.
3. **Access Class**: Click on class → view lecture notes (Google Docs), assignment (Google Sheets), Chat space, Meet link.
4. **Submit Assignment**: Upload file or complete Sheets form.
5. **Register for Event**: Browse event directory → register via Form → get calendar reminder.
6. **Submit Complaint**: Fill complaint Form → get tracking ID → monitor status.
7. **Personal Productivity**: Add personal tasks, check resources, sync with Drive.

### 7.2 Teacher Daily Workflow

1. **Login**: Google OAuth.
2. **Dashboard**: See enrolled students, assignment submissions, quiz responses.
3. **Manage Course**: Create/edit assignments, share Docs/Slides, create Forms (quizzes).
4. **Review Submissions**: See responses in Sheets, add scores and feedback.
5. **Host Session**: Schedule Meet, generate link, share via Calendar + Chat.
6. **Event**: Organize club event → create Form, approve registrations, collect feedback.

### 7.3 HOD Daily Workflow

1. **Login**: Google OAuth.
2. **Dashboard**: Departmental overview (courses, students, performance).
3. **Monitor**: Check course analytics, identify struggling students, review complaints.
4. **Approve**: Review and approve departmental events, club activities.
5. **Report**: Generate departmental performance reports for leadership.

### 7.4 Admin Daily Workflow

1. **Login**: Google OAuth.
2. **Dashboard**: Campus-wide overview (complaints, events, announcements).
3. **Manage**: Create announcements, manage events, approve/decline requests.
4. **Resolve**: Assign and track complaints, generate resolution reports.
5. **Govern**: Manage users, policies, institutional settings, SLAs.

---

## 8. Key Features & Differentiators

1. **Unified Dashboard**: Single login for all campus services (academics, events, complaints, resources).
2. **Google Workspace Integration**: Leverage existing institutional Google Workspace investments.
3. **Role-Based Access**: Granular control per role (student, teacher, HOD, admin).
4. **Real-Time Collaboration**: Instant updates on assignments, complaints, events.
5. **Analytics & Insights**: Department and campus-wide reports for informed decision-making.
6. **Complaint Transparency**: Students can track complaint status and resolution in real-time.
7. **AI-Powered Features** (Gemini):
   - Auto-summarize complaints by category.
   - Generate event descriptions and agendas.
   - Suggest solutions based on complaint patterns.
   - Draft resolution emails.
8. **Mobile-Responsive**: Works seamlessly on phones, tablets, and desktops.
9. **Scalable**: Can be deployed across multiple campuses with minimal configuration.

---

## 9. MVP Scope (TechSprint 24-Hour Hackathon)

### In Scope:
1. **Firebase Auth**: Google OAuth login with role assignment.
2. **Academic Dashboard** (Simplified):
   - Show today's classes from a mock Calendar.
   - Assignment tracker from Firestore with submission status.
   - Quick links to course resources (mock Docs/Sheets).
3. **Complaint Management**:
   - Submit complaint Form (Firestore backend).
   - Admin dashboard to view and update status.
   - Student complaint tracking.
4. **Event Management** (Basic):
   - Event creation and listing.
   - Registration via Form (Firestore-backed).
   - Attendee count and feedback.
5. **Announcements**:
   - Simple announcement feed from Firestore.
   - Filter by category.

### Out of Scope (Post-MVP):
1. Full Google Workspace API integration (can be mocked with sample data).
2. Gemini AI features (requires API setup).
3. Multi-campus deployments.
4. Advanced analytics and reporting.
5. Chat space management.
6. Meet integration (link generation only).
7. Document version control and ACL management.

---

## 10. Non-Functional Requirements

### 10.1 Performance
- Page load time: < 2 seconds.
- Search results: < 500ms.
- Real-time updates: < 1 second latency.

### 10.2 Security
- All data encrypted in transit (HTTPS).
- Firestore security rules enforce authentication and authorization.
- No sensitive data (passwords, tokens) stored in local storage.
- Rate limiting on API endpoints to prevent abuse.

### 10.3 Scalability
- Firestore auto-scales for up to 100,000 users.
- Firebase Hosting serves static assets globally via CDN.
- Backend APIs deployed on Cloud Run (auto-scaling).

### 10.4 Accessibility
- WCAG 2.1 Level AA compliance.
- Keyboard navigation support.
- Screen reader friendly.
- High contrast color scheme option.

### 10.5 Reliability
- 99.9% uptime SLA (Firebase guarantees).
- Automatic failover for backend services.
- Data backup and recovery (Firestore automatic backups).

---

## 11. User Interface Design Guidelines

### Color Scheme
- **Primary**: Teal/Blue (Google brand colors).
- **Secondary**: Orange/Yellow for accents.
- **Neutral**: Gray for backgrounds, text.
- **Status Colors**: Green (approved), Orange (pending), Red (rejected/urgent).

### Typography
- **Font Family**: Inter, Roboto (modern, readable).
- **Headings**: Bold, 24px–32px.
- **Body Text**: Regular, 14px–16px.

### Components
- **Cards**: For assignments, events, announcements (shadow + border).
- **Modals**: For forms, confirmations.
- **Buttons**: Primary (filled, teal), Secondary (outlined), Tertiary (text-only).
- **Tables**: Sortable, filterable columns with pagination.
- **Charts**: Bar charts (complaints by category), Pie charts (status distribution), Heatmaps (locations).

### Responsive Design
- **Desktop**: Full-width layout with sidebars.
- **Tablet**: Single-column layout, collapsible sidebars.
- **Mobile**: Bottom navigation bar, stacked cards.

---

## 12. Monetization & Scalability

### Licensing Model (Post-MVP)
1. **Freemium**: Basic features for free (up to 100 students).
2. **Professional**: ₹500–1000/month (up to 1000 students, analytics, priority support).
3. **Enterprise**: Custom pricing (multi-campus, dedicated support, integrations).

### Revenue Streams
1. **Per-Campus Licensing**: ₹5000–20,000/month depending on student count.
2. **Premium Features**: Advanced analytics, AI summaries, priority support.
3. **API Access**: For third-party integrations (e.g., LMS plugins).

### Scalability Path
- **Phase 1 (MVP)**: Single campus, core modules.
- **Phase 2 (3–6 months)**: Multi-campus support, Gemini AI integration, advanced analytics.
- **Phase 3 (6–12 months)**: Mobile native apps, LMS integrations, advanced automation.

---

## 13. Success Metrics (KPIs)

| Metric | Target (MVP) | Target (6 months) |
|--------|--------------|-------------------|
| Daily Active Users | 200+ students | 1000+ across 3 campuses |
| Assignment Submission Rate | 80%+ | 85%+ |
| Complaint Resolution Time (avg) | 48 hours | 24 hours |
| User Satisfaction (NPS) | 50+ | 70+ |
| Event Registrations per Month | 300+ | 1000+ |
| Platform Uptime | 99.9% | 99.95% |
| Feature Adoption Rate | 60%+ modules used | 80%+ modules used |

---

## 14. Constraints & Assumptions

### Constraints
1. **MVP Timeline**: 24 hours (TechSprint hackathon).
2. **Team Size**: 2–4 developers.
3. **Google Workspace API Quota**: Limited free tier; may use mock data in MVP.
4. **Deployment**: Firebase (free tier) for MVP, paid tier for production.

### Assumptions
1. All campus users have Google accounts (@campus.edu).
2. Campus has existing Google Workspace for Education license.
3. Internet connectivity is available on campus.
4. Users have basic digital literacy.

---

## 15. Launch Plan & Timeline

### Week 1–2: Design & Setup
- Finalize user flows and wireframes.
- Setup Firebase project, Firestore database.
- Setup frontend and backend repositories.
- Design UI/UX in Figma (reusable components).

### Week 3–4: Core Development
- Implement Firebase Auth (Google OAuth).
- Build Academic Dashboard module (mockup integration).
- Build Complaint Management module.
- Implement Firestore CRUD operations.

### Week 5: Additional Modules & Testing
- Build Event Management module.
- Build Announcement Feed.
- Unit and integration testing.
- Performance optimization.

### Week 6: Deployment & Launch
- Deploy frontend to Firebase Hosting.
- Deploy backend to Cloud Run.
- Configure custom domain.
- Beta testing with 50–100 users.
- Full launch and marketing.

---

## 16. Appendix

### A. Wireframes/UI Mockups
(To be created in Figma and linked here)

### B. API Endpoint Specifications
(To be detailed in OpenAPI/Swagger documentation)

### C. Database Security Rules
(Firestore rules to be detailed in firebase.rules file)

### D. Google Workspace API Integration Guides
(Links to official Google documentation)

### E. Glossary
- **HOD**: Head of Department (faculty administrator).
- **SLA**: Service Level Agreement (target resolution time).
- **MVP**: Minimum Viable Product (core features only).
- **OAuth**: Open Authentication standard for secure login.
- **Firestore**: Google Cloud's NoSQL database.

---

**Document Version**: 1.0  
**Last Updated**: January 8, 2026  
**Owner**: Product Team  
**Status**: Draft (Ready for Development)
