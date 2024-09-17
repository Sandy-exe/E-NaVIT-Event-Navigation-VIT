# E-NaVIT (EVENT NAVIGATION VIT)

**Helping you Navigate your way to our Events**

## Introduction

E-NaVIT is a comprehensive event management platform designed to address key challenges in managing and participating in campus events. By offering a streamlined, mobile-first solution, E-NaVIT simplifies the process of organizing, approving, and participating in events, making it easier for both students and faculty members to stay informed and engaged.

## Key Features

### 1. Efficient Event Management

- Provides a robust platform for viewing, editing, and managing events.
- A mobile app for real-time access to event information.

### 2. Role-Based Access Control

- Implements a user role system to define and manage authorizations.
- Roles include **Approver**, **Captain**, **Organizer**, **Club Member**, and **Participant**.

### 3. Streamlined Event Approval Process

- Simplifies the process of event approval for organizers and stakeholders.
- Allows for easy proposal of new events.

### 4. Improved Communication

- Facilitates clear communication between organizers and participants.
- Notifications include polls, venue changes, date adjustments, and attendance forms.

### 5. Event Participation Tracking

- Provides a mechanism to track participation, enabling proper recognition of students involved in events.

## Why Flutter?

- **Cross-Platform Compatibility:** Single codebase for iOS, Android, and web.
- **Firebase Integration:** Real-time synchronization, authentication, and cloud storage for backend management.
- **Rich UI/UX:** Visually appealing and responsive interfaces with Flutter's widget library.

## Why Firebase?

- **Easy Integration with Flutter:** Efficient backend management and real-time data handling.
- **Real-Time Database:** Ensures instant updates across devices.
- **Scalability:** Automatically scales with event size.

### Student Roles:

- **Participant:** Join events and view participation history.
- **Organizer:** Manage events they've organized and maintain records.
- **Club Member:** Propose events, view club statistics, and track event impacts.
- **Captain:** Submit event requests, manage club details, appoint organizers, and publish approved events.

### Faculty Role:

- **Approver:** Create, approve, and monitor events. Assign roles and broadcast updates.

## Database Structure

- **Users:** Information like email, events, favorites, roles, and more.
- **Events:** Track event attendance, budgets, coordinators, descriptions, etc.
- **Clubs:** Manage club-related data including events, followers, expenses, and revenue.
- **Approvals:** Manage the event approval process with relevant details like budget, coordinators, and event type.

## Roles & Responsibilities

![Roles and Responsibilities Chart](INFO\ROLES.png)

- **Approver:** Monitor performance, approve events, assign roles, and create updates.
- **Captain:** Lead the club by proposing events, managing the team, and publishing events after approval.
- **Organizer/Club Member/Participant:** Organize, track, and participate in events with access to relevant statistics.

## How to Use

1. Log in with your assigned role (Approver, Captain, Organizer, etc.).
2. Manage or participate in events based on your role.
3. Stay updated with notifications about upcoming events, approvals, and important changes.

[View PDF Presentation](INFO\PPT_ENAVIT.pdf) for More INFO.
