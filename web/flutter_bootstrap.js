{{flutter_js}}
{{flutter_build_config}}

// tool/deploy.sh replaces __BUILD_DIR__ with this build's own folder
// (for example "v/1a2b3c4d5e/"). Code and assets then live at URLs that
// change with every deploy, so a browser cache can never mix two versions.
// Left untouched (local `flutter run`), everything loads from the root.
const buildDir = "__BUILD_DIR__".startsWith("__") ? null : "__BUILD_DIR__";

_flutter.loader.load({
  config: buildDir ? { entrypointBaseUrl: buildDir, assetBase: buildDir } : {},
});
