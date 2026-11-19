#!/usr/bin/env bash
# Builds the site and lays it out for GitHub Pages (root of the kh-pages branch).
#
# Code and assets go into v/<hash>/, named after the build, so a visitor's
# cache can never pair new code with old assets. index.html and the small
# static files stay at the root. The previous build folder is kept so a
# visitor still holding the old index.html (cached up to 10 minutes) loads a
# complete, consistent set; anything older is removed.
set -euo pipefail
cd "$(dirname "$0")/.."

flutter build web --release --base-href /portoflio/

hash=$( (md5 -q build/web/main.dart.js 2>/dev/null || md5sum build/web/main.dart.js) | cut -c1-10)
dir="v/$hash"
prev=$(grep -o 'v/[0-9a-f]\{10\}' index.html 2>/dev/null | head -1 || true)

rm -rf "$dir"
mkdir -p "$dir"
cp build/web/main.dart.js "$dir/"
cp -R build/web/assets "$dir/assets"
sed "s#__BUILD_DIR__#$dir/#g" build/web/flutter_bootstrap.js > "$dir/flutter_bootstrap.js"

sed "s#src=\"flutter_bootstrap.js\"#src=\"$dir/flutter_bootstrap.js\"#" build/web/index.html > index.html
cp -R build/web/favicon.png build/web/icons build/web/manifest.json \
      build/web/og-image.png build/web/version.json .

# Drop build folders older than the previous one.
for d in v/*/; do
  d=${d%/}
  [[ "$d" == "$dir" || "$d" == "$prev" ]] || rm -rf "$d"
done

# Files from the old unversioned layout: keep them for one more deploy so
# cached pages from before the switch still work, then remove them.
if [[ -n "$prev" ]]; then
  rm -rf main.dart.js flutter.js flutter_bootstrap.js flutter_service_worker.js assets
fi
# Never loaded (CanvasKit comes from gstatic), only weighed down the branch.
rm -rf canvaskit

echo "Deployed build $dir (previous: ${prev:-none})"
