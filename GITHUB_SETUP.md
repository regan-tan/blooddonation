# 🚀 GitHub Repository Setup Guide

This guide will help you set up your Bloodline SG project on GitHub safely and professionally.

## 📋 Pre-Setup Checklist

### ✅ Security Check
- [ ] `google-services.json` is in `.gitignore`
- [ ] `firebase_options.dart` is in `.gitignore`
- [ ] No API keys are hardcoded in source code
- [ ] `.env` files are in `.gitignore`
- [ ] Sensitive configuration files are excluded

### ✅ Code Quality Check
- [ ] Run `flutter analyze` - no errors
- [ ] Run `flutter test` - all tests pass
- [ ] Code is properly formatted with `dart format .`
- [ ] No TODO comments with sensitive information
- [ ] All imports are properly organized

## 🔐 GitHub Repository Creation

### 1. Create New Repository
1. Go to [GitHub.com](https://github.com)
2. Click "New repository"
3. Repository name: `bloodline_sg` or `bloodline-sg`
4. Description: "🩸 A peer-led blood donation app for Singapore youths"
5. **Make it PRIVATE** (recommended for projects with API keys)
6. Don't initialize with README (we already have one)
7. Click "Create repository"

### 2. Initialize Local Git Repository
```bash
# If you haven't initialized git yet
git init

# Add all files (excluding those in .gitignore)
git add .

# Make initial commit
git commit -m "Initial commit: Bloodline SG Flutter app

- Complete Flutter 3.x app with Firebase integration
- Blood donation centre locator with HSA data
- Group booking system with RSVP management
- Bloodline challenges and streak system
- Modern UI with Dexter design system
- Google Maps integration for centre locations
- Comprehensive testing and documentation"

# Add remote origin
git remote add origin https://github.com/YOUR_USERNAME/bloodline_sg.git

# Push to main branch
git branch -M main
git push -u origin main
```

## 🏷️ Repository Configuration

### 1. Repository Settings
- **General**: Enable issues, wiki, projects
- **Branches**: Set `main` as default branch
- **Collaborators**: Add team members if needed
- **Security**: Enable security features

### 2. Branch Protection Rules
1. Go to Settings > Branches
2. Add rule for `main` branch
3. Enable:
   - Require pull request reviews
   - Require status checks to pass
   - Require branches to be up to date
   - Include administrators

### 3. Repository Topics
Add these topics to your repository:
- `flutter`
- `dart`
- `firebase`
- `blood-donation`
- `singapore`
- `youth`
- `healthcare`
- `mobile-app`

## 📁 Repository Structure

Your repository should look like this:
```
bloodline_sg/
├── .github/                    # GitHub templates and workflows
│   ├── ISSUE_TEMPLATE/
│   └── workflows/
├── android/                    # Android platform code
├── ios/                       # iOS platform code
├── lib/                       # Flutter source code
├── assets/                    # Images and data
├── test/                      # Test files
├── .gitignore                 # Git ignore rules
├── README.md                  # Project documentation
├── SETUP.md                   # Setup instructions
├── CONTRIBUTING.md            # Contributing guidelines
├── LICENSE                    # MIT License
├── pubspec.yaml              # Flutter dependencies
└── DESIGN_NOTES.md           # Design system documentation
```

## 🚨 Security Reminders

### Never Commit These Files:
- ❌ `android/app/google-services.json`
- ❌ `ios/Runner/GoogleService-Info.plist`
- ❌ `lib/firebase_options.dart`
- ❌ `.env` files
- ❌ API keys or secrets
- ❌ Private certificates

### Safe to Commit:
- ✅ Source code
- ✅ Configuration templates
- ✅ Documentation
- ✅ Assets (images, fonts)
- ✅ Test files
- ✅ Build scripts

## 🔄 First Push Commands

```bash
# Check what will be committed
git status

# Add all files (respecting .gitignore)
git add .

# Check what's staged
git diff --cached

# Make initial commit
git commit -m "Initial commit: Bloodline SG Flutter app

Features:
- Blood donation centre locator
- Group booking system
- Bloodline challenges
- Modern UI with Dexter design
- Firebase integration
- Google Maps support
- Comprehensive testing"

# Push to GitHub
git push origin main
```

## 📱 Post-Setup Tasks

### 1. Verify Repository
- [ ] All files are uploaded correctly
- [ ] Sensitive files are NOT visible
- [ ] README.md displays properly
- [ ] .gitignore is working

### 2. Enable GitHub Features
- [ ] Issues are enabled
- [ ] Projects are enabled
- [ ] Wiki is enabled (optional)
- [ ] Discussions are enabled (optional)

### 3. Set Up CI/CD
- [ ] GitHub Actions workflow is in place
- [ ] Tests run automatically on push
- [ ] Build artifacts are generated

### 4. Team Setup
- [ ] Add collaborators if needed
- [ ] Set up branch protection
- [ ] Configure review requirements

## 🎯 Repository Goals

### Short Term
- [ ] Complete initial setup
- [ ] Verify all features work
- [ ] Set up CI/CD pipeline
- [ ] Add comprehensive documentation

### Long Term
- [ ] Build active community
- [ ] Regular releases and updates
- [ ] Feature requests and contributions
- [ ] Open source adoption

## 🆘 Troubleshooting

### Common Issues

**"API key exposed" warning**
- Check .gitignore includes sensitive files
- Remove file from git history if needed
- Rotate exposed API keys immediately

**Build failures in CI/CD**
- Check Flutter version compatibility
- Verify all dependencies are in pubspec.yaml
- Test locally before pushing

**Large file uploads**
- Use Git LFS for large assets
- Check .gitignore excludes build folders
- Consider asset optimization

## 📞 Support

If you encounter issues:
1. Check existing GitHub issues
2. Review the setup documentation
3. Contact the development team
4. Create a detailed issue report

---

**Your Bloodline SG repository is now ready for collaboration and contribution!** 🎉✨

Remember: Security first, then collaboration. Keep your API keys safe and your code open for the community to help improve.
