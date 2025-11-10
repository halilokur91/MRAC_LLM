# 🤝 Contributing to MRAC-LLM

Thank you for your interest in contributing to MRAC-LLM! This document provides guidelines and instructions for contributing.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)

---

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please be respectful and constructive.

### Expected Behavior

- ✅ Use welcoming and inclusive language
- ✅ Be respectful of differing viewpoints
- ✅ Accept constructive criticism gracefully
- ✅ Focus on what is best for the community
- ✅ Show empathy towards other community members

### Unacceptable Behavior

- ❌ Trolling, insulting/derogatory comments
- ❌ Public or private harassment
- ❌ Publishing others' private information
- ❌ Other conduct which could be considered inappropriate

---

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

- ✅ MATLAB R2019b or later
- ✅ Simulink
- ✅ Git installed
- ✅ GitHub account
- ✅ Basic understanding of MRAC theory (for algorithm contributions)

### Areas for Contribution

We welcome contributions in:

1. 🐛 **Bug Fixes**: Fix issues in existing code
2. ✨ **New Features**: Add new MRAC variants or functionality
3. 📚 **Documentation**: Improve docs, add examples
4. 🧪 **Testing**: Write tests, improve coverage
5. 🎨 **UI/UX**: Enhance GUI design
6. 🌐 **Localization**: Add language support
7. 📊 **Performance**: Optimize algorithms

---

## 💡 How to Contribute

### 1. Find or Create an Issue

**Before starting work:**

