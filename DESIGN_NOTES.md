# 🦕 Dexter Design System - Bloodline SG

## Overview
The Dexter Design System transforms Bloodline SG into a playful, modern interface inspired by our cute green dino mascot donating blood. This creates a cohesive, youth-friendly experience that makes blood donation feel approachable and engaging.

## 🎨 Design Tokens

### Color Palette
```dart
// Primary Colors (from mascot)
dexGreen = #7EDC86    // Mascot body - primary actions
dexLeaf = #51B969     // Outline mid - secondary elements  
dexForest = #2E7B52   // Dark outline - text & borders
dexBlush = #FF9AA8    // Mascot cheeks - accent details
dexBlood = #F04A3E    // Blood drop - error & blood elements
dexGold = #8C7A35     // Warm accent - warnings
dexIvory = #FFFDF7    // Base surface - backgrounds
dexInk = #1C1C1C      // Primary text
```

### Typography
- **Headlines**: Nunito (rounded, friendly)
- **Body Text**: Inter (clean, readable)  
- **Sizes**: 12/14/16/20/28px with 1.25-1.35 line-height

### Shape Language
- **Border Radius**: 12px (small), 20px (medium), 28px (large), 32px (extra-large)
- **Borders**: Subtle 1px dexLeaf on cards/components
- **Elevation**: Soft shadows with low blur, medium spread (1-6px)

### Motion
- **Duration**: 120-250ms for micro-interactions
- **Easing**: Elastic out for playful, ease out for smooth
- **Haptics**: Light impact on key actions

## 🧩 Core Components

### Buttons
- **DexPrimaryButton**: Filled dexGreen with white text
- **DexSecondaryButton**: Outlined dexGreen with colored text  
- **DexTonalButton**: Soft background with tinted color

### Cards & Data
- **DexCard**: Rounded container with optional header and soft shadow
- **DexStatPill**: Circular stat display for streaks/lives saved
- **DexBadge**: Small rounded badge for notifications/levels

### States & Feedback
- **DexEmptyState**: Illustration + title + message + CTA
- **DexLoader**: Rotating blood drop with optional message
- **DexSuccessAnimation**: Confetti celebration with haptics
- **DexSectionHeader**: Title with optional subtitle and action

## 🏗️ Implementation Architecture

### Theme Structure
```
lib/core/theme/
├── dexter_theme.dart       # Main theme factory
└── DexterTokens           # Theme extension with palette
```

### Component Library
```
lib/core/widgets/
├── dex_buttons.dart       # Primary, secondary, tonal buttons
├── dex_cards.dart         # Cards, stat pills, badges  
└── dex_states.dart        # Empty states, loaders, animations
```

### Usage Pattern
```dart
// Access tokens anywhere
final tokens = context.dexter;
Container(color: tokens.primaryColor)

// Use semantic colors
backgroundColor: DexterTokens.success
```

## 🎯 Key Features

### Micro-Interactions
- Scale animations on button taps (120ms)
- Shimmer effects on hero elements
- Pulse animations for urgent badges
- Shake animations for warnings
- Haptic feedback on important actions

### Accessibility
- AA contrast ratios maintained
- 48px minimum touch targets
- Screen reader friendly labels
- Reduced motion respect
- Dynamic Type support

### Youth-Friendly Elements
- Playful gradients and shadows
- Rounded corners throughout
- Emoji integration (🩸💚🔥)
- Confetti success celebrations
- Gentle animations and transitions

## 🚀 Usage Guidelines

### Do's
✅ Use DexterTokens for all colors  
✅ Apply consistent border radius (20-28px)  
✅ Add micro-animations to key interactions  
✅ Include haptic feedback on important actions  
✅ Use Dexter components over custom widgets  

### Don'ts
❌ Hard-code colors or sizes  
❌ Create sharp corners  
❌ Skip loading/empty states  
❌ Ignore accessibility guidelines  
❌ Overuse animations (keep under 250ms)  

## 🎨 Extending the System

### Adding New Colors
```dart
// Add to DexterTokens class
static const Color newColor = Color(0xFFHEXCODE);

// Use semantic naming
static const Color newSemantic = newColor;
```

### Creating New Components
```dart
// Follow naming convention: Dex + ComponentName
class DexNewComponent extends StatelessWidget {
  // Use theme tokens
  final tokens = context.dexter;
  
  // Apply consistent styling
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
    color: tokens.surfaceColor,
  )
}
```

### Animation Patterns
```dart
// Standard entrance
widget.animate().fadeIn(duration: 200.ms).slideY(begin: 0.3)

// Success celebration  
widget.animate().scale(curve: Curves.elasticOut)

// Warning attention
widget.animate().shake(hz: 2).then().scale()
```

## 📱 Screen-Specific Applications

### Bloodline Home
- Hero streak counter with fire icon
- Gradient mascot placeholder
- Pulse animations on CTAs
- Lives saved celebration

### Sign-in Page  
- Gradient logo with shimmer effect
- Staggered text animations
- Rounded input fields
- Primary/secondary button pairing

### Centres List
- Open/closed status chips
- Distance pills for nearby centres
- Booking CTAs with icons
- Empty state for no results

### Challenge Detail
- VS badge between avatars
- Timeline with footprint separators  
- Expiry warning badges
- Share bottom sheet

## 🎉 Brand Moments

### Success States
- Confetti particle animations
- Haptic success feedback
- Share card generation
- Lives saved counter increment

### Onboarding Flow
- Dexter mascot introduction
- Progressive disclosure
- Gentle nudges vs pressure
- Achievement unlocks

### Social Features
- Friend invitation cards
- Streak sharing banners
- Leaderboard celebrations
- Nomination workflows

---

## 🦕 Dexter's Promise

*"Making blood donation feel as friendly as a green dino's hug"*

The Dexter Design System ensures every interaction feels approachable, celebrating the life-saving impact while maintaining the serious responsibility of healthcare. Through playful design, we encourage youth participation without trivializing the importance of blood donation.
