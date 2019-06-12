#!/usr/bin/env sh

get_latest_release() {
  curl --silent "https://api.github.com/repos/yrutschle/sslh/tags" |
    grep -m1 '"name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}

git clone --recurse-submodules docker-sslh docker-sslh_updated
cd docker-sslh_updated/src
export SUBMODULE_PREV_REF=$(git rev-parse HEAD)
git checkout $(get_latest_release)
export SUBMODULE_REF=$(git rev-parse HEAD)
cd ..
git diff-index --quiet HEAD -- && echo "No update required" && exit 0
git add src
read -r -d '' COMMIT_MESSAGE <<EOM
[CI] Updated src

From: ${SUBMODULE_PREV_REF}
To: ${SUBMODULE_REF}
[ci-skip]
EOM
git commit -m "${COMMIT_MESSAGE}"
