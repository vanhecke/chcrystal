# shellcheck shell=bash
CHCRYSTAL_VERSION="0.1.0"
CRYSTALS=()

for dir in "$PREFIX/opt/crystals" "$HOME/.crystals"; do
	[[ -d "$dir" && -n "$(ls -A "$dir" 2>/dev/null)" ]] && CRYSTALS+=("$dir"/*)
done
unset dir

function chcrystal_reset()
{
	[[ -z "$CRYSTAL_ROOT" ]] && return

	PATH=":$PATH:"
	PATH="${PATH//:$CRYSTAL_ROOT\/embedded\/bin:/:}"
	PATH="${PATH//:$CRYSTAL_ROOT\/bin:/:}"
	PATH="${PATH#:}"
	PATH="${PATH%:}"

	unset CRYSTAL_ROOT CRYSTAL_VERSION
	hash -r
}

function chcrystal_use()
{
	if [[ ! -x "$1/bin/crystal" ]]; then
		echo "chcrystal: $1/bin/crystal not executable" >&2
		return 1
	fi

	[[ -n "$CRYSTAL_ROOT" ]] && chcrystal_reset

	export CRYSTAL_ROOT="$1"

	# Add embedded/bin first (for shards), then bin/ on top (so the crystal
	# wrapper script takes precedence over the raw embedded/bin/crystal binary)
	if [[ -d "$CRYSTAL_ROOT/embedded/bin" ]]; then
		export PATH="$CRYSTAL_ROOT/bin:$CRYSTAL_ROOT/embedded/bin:$PATH"
	else
		export PATH="$CRYSTAL_ROOT/bin:$PATH"
	fi

	CRYSTAL_VERSION="$("$CRYSTAL_ROOT/bin/crystal" --version 2>/dev/null | head -1 | awk '{print $2}')"
	export CRYSTAL_VERSION

	hash -r
}

function chcrystal()
{
	case "$1" in
		-h|--help)
			echo "usage: chcrystal [VERSION|system]"
			echo
			echo "   chcrystal              List installed Crystal versions"
			echo "   chcrystal VERSION      Switch to a Crystal version"
			echo "   chcrystal system       Reset to system Crystal"
			echo "   chcrystal -V           Print chcrystal version"
			;;
		-V|--version)
			echo "chcrystal: $CHCRYSTAL_VERSION"
			;;
		"")
			local dir star
			for dir in "${CRYSTALS[@]}"; do
				dir="${dir%%/}"
				if [[ "$dir" == "$CRYSTAL_ROOT" ]]; then star="*"
				else                                      star=" "
				fi
				echo " $star ${dir##*/}"
			done
			;;
		system)
			chcrystal_reset
			;;
		*)
			local dir match
			for dir in "${CRYSTALS[@]}"; do
				dir="${dir%%/}"
				case "${dir##*/}" in
					"crystal-$1")  match="$dir" && break ;;
					"$1")          match="$dir" && break ;;
					*"$1"*)        match="$dir" ;;
				esac
			done

			if [[ -z "$match" ]]; then
				echo "chcrystal: unknown Crystal: $1" >&2
				return 1
			fi

			shift
			chcrystal_use "$match"
			;;
	esac
}
