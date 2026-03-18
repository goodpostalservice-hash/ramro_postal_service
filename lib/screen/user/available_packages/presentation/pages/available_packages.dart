import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/screen/user/available_packages/controller/available_package_controller.dart';
import '../../model/available_package_model.dart';

class _CardTheme {
  final Color background;
  final Color priceColor;
  final Color ctaBackground;
  final Color ctaText;
  final Color ctaBorder;
  final Color checkColor;
  final Color tagBg;
  final Color tagText;
  final String? popularTag;

  const _CardTheme({
    required this.background,
    required this.priceColor,
    required this.ctaBackground,
    required this.ctaText,
    required this.ctaBorder,
    required this.checkColor,
    this.tagBg = Colors.transparent,
    this.tagText = Colors.transparent,
    this.popularTag,
  });
}

final _themes = [
  _CardTheme(
    background: appTheme.white,
    priceColor: appTheme.black,
    ctaBackground: appTheme.black,
    ctaText: Colors.white,
    ctaBorder: appTheme.black,
    checkColor: const Color(0xFF16A34A),
  ),
  _CardTheme(
    background: appTheme.white,
    priceColor: appTheme.black,
    ctaBackground: appTheme.black,
    ctaText: Color(0xFF052E16),
    ctaBorder: Color(0xFF4ADE80),
    checkColor: Color(0xFF16A34A),
    tagBg: Color(0xFFDCFCE7),
    tagText: Color(0xFF166534),
    popularTag: 'Popular',
  ),
  _CardTheme(
    background: appTheme.white,
    priceColor: appTheme.black,
    ctaBackground: appTheme.black,
    ctaText: appTheme.white,
    ctaBorder: appTheme.black,
    checkColor: Color(0xFF16A34A),
  ),
];

class _PlanExtras {
  final String subtitle;
  final List<String> features;
  const _PlanExtras({required this.subtitle, required this.features});
}

_PlanExtras _extrasForIndex(int i, AvailablePackageModel pkg) {
  switch (i) {
    case 0:
      return _PlanExtras(
        subtitle: 'For new and growing businesses',
        features: [
          'One-time payment of NPR ${pkg.price!}',
          'Instant account activation',
          '0% tax — fully transparent pricing',
          'Access to all basic features',
          'Email support (Mon–Fri)',
        ],
      );
    case 1:
      return _PlanExtras(
        subtitle: 'For scaling companies',
        features: [
          'NPR ${pkg.discountPrice} one-time — best value',
          'Priority fraud protection',
          'Dedicated account manager',
          'Advanced analytics dashboard',
          '24/7 priority support',
        ],
      );
    default:
      return _PlanExtras(
        subtitle: 'For global and high-volume businesses',
        features: [
          'Custom pricing (contact sales)',
          'SLA 99.99% uptime guarantee',
          'Real-time risk scoring & analytics',
          'API customization & sandbox env',
          'Integration assistance & audit',
        ],
      );
  }
}

class AvailablePackageScreen extends StatefulWidget {
  const AvailablePackageScreen({super.key});

  @override
  State<AvailablePackageScreen> createState() => _AvailablePackageScreenState();
}

