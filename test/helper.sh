if [[ -z "$SHUNIT2" ]]; then
	if [[ -f /usr/share/shunit2/shunit2 ]]; then
		SHUNIT2=/usr/share/shunit2/shunit2
	elif shunit2="$(command -v shunit2)"; then
		SHUNIT2="$shunit2"
	else
		echo "$0: shunit2 is not installed." >&2
		exit 1
	fi
fi

test_fixtures_dir="$PWD/test/fixtures"

export HOME="$test_fixtures_dir/home"

mkdir -p "$HOME"

# Create a mock crystal installation for testing
mock_crystals_dir="$test_fixtures_dir/home/.crystals"
mock_crystal_dir="$mock_crystals_dir/crystal-1.19.1"

mkdir -p "$mock_crystal_dir/bin"
mkdir -p "$mock_crystal_dir/embedded/bin"

# Create a fake crystal binary that outputs version info
cat > "$mock_crystal_dir/bin/crystal" <<'SCRIPT'
#!/usr/bin/env bash
echo "Crystal 1.19.1 [mock] (2026-01-20)"
SCRIPT
chmod +x "$mock_crystal_dir/bin/crystal"

# Create a fake shards binary
cat > "$mock_crystal_dir/embedded/bin/shards" <<'SCRIPT'
#!/usr/bin/env bash
echo "Shards 0.20.0 (mock)"
SCRIPT
chmod +x "$mock_crystal_dir/embedded/bin/shards"

# Also create a fake crystal in embedded/bin (like the real distribution)
cat > "$mock_crystal_dir/embedded/bin/crystal" <<'SCRIPT'
#!/usr/bin/env bash
echo "Crystal 1.19.1 [mock-embedded] (2026-01-20)"
SCRIPT
chmod +x "$mock_crystal_dir/embedded/bin/crystal"

. $PWD/share/chcrystal/chcrystal.sh

function oneTimeSetUp() { return; }
function setUp() { return; }
function tearDown() { return; }
function oneTimeTearDown() { return; }
