#!/bin/bash
echo "🐳 Running Trivy container scan..."
trivy image  --severity HIGH,CRITICAL --exit-code 0 --no-progress "$IMAGE_NAME" > "trivy-report.txt"
