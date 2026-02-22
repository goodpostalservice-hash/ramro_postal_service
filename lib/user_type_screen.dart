import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';




class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {

    final t = Theme.of(context);
    final cs = t.colorScheme;

    return Scaffold(
      backgroundColor: appTheme.gray25,
      body: SafeArea(
        child: Padding(
          padding: getPadding(left: 24, right: 24),
          child: Column(
            children: [
              SizedBox(height: getVerticalSize(16)),

              const Spacer(),

              _AppLogo(),

              SizedBox(height: getVerticalSize(28)),

              Text(
                'Welcome!',
                style: t.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),

              SizedBox(height: getVerticalSize(10)),

              Text(
                'Choose how you want to continue',
                textAlign: TextAlign.center,
                style: t.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),

              SizedBox(height: getVerticalSize(40)),

              RoleCard(
                icon: Icons.local_taxi,
                title: 'Driver',
                description: 'Earn money by giving rides',
                isSelected: selectedRole == 'driver',
                onTap: () => setState(() => selectedRole = 'driver'),
              ),

              SizedBox(height: getVerticalSize(16)),

              RoleCard(
                icon: Icons.person,
                title: 'Rider',
                description: 'Request rides to your destination',
                isSelected: selectedRole == 'rider',
                onTap: () => setState(() => selectedRole = 'rider'),
              ),

              SizedBox(height: getVerticalSize(28)),

              AppButton(
                onPressed: selectedRole == null
                    ? null
                    : () {
                        final roleText =
                            selectedRole == 'driver' ? 'Driver' : 'Rider';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Continuing as $roleText'),
                          ),
                        );
                      },
                // buttonStyle: selectedRole == null
                //     ? CustomButtonStyles.fillGray
                //     : CustomButtonStyles.fillPrimary,
                minHeight: getVerticalSize(56),
                 label: 'Continue',
                // radius is handled by your button styles; if your AppButton supports it, you can set.
              ),

              const Spacer(),

              Padding(
                padding: getPadding(bottom: 14),
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    return Container(
      width: getSize(96),
      height: getSize(96),
      decoration: AppDecoration.fillPrimary.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder19,
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.22),
            blurRadius: getHorizontalSize(16),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.directions_car,
        size: getSize(56),
        color: cs.onPrimary,
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    final bg = isSelected ? cs.primary : cs.surface;
    final border = isSelected ? cs.primary : cs.outlineVariant;
    final titleColor = isSelected ? cs.onPrimary : cs.onSurface;
    final descColor =
        isSelected ? cs.onPrimary.withOpacity(0.9) : cs.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadiusStyle.circleBorder19,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: getPadding(all: 18),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadiusStyle.circleBorder19,
          border: Border.all(
            color: border,
            width: getHorizontalSize(1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? cs.primary.withOpacity(0.22)
                  : Colors.black.withOpacity(0.04),
              blurRadius: getHorizontalSize(14),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: getSize(56),
              height: getSize(56),
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.onPrimary.withOpacity(0.18)
                    : cs.primary.withOpacity(0.08),
                borderRadius: BorderRadiusStyle.circleBorder19,
              ),
              child: Icon(
                icon,
                size: getSize(30),
                color: isSelected ? cs.onPrimary : cs.primary,
              ),
            ),
            SizedBox(width: getHorizontalSize(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: t.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: getVerticalSize(4)),
                  Text(
                    description,
                    style: t.textTheme.bodyMedium?.copyWith(
                      color: descColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: cs.onPrimary,
                size: getSize(26),
              ),
          ],
        ),
      ),
    );
  }
}
