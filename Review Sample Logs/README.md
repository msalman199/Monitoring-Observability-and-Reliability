# 📊 Log Analysis 

<p align="center">

![Linux](https://img.shields.io/badge/Linux-Terminal-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![grep](https://img.shields.io/badge/grep-Log_Search-blue?style=for-the-badge)
![awk](https://img.shields.io/badge/awk-Text_Processing-orange?style=for-the-badge)
![Log Analysis](https://img.shields.io/badge/Log-Analysis-success?style=for-the-badge)

</p>

---

# 📖 Review Sample Logs

## 🎯 Overview

Logs are one of the most important sources of information for troubleshooting, monitoring, and understanding application behavior.

In this lab, you'll learn how to analyze application logs using Linux command-line tools, identify errors and warnings, detect anomalies, and generate automated reports.

---

# 📋 Prerequisites

Before starting this lab, ensure you have:

✅ Basic Linux command-line knowledge

✅ Understanding of text file operations

✅ Access to a Linux terminal

---

# 🎯 Learning Objectives

By completing this lab, you will:

✅ Understand common log file formats and structures

✅ Identify different log severity levels

✅ Detect anomalies and patterns in log files

✅ Use Linux command-line tools for log analysis

✅ Summarize findings from log data

---

# 🛠️ Environment Setup

After launching the lab, you'll work on a Linux machine.

---

## 🔹 Step 1: Update System and Install Tools

```bash
sudo apt update
sudo apt install -y grep less vim
```

Verify installation:

```bash
grep --version
less --version
vim --version
```

---

## 🔹 Step 2: Create Working Directory

```bash
mkdir ~/log-analysis-lab

cd ~/log-analysis-lab
```

Verify:

```bash
pwd
```

Expected:

```text
/home/user/log-analysis-lab
```

---

## 🔹 Step 3: Create Sample Log File

Create a realistic application log file:

```bash
cat > application.log << 'EOF'
2024-01-15 08:00:01 INFO Application started successfully
2024-01-15 08:00:05 INFO User login: user_id=1001, username=alice
2024-01-15 08:01:23 INFO Database connection established
2024-01-15 08:02:45 WARNING High memory usage detected: 85%
2024-01-15 08:03:12 INFO User login: user_id=1002, username=bob
2024-01-15 08:05:30 ERROR Failed to connect to payment gateway: timeout
2024-01-15 08:05:31 WARNING Retrying payment gateway connection
2024-01-15 08:05:35 INFO Payment gateway connection restored
2024-01-15 08:07:22 INFO User logout: user_id=1001, username=alice
2024-01-15 08:08:45 ERROR Database query failed: table 'orders' not found
2024-01-15 08:09:10 WARNING Disk space low: 92% used on /var
2024-01-15 08:10:33 INFO User login: user_id=1003, username=charlie
2024-01-15 08:12:15 ERROR Authentication service unavailable
2024-01-15 08:12:16 ERROR Authentication service unavailable
2024-01-15 08:12:17 ERROR Authentication service unavailable
2024-01-15 08:12:18 ERROR Authentication service unavailable
2024-01-15 08:13:00 WARNING Cache miss rate exceeding threshold: 45%
2024-01-15 08:14:22 INFO Scheduled backup completed
2024-01-15 08:15:40 INFO User logout: user_id=1002, username=bob
2024-01-15 08:16:55 ERROR Network connection lost
2024-01-15 08:17:10 INFO Network connection restored
EOF
```

Verify file:

```bash
cat application.log
```

---

# 🧪 Task 1: Open and Examine the Log File

---

## 🔹 Step 1: View the Entire Log File

```bash
less application.log
```

### Navigation

| Key | Action |
|------|---------|
| Space | Scroll Down |
| b | Scroll Up |
| q | Quit |

Observe:

- Timestamp
- Severity Level
- Message

---

## 🔹 Step 2: Count Total Log Entries

```bash
wc -l application.log
```

Expected Output:

```text
21 application.log
```

---

## 🔹 Step 3: Understand Log Structure

Each entry contains:

| Component | Example |
|------------|----------|
| Timestamp | 2024-01-15 08:00:01 |
| Severity | INFO |
| Message | Application started successfully |

Example:

```text
2024-01-15 08:00:01 INFO Application started successfully
```

---

# 🚦 Task 2: Identify Log Severity Levels

---

## 🔹 Step 1: Extract INFO Messages

```bash
grep "INFO" application.log
```

Count:

```bash
grep -c "INFO" application.log
```

---

## 🔹 Step 2: Extract WARNING Messages

```bash
grep "WARNING" application.log
```

Count:

```bash
grep -c "WARNING" application.log
```

---

## 🔹 Step 3: Extract ERROR Messages

```bash
grep "ERROR" application.log
```

Count:

```bash
grep -c "ERROR" application.log
```

---

## 🔹 Step 4: Create Summary Script

Create:

```bash
cat > analyze_logs.sh << 'EOF'
#!/bin/bash

LOG_FILE="application.log"

echo "=== Log Analysis Summary ==="
echo ""

INFO_COUNT=$(grep -c "INFO" $LOG_FILE)
WARNING_COUNT=$(grep -c "WARNING" $LOG_FILE)
ERROR_COUNT=$(grep -c "ERROR" $LOG_FILE)
TOTAL_COUNT=$(wc -l < $LOG_FILE)

echo "Total entries: $TOTAL_COUNT"
echo "INFO messages: $INFO_COUNT"
echo "WARNING messages: $WARNING_COUNT"
echo "ERROR messages: $ERROR_COUNT"
EOF
```

Make executable:

```bash
chmod +x analyze_logs.sh
```

Run:

```bash
./analyze_logs.sh
```

---

# 🚨 Task 3: Detect Anomalies

---

## 🔹 Step 1: Identify Repeated Errors

```bash
grep "ERROR" application.log | uniq -c
```

Observation:

```text
Authentication service unavailable
```

appears 4 consecutive times.

This indicates a possible service outage.

---

## 🔹 Step 2: Find Time Gaps

```bash
awk '{print $1, $2}' application.log
```

Review timestamps manually.

Look for:

- Delays
- Missing events
- Long gaps

---

## 🔹 Step 3: Detect Critical Keywords

```bash
grep -E "failed|unavailable|lost|timeout" application.log
```

Critical Indicators:

- failed
- unavailable
- timeout
- lost

---

## 🔹 Step 4: Create Anomaly Detection Script

```bash
cat > detect_anomalies.sh << 'EOF'
#!/bin/bash

LOG_FILE="application.log"

echo "=== Anomaly Detection Report ==="
echo ""

echo "1. Repeated Errors:"
grep "ERROR" $LOG_FILE | sort | uniq -c | awk '$1 >= 3 {print "Found", $1, "occurrences:", substr($0,index($0,$4))}'

echo ""

echo "2. Critical Issues:"
grep -i -E "failed|unavailable|lost|timeout" $LOG_FILE

echo ""

echo "3. Resource Warnings:"
grep -E "memory|disk|cache" $LOG_FILE
EOF
```

Run:

```bash
chmod +x detect_anomalies.sh

./detect_anomalies.sh
```

---

# 📑 Task 4: Summarize Findings

---

## 🔹 Step 1: Generate Full Analysis Report

Create:

```bash
cat > generate_report.sh << 'EOF'
#!/bin/bash

LOG_FILE="application.log"
REPORT_FILE="analysis_report.txt"

{
echo "================================="
echo "LOG ANALYSIS REPORT"
echo "================================="
echo ""

echo "Total Entries: $(wc -l < $LOG_FILE)"
echo "INFO: $(grep -c INFO $LOG_FILE)"
echo "WARNING: $(grep -c WARNING $LOG_FILE)"
echo "ERROR: $(grep -c ERROR $LOG_FILE)"

echo ""
echo "RECOMMENDATIONS"
echo "1. Investigate authentication failures"
echo "2. Monitor disk usage"
echo "3. Review database schema"
echo "4. Optimize cache settings"
echo "5. Review payment gateway timeout settings"

} > $REPORT_FILE

cat $REPORT_FILE
EOF
```

Run:

```bash
chmod +x generate_report.sh

./generate_report.sh
```

---

## 🔹 Step 2: Export Error Timeline

```bash
grep "ERROR" application.log > errors_only.log
```

View:

```bash
cat errors_only.log
```

---

## 🔹 Step 3: Manual Analysis Questions

### ❓ Most Critical Issue

```text
Authentication service unavailable
```

Occurred 4 consecutive times.

---

### ❓ Resource Warnings

```text
High memory usage (85%)
Disk usage at 92%
Cache miss rate 45%
```

---

### ❓ Network Issues

```text
Payment gateway timeout
Network connection lost
```

---

### ❓ Database Issues

```text
Orders table not found
```

---

# ✅ Verification

---

## 🔍 Run All Analysis Scripts

```bash
echo "=== Running All Analysis Scripts ==="

./analyze_logs.sh

./detect_anomalies.sh

ls -lh analysis_report.txt
```

---

## 📌 Expected Results Checklist

### Log File

- [x] Created application.log

### Severity Analysis

- [x] 11 INFO messages

- [x] 4 WARNING messages

- [x] 6 ERROR messages

### Anomaly Detection

- [x] Detected repeated authentication failures

- [x] Identified resource warnings

- [x] Detected network problems

### Reporting

- [x] Generated analysis report

- [x] Created error timeline

---

# 🛠️ Troubleshooting

---

## ❌ grep Not Found

Install:

```bash
sudo apt install grep
```

---

## ❌ Permission Denied

```bash
chmod +x script_name.sh
```

---

## ❌ Log File Missing

Verify location:

```bash
pwd

ls -l
```

---

## ❌ Script Produces No Output

Verify file exists:

```bash
ls -l application.log
```

---

# 🧹 Cleanup

Remove lab files:

```bash
rm -f analyze_logs.sh

rm -f detect_anomalies.sh

rm -f generate_report.sh

rm -f analysis_report.txt

rm -f errors_only.log

rm -f application.log
```

Remove workspace:

```bash
cd ~

rm -rf ~/log-analysis-lab
```

---

# 🎓 Conclusion

Congratulations! You have successfully completed the Log Analysis Lab.

You learned how to:

✅ Navigate log files using Linux tools

✅ Analyze INFO, WARNING, and ERROR events

✅ Detect anomalies and repeated failures

✅ Use grep and awk for investigation

✅ Create automation scripts

✅ Generate professional reports

---

# 💡 Key Takeaways

- Logs reveal application health and system behavior.
- ERROR events require immediate attention.
- Repeated failures usually indicate major issues.
- Automated analysis improves troubleshooting speed.
- Regular monitoring prevents outages.

---

# 🚀 Next Steps

### 🔹 Advanced grep Usage

Learn:

```bash
grep -r
grep -v
grep -E
```

### 🔹 Master awk

Practice:

```bash
awk
```

for structured log parsing.

### 🔹 Learn sed

Automate text transformations.

### 🔹 Analyze Real Logs

Explore:

```text
/var/log/syslog
/var/log/auth.log
/var/log/nginx/access.log
```

### 🔹 Explore Log Platforms

- ELK Stack
- Grafana Loki
- Splunk
- Graylog

---

# 🏆 Lab Completed Successfully

```text
✔ Environment Configured
✔ Log File Created
✔ Severity Levels Identified
✔ Errors Detected
✔ Anomalies Found
✔ Reports Generated
✔ Timeline Exported
✔ Cleanup Completed
```

🎉 Congratulations! You have successfully mastered the fundamentals of Linux Log Analysis.
