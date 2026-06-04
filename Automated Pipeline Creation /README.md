# 🚀 Automated Pipeline Creation 

<p align="center">

![Git](https://img.shields.io/badge/Git-Version_Control-F05032?style=for-the-badge&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-Actions-181717?style=for-the-badge&logo=github)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI/CD-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Python](https://img.shields.io/badge/Python-Automation-3776AB?style=for-the-badge&logo=python&logoColor=white)
![YAML](https://img.shields.io/badge/YAML-Workflow-red?style=for-the-badge&logo=yaml)

</p>

---

# 📖 Automated Pipeline Creation

## 🎯 Overview

Continuous Integration and Continuous Deployment (CI/CD) pipelines automate software testing, validation, packaging, and deployment.

In this lab, you will create a complete GitHub Actions CI/CD pipeline for a Python application, including automated testing, linting, multi-version testing, artifact generation, and pull request validation.

---

# 📋 Prerequisites

Before starting this lab, ensure you have:

✅ Basic understanding of Git and Version Control

✅ Familiarity with Linux Command Line

✅ Basic YAML knowledge

✅ Understanding of software testing concepts

✅ GitHub account (Free Tier)

---

# 🎯 Learning Objectives

By the end of this lab, you will be able to:

✅ Configure GitHub Actions workflows

✅ Create automated testing pipelines

✅ Implement build and deployment stages

✅ Troubleshoot pipeline failures

✅ Understand CI/CD best practices

---

# 🛠️ Environment Setup

---

## 🔹 Step 1: Update System

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 🔹 Step 2: Install Required Tools

```bash
sudo apt install -y git curl nodejs npm python3 python3-pip
```

Verify installation:

```bash
git --version
python3 --version
node --version
npm --version
```

---

## 🔹 Step 3: Configure Git

```bash
git config --global user.name "Your Name"

git config --global user.email "your.email@example.com"
```

Verify:

```bash
git config --list
```

---

## 🔹 Step 4: Install GitHub CLI (Optional)

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
| sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
```

```bash
echo "deb [arch=$(dpkg --print-architecture) \
signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" \
| sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
```

```bash
sudo apt update

sudo apt install gh -y
```

Verify:

```bash
gh --version
```

---

# 🧪 Task 1: Create Sample Application and Repository

---

## 🔹 Step 1: Create Project Directory

```bash
mkdir ~/cicd-demo

cd ~/cicd-demo
```

---

## 🔹 Step 2: Initialize Git Repository

```bash
git init
```

Verify:

```bash
git status
```

---

## 🔹 Step 3: Create Python Application

Create:

```bash
cat > calculator.py << 'EOF'
"""
Simple calculator module for CI/CD demonstration
"""

def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b
EOF
```

---

## 🔹 Step 4: Create Unit Tests

```bash
cat > test_calculator.py << 'EOF'
import unittest

from calculator import add, subtract, multiply, divide

class TestCalculator(unittest.TestCase):

    def test_add(self):
        self.assertEqual(add(2,3),5)
        self.assertEqual(add(-1,1),0)

    def test_subtract(self):
        self.assertEqual(subtract(5,3),2)
        self.assertEqual(subtract(0,5),-5)

    def test_multiply(self):
        self.assertEqual(multiply(3,4),12)
        self.assertEqual(multiply(-2,3),-6)

    def test_divide(self):
        self.assertEqual(divide(10,2),5)

        with self.assertRaises(ValueError):
            divide(10,0)

if __name__ == "__main__":
    unittest.main()
EOF
```

---

## 🔹 Step 5: Create Requirements File

```bash
cat > requirements.txt << 'EOF'
pytest==7.4.3
pytest-cov==4.1.0
EOF
```

---

## 🔹 Step 6: Install Dependencies

```bash
pip3 install -r requirements.txt
```

---

## 🔹 Step 7: Test Locally

```bash
python3 -m pytest test_calculator.py -v
```

Expected:

```text
4 passed
```

---

## 🔹 Step 8: Create GitHub Repository

Using GitHub CLI:

```bash
gh auth login
```

```bash
gh repo create cicd-demo \
--public \
--source=. \
--remote=origin \
--push
```

---

### Manual Method

```bash
git add .
git commit -m "Initial commit"
```

```bash
git branch -M main
```

```bash
git remote add origin \
https://github.com/YOUR_USERNAME/cicd-demo.git
```

```bash
git push -u origin main
```

---

# ⚙️ Task 2: Configure GitHub Actions Pipeline

---

## 🔹 Step 1: Create Workflow Directory

```bash
mkdir -p .github/workflows
```

---

## 🔹 Step 2: Create Basic CI Workflow

```bash
cat > .github/workflows/ci.yml << 'EOF'
name: CI Pipeline

on:
  push:
    branches:
      - main
      - develop

  pull_request:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest

    steps:

    - uses: actions/checkout@v3

    - name: Setup Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.10'

    - name: Install Dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt

    - name: Run Tests
      run: |
        pytest test_calculator.py -v \
        --cov=calculator \
        --cov-report=xml

    - name: Upload Coverage
      uses: codecov/codecov-action@v3
EOF
```

---

## 🔹 Step 3: Create Multi-Stage Pipeline

Create:

```bash
cat > .github/workflows/full-pipeline.yml << 'EOF'
name: Full CI/CD Pipeline
EOF
```

Pipeline stages:

### Lint Stage

```text
Code Quality Validation
```

### Test Stage

```text
Unit Testing
Coverage Reports
Matrix Builds
```

### Build Stage

```text
Artifact Creation
Packaging
```

---

## 🔹 Step 4: Configure Linting

Install:

```yaml
pip install flake8
```

Run:

```yaml
flake8 calculator.py --max-line-length=100
```

---

## 🔹 Step 5: Configure Multi-Version Testing

```yaml
strategy:
  matrix:
    python-version:
      - "3.9"
      - "3.10"
      - "3.11"
```

Benefits:

✅ Compatibility Validation

✅ Early Failure Detection

✅ Production Readiness

---

## 🔹 Step 6: Create Build Artifacts

Create package:

```bash
tar -czf calculator-app.tar.gz \
calculator.py \
requirements.txt
```

Upload artifact:

```yaml
uses: actions/upload-artifact@v3
```

---

## 🔹 Step 7: Create README Badge

```markdown
# CI/CD Demo

![CI Pipeline](https://github.com/YOUR_USERNAME/cicd-demo/workflows/CI%20Pipeline/badge.svg)
```

---

## 🔹 Step 8: Commit Pipeline

```bash
git add .
```

```bash
git commit -m "Add GitHub Actions CI/CD pipeline"
```

```bash
git push origin main
```

---

## 🔹 Step 9: Monitor Pipeline

Open GitHub:

```text
Repository → Actions
```

Observe:

- Workflow execution
- Build logs
- Test results
- Artifacts

---

## 🔹 Step 10: Create Feature Branch

```bash
git checkout -b feature/advanced-operations
```

Add:

```python
def power(a,b):
    return a ** b

def modulo(a,b):
    return a % b
```

Add tests.

Commit:

```bash
git add .
```

```bash
git commit -m "Add power and modulo"
```

```bash
git push origin feature/advanced-operations
```

Create Pull Request.

---

# 🔍 Verification

---

## Verify Workflow Files

```bash
ls -la .github/workflows/
```

---

## Validate YAML

Install validator:

```bash
pip3 install yamllint
```

Validate:

```bash
yamllint .github/workflows/*.yml
```

---

## Verify GitHub Actions

Visit:

```text
https://github.com/YOUR_USERNAME/cicd-demo/actions
```

Expected:

```text
✔ CI Pipeline Passed
✔ Full Pipeline Passed
```

---

## Test Workflows Locally (Optional)

Install:

```bash
curl https://raw.githubusercontent.com/nektos/act/master/install.sh \
| sudo bash
```

List workflows:

```bash
act -l
```

Run:

```bash
act push
```

---

# 📊 Verify Pipeline Features

| Feature | Expected Result |
|----------|----------------|
| Automated Testing | Tests run on every push |
| Multi-Python Support | Python 3.9, 3.10, 3.11 |
| Artifacts | Downloadable packages |
| Status Badge | Shows pipeline status |
| Pull Request Validation | Blocks failed merges |

---

# ✅ Expected Outcomes

- [x] Pipeline executes automatically
- [x] Tests run successfully
- [x] Coverage reports generated
- [x] Artifacts uploaded
- [x] Matrix builds succeed
- [x] PR validation enabled
- [x] Build completes under 5 minutes

---

# 🛠️ Troubleshooting

---

## ❌ Workflow Not Triggering

Check:

```bash
.github/workflows/
```

Validate YAML:

```bash
yamllint .github/workflows/*.yml
```

---

## ❌ Tests Pass Locally But Fail in CI

Verify:

```text
Python Version
Dependencies
Environment Variables
```

---

## ❌ Permission Errors

Repository Settings:

```text
Settings → Actions → General
```

Enable:

```text
Read and Write Permissions
```

---

## ❌ Slow Pipeline

Optimize:

```text
Caching Dependencies
Parallel Jobs
Smaller Test Suites
```

---

## Debug Commands

List runs:

```bash
gh run list
```

View logs:

```bash
gh run view <run-id> --log
```

List secrets:

```bash
gh secret list
```

---

# 🧹 Cleanup

Delete local repository:

```bash
cd ~

rm -rf ~/cicd-demo
```

Delete GitHub repository:

```bash
gh repo delete YOUR_USERNAME/cicd-demo
```

---

# 🎓 Conclusion

Congratulations! You have successfully completed the Automated Pipeline Creation Lab.

You learned how to:

✅ Build CI/CD pipelines using GitHub Actions

✅ Automate testing and validation

✅ Configure matrix builds

✅ Generate artifacts

✅ Integrate pull request workflows

✅ Implement CI/CD best practices

---

# 💡 Key Takeaways

### Automation

CI/CD eliminates repetitive manual work.

### Quality Assurance

Automated testing prevents bugs from reaching production.

### Consistency

Every change follows the same validation process.

### Collaboration

Pull requests enforce code quality standards.

### Visibility

Pipeline logs and badges improve transparency.

---

# 🚀 Next Steps

### 🔹 Continuous Deployment

Deploy automatically to:

- Staging
- Production
- Kubernetes

---

### 🔹 Security Scanning

Integrate:

- Trivy
- Snyk
- Dependabot

---

### 🔹 Code Coverage

Add:

```text
Coverage Thresholds
Quality Gates
```

---

### 🔹 Release Automation

Implement:

```text
Semantic Versioning
Git Tags
Release Notes
```

---

### 🔹 Notifications

Integrate:

- Slack
- Microsoft Teams
- Email Alerts

---

# 🌍 Real-World Applications

Organizations use CI/CD pipelines to:

✅ Deploy web applications

✅ Validate Infrastructure as Code

✅ Run security checks

✅ Build microservices

✅ Automate documentation generation

✅ Improve software delivery speed

---

# 🏆 Lab Completed Successfully

```text
✔ Environment Configured
✔ Repository Created
✔ Python Application Built
✔ Unit Tests Implemented
✔ GitHub Actions Configured
✔ Multi-Stage Pipeline Created
✔ Matrix Builds Enabled
✔ Artifacts Generated
✔ Pull Request Validation Enabled
✔ CI/CD Workflow Operational
```

🎉 Congratulations! You have successfully completed the Automated Pipeline Creation Lab and built a production-style CI/CD workflow using GitHub Actions.