class _AvailablePackageScreenState extends State<AvailablePackageScreen> {
  late final PageController _pageCtrl = PageController(
    viewportFraction: 0.88,
    initialPage: 0,
  );
  int _currentPage = 0;
  final _packages = Get.put(AvailablePackageController());
  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: appTheme.gray25,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),

              Padding(
                padding: getPadding(left: 24, top: 20, right: 24, bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your plan',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF111111),
                        fontSize: getFontSize(22),
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: getVerticalSize(4)),
                    Text(
                      'Swipe to compare — pick what fits best',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF888888),
                        fontSize: getFontSize(13),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: getVerticalSize(18)),

              Expanded(
                child: Obx(() {
                  if (_packages.isLoading.value) {
                    return Center(
                      child: SizedBox(
                        width: getSize(26),
                        height: getSize(26),
                        child: CircularProgressIndicator(
                          strokeWidth: getHorizontalSize(2.4),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            appTheme.orangeBase,
                          ),
                        ),
                      ),
                    );
                  }

                  final list = _packages.availablePackages;

                  if (list.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: getPadding(left: 24, right: 24),
                        child: Text(
                          'No packages available right now.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF888888),
                            fontSize: getFontSize(13),
                          ),
                        ),
                      ),
                    );
                  }

                  // keep currentPage safe when list size changes
                  if (_currentPage >= list.length) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _currentPage = 0);
                      if (_pageCtrl.hasClients) {
                        _pageCtrl.jumpToPage(0);
                      }
                    });
                  }

                  return PageView.builder(
                    controller: _pageCtrl,
                    itemCount: list.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (_, i) {
                      final pkg = list[i];
                      final cardTheme = _themes[i % _themes.length];
                      final extras = _extrasForIndex(i, pkg);
                      final isActive = i == _currentPage;

                      return _PricingCard(
                        pkg: pkg,
                        cardTheme: cardTheme,
                        extras: extras,
                        isActive: isActive,
                        index: i,
                      );
                    },
                  );
                }),
              ),

              SizedBox(height: getVerticalSize(16)),

              Obx(() {
                if (_packages.isLoading.value) return const SizedBox.shrink();
                if (_packages.availablePackages.isEmpty) {
                  return SizedBox.shrink();
                }
                return _buildDots();
              }),

              SizedBox(height: getVerticalSize(32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: getPadding(left: 20, top: 14, right: 20, bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SmallIconBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          Text(
            'Packages',
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF111111),
              fontSize: getFontSize(16),
              fontWeight: FontWeight.w800,
            ),
          ),
          _SmallIconBtn(icon: Icons.more_horiz_rounded, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_packages.availablePackages.length, (i) {
        final active = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: getMargin(left: 3, right: 3),
          width: active ? getHorizontalSize(20) : getHorizontalSize(6),
          height: getVerticalSize(6),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF111111) : const Color(0xFFD4D4D4),
            borderRadius: BorderRadius.circular(getHorizontalSize(3)),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PRICING CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PricingCard extends StatelessWidget {
  final AvailablePackageModel pkg;
  final _CardTheme cardTheme;
  final _PlanExtras extras;
  final bool isActive;
  final int index;

  const _PricingCard({
    required this.pkg,
    required this.cardTheme,
    required this.extras,
    required this.isActive,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.0 : 0.94,
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.60,
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: getPadding(left: 10, right: 10, top: 2, bottom: 2),
          child: Container(
            decoration: BoxDecoration(
              color: cardTheme.background,
              borderRadius: BorderRadius.circular(getHorizontalSize(20)),
              border: Border.all(
                color: cardTheme.popularTag != null
                    ? const Color(0xFFBBF7D0)
                    : const Color(0xFFE5E5E5),
                width: cardTheme.popularTag != null ? 1.5 : 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: getPadding(all: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title row + popular tag ──────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pkg.title!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF111111),
                                fontSize: getFontSize(18),
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: getVerticalSize(4)),
                            Text(
                              extras.subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF888888),
                                fontSize: getFontSize(12),
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (cardTheme.popularTag != null) ...[
                        SizedBox(width: getHorizontalSize(8)),
                        Container(
                          padding: getPadding(
                            left: 10,
                            right: 10,
                            top: 4,
                            bottom: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cardTheme.tagBg,
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(100),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: getSize(6),
                                color: cardTheme.tagText,
                              ),
                              SizedBox(width: getHorizontalSize(4)),
                              Text(
                                cardTheme.popularTag!,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: cardTheme.tagText,
                                  fontSize: getFontSize(11),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: getVerticalSize(22)),

                  // ── Price ──────────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'NPR',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: cardTheme.priceColor,
                          fontSize: getFontSize(18),
                          fontWeight: FontWeight.w800,
                          height: 2.0,
                        ),
                      ),
                      SizedBox(width: getHorizontalSize(8)),
                      Text(
                        pkg.price!,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: cardTheme.priceColor,
                          fontSize: getFontSize(52),
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: getHorizontalSize(6)),
                      Padding(
                        padding: getPadding(bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (pkg.discountPrice == null)
                              Text(
                                'NPR ${pkg.discountPrice}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFFAAAAAA),
                                  fontSize: getFontSize(12),
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: const Color(0xFFAAAAAA),
                                ),
                              ),
                            Text(
                              '/ ${pkg.packageType}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF888888),
                                fontSize: getFontSize(13),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: getVerticalSize(22)),

                  // ── CTA Button (Ramro button system, SAME visual) ───────
                  SizedBox(
                    width: double.infinity,
                    child: _RamroCtaButton(
                      pkg: pkg,
                      cardTheme: cardTheme,
                      onTap: () {},
                    ),
                  ),

                  SizedBox(height: getVerticalSize(24)),

                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  SizedBox(height: getVerticalSize(20)),

                  // ── Features list ─────────────────────────────────────
                  Expanded(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: extras.features.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: getVerticalSize(12)),
                      itemBuilder: (_, i) => _FeatureRow(
                        text: extras.features[i],
                        checkColor: cardTheme.checkColor,
                      ),
                    ),
                  ),

                  SizedBox(height: getVerticalSize(16)),
                  _StatusRow(pkg: pkg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Ramro CTA BUTTON (keeps EXACT look, but routes through your button system)
// ─────────────────────────────────────────────────────────────────────────────
// Why this approach?
// - Your design needs per-card colors (black / green)
// - CustomButtonStyles usually locks to app primary colors
// - So we keep UI exact by drawing Container exactly,
//   but we still use Ramro fonts + sizing + behavior patterns.

class _RamroCtaButton extends StatelessWidget {
  final AvailablePackageModel pkg;
  final _CardTheme cardTheme;
  final VoidCallback onTap;

  const _RamroCtaButton({
    required this.pkg,
    required this.cardTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = pkg.hasSubscribed! ? 'Manage Plan' : 'Get Started';

    return InkWell(
      borderRadius: BorderRadius.circular(getHorizontalSize(12)),
      onTap: onTap,
      child: Container(
        height: getVerticalSize(48),
        decoration: BoxDecoration(
          color: cardTheme.ctaBackground,
          borderRadius: BorderRadius.circular(getHorizontalSize(12)),
          border: Border.all(color: cardTheme.ctaBorder, width: 1.5),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: cardTheme.ctaText,
                  fontSize: getFontSize(15),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.1,
                ),
              ),
              if (pkg.hasSubscribed!) ...[
                SizedBox(width: getHorizontalSize(6)),
                Icon(
                  Icons.verified_rounded,
                  color: cardTheme.ctaText,
                  size: getSize(16),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FEATURE ROW
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final String text;
  final Color checkColor;
  const _FeatureRow({required this.text, required this.checkColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_rounded, color: checkColor, size: getSize(16)),
        SizedBox(width: getHorizontalSize(10)),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF333333),
              fontSize: getFontSize(13),
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  STATUS ROW
// ─────────────────────────────────────────────────────────────────────────────

class _StatusRow extends StatelessWidget {
  final AvailablePackageModel pkg;
  const _StatusRow({required this.pkg});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: getPadding(left: 10, right: 10, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: pkg.status == 'active'
                ? const Color(0xFFDCFCE7)
                : const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(getHorizontalSize(100)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: getSize(5),
                height: getSize(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pkg.status == 'active'
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                ),
              ),
              SizedBox(width: getHorizontalSize(5)),
              Text(
                pkg.status == 'active' ? 'Active' : 'Inactive',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: pkg.status == 'active'
                      ? const Color(0xFF166534)
                      : const Color(0xFF991B1B),
                  fontSize: getFontSize(11),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        if (pkg.hasSubscribed!) ...[
          SizedBox(width: getHorizontalSize(8)),
          Container(
            padding: getPadding(left: 10, right: 10, top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(getHorizontalSize(100)),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  size: getSize(11),
                  color: const Color(0xFFD97706),
                ),
                SizedBox(width: getHorizontalSize(4)),
                Text(
                  'Subscribed',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF92400E),
                    fontSize: getFontSize(11),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
        const Spacer(),
        Text(
          '${double.parse(pkg.tax ?? '0').toStringAsFixed(0)}% tax',
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFFAAAAAA),
            fontSize: getFontSize(11),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SMALL ICON BUTTON (uses size utils + theme fonts, same look)
// ─────────────────────────────────────────────────────────────────────────────

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(getHorizontalSize(12)),
      onTap: onTap,
      child: Container(
        width: getSize(40),
        height: getSize(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(getHorizontalSize(12)),
          border: Border.all(color: const Color(0xFFE5E5E5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF111111), size: getSize(16)),
      ),
    );
  }
}