1. Check [existing issues](https://github.com/YOUR_USERNAME/MRAC_LLM/issues)
2. Search [closed issues](https://github.com/YOUR_USERNAME/MRAC_LLM/issues?q=is%3Aissue+is%3Aclosed)
3. If no issue exists, [create one](https://github.com/YOUR_USERNAME/MRAC_LLM/issues/new)

**Issue Labels:**
- `bug` - Something isn't working
- `enhancement` - New feature request
- `documentation` - Documentation improvements
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed

### 2. Fork the Repository

```bash
# Click "Fork" on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/MRAC_LLM.git
cd MRAC_LLM

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/MRAC_LLM.git
```

### 3. Create a Branch

```bash
# Create and switch to a new branch
git checkout -b feature/your-feature-name

# Branch naming conventions:
# - feature/description  (new features)
# - fix/description      (bug fixes)
# - docs/description     (documentation)
# - test/description     (testing)
```

### 4. Make Your Changes

Follow the [Coding Standards](#coding-standards) below.

### 5. Test Your Changes

```matlab
% Run comprehensive tests
comprehensive_test;

% Run specific module tests
test_modular_system;

% Manual testing
app = MRACApp;
% Test your feature...
```

### 6. Commit Your Changes

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "Add feature: description of what you did"

# Commit message format:
# - Add feature: <description>
# - Fix bug: <description>
# - Update docs: <description>
# - Refactor: <description>
```

### 7. Push to Your Fork

```bash
# Push to your fork
git push origin feature/your-feature-name
```

### 8. Open a Pull Request

1. Go to your fork on GitHub
2. Click **Compare & pull request**
3. Fill out the PR template
4. Submit the pull request

---

## 🛠️ Development Setup

### Initial Setup

```bash
# 1. Clone your fork
git clone https://github.com/YOUR_USERNAME/MRAC_LLM.git
cd MRAC_LLM

# 2. Add upstream
git remote add upstream https://github.com/ORIGINAL_OWNER/MRAC_LLM.git

# 3. Install in MATLAB
# Open MATLAB, navigate to folder, then:
addpath(genpath(pwd));
savepath;
```

### Development Workflow

```bash
# 1. Sync with upstream
git fetch upstream
git checkout main
git merge upstream/main

# 2. Create feature branch
git checkout -b feature/new-feature

# 3. Make changes in MATLAB
# (Edit files, test, iterate)

# 4. Test thoroughly
# Run: comprehensive_test in MATLAB

# 5. Commit and push
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# 6. Open PR on GitHub
```

---

## 📝 Coding Standards

### MATLAB Code Style

#### File Headers

```matlab
% filename.m
% Brief description of what this file does
%
% Syntax:
%   output = filename(input1, input2)
%
% Inputs:
%   input1 - Description of first input
%   input2 - Description of second input
%
% Outputs:
%   output - Description of output
%
% Example:
%   result = filename(10, 20);
%
% Author: Your Name
% Date: YYYY-MM-DD
```

#### Function Documentation

```matlab
function [output1, output2] = myFunction(input1, input2)
    %myFunction - One-line description
    %
    %   Detailed description of what the function does,
    %   including algorithm overview if complex.
    %
    %   See also: relatedFunction1, relatedFunction2
    
    % Input validation
    if nargin < 2
        error('myFunction requires 2 inputs');
    end
    
    % Main logic
    output1 = input1 * 2;
    output2 = input2 + 5;
    
    % Return values
end
```

#### Naming Conventions

```matlab
% Variables: camelCase
myVariable = 10;
settlingTime = 3.5;

% Functions: camelCase
function result = calculateGain(input)
    % ...
end

% Classes: PascalCase
classdef MRACEngine < handle
    % ...
end

% Constants: UPPER_CASE
MAX_ITERATIONS = 100;
DEFAULT_GAIN = 1000;
```

#### Code Formatting

```matlab
% Good: Clear spacing and indentation
if condition
    for i = 1:10
        result = compute(i);
        display(result);
    end
else
    warning('Condition not met');
end

% Bad: Poor formatting
if condition,for i=1:10,result=compute(i);display(result);end,else,warning('Condition not met');end

% Good: Meaningful variable names
dampingRatio = 0.7;
naturalFrequency = 3.0;

% Bad: Unclear names
dr = 0.7;
nf = 3.0;
```

#### Comments

```matlab
% Single-line comment for simple explanations
result = input * 2;  % Inline comment

%{
Multi-line comment
for more complex explanations
or TODO notes
%}

%% Section Headers (with double %%
%% Main Simulation Loop
for iter = 1:maxIterations
    % ...
end
```

---

## 🧪 Testing Guidelines

### Test Requirements

All contributions must include tests:

- ✅ **Unit Tests**: Test individual functions
- ✅ **Integration Tests**: Test module interactions
- ✅ **GUI Tests**: Test user interface components
- ✅ **Regression Tests**: Ensure no existing features break

### Writing Tests

```matlab
% test_myFeature.m
function test_myFeature()
    %test_myFeature - Test suite for myFeature
    
    fprintf('Running myFeature tests...\n');
    
    % Test 1: Basic functionality
    input = 10;
    expected = 20;
    actual = myFeature(input);
    assert(actual == expected, 'Test 1 Failed: Basic functionality');
    fprintf('✅ Test 1: Basic functionality - PASSED\n');
    
    % Test 2: Edge case
    input = 0;
    expected = 0;
    actual = myFeature(input);
    assert(actual == expected, 'Test 2 Failed: Edge case');
    fprintf('✅ Test 2: Edge case - PASSED\n');
    
    % Test 3: Error handling
    try
        myFeature('invalid');
        error('Test 3 Failed: Should have thrown error');
    catch ME
        fprintf('✅ Test 3: Error handling - PASSED\n');
    end
    
    fprintf('All tests passed!\n');
end
```

### Running Tests

```matlab
% Run all tests
comprehensive_test;

% Run specific test
test_myFeature;

% Check coverage (manual)
% Ensure all code paths are tested
```

---

## 🔄 Pull Request Process

### PR Checklist

Before submitting, ensure:

- [ ] Code follows style guidelines
- [ ] Tests added and passing
- [ ] Documentation updated
- [ ] Comments added for complex code
- [ ] No merge conflicts with main branch
- [ ] Commit messages are clear
- [ ] PR description is complete

### PR Template

When opening a PR, include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Testing
- [ ] Tests added
- [ ] All tests passing
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots for UI changes

## Related Issues
Closes #123
```

### Review Process

1. **Automated Checks**: Tests run automatically
2. **Code Review**: Maintainers review your code
3. **Feedback**: Address any requested changes
4. **Approval**: Once approved, PR will be merged
5. **Merge**: Maintainer merges to main branch

### After Merge

```bash
# Update your fork
git checkout main
git pull upstream main
git push origin main

# Delete feature branch
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

---

## 🐛 Issue Reporting

### Bug Reports

Include:

1. **Description**: Clear description of the bug
2. **Steps to Reproduce**: Exact steps to trigger the bug
3. **Expected Behavior**: What should happen
4. **Actual Behavior**: What actually happens
5. **Environment**: MATLAB version, OS, etc.
6. **Screenshots**: If applicable
7. **Error Messages**: Full error text

**Template:**

```markdown
**Bug Description**
Clear description of the bug

**To Reproduce**
1. Step 1
2. Step 2
3. Step 3

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- MATLAB Version: R2023b
- OS: Windows 11
- MRAC-LLM Version: 1.0.0

**Screenshots**
[Add screenshots]

**Error Messages**
```
Error text here
```
```

### Feature Requests

Include:

1. **Problem**: What problem does this solve?
2. **Proposed Solution**: How should it work?
3. **Alternatives**: Other solutions considered
4. **Additional Context**: Any other info

---

## 🌟 Recognition

Contributors will be:

- ✅ Listed in [CONTRIBUTORS.md](CONTRIBUTORS.md)
- ✅ Mentioned in release notes
- ✅ Acknowledged in documentation

---

## 📞 Questions?

- 💬 [GitHub Discussions](https://github.com/YOUR_USERNAME/MRAC_LLM/discussions)
- 🐛 [GitHub Issues](https://github.com/YOUR_USERNAME/MRAC_LLM/issues)

---

## 📚 Resources

- [MATLAB Style Guide](https://www.mathworks.com/matlabcentral/fileexchange/46056-matlab-style-guidelines-2-0)
- [Git Handbook](https://guides.github.com/introduction/git-handbook/)
- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)

---

<div align="center">

**Thank you for contributing to MRAC-LLM! 🎉**

[⬆ Back to README](README.md)

</div>

