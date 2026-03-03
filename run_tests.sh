#!/bin/bash
# Script to run tests and verify code quality

set -e  # Exit on error

TARGET=${1:-all}

setup_venv() {
	if [ ! -d ".venv" ]; then
		echo "===== Creating virtual environment ====="
		python3 -m venv .venv
	fi
	source .venv/bin/activate
}

install_dev() {
	echo "===== Installing dependencies ====="
	pip install -e ".[dev]"
}

run_typecheck() {
	echo "===== Running type checking ====="
	pyright
}

run_lint() {
	echo "===== Running linting ====="
	ruff check .
}

run_format() {
	echo "===== Running formatting ====="
	ruff format .
}

run_tests() {
	echo "===== Running tests ====="
	pytest
}

run_tests_tools() {
	echo "===== Running tests/test_tools.py ====="
	pytest tests/test_tools.py
}

run_tests_session() {
	echo "===== Running tests matching session ====="
	pytest -k "session"
}

setup_venv

case "$TARGET" in
	install)
		install_dev
		;;
	typecheck)
		run_typecheck
		;;
	lint)
		run_lint
		;;
	format)
		run_format
		;;
	test)
		run_tests
		;;
	test-tools)
		run_tests_tools
		;;
	test-session)
		run_tests_session
		;;
	all)
		install_dev
		run_typecheck
		run_lint
		run_tests
		echo "===== All checks passed! ====="
		;;
	*)
		echo "Unknown target: $TARGET"
		echo "Usage: ./run_tests.sh [install|typecheck|lint|format|test|test-tools|test-session|all]"
		exit 1
		;;
esac