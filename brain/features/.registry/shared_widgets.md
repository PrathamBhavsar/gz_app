# Registry: Shared Widgets — em_ Design System
> Phase 1 complete. `gz_` prefix is retired; all canonical widgets use `em_` prefix.
> Old `gz_*.dart` files are backward-compat shims (import + typedef only).

---

## Renamed from gz_ → em_

| Old file | New file | Classes |
|----------|----------|---------|
| `gz_button.dart` | `em_button.dart` | `EmButton`, `EmButtonFull`, `EmButtonVariant` |
| `gz_tag.dart` | `em_tag.dart` | `EmTag`, `EmTagKind` |
| `gz_chip.dart` | `em_chip.dart` | `EmChip` |
| `gz_top_bar.dart` | `em_top_bar.dart` | `EmTopBar` |
| `gz_meta_row.dart` | `em_meta_row.dart` | `EmMetaRow` |
| `gz_live_dot.dart` | `em_live_dot.dart` | `EmLiveDot` |
| `gz_progress_bar.dart` | `em_progress_bar.dart` | `EmProgressBar` |

---

## New Widgets (Phase 1c)

### `em_avatar.dart` — `EmAvatar`
- Path: `lib/shared/widgets/em_avatar.dart`
- Props: `icon: Widget?`, `children: String?`, `size: AvatarSize`, `index: int?`
- Sizes: `sm`=32, `md`=34 (default), `lg`=40, `xl`=56
- Color: Walle palette (7 muted tones) — indexed by `index` or first char of `children`

### `em_card.dart` — `EmCard` + `CardVariant`
- Path: `lib/shared/widgets/em_card.dart`
- Props: `child: Widget`, `variant: CardVariant`, `padding: double?`
- Variants:
  - `base`: `AppColors.surface`, `borderRadiusCard` (26)
  - `tint`: `AppColors.surfaceTint`, `borderRadiusCard` (26)
  - `inset`: `AppColors.pillBg`, `borderRadiusLg` (16)
- Default padding: `AppSpacing.md` (16)

### `em_icon_btn.dart` — `EmIconBtn`
- Path: `lib/shared/widgets/em_icon_btn.dart`
- Props: `child: Widget`, `onTap: VoidCallback?`, `tooltip: String?`
- 38×38 transparent tap target

### `em_collapse.dart` — `EmCollapse`
- Path: `lib/shared/widgets/em_collapse.dart`
- Props: `title: String`, `child: Widget`, `isOpen: bool`, `onToggle: VoidCallback`, `right: Widget?`
- State managed by caller; uses flutter_animate for chevron rotation

### `em_section_head.dart` — `EmSectionHead`
- Path: `lib/shared/widgets/em_section_head.dart`
- Props: `title: String` (positional), `subtitle: String?`, `trailing: Widget?`
- Padding: 4px top, 12px bottom

### `em_scroll_content.dart` — `EmScrollContent`
- Path: `lib/shared/widgets/em_scroll_content.dart`
- Props: `child: Widget`, `padded: bool` (default false)
- Wraps child in `Expanded` + `SingleChildScrollView` (scrollbar hidden)
- `padded: true` → `EdgeInsets.fromLTRB(16, 4, 16, 24)`

### `em_bottom_nav.dart` — `EmBottomNav`
- Path: `lib/shared/widgets/em_bottom_nav.dart`
- Props: `active: int`, `onTap: void Function(int)`
- Extracted from `main_mobile_layout.dart`; `MainMobileLayout` now references it
- 5-tab custom painted nav: home / book / games / wallet / user

### `em_store_selector_pill.dart` — `EmStoreSelectorPill`
- Path: `lib/shared/widgets/em_store_selector_pill.dart`
- Props: `storeName: String`, `onTap: VoidCallback?`
- Pill shape, `AppColors.pillBg`, `borderRadiusPill`
- `onTap` → will open `StoreSelectorSheet` (Phase 8)

### `em_gz_logo.dart` — `EmGzLogo`
- Path: `lib/shared/widgets/em_gz_logo.dart`
- No props
- 32×32 dark square (radius 8), "GZ" in GeistMono w700, `surfaceTintStrong` color

---

## AppTheme

- Path: `lib/core/theme/app_theme.dart`
- `AppTheme.light` — full `ThemeData` for Material 3
- Wired in `main.dart`: `theme: AppTheme.light`

---

## Keep as-is (not design-system atoms)
- `page_error_display.dart` — architectural error widget
- `huge_icon_widget.dart` — third-party wrapper
