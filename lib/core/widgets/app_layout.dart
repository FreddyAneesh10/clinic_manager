import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_sidebar.dart';
import 'custom_app_bar.dart';
import 'custom_icon_button.dart';
import 'responsive.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;
  final List<SidebarItem> sidebarItems;
  final String title;
  final String subtitle;
  final VoidCallback? onLogout;
  final String pageTitle;
  final List<Widget>? actions;

  const AppLayout({
    super.key,
    required this.child,
    required this.currentRoute,
    required this.sidebarItems,
    required this.title,
    this.subtitle = '',
    this.onLogout,
    required this.pageTitle,
    this.actions,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  bool _sidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return _MobileLayout(
        currentRoute: widget.currentRoute,
        sidebarItems: widget.sidebarItems,
        title: widget.title,
        subtitle: widget.subtitle,
        onLogout: widget.onLogout,
        pageTitle: widget.pageTitle,
        actions: widget.actions,
        child: widget.child,
      );
    }

    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AppSidebar(
            currentRoute: widget.currentRoute,
            items: widget.sidebarItems,
            title: widget.title,
            subtitle: widget.subtitle,
            onLogout: widget.onLogout,
            isCollapsed: !isDesktop || _sidebarCollapsed,
          ),
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: AppColors.surface,
                  child: Row(
                    children: [
                      CustomIconButton(
                        icon: (_sidebarCollapsed || !isDesktop) ? Icons.menu : Icons.menu_open,
                        color: AppColors.textSecondary,
                        onPressed: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.pageTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      if (widget.actions != null) ...widget.actions!,
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Content
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  final List<SidebarItem> sidebarItems;
  final String title;
  final String subtitle;
  final VoidCallback? onLogout;
  final String pageTitle;
  final List<Widget>? actions;

  const _MobileLayout({
    required this.child,
    required this.currentRoute,
    required this.sidebarItems,
    required this.title,
    this.subtitle = '',
    this.onLogout,
    required this.pageTitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: pageTitle,
        actions: actions,
      ),
      drawer: Drawer(
        child: AppSidebar(
          currentRoute: currentRoute,
          items: sidebarItems,
          title: title,
          subtitle: subtitle,
          onLogout: () {
            Navigator.of(context).pop();
            onLogout?.call();
          },
        ),
      ),
      body: child,
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'waiting':
        color = AppColors.waiting;
        label = 'Waiting';
        break;
      case 'in_consultation':
        color = AppColors.inConsultation;
        label = 'In Consultation';
        break;
      case 'completed':
        color = AppColors.completed;
        label = 'Completed';
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );
  }
}
