# Staff Management System

A modern Flutter application for managing university staff members with Firebase Firestore integration.

## 📱 Overview

This application provides a comprehensive staff management system designed specifically for university environments. It allows administrators to efficiently manage staff information including personal details and department assignments.

## ✨ Features

### Core Functionality
- **Staff Registration**: Add new staff members with complete information
- **Staff Listing**: View all registered staff in an organized, searchable format
- **Staff Management**: Edit and delete existing staff records
- **Department Organization**: Categorize staff by university departments

### Technical Features
- **Real-time Data**: Firebase Firestore integration for live data synchronization
- **Input Validation**: Comprehensive form validation for data integrity
- **Modern UI**: Material 3 design with custom purple theme
- **Responsive Design**: Optimized for various screen sizes
- **Smooth Animations**: Enhanced user experience with fluid transitions

## 🏛️ University Departments

The application supports 30+ university departments including:
- **Academic**: Computer Science, Engineering, Mathematics, Physics, Chemistry, Biology
- **Humanities**: English Literature, History, Philosophy, Psychology
- **Business**: Business Administration, Economics, Marketing, Finance
- **Professional**: Medicine, Nursing, Law, Architecture, Education
- **Support**: Human Resources, Administration, Library Science, Maintenance

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase Firestore
- **Authentication**: Firebase Core
- **State Management**: StatefulWidget with Provider pattern
- **UI Design**: Material 3 with custom theming
- **Platform**: iOS and Android

## 📋 Staff Information Captured

- **Personal Details**: Full name, age
- **Professional Info**: Staff ID, department assignment
- **Metadata**: Registration timestamp, last updated

## 🎨 User Interface

### Staff List Page (Main Screen)
- Dashboard with total staff count
- Beautiful card-based staff display
- Department icons and categorization
- Quick access to add/edit/delete functions
- Search and filter capabilities

### Staff Creation/Edit Page
- Intuitive form with input validation
- Department dropdown with visual icons
- Real-time validation feedback
- Smooth animations and transitions

## 🔧 Setup Instructions

### Prerequisites
- Flutter SDK (latest version)
- Firebase project setup
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure Firebase:
   - Add `google-services.json` (Android)
   - Add `GoogleService-Info.plist` (iOS)
4. Run `flutter run` to start the application

## 📱 Supported Platforms

- **iOS**: 13.0+
- **Android**: API 21+
- **Web**: Modern browsers (Chrome, Firefox, Safari)

## 🎯 Use Cases

- **University Administration**: Manage faculty and staff records
- **HR Departments**: Track employee information and assignments
- **Department Heads**: View and manage departmental staff
- **Academic Planning**: Resource allocation and staff distribution

## 🔐 Data Security

- Secure Firebase Firestore rules
- Input validation and sanitization
- Type-safe data models
- Error handling and recovery

## 📈 Future Enhancements

- Advanced search and filtering
- Export functionality (PDF, Excel)
- Staff photo uploads
- Role-based access control
- Attendance tracking integration
- Reporting and analytics dashboard

## 👨‍💻 Development

This project demonstrates modern Flutter development practices including:
- Clean architecture principles
- Separation of concerns
- Reusable component design
- Comprehensive error handling
- Performance optimization

---

*Built with ❤️ using Flutter and Firebase*
