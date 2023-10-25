#!/usr/bin/bash -e
#
# Creating repository on Gitea.
#
# @package    Bash
# @author     Kitsune Solar <mail@kitsune.solar>
# @copyright  2023 iHub TO
# @license    MIT
# @version    0.0.1
# @link       https://lib.onl
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID == 0 )) && { echo >&2 'This script should not be run as root!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION.
# -------------------------------------------------------------------------------------------------------------------- #

curl="$( command -v curl )"
sleep='2'

# Help.
read -r -d '' help <<- EOF
Options:
  -x 'TOKEN'                            Gitea user token.
  -a 'https://gitea.com'                Gitea API URL.
  -o 'OWNER'                            Repository owner (organization). This is not case sensitive.
  -r 'REPO_1;REPO_2;REPO_3'             Repository name (array).
  -d 'DESCRIPTION'                      Repository description.
  -l 'mit'                              Open source license template. For example, "mit" or "mpl-2.0".
  -b 'main'                             Repository default branch.
  -i                                    Repository auto-init.
  -p                                    Whether repository is private.
EOF

# -------------------------------------------------------------------------------------------------------------------- #
# OPTIONS.
# -------------------------------------------------------------------------------------------------------------------- #

OPTIND=1

while getopts 'x:a:o:r:d:l:b:iph' opt; do
  case ${opt} in
    x)
      token="${OPTARG}"
      ;;
    a)
      api="${OPTARG}"
      ;;
    o)
      org="${OPTARG}"
      ;;
    r)
      repos="${OPTARG}"; IFS=';' read -ra repos <<< "${repos}"
      ;;
    d)
      description="${OPTARG}"
      ;;
    l)
      license="${OPTARG}"
      ;;
    b)
      branch="${OPTARG}"
      ;;
    i)
      auto_init=1
      ;;
    p)
      private=1
      ;;
    h|*)
      echo "${help}"; exit 2
      ;;
  esac
done

shift $(( OPTIND - 1 ))

(( ! ${#repos[@]} )) && { echo >&2 '[ERROR] Repository name not specified!'; exit 1; }
[[ -z "${token}" ]] && { echo >&2 '[ERROR] Token not specified!'; exit 1; }
[[ -z "${api}" ]] && { echo >&2 '[ERROR] Gitea API URL not specified!'; exit 1; }
[[ -z "${org}" ]] && { echo >&2 '[ERROR] Repository owner (organization) not specified!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# INITIALIZATION.
# -------------------------------------------------------------------------------------------------------------------- #

init() {
  repo_create
}

# -------------------------------------------------------------------------------------------------------------------- #
# GITHUB: CREATE REPOSITORY.
# -------------------------------------------------------------------------------------------------------------------- #

repo_create() {
  [[ -z "${branch}" ]] && branch='main'
  [[ -n "${auto_init}" ]] && auto_init='true' || auto_init='false'
  [[ -n "${private}" ]] && private='true' || private='false'

  for repo in "${repos[@]}"; do
    echo '' && echo "--- OPEN: '${repo}'"

    ${curl} -X POST \
      -H "Authorization: token ${token}" \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      "${api}/api/v1/orgs/${org}/repos" \
      -d @- << EOF
{
  "auto_init": ${auto_init},
  "default_branch": "${branch}",
  "name": "${repo}",
  "description": "${description}",
  "license": "${license}",
  "private": ${private}
}
EOF

    echo '' && echo "--- DONE: '${repo}'" && echo ''; sleep ${sleep}
  done
}

# -------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------< INIT FUNCTIONS >------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

init "$@"; exit 0
