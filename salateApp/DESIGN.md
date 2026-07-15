---
name: Serene Devotion
colors:
  surface: '#fff8f5'
  surface-dim: '#e0d8d5'
  surface-bright: '#fff8f5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#faf2ee'
  surface-container: '#f4ece8'
  surface-container-high: '#eee7e3'
  surface-container-highest: '#e9e1dd'
  on-surface: '#1e1b19'
  on-surface-variant: '#404944'
  inverse-surface: '#33302d'
  inverse-on-surface: '#f7efeb'
  outline: '#707974'
  outline-variant: '#bfc9c3'
  surface-tint: '#2b6954'
  primary: '#003527'
  on-primary: '#ffffff'
  primary-container: '#064e3b'
  on-primary-container: '#80bea6'
  inverse-primary: '#95d3ba'
  secondary: '#9b4500'
  on-secondary: '#ffffff'
  secondary-container: '#fd8a42'
  on-secondary-container: '#682c00'
  tertiary: '#2d2f2e'
  on-tertiary: '#ffffff'
  tertiary-container: '#434545'
  on-tertiary-container: '#b1b2b1'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#b0f0d6'
  primary-fixed-dim: '#95d3ba'
  on-primary-fixed: '#002117'
  on-primary-fixed-variant: '#0b513d'
  secondary-fixed: '#ffdbca'
  secondary-fixed-dim: '#ffb68e'
  on-secondary-fixed: '#331200'
  on-secondary-fixed-variant: '#763300'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c7c6'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#fff8f5'
  on-background: '#1e1b19'
  surface-variant: '#e9e1dd'
typography:
  display-lg:
    fontFamily: Source Serif 4
    fontSize: 48px
    fontWeight: '600'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Source Serif 4
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Source Serif 4
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-md:
    fontFamily: Source Serif 4
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 32px
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Manrope
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
  sm: 12px
  md: 24px
  lg: 40px
  xl: 64px
  container-max: 1200px
  gutter: 20px
---

## Brand & Style

The design system is centered on tranquility, mindfulness, and spiritual focus. It targets a modern audience seeking a respectful and clutter-free environment for their daily religious obligations.

The aesthetic is **Contemporary Minimalism with Tonal Layering**. It avoids excessive ornamentation in favor of balanced whitespace, high-quality typography, and subtle atmospheric depth. The emotional goal is to lower the user's heart rate and provide a "digital sanctuary" that feels both ancient in its wisdom and modern in its utility.

## Colors

The palette is inspired by sacred architecture and natural elements.
- **Primary (Emerald):** A deep, rich emerald green (#064E3B) used for core brand moments, active states, and primary actions. It represents life and growth.
- **Secondary (Gold):** A soft, burnished gold (#B45309) used sparingly for accents, highlights, and secondary indicators like "current prayer time" markers.
- **Surface (Off-White):** A warm, stone-like off-white (#F5F5F4) serves as the primary background color to reduce eye strain and provide a soft, paper-like feel.
- **Neutral (Stone):** A near-black stone grey (#1C1917) for high-contrast text and structural borders.

## Typography

This design system utilizes a sophisticated pairing of a serif for editorial storytelling and a sans-serif for functional clarity.
- **Headings:** Source Serif 4 provides a scholarly, authoritative, and elegant feel. It is used for prayer names, titles, and welcome messages.
- **UI & Body:** Manrope is chosen for its modern, balanced, and highly legible proportions. It handles data-heavy sections like time lists and settings with professional ease.
- **Styling:** Labels should use uppercase with slight letter spacing to create a sense of hierarchy and distinction from body text.

## Layout & Spacing

The layout philosophy follows a **Fixed-Width Centered Grid** for desktop and a **Fluid Single Column** for mobile.
- **Rhythm:** A strict 8px baseline grid ensures vertical harmony.
- **Negative Space:** Generous margins (40px+) are used around key prayer time cards to foster a sense of "calm."
- **Breakpoints:**
  - Mobile (< 600px): 16px side margins, single column cards.
  - Tablet (600px - 1024px): 32px side margins, 2-column card layouts for grid-based views.
  - Desktop (> 1024px): 1200px max-width container, 12-column grid.

## Elevation & Depth

To maintain a serene atmosphere, this design system avoids heavy shadows in favor of **Tonal Layering and Soft Ambient Glows**.
- **Surface Levels:** The base background is the Off-White. Cards and containers use a pure white (#FFFFFF) with a very thin (1px) border in a light grey-gold tint to define edges.
- **Shadows:** When necessary (e.g., for active modals or city selection dropdowns), use a "Sunken Shadow" — a very wide, low-opacity (5%) shadow with a slight vertical offset (Y: 10px, Blur: 20px) to simulate a physical card floating just above the surface.
- **Glassmorphism:** Use a subtle backdrop blur (12px) for sticky navigation bars or overlays to maintain a sense of context and spatial awareness.

## Shapes

The shape language is organic and soft, avoiding sharp corners that feel aggressive or clinical.
- **Base Corner Radius:** 0.5rem (8px) for buttons and inputs.
- **Large Corner Radius:** 1.5rem (24px) for prayer time cards and container sections to create a friendly, approachable container.
- **Iconography:** Use line icons with rounded terminals (ends) to match the soft typography and corner radii.

## Components

### Prayer Time Cards
Cards should be the focal point. The "Current Prayer" card uses a deep emerald background with gold typography. Inactive prayer cards use a white background with thin borders. Times are displayed in `headline-lg`, while prayer names use `headline-md`.

### City Selection
A clean, full-width input field with a leading "location" icon. Results should appear in a list using `body-md` with generous vertical padding (16px) between items. Use a soft-gold highlight for the "Current Location" button.

### Buttons
- **Primary:** Solid Emerald (#064E3B) with white text. High-contrast and clear.
- **Secondary:** Transparent with an Emerald border and text.
- **Tertiary/Ghost:** Text only in Emerald or Gold, used for low-priority actions like "Change Method."

### Input Fields
Inputs use a minimal bottom-border style or a very light-filled background. Labels are positioned above the field in `label-sm` (uppercase). Focus states are indicated by the border color transitioning to Emerald.

### Progress Indicators
A thin, circular stroke around the current prayer time or a horizontal bar at the top of the screen to show time remaining until the next prayer, using a soft Gold tint.

### Login Flow
Minimalist forms centered on the screen. Use high-quality photography of nature or subtle Islamic patterns (low opacity) as a background element to maintain the spiritual theme during the authentication process.
