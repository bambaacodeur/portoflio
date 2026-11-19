import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Design tokens for the portfolio. Every color in the UI comes from here,
/// so light and dark mode stay in sync and contrast stays checked.
@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.background,
    required this.backgroundAlt,
    required this.surface,
    required this.border,
    required this.ink,
    required this.body,
    required this.muted,
    required this.primary,
    required this.primaryInk,
    required this.primaryTint,
    required this.heroStart,
    required this.heroEnd,
    required this.onHero,
    required this.onHeroMuted,
    required this.footer,
    required this.footerInk,
    required this.footerMuted,
    required this.footerBrand,
    required this.shadow,
  });

  final Color background;
  final Color backgroundAlt;
  final Color surface;
  final Color border;
  final Color ink;
  final Color body;
  final Color muted;
  final Color primary;
  final Color primaryInk;
  final Color primaryTint;
  final Color heroStart;
  final Color heroEnd;
  final Color onHero;
  final Color onHeroMuted;
  final Color footer;
  final Color footerInk;
  final Color footerMuted;
  final Color footerBrand;
  final Color shadow;

  LinearGradient get heroGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [heroStart, heroEnd],
      );

  static const light = Palette(
    background: Color(0xFFFFFFFF),
    backgroundAlt: Color(0xFFF6F6FB),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE4E4EE),
    ink: Color(0xFF14142B),
    body: Color(0xFF3A3A55),
    muted: Color(0xFF55557A),
    primary: Color(0xFF4F46E5),
    primaryInk: Color(0xFF3F37C9),
    primaryTint: Color(0xFFEEEDFD),
    heroStart: Color(0xFF4338CA),
    heroEnd: Color(0xFF6D28D9),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFFE6E3FF),
    footer: Color(0xFF14142B),
    footerInk: Color(0xFFFFFFFF),
    footerMuted: Color(0xFFC4C4DA),
    footerBrand: Color(0xFFB4B0FF),
    shadow: Color(0x1414142B),
  );

  static const dark = Palette(
    background: Color(0xFF0D0D1A),
    backgroundAlt: Color(0xFF121224),
    surface: Color(0xFF1A1A30),
    border: Color(0xFF2C2C48),
    ink: Color(0xFFF2F2FA),
    body: Color(0xFFD3D3E6),
    muted: Color(0xFFA9A9C6),
    primary: Color(0xFFA5A1FF),
    primaryInk: Color(0xFFC3C0FF),
    primaryTint: Color(0xFF26244A),
    heroStart: Color(0xFF312E81),
    heroEnd: Color(0xFF5B21B6),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFFDDD9FF),
    footer: Color(0xFF08080F),
    footerInk: Color(0xFFFFFFFF),
    footerMuted: Color(0xFFB9B9D2),
    footerBrand: Color(0xFFB4B0FF),
    shadow: Color(0x66000000),
  );

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(ThemeExtension<Palette>? other, double t) {
    if (other is! Palette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return Palette(
      background: l(background, other.background),
      backgroundAlt: l(backgroundAlt, other.backgroundAlt),
      surface: l(surface, other.surface),
      border: l(border, other.border),
      ink: l(ink, other.ink),
      body: l(body, other.body),
      muted: l(muted, other.muted),
      primary: l(primary, other.primary),
      primaryInk: l(primaryInk, other.primaryInk),
      primaryTint: l(primaryTint, other.primaryTint),
      heroStart: l(heroStart, other.heroStart),
      heroEnd: l(heroEnd, other.heroEnd),
      onHero: l(onHero, other.onHero),
      onHeroMuted: l(onHeroMuted, other.onHeroMuted),
      footer: l(footer, other.footer),
      footerInk: l(footerInk, other.footerInk),
      footerMuted: l(footerMuted, other.footerMuted),
      footerBrand: l(footerBrand, other.footerBrand),
      shadow: l(shadow, other.shadow),
    );
  }
}

extension PaletteContext on BuildContext {
  Palette get palette => Theme.of(this).extension<Palette>()!;
}

ThemeData buildTheme(Brightness brightness) {
  final p = brightness == Brightness.dark ? Palette.dark : Palette.light;
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: brightness,
      primary: p.primary,
      surface: p.surface,
    ),
    scaffoldBackgroundColor: p.background,
  );
  final text = base.textTheme.apply(
    fontFamily: GoogleFonts.poppins().fontFamily,
    bodyColor: p.body,
    displayColor: p.ink,
  );
  return base.copyWith(
    textTheme: text,
    extensions: [p],
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: p.primary.withValues(alpha: 0.28),
      cursorColor: p.primary,
    ),
    focusColor: p.primary.withValues(alpha: 0.18),
    hoverColor: p.primary.withValues(alpha: 0.06),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: p.ink,
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: TextStyle(color: p.background, fontSize: 13),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(p.primary.withValues(alpha: 0.45)),
      radius: const Radius.circular(8),
      thickness: const WidgetStatePropertyAll(6),
    ),
  );
}

/// The viewer's light/dark choice. Starts from the device setting and,
/// once the viewer toggles, remembers their choice on this browser.
final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

const _themeKey = 'theme_mode';

Future<void> loadThemeMode() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    themeMode.value = switch (prefs.getString(_themeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  } catch (_) {
    // Storage blocked (private mode, etc.): keep following the device.
  }
}

/// Switches to the opposite of what is currently on screen.
Future<void> toggleThemeMode(BuildContext context) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final next = isDark ? ThemeMode.light : ThemeMode.dark;
  themeMode.value = next;
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, next.name);
  } catch (_) {}
}
