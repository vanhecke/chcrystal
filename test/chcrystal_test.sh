#!/usr/bin/env bash

. ./test/helper.sh

function setUp()
{
	chcrystal_reset 2>/dev/null
}

function test_chcrystal_lists_installed_versions()
{
	local output="$(chcrystal)"

	assertTrue "did not list crystal-1.19.1" \
		   '[[ "$output" == *"crystal-1.19.1"* ]]'
}

function test_chcrystal_use_sets_crystal_root()
{
	chcrystal_use "$mock_crystal_dir"

	assertEquals "did not set CRYSTAL_ROOT" \
		     "$mock_crystal_dir" "$CRYSTAL_ROOT"
}

function test_chcrystal_use_sets_crystal_version()
{
	chcrystal_use "$mock_crystal_dir"

	assertEquals "did not set CRYSTAL_VERSION" \
		     "1.19.1" "$CRYSTAL_VERSION"
}

function test_chcrystal_use_adds_bin_to_path()
{
	chcrystal_use "$mock_crystal_dir"

	assertTrue "did not add bin/ to PATH" \
		   '[[ ":$PATH:" == *":$mock_crystal_dir/bin:"* ]]'
}

function test_chcrystal_use_adds_embedded_bin_to_path()
{
	chcrystal_use "$mock_crystal_dir"

	assertTrue "did not add embedded/bin/ to PATH" \
		   '[[ ":$PATH:" == *":$mock_crystal_dir/embedded/bin:"* ]]'
}

function test_chcrystal_use_bin_before_embedded_bin()
{
	chcrystal_use "$mock_crystal_dir"

	# bin/crystal should take precedence over embedded/bin/crystal
	local crystal_path
	crystal_path="$(command -v crystal)"

	assertEquals "bin/crystal does not take precedence" \
		     "$mock_crystal_dir/bin/crystal" "$crystal_path"
}

function test_chcrystal_reset_clears_crystal_root()
{
	chcrystal_use "$mock_crystal_dir"
	chcrystal_reset

	assertNull "did not unset CRYSTAL_ROOT" "$CRYSTAL_ROOT"
}

function test_chcrystal_reset_clears_crystal_version()
{
	chcrystal_use "$mock_crystal_dir"
	chcrystal_reset

	assertNull "did not unset CRYSTAL_VERSION" "$CRYSTAL_VERSION"
}

function test_chcrystal_reset_removes_bin_from_path()
{
	chcrystal_use "$mock_crystal_dir"
	chcrystal_reset

	assertFalse "did not remove bin/ from PATH" \
		    '[[ ":$PATH:" == *":$mock_crystal_dir/bin:"* ]]'
}

function test_chcrystal_reset_removes_embedded_bin_from_path()
{
	chcrystal_use "$mock_crystal_dir"
	chcrystal_reset

	assertFalse "did not remove embedded/bin/ from PATH" \
		    '[[ ":$PATH:" == *":$mock_crystal_dir/embedded/bin:"* ]]'
}

function test_chcrystal_switch_by_version()
{
	chcrystal "1.19.1"

	assertEquals "did not switch to correct version" \
		     "$mock_crystal_dir" "$CRYSTAL_ROOT"
}

function test_chcrystal_switch_by_full_name()
{
	chcrystal "crystal-1.19.1"

	assertEquals "did not switch to correct version" \
		     "$mock_crystal_dir" "$CRYSTAL_ROOT"
}

function test_chcrystal_system_resets()
{
	chcrystal "1.19.1"
	chcrystal "system"

	assertNull "did not reset CRYSTAL_ROOT" "$CRYSTAL_ROOT"
}

function test_chcrystal_unknown_version()
{
	chcrystal "9.9.9" 2>/dev/null

	assertEquals "did not return 1" 1 $?
}

function test_chcrystal_marks_active_version()
{
	chcrystal "1.19.1"

	local output="$(chcrystal)"

	assertTrue "did not mark active version with *" \
		   '[[ "$output" == *"*"*"crystal-1.19.1"* ]]'
}

function tearDown()
{
	chcrystal_reset 2>/dev/null
}

SHUNIT_PARENT=$0 . $SHUNIT2
