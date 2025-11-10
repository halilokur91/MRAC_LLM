# 📦 MRAC-LLM Installation Guide

Complete step-by-step installation instructions for MRAC-LLM.

---

## 📋 Table of Contents

- [System Requirements](#system-requirements)
- [Installation Methods](#installation-methods)
- [Configuration](#configuration)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)

---

## 💻 System Requirements

### Minimum Requirements

| Component | Requirement |
|-----------|-------------|
| **MATLAB** | R2019b or later |
| **Simulink** | Required |
| **Operating System** | Windows 10+, macOS 10.14+, Linux (Ubuntu 18.04+) |
| **RAM** | 4 GB (8 GB recommended) |
| **Disk Space** | 500 MB free space |
| **Display** | 1280x720 minimum resolution |

### Required MATLAB Toolboxes

- ✅ **Control System Toolbox** (Required)
- ✅ **Simulink** (Required)
- ⚪ **Optimization Toolbox** (Optional, for advanced features)
- ⚪ **Statistics and Machine Learning Toolbox** (Optional)

### Optional Requirements

- **OpenAI API Key**: For GPT-4 integration features
  - Get one at: https://platform.openai.com/api-keys
  - Cost: ~$0.01-0.05 per simulation with GPT suggestions
  - Not required for basic functionality (system has local fallback)

---

## 🚀 Installation Methods

### Method 1: Git Clone (Recommended)

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/MRAC_LLM.git

# Navigate to directory
cd MRAC_LLM
```

### Method 2: Download ZIP

1. Go to: https://github.com/YOUR_USERNAME/MRAC_LLM
2. Click **Code** → **Download ZIP**
3. Extract the ZIP file to your desired location
4. Rename folder to `MRAC_LLM` (if needed)

### Method 3: MATLAB Add-On (Future)

*Coming soon: MATLAB File Exchange integration*

---

## ⚙️ Configuration

### Step 1: Add to MATLAB Path

**Option A: Automatic (Recommended)**

```matlab
% Navigate to MRAC_LLM folder in MATLAB
cd('path/to/MRAC_LLM')

% Add all folders and subfolders
addpath(genpath(pwd));

% Save path for future sessions
savepath;

fprintf('✅ MRAC_LLM added to MATLAB path\n');
```

**Option B: Manual**

1. Open MATLAB
2. Navigate to the `MRAC_LLM` folder
3. Right-click on the folder → **Add to Path** → **Selected Folders and Subfolders**
4. Click **Save** in the Set Path dialog

### Step 2: Configure API Key (Optional)

If you want to use GPT-4 features:

**Option A: Using config.json (Recommended)**

```bash
# Copy example config
cp config.json.example config.json

# Edit config.json with your API key
# On Windows:
notepad config.json

# On macOS/Linux:
nano config.json
```

Edit the file:
```json
{
  "apiKey": "sk-proj-YOUR_ACTUAL_API_KEY_HERE",
  "model": "gpt-4o",
  "temperature": 0.7,
  "max_tokens": 800
}
```

**Option B: Using GUI Settings**

1. Launch the application: `app = MRACApp;`
2. Go to **Settings** tab
3. Enter your API key in the **OpenAI API Key** field
4. Click **Save Settings**
5. Click **Test API Connection** to verify

**Option C: Environment Variable**

```bash
# Windows (PowerShell)
$env:OPENAI_API_KEY="sk-proj-YOUR_API_KEY_HERE"

# macOS/Linux
export OPENAI_API_KEY="sk-proj-YOUR_API_KEY_HERE"
```

### Step 3: Initialize Modules

```matlab
% Run startup script (optional but recommended)
run('utils/startup_modular.m');
```

This script:
- ✅ Adds module paths
- ✅ Checks dependencies
- ✅ Validates Simulink models
- ✅ Tests API connection (if configured)

---

## ✅ Verification

### Quick Test

```matlab
% Test 1: Launch GUI
app = MRACApp;
fprintf('✅ GUI launched successfully\n');

% Test 2: Check modules
addModulePaths();
engine = MRACEngine();
fprintf('✅ Modules loaded successfully\n');

% Test 3: Verify Simulink models
if exist('mrac_classic.slx', 'file')
    fprintf('✅ Simulink models found\n');
else
    fprintf('⚠️ Warning: Simulink models not found\n');
end

% Test 4: Check API (if configured)
if isfile('config.json')
    cfg = jsondecode(fileread('config.json'));
    if ~isempty(cfg.apiKey) && ~contains(cfg.apiKey, 'your-')
        fprintf('✅ API key configured\n');
    else
        fprintf('ℹ️ API key not configured (optional)\n');
    end
end

fprintf('\n🎉 Installation verification complete!\n');
```

### Comprehensive Test

```matlab
% Run full system test
comprehensive_test;

% Expected output:
% ✅ Test 1/9: GUI Creation - PASSED
% ✅ Test 2/9: Model Selection - PASSED
% ...
% ✅ Test 9/9: Final Status - PASSED
% 📊 SUCCESS: 9/9 tests passed (100%)
```

---

## 🔧 Troubleshooting

### Issue 1: "Cannot find MRACApp"

**Cause**: MATLAB path not set correctly

**Solution**:
```matlab
% Navigate to MRAC_LLM folder
cd('path/to/MRAC_LLM')

% Add to path
addpath(genpath(pwd));
savepath;

% Verify
which MRACApp
% Should show: C:\path\to\MRAC_LLM\MRACApp.m
```

### Issue 2: "Cannot open Simulink model"

**Cause**: Simulink not installed or models missing

**Solution**:
```matlab
% Check if Simulink is installed
ver simulink

% Check if models exist
dir *.slx

% If models are missing, re-clone repository
```

### Issue 3: "API Connection Failed"

**Cause**: Invalid API key or network issue

**Solution**:
```matlab
% Test API manually
cfg = jsondecode(fileread('config.json'));
url = 'https://api.openai.com/v1/models';
options = weboptions('HeaderFields', {'Authorization', ['Bearer ' cfg.apiKey]});

try
    response = webread(url, options);
    fprintf('✅ API connection successful\n');
catch ME
    fprintf('❌ API Error: %s\n', ME.message);
    fprintf('💡 Check your API key and internet connection\n');
end
```

### Issue 4: "Out of Memory"

**Cause**: Large simulation data

**Solution**:
```matlab
% Clear workspace
clear all;
close all;
clc;

% Reduce simulation time
% Edit in GUI or scripts: max_iterations = 50 (instead of 100)

% Increase MATLAB memory (if available)
% Preferences → General → Java Heap Memory
```

### Issue 5: "Module Path Error"

**Cause**: Module paths not added

**Solution**:
```matlab
% Run module path setup
addModulePaths();

% Or manually:
addpath('modules');
addpath('modules/core');
addpath('modules/ui');
addpath('modules/simulation');
addpath('utils');
addpath('api');
savepath;
```

---

## 📝 Platform-Specific Notes

### Windows

- **Path Separator**: Use `\` or `/` (both work)
- **API Key Storage**: Stored in `config.json`
- **Default Location**: `C:\Users\YourName\Documents\MATLAB\MRAC_LLM\`

```powershell
# Windows command prompt
cd %USERPROFILE%\Documents\MATLAB
git clone https://github.com/YOUR_USERNAME/MRAC_LLM.git
```

### macOS

- **Path Separator**: Use `/`
- **Default Location**: `~/Documents/MATLAB/MRAC_LLM/`
- **Permission Issues**: May need `chmod +x` for scripts

```bash
# macOS Terminal
cd ~/Documents/MATLAB
git clone https://github.com/YOUR_USERNAME/MRAC_LLM.git
```

### Linux

- **Path Separator**: Use `/`
- **Default Location**: `~/Documents/MATLAB/MRAC_LLM/`
- **Dependencies**: Ensure MATLAB is properly installed

```bash
# Linux Terminal
cd ~/Documents/MATLAB
git clone https://github.com/YOUR_USERNAME/MRAC_LLM.git

# If MATLAB not in PATH:
export PATH=$PATH:/usr/local/MATLAB/R2023b/bin
```

---

## 🔄 Updating

### Update from Git

```bash
# Navigate to repository
cd path/to/MRAC_LLM

# Pull latest changes
git pull origin main

# In MATLAB, refresh path
rehash toolboxcache
```

### Manual Update

1. Backup your `config.json` file
2. Download latest version
3. Replace old files
4. Restore your `config.json`

---

## 🗑️ Uninstallation

### Step 1: Remove from MATLAB Path

```matlab
% Remove from path
rmpath(genpath('path/to/MRAC_LLM'));
savepath;

fprintf('✅ MRAC_LLM removed from MATLAB path\n');
```

### Step 2: Delete Files

**Windows**:
```powershell
# Delete folder
Remove-Item -Recurse -Force "C:\path\to\MRAC_LLM"
```

**macOS/Linux**:
```bash
# Delete folder
rm -rf /path/to/MRAC_LLM
```

### Step 3: Clean MATLAB Cache

```matlab
% Clear MATLAB cache
rehash toolboxcache
clear all;
close all;
clc;
```

---

## 📞 Need Help?

If you encounter issues not covered here:

1. 📖 Check the [Main README](README.md)
2. 🔍 Search [GitHub Issues](https://github.com/YOUR_USERNAME/MRAC_LLM/issues)
3. 💬 Ask in [Discussions](https://github.com/YOUR_USERNAME/MRAC_LLM/discussions)
4. 🐛 Report a bug in [Issues](https://github.com/YOUR_USERNAME/MRAC_LLM/issues/new)

---

## ✅ Post-Installation Checklist

- [ ] MATLAB R2019b+ installed
- [ ] Simulink available
- [ ] Repository cloned/downloaded
- [ ] Added to MATLAB path
- [ ] API key configured (optional)
- [ ] Verification tests passed
- [ ] GUI launches successfully
- [ ] Sample simulation runs

**🎉 You're ready to use MRAC-LLM!**

```matlab
% Start your first simulation
app = MRACApp;
```

---

<div align="center">

[⬆ Back to Main README](README.md)

</div>

