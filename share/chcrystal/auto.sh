unset CRYSTAL_AUTO_VERSION

function chcrystal_auto()
{
	local dir="$PWD/" version

	until [[ -z "$dir" ]]; do
		dir="${dir%/*}"

		if { read -r version < "$dir/.crystal-version"; } 2>/dev/null || [[ -n "$version" ]]; then
			version="${version%%[[:space:]]}"

			if [[ "$version" == "$CRYSTAL_AUTO_VERSION" ]]; then
				return
			else
				CRYSTAL_AUTO_VERSION="$version"
				chcrystal "$version"
				return $?
			fi
		fi
	done

	if [[ -n "$CRYSTAL_AUTO_VERSION" ]]; then
		chcrystal_reset
		unset CRYSTAL_AUTO_VERSION
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$preexec_functions" == *chcrystal_auto* ]]; then
		preexec_functions+=("chcrystal_auto")
	fi
elif [[ -n "$BASH_VERSION" ]]; then
	trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chcrystal_auto' DEBUG
fi
