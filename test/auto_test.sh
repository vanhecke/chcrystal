#!/usr/bin/env bash

. ./test/helper.sh
. ./share/chcrystal/auto.sh

function setUp()
{
	chcrystal_reset 2>/dev/null
	unset CRYSTAL_AUTO_VERSION
}

function test_chcrystal_auto_switches_when_crystal_version_file_exists()
{
	local test_dir="$test_fixtures_dir/auto_test_project"
	mkdir -p "$test_dir"
	echo "1.19.1" > "$test_dir/.crystal-version"

	# Simulate cd by changing PWD
	local old_pwd="$PWD"
	cd "$test_dir"
	chcrystal_auto
	cd "$old_pwd"

	assertEquals "did not switch to version from .crystal-version" \
		     "$mock_crystal_dir" "$CRYSTAL_ROOT"

	rm -rf "$test_dir"
}

function test_chcrystal_auto_resets_when_leaving_versioned_dir()
{
	local test_dir="$test_fixtures_dir/auto_test_project"
	mkdir -p "$test_dir"
	echo "1.19.1" > "$test_dir/.crystal-version"

	# Switch into versioned dir
	local old_pwd="$PWD"
	cd "$test_dir"
	chcrystal_auto

	# Now leave the versioned directory
	cd "/tmp"
	chcrystal_auto
	cd "$old_pwd"

	assertNull "did not reset CRYSTAL_ROOT" "$CRYSTAL_ROOT"

	rm -rf "$test_dir"
}

function test_chcrystal_auto_does_not_re_switch_same_version()
{
	local test_dir="$test_fixtures_dir/auto_test_project"
	mkdir -p "$test_dir"
	echo "1.19.1" > "$test_dir/.crystal-version"

	local old_pwd="$PWD"
	cd "$test_dir"
	chcrystal_auto

	CRYSTAL_AUTO_VERSION="1.19.1"

	# This should be a no-op since version hasn't changed
	chcrystal_auto

	assertEquals "CRYSTAL_AUTO_VERSION changed unexpectedly" \
		     "1.19.1" "$CRYSTAL_AUTO_VERSION"

	cd "$old_pwd"
	rm -rf "$test_dir"
}

function tearDown()
{
	chcrystal_reset 2>/dev/null
	unset CRYSTAL_AUTO_VERSION
}

SHUNIT_PARENT=$0 . $SHUNIT2
