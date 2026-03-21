import 'package:flutter/material.dart';
import 'app_sidebar.dart';
import '../../features/doctor/presentation/router/doctor_router.dart';
import '../../features/receptionist/presentation/router/receptionist_router.dart';
import '../../features/appointment/presentation/router/appointment_router.dart';
import '../../features/patient/presentation/router/patient_router.dart';

class LayoutConfig {
  final List<SidebarItem> sidebarItems;
  final String title;
  final String subtitle;
  final String pageTitle;

  const LayoutConfig({
    required this.sidebarItems,
    required this.title,
    required this.subtitle,
    required this.pageTitle,
  });

  factory LayoutConfig.fromLocation(String location) {
    if (location.startsWith('/reception')) {
      return LayoutConfig(
        sidebarItems: [
          const SidebarItem(
            label: 'Dashboard',
            icon: Icons.dashboard,
            route: ReceptionistRouter.dashboard,
          ),
          const SidebarItem(
            label: 'Patient List',
            icon: Icons.people,
            route: PatientRouter.root,
          ),
          const SidebarItem(
            label: 'Add Appointment',
            icon: Icons.calendar_today,
            route: AppointmentRouter.addAppointment,
          ),
        ],
        title: 'Mini Clinic',
        subtitle: 'Receptionist',
        pageTitle: _getReceptionPageTitle(location),
      );
    } else if (location.startsWith('/doctor')) {
      return LayoutConfig(
        sidebarItems: [
          const SidebarItem(
            label: 'Queue',
            icon: Icons.people_outline,
            route: DoctorRouter.dashboard,
          ),
        ],
        title: 'Mini Clinic',
        subtitle: 'Doctor',
        pageTitle: _getDoctorPageTitle(location),
      );
    }

    return const LayoutConfig(
      sidebarItems: [],
      title: 'Mini Clinic',
      subtitle: '',
      pageTitle: '',
    );
  }

  static String _getReceptionPageTitle(String location) {
    if (location == ReceptionistRouter.dashboard) {
      return 'Reception Dashboard';
    }
    if (location.contains('register-patient')) {
      return 'Register Patient';
    }
    if (location == AppointmentRouter.addAppointment) {
      return 'Add Appointment';
    }
    if (location == PatientRouter.root) {
      return 'Patient List';
    }
    return '';
  }

  static String _getDoctorPageTitle(String location) {
    if (location == DoctorRouter.dashboard) {
      return 'Doctor Dashboard';
    }
    if (location.contains('prescription')) {
      return 'Add Prescription';
    }
    if (location.contains('patient')) {
      return 'Patient Details';
    }
    return '';
  }
}
