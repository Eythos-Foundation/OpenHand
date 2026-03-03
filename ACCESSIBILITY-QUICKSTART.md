# OpenHand Accessibility Quick Start Guide

**For people with disabilities using OpenHand**

This guide helps you set up OpenHand with accessibility features. Written in simple language.

---

## 🎤 Voice Control

### Turn on voice control:

1. Open your OpenHand settings
2. Find "Voice" settings
3. Turn on "Voice Input"
4. Choose your wake word (like "Hey OpenHand")

### Make voice easier to understand:

```yaml
# Add to your config file (~/.openhand/config.yml)
accessibility:
  voice:
    tts:
      enabled: true
      speed: 1.0          # Make slower: 0.5, Make faster: 2.0
      pitch: 1.0          # Make lower: 0.8, Make higher: 1.2
      fallbackToText: true # Show text if voice doesn't work
```

---

## 👁️ Screen Readers

### If you use NVDA, JAWS, or VoiceOver:

**For the web interface:**
- All buttons have labels
- You can use Tab key to move between controls
- Press Enter to activate buttons
- Press Escape to close dialogs

**For the command line:**
```bash
# Turn on screen reader mode
openhand --screen-reader

# Turn off colors (easier to hear)
openhand --no-color

# Get results as text (not fancy formatting)
openhand --output json
```

---

## 🎨 Visual Settings

### High Contrast Mode:

```yaml
# Add to config
accessibility:
  visual:
    highContrast: true
    colorScheme: dark    # or 'light' or 'auto'
```

### Make Text Bigger:

```yaml
accessibility:
  visual:
    fontSize: large      # Options: small, medium, large, xlarge
```

### Reduce Motion (if animations make you dizzy):

```yaml
accessibility:
  visual:
    reduceMotion: true
```

---

## 🧠 Cognitive Accessibility

### Simple Language Mode:

```yaml
accessibility:
  cognitive:
    simplifiedLanguage: true  # Uses simpler words
    reducedClutter: true       # Hides extra information
    stepByStepMode: true       # One thing at a time
    confirmActions: true       # Asks before doing important things
```

---

## ⌨️ Keyboard Only (No Mouse)

### Important Keyboard Shortcuts:

- **Tab** - Move to next control
- **Shift + Tab** - Move to previous control
- **Enter** - Activate button
- **Escape** - Close dialog or cancel
- **Space** - Toggle checkbox
- **Arrow Keys** - Navigate lists

### Skip to Main Content:
When the page loads, press **Tab** once, then **Enter** to skip the menu.

---

## 🆘 If Something Doesn't Work

### Voice isn't working:
1. Check your microphone is connected
2. Give OpenHand microphone permission
3. Turn on fallback mode: `fallbackToText: true`

### Screen reader can't read something:
1. Try using keyboard shortcuts instead
2. Report the problem: email eythosfoundation@gmail.com
3. Include what screen reader you use

### Text is too small or too big:
1. Change `fontSize` setting
2. Use your browser's zoom (Ctrl + Plus or Ctrl + Minus)

---

## 💬 Get Help

**Email:** eythosfoundation@gmail.com  
**Discord:** https://discord.gg/clawd  
**Documentation:** https://docs.eythosfound.org

We want to help! Tell us what's not working for you.

---

## 🛠️ Full Config Example

Here's a complete accessibility config you can copy:

```yaml
# ~/.openhand/config.yml
accessibility:
  voice:
    tts:
      enabled: true
      speed: 1.0
      pitch: 1.0
      fallbackToText: true
    input:
      enabled: true
      wakeWord: "hey assistant"
      noiseReduction: true
      fallbackToText: true
  
  visual:
    highContrast: true
    fontSize: large
    reduceMotion: true
    colorScheme: dark
  
  cognitive:
    simplifiedLanguage: true
    reducedClutter: true
    stepByStepMode: true
    confirmActions: true
```

---

**Made by Eythos Foundation**  
Adaptive technology for everyone 💙
