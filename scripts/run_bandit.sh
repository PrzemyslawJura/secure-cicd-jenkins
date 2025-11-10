#!/bin/bash
echo "🔍 Running Bandit static code analysis..."
bandit -r app/ -f html -o bandit-report.html || true
