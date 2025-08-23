# Contributing to Bloodline SG

Thank you for your interest in contributing to Bloodline SG! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- Flutter 3.5+ and Dart 3.9+
- Git
- Android Studio / Xcode (for mobile development)
- Firebase project access (contact maintainers)

### Setup
1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/bloodline_sg.git`
3. Add upstream: `git remote add upstream https://github.com/ORIGINAL_REPO/bloodline_sg.git`
4. Install dependencies: `flutter pub get`
5. Follow the setup instructions in `SETUP.md`

## 🔧 Development Workflow

### Branch Naming
- `feature/feature-name` - New features
- `bugfix/bug-description` - Bug fixes
- `hotfix/urgent-fix` - Critical fixes
- `docs/documentation-update` - Documentation changes

### Commit Messages
Use conventional commit format:
```
type(scope): description

feat(auth): add biometric authentication
fix(booking): resolve date picker crash
docs(readme): update setup instructions
style(ui): improve button styling
refactor(core): extract common utilities
test(auth): add unit tests for auth service
```

### Pull Request Process
1. Create a feature branch from `develop`
2. Make your changes
3. Run tests: `flutter test`
4. Check code quality: `flutter analyze`
5. Format code: `dart format .`
6. Create a pull request with clear description
7. Wait for review and address feedback

## 📱 Code Standards

### Flutter/Dart
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` before committing
- Prefer const constructors where possible
- Use meaningful variable and function names
- Add documentation for public APIs

### Architecture
- Follow feature-first folder structure
- Use Riverpod for state management
- Implement proper error handling
- Write unit tests for business logic
- Use freezed for data models

### UI/UX
- Follow Material Design principles
- Use Dexter design system tokens
- Ensure accessibility compliance
- Test on multiple screen sizes
- Maintain consistent spacing and typography

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Golden Tests
```bash
flutter test --update-goldens
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🔐 Security

### Never Commit
- API keys
- Firebase configuration files
- Environment variables
- Private keys
- User data

### Security Checklist
- [ ] No hardcoded secrets
- [ ] Input validation implemented
- [ ] Error messages don't leak information
- [ ] Authentication properly implemented
- [ ] Data access properly restricted

## 📚 Documentation

### Code Documentation
- Document all public APIs
- Use clear, concise comments
- Include examples for complex functions
- Update README.md for new features

### API Documentation
- Document Firebase collections
- Explain data models
- Provide usage examples
- Keep security rules updated

## 🚨 Reporting Issues

### Bug Reports
- Use the bug report template
- Provide detailed reproduction steps
- Include device information
- Attach screenshots if applicable

### Feature Requests
- Use the feature request template
- Explain the problem being solved
- Provide use case examples
- Consider implementation complexity

## 🤝 Community Guidelines

### Be Respectful
- Treat all contributors with respect
- Provide constructive feedback
- Be patient with newcomers
- Celebrate contributions

### Communication
- Use clear, professional language
- Ask questions when unsure
- Share knowledge and help others
- Participate in discussions

## 📋 Review Process

### Code Review Checklist
- [ ] Code follows style guidelines
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No security vulnerabilities
- [ ] Performance considerations addressed
- [ ] Accessibility requirements met

### Review Guidelines
- Be constructive and specific
- Focus on code quality and functionality
- Suggest improvements when possible
- Approve when requirements are met

## 🎯 Project Goals

### Mission
Build a peer-led blood donation app that encourages Singapore youths to donate blood and save lives together.

### Values
- **Safety First**: Prioritize donor safety and HSA guidelines
- **Community**: Foster peer support and motivation
- **Innovation**: Use technology to improve donation experience
- **Accessibility**: Ensure app is usable by all target users

## 📞 Getting Help

- Create an issue for questions
- Join our Discord community
- Contact maintainers directly
- Check existing documentation

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to Bloodline SG! Together we can save more lives.** 🩸❤️
