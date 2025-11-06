#!/bin/bash
echo "🔍 Running Bandit static code analysis..."
bandit -r app/ -f txt || true
