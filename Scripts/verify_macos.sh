#!/usr/bin/env bash
#
# verify_macos.sh
# MemoryMatch tvOS Verification Script
# Student: Abhilash K A T W (IT22081698)
# Module: SE4041 - Mobile Application Design and Development (Assignment 2, Part B)
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOGS_DIR="${PROJECT_ROOT}/build_logs"
mkdir -p "${LOGS_DIR}"

echo "========================================================"
echo "MemoryMatch (tvOS) - Automated Verification Suite"
echo "Student: Abhilash K A T W (IT22081698)"
echo "Target Platform: Apple tvOS 17.0+"
echo "Project Root: ${PROJECT_ROOT}"
echo "========================================================"

# Check for Xcode command line tools
if ! command -v xcodebuild &> /dev/null; then
    echo "[-] ERROR: xcodebuild not found. This script must be executed on macOS with Xcode 15+ installed."
    exit 1
fi

echo "[+] Discovering available Apple TV Simulators..."
SIMULATOR_NAME=$(xcrun simctl list devices available | grep -E "Apple TV" | head -n 1 | sed -E 's/^[[:space:]]+//; s/[[:space:]]+\(.*\)$//' || true)

if [ -z "${SIMULATOR_NAME}" ]; then
    echo "[!] Warning: No specific named Apple TV simulator detected. Falling back to generic platform destination."
    DESTINATION="generic/platform=tvOS Simulator"
else
    echo "[+] Found Apple TV Simulator: ${SIMULATOR_NAME}"
    DESTINATION="platform=tvOS Simulator,name=${SIMULATOR_NAME}"
fi

echo "[+] Target Destination: ${DESTINATION}"
echo ""

# 1. Clean Build
echo "--- [STEP 1/3] Building MemoryMatch tvOS App ---"
BUILD_LOG="${LOGS_DIR}/build_tvos.log"
if xcodebuild clean build \
    -project "${PROJECT_ROOT}/MemoryMatch.xcodeproj" \
    -scheme "MemoryMatch" \
    -destination "${DESTINATION}" \
    -derivedDataPath "${PROJECT_ROOT}/DerivedData" \
    CODE_SIGNING_ALLOWED=NO \
    | tee "${BUILD_LOG}"; then
    echo "[PASS] MemoryMatch tvOS App build succeeded!"
else
    echo "[-] FAIL: App build failed. Review log at ${BUILD_LOG}"
    exit 1
fi

echo ""

# 2. Run Unit Tests
echo "--- [STEP 2/3] Running Unit Tests (MemoryMatchTests) ---"
TEST_LOG="${LOGS_DIR}/test_unit.log"
if xcodebuild test \
    -project "${PROJECT_ROOT}/MemoryMatch.xcodeproj" \
    -scheme "MemoryMatch" \
    -destination "${DESTINATION}" \
    -only-testing:MemoryMatchTests \
    -derivedDataPath "${PROJECT_ROOT}/DerivedData" \
    CODE_SIGNING_ALLOWED=NO \
    | tee "${TEST_LOG}"; then
    echo "[PASS] All Unit Tests PASSED!"
else
    echo "[-] FAIL: Unit tests failed. Review log at ${TEST_LOG}"
    exit 1
fi

echo ""

# 3. Run UI Tests
echo "--- [STEP 3/3] Running UI Automation Tests (MemoryMatchUITests) ---"
UI_TEST_LOG="${LOGS_DIR}/test_ui.log"
if xcodebuild test \
    -project "${PROJECT_ROOT}/MemoryMatch.xcodeproj" \
    -scheme "MemoryMatch" \
    -destination "${DESTINATION}" \
    -only-testing:MemoryMatchUITests \
    -derivedDataPath "${PROJECT_ROOT}/DerivedData" \
    CODE_SIGNING_ALLOWED=NO \
    | tee "${UI_TEST_LOG}"; then
    echo "[PASS] All UI Tests PASSED!"
else
    echo "[-] FAIL: UI automation tests failed. Review log at ${UI_TEST_LOG}"
    exit 1
fi

echo ""
echo "========================================================"
echo "[SUMMARY] ALL tvOS 17.0 VERIFICATION SUITES COMPLETED: PASS"
echo "Log files saved to: ${LOGS_DIR}"
echo "========================================================"
