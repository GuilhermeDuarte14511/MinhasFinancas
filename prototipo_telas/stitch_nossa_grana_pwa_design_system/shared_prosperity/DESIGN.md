---
name: Shared Prosperity
colors:
  surface: '#fcf8ff'
  surface-dim: '#dcd8e5'
  surface-bright: '#fcf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f2ff'
  surface-container: '#f0ecf9'
  surface-container-high: '#eae6f4'
  surface-container-highest: '#e4e1ee'
  on-surface: '#1b1b24'
  on-surface-variant: '#464555'
  inverse-surface: '#302f39'
  inverse-on-surface: '#f3effc'
  outline: '#777587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4d44e3'
  primary: '#3525cd'
  on-primary: '#ffffff'
  primary-container: '#4f46e5'
  on-primary-container: '#dad7ff'
  inverse-primary: '#c3c0ff'
  secondary: '#006a63'
  on-secondary: '#ffffff'
  secondary-container: '#99efe5'
  on-secondary-container: '#006f67'
  tertiary: '#3d37a9'
  on-tertiary: '#ffffff'
  tertiary-container: '#5551c2'
  on-tertiary-container: '#dbd7ff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c3c0ff'
  on-primary-fixed: '#0f0069'
  on-primary-fixed-variant: '#3323cc'
  secondary-fixed: '#9cf2e8'
  secondary-fixed-dim: '#80d5cb'
  on-secondary-fixed: '#00201d'
  on-secondary-fixed-variant: '#00504a'
  tertiary-fixed: '#e2dfff'
  tertiary-fixed-dim: '#c3c0ff'
  on-tertiary-fixed: '#0f0069'
  on-tertiary-fixed-variant: '#3b35a7'
  background: '#fcf8ff'
  on-background: '#1b1b24'
  surface-variant: '#e4e1ee'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-lg:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  2xl: 48px
  3xl: 64px
  container-margin-mobile: 16px
  container-margin-desktop: 40px
  gutter: 16px
---

## Brand & Style
The design system is centered on the concept of "Financial Harmony." It targets modern couples who seek a collaborative, transparent, and stress-free way to manage their shared lives. The visual language balances the seriousness of financial management with a human-centric, welcoming warmth.

The style is **Corporate Modern** with a soft, humanistic touch. It leverages heavy whitespace and a refined color palette to reduce cognitive load—essential for complex financial data. The interface feels sophisticated and premium, utilizing subtle depth and rhythmic spacing to create a sense of reliability and calm. It avoids the coldness of traditional banking in favor of a supportive, joint-journey atmosphere.

## Colors
This design system utilizes a sophisticated Indigo and Teal palette to establish trust and professional clarity. 

- **Primary Indigo** serves as the main brand driver, used for key actions and brand presence.
- **Secondary Teal** is used for growth indicators, savings goals, and complementary data visualizations, providing a refreshing contrast to the indigo.
- **Background and Surface** logic follows a clean, layered approach: `#F8FAFC` for the canvas and `#FFFFFF` for the primary content containers to maximize legibility.
- **Semantic Colors** (Success, Warning, Error) are highly legible and saturated, ensuring financial status is communicated clearly without causing alarm.

## Typography
Inter is used across all levels to ensure maximum legibility and a systematic, clean aesthetic. 

- **Display and Headlines** use tighter letter-spacing and heavier weights to create a strong visual hierarchy.
- **Numerical Data** should ideally use tabular figures if available in the Inter font set to ensure columns of currency align perfectly.
- **Body Text** maintains a comfortable 1.5x line height to allow for effortless reading of transaction lists and financial reports.
- **Mobile adjustments** focus on reducing the scale of the largest headlines to prevent awkward text wrapping on smaller devices.

## Layout & Spacing
The design system follows a strict 8pt grid system to ensure mathematical harmony across all components and screen sizes.

- **Grid:** A 12-column fluid grid is used for desktop (breakpoint: 1024px+), transitioning to a 4-column grid for mobile devices.
- **Whitespace:** Emphasize the use of `3xl` (64px) spacing between major sections on desktop to maintain the "Sophisticated" brand pillar.
- **PWA Considerations:** Vertical margins are generous to prevent elements from feeling cramped against mobile system bars or notch areas. Use `lg` (24px) for safe-area padding.

## Elevation & Depth
This design system uses a combination of **Tonal Layers** and **Ambient Shadows** to create a structured, tactile experience that feels like a physical wallet or organizer.

- **Level 0 (Background):** `#F8FAFC` - The base layer.
- **Level 1 (Cards/Surfaces):** `#FFFFFF` with a 1px border of `#E2E8F0`. This is the standard state for most content.
- **Elevation - Soft:** Used for cards and primary containers. A subtle shadow: `0px 4px 6px -1px rgba(15, 23, 42, 0.05), 0px 2px 4px -2px rgba(15, 23, 42, 0.05)`.
- **Elevation - Floating:** Used for Modals and Navigation Bars. A more pronounced, diffused shadow: `0px 20px 25px -5px rgba(15, 23, 42, 0.1), 0px 8px 10px -6px rgba(15, 23, 42, 0.1)`.
- **Depth Logic:** Avoid heavy dark shadows; use low-opacity Indigo-tinted grays to maintain the "Human" and "Welcoming" feel.

## Shapes
Shapes are intentionally soft and approachable, moving away from the rigid corners of traditional finance.

- **Standard Elements:** Buttons and small components use `0.5rem` (8px) for a balanced look.
- **Content Containers:** Cards use a more pronounced radius of `1rem` to `1.25rem` (16px - 20px) to evoke a friendly, modern app feel.
- **Inputs:** Form fields use a `0.75rem` (12px) radius, providing a distinct, "squishy" yet professional appearance.

## Components
Consistent implementation of these components ensures the PWA feels native and reliable.

- **Primary Buttons:** Height: 52px. Background: `#4F46E5`. Text: Bold White. Padding: 0 24px. Subtle shadow on hover.
- **Input Fields:** Height: 56px. Border: 1px solid `#E2E8F0`. Background: White. Label: Floating or Small Label above using `label-md`. Focus state: 2px border of `#4F46E5` with a soft glow.
- **Cards:** White background, 16px - 20px radius, 1px soft border. Internal padding: 24px (`lg`).
- **Chips/Badges:** Used for transaction categories (e.g., "Groceries"). 32px height, 100px radius. Use `accent_light` (`#EEF2FF`) with `primary_color_hex` text.
- **Lists:** Transaction items should have a 72px minimum touch target height. Use a subtle 1px bottom border (`#E2E8F0`).
- **Shared Progress Bar:** For couple's goals. Uses a 12px height, `accent_light` background, and `secondary_color_hex` (Teal) fill to represent growth and collaborative success.