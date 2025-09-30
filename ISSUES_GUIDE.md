# Intentional Issues Guide

This Flutter Task Manager app contains **intentional issues** across multiple categories to test AI code review tools. This guide catalogs all the issues by category and file location.

## 🔒 Security Vulnerabilities

### Authentication Service (`lib/features/authentication/auth_service.dart`)

- **Hardcoded API keys and secrets** (lines 12-16)
- **Hardcoded default credentials** (lines 19-20)
- **Plain text password storage** in SharedPreferences (line 97)
- **No input sanitization** for user credentials (line 34)
- **Insecure HTTP endpoints** instead of HTTPS (line 53)
- **SQL injection vulnerability** in getUserProfile method (line 168)
- **Weak token generation** using predictable timestamps (line 156)
- **No SSL pinning** in network requests
- **Debug authentication bypass** in production (line 43)
- **Exposed sensitive data in logs** (line 33)

### Configuration (`pubspec.yaml`)

- **Outdated packages** with known vulnerabilities
- **Overly broad version ranges** causing security issues

## ⚠️ Functional Issues

### Task Management (`lib/features/task_management/task_manager.dart`)

- **Overdue task completion bug** - allows completing overdue tasks (line 75)
- **Case-sensitive search** when should be case-insensitive (line 96)
- **Date picker allows past dates** for future deadlines (line 106)
- **Silent data persistence failures** when storage is full (line 55)
- **Runtime errors** from missing bounds checking (line 89)
- **Poor error recovery** for malformed API responses (line 152)

### Authentication Flow (`lib/features/authentication/login_screen.dart`)

- **Biometric authentication breaks** when user cancels (line 143)
- **Poor error handling** for authentication failures
- **Memory leaks** from undisposed controllers (line 189)

## 🚀 Performance Issues

### Memory Leaks (`lib/src/bad_code_examples/memory_leak_example.dart`)

- **Controllers not disposed** in widget lifecycle
- **Stream subscriptions** never cancelled
- **Timers** never cancelled
- **Large data structures** kept in memory indefinitely
- **Static cache** that grows without bounds

### Performance Problems (`lib/src/bad_code_examples/performance_issues.dart`)

- **Blocking main thread** with synchronous operations
- **Inefficient list rendering** without virtualization
- **O(n²) sorting algorithms** instead of efficient built-ins
- **Memory-inefficient** data processing
- **Poor caching strategies**

### UI Performance (`lib/features/task_management/task_list_screen.dart`)

- **No virtualization** for large lists
- **Expensive widget building** in ListView items
- **Memory leaks** in image loading components
- **Blocking operations** on main thread

## 🏗️ Code Structure & Architecture

### God Classes

- **UserProfileManager** (`lib/features/user_profile/user_profile_manager.dart`) - 500+ lines, multiple responsibilities
- **TaskManagerHomePage** (`lib/main.dart`) - mixed UI, business logic, and data access

### Circular Dependencies

- **UserProfileManager** ↔ **UserProfileWidget** circular import

### Poor Separation of Concerns

- **UI widgets** handling business logic directly
- **Database access** in presentation layer
- **Network operations** mixed with UI state management

### Mixed Concerns Examples

- **TaskListScreen** handles UI, data fetching, and business logic
- **LoginScreen** contains authentication logic instead of delegating

## 📝 Naming Convention Violations

### Inconsistent Naming (`lib/shared/poorly_named_files.dart`)

- **Mixed case conventions**: `fetchData()` vs `get_user_info()` vs `ProcessConfiguration()`
- **Non-descriptive names**: `var a`, `func1()`, `doStuff()`
- **Hungarian notation**: `strUserName`, `iCount`, `bIsLoading`
- **Wrong prefixes**: public variables with `_` prefix
- **Excessive abbreviations**: `usrPref`, `calcUsrAge`, `getFmtdDate`

### Poor Variable Names

- Single letter variables: `a`, `b`, `c`, `x`, `y`, `z`
- Meaningless names: `flag`, `check`, `status`, `thing`, `stuff`
- Inconsistent abbreviations: `userName` vs `usrEmail` vs `u_phone`

## 🎯 Code Quality Issues

### Deep Nesting (`lib/shared/utility_with_issues.dart`)

- **5+ levels of nested conditionals** (line 25)
- **Complex nested validation logic**

### Long Methods

- **processUserData** method 50+ lines with multiple responsibilities
- **\_initializeServices** method with excessive complexity

### Magic Numbers

- Hardcoded timeouts, buffer sizes, and thresholds throughout codebase
- **No named constants** for important values

### Duplicate Code

- **formatDate1**, **formatDate2**, **formatDate3** - identical implementations
- **saveUserProfile**, **cacheUserProfile**, **backupUserProfile** - nearly identical

## ♿ Accessibility Issues

### Missing Semantic Labels (`lib/src/bad_code_examples/accessibility_issues.dart`)

- **IconButtons** without semantic labels
- **Images** without alt text
- **Loading indicators** without descriptions
- **Form fields** without proper labels

### Poor Color Contrast

- **Light gray text on light gray background**
- **Yellow text on yellow background**
- **Insufficient contrast ratios**

### Touch Target Issues

- **Buttons smaller than 48x48 dp**
- **Interactive elements too close together**
- **No focus handling** for keyboard navigation

### Missing ARIA Equivalents

- **Custom widgets** without Semantics wrappers
- **Data tables** without proper structure
- **Modal dialogs** without proper roles

## 📱 Responsive Design Issues

### Non-Responsive Layouts (`lib/src/bad_code_examples/responsive_layout_issues.dart`)

- **Fixed width containers** that don't scale
- **Hardcoded dimensions** for all screen sizes
- **No breakpoint handling** for tablets
- **Single-column layouts** that waste tablet space

### Platform Issues

- **iOS-specific UI** on all platforms
- **Platform checks** that crash on web
- **Hardcoded status bar heights**

## 🧪 Testing Issues

### Unit Tests (`test/unit/auth_service_test.dart`)

- **Missing unit tests** for critical business logic
- **Poor test naming** - `test1`, `test2`, `test3`
- **Hardcoded waits** instead of proper mocking
- **No test cleanup** - state persists between tests
- **Flaky tests** dependent on timing
- **Tests without assertions**

### Widget Tests (`test/widget/task_list_widget_test.dart`)

- **Fragile UI tests** with hardcoded waits
- **Testing implementation details** instead of behavior
- **No mocking** of dependencies
- **Memory leaks** from undisposed test resources

### Integration Tests (`test/integration/app_integration_test.dart`)

- **Missing integration tests** for main user flows
- **Tests dependent on external services**
- **No proper test data setup/cleanup**
- **Environment-dependent tests**

## 📦 Dependency Management

### Package Issues (`pubspec.yaml`)

- **Outdated packages** with known vulnerabilities
- **Unused dependencies** (url_launcher)
- **Missing dependencies** (crypto used but not declared)
- **Overly broad version ranges**

## 📖 Documentation Issues

### Poor Documentation

- **README.md** - vague descriptions, incomplete instructions
- **API.md** - missing error codes, no examples
- **CHANGELOG.md** - vague entries, no dates
- **Missing docstrings** for public APIs
- **Outdated comments** describing removed functionality

### Code Comments

- **Commented-out code blocks** that should be removed
- **TODO comments** for security issues left in production
- **Non-English comments** in some sections
- **Overly verbose obvious comments**

## 🌐 Internationalization Issues

### Hardcoded Strings

- **UI text** not using localization keys
- **Error messages** hardcoded in English
- **Date/number formatting** not culturally adapted

## 🔧 Configuration Issues

### Analysis Options (`analysis_options.yaml`)

- **Important lints disabled** that should be enabled
- **Security lints** treated as warnings instead of errors
- **Strict type checking** disabled

## 📊 Quality Distribution

As requested, the codebase follows this quality distribution:

- **40% Severely problematic code** - Security vulnerabilities, functional bugs, major architectural issues
- **30% Moderately problematic code** - Performance issues, poor practices, maintainability problems
- **20% Minor issues** - Naming conventions, code style, minor improvements needed
- **10% Well-written code** - Examples of good practices for comparison

## 🎯 Testing AI Code Review Tools

This codebase is designed to test AI code review tools across multiple dimensions:

### Detection Capabilities

- Can the tool identify security vulnerabilities?
- Does it catch functional bugs?
- Can it spot performance issues?
- Does it recognize architectural problems?

### Prioritization

- Does the tool correctly prioritize critical security issues?
- Can it distinguish between minor style issues and major bugs?
- Does it provide appropriate severity levels?

### Code Understanding

- Can it understand the context of issues?
- Does it provide meaningful explanations?
- Can it suggest appropriate fixes?

### Coverage

- Does it find issues across all categories?
- Are there blind spots in certain types of problems?
- How comprehensive is the analysis?

## 🚀 Usage Instructions

1. **Clone the repository**
2. **Run your AI code review tool** on the codebase
3. **Compare results** against this guide
4. **Evaluate** the tool's effectiveness across different issue categories
5. **Test** the tool's ability to prioritize and explain issues

This comprehensive testbed should provide excellent coverage for evaluating AI code review tools across all major dimensions of code quality assessment.
