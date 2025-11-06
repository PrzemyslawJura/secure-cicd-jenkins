#!/bin/bash
echo "🐳 Running Trivy container scan..."
trivy image --severity HIGH,CRITICAL secure-cicd-demo:latest || true
