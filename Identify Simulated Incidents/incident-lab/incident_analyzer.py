#!/usr/bin/env python3
"""Complete Incident Analyzer"""

import re
from datetime import datetime

def analyze_logs():
    """Main analysis function"""
    
    incidents = []
    
    # Analyze application logs
    print("\n[TASK 1] Analyzing Application Logs...")
    with open('logs/application.log', 'r') as f:
        error_count = 0
        for line in f:
            if 'ERROR' in line or 'CRITICAL' in line:
                parts = line.strip().split(' ', 3)
                timestamp = f"{parts[0]} {parts[1]}"
                level = parts[2]
                message = parts[3]
                
                severity = 'CRITICAL' if 'CRITICAL' in line else 'HIGH'
                incidents.append({
                    'timestamp': timestamp,
                    'type': 'Application Error',
                    'severity': severity,
                    'details': message
                })
                error_count += 1
        
        print(f"  Found {error_count} application errors")
    
    # Analyze web server logs
    print("\n[TASK 2] Analyzing Web Server Logs...")
    downtime_count = 0
    slow_response_count = 0
    
    with open('logs/webserver.log', 'r') as f:
        for line in f:
            parts = line.strip().split()
            timestamp = f"{parts[0]} {parts[1]}"
            status_code = parts[2]
            response_time = float(parts[5].replace('s', ''))
            
            # Detect downtime (5xx errors)
            if status_code.startswith('5'):
                incidents.append({
                    'timestamp': timestamp,
                    'type': 'Service Downtime',
                    'severity': 'CRITICAL',
                    'details': f"HTTP {status_code} - Service unavailable"
                })
                downtime_count += 1
            
            # Detect performance issues
            elif response_time > 2.0:
                incidents.append({
                    'timestamp': timestamp,
                    'type': 'Performance Degradation',
                    'severity': 'MEDIUM',
                    'details': f"Slow response: {response_time}s"
                })
                slow_response_count += 1
    
    print(f"  Found {downtime_count} downtime incidents")
    print(f"  Found {slow_response_count} performance issues")
    
    # Analyze metrics
    print("\n[TASK 3] Analyzing System Metrics...")
    resource_issues = 0
    
    with open('logs/metrics.log', 'r') as f:
        for line in f:
            parts = line.strip().split()
            timestamp = f"{parts[0]} {parts[1]}"
            cpu = int(parts[2].split(':')[1].replace('%', ''))
            mem = int(parts[3].split(':')[1].replace('%', ''))
            disk = int(parts[4].split(':')[1].replace('%', ''))
            
            if cpu > 80 or mem > 90 or disk > 90:
                severity = 'CRITICAL' if mem > 95 else 'HIGH'
                incidents.append({
                    'timestamp': timestamp,
                    'type': 'Resource Exhaustion',
                    'severity': severity,
                    'details': f"CPU:{cpu}% MEM:{mem}% DISK:{disk}%"
                })
                resource_issues += 1
    
    print(f"  Found {resource_issues} resource issues")
    
    return incidents

def categorize_incidents(incidents):
    """Categorize incidents by severity"""
    categories = {'CRITICAL': [], 'HIGH': [], 'MEDIUM': [], 'LOW': []}
    
    for incident in incidents:
        severity = incident['severity']
        categories[severity].append(incident)
    
    return categories

def propose_mitigation(incident):
    """Suggest mitigation steps"""
    mitigations = {
        'Service Downtime': [
            '1. Check database connectivity',
            '2. Restart application service',
            '3. Verify network connectivity',
            '4. Review recent deployments'
        ],
        'Application Error': [
            '1. Review application logs for root cause',
            '2. Check database connection pool',
            '3. Verify external service availability',
            '4. Restart affected services'
        ],
        'Resource Exhaustion': [
            '1. Identify resource-intensive processes',
            '2. Scale up system resources',
            '3. Implement resource limits',
            '4. Check for memory leaks'
        ],
        'Performance Degradation': [
            '1. Analyze slow queries',
            '2. Review application performance metrics',
            '3. Check system load',
            '4. Consider caching strategies'
        ]
    }
    
    return mitigations.get(incident['type'], ['Investigate and monitor'])

def generate_report(incidents):
    """Generate incident report"""
    print("\n" + "="*70)
    print("INCIDENT ANALYSIS REPORT")
    print("="*70)
    
    categories = categorize_incidents(incidents)
    
    print(f"\nTotal Incidents Found: {len(incidents)}")
    print(f"  CRITICAL: {len(categories['CRITICAL'])}")
    print(f"  HIGH: {len(categories['HIGH'])}")
    print(f"  MEDIUM: {len(categories['MEDIUM'])}")
    print(f"  LOW: {len(categories['LOW'])}")
    
    # Detailed incident list
    for severity in ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW']:
        if categories[severity]:
            print(f"\n{'='*70}")
            print(f"{severity} SEVERITY INCIDENTS")
            print('='*70)
            
            for idx, incident in enumerate(categories[severity], 1):
                print(f"\nIncident #{idx}")
                print(f"  Timestamp: {incident['timestamp']}")
                print(f"  Type: {incident['type']}")
                print(f"  Details: {incident['details']}")
                print(f"  Mitigation Steps:")
                for step in propose_mitigation(incident):
                    print(f"    {step}")

if __name__ == "__main__":
    incidents = analyze_logs()
    generate_report(incidents)
