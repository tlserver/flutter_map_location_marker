flutter create --no-pub --overwrite . `
               --project-name "flutter_map_location_marker" `
               --description "A flutter map plugin for displaying device current location." `
               --org "net.tlserver6y" `
               --template "package"

flutter create --no-pub --overwrite --empty example `
               --project-name "flutter_map_location_marker_example" `
               --description "Example of FlutterMapLocationMarkerPlugin" `
               --org "net.tlserver6y"

git checkout HEAD -- ".\.gitignore"
git checkout HEAD -- ".\CHANGELOG.md"
git clean -fd        ".\example\README.md"
git checkout HEAD -- ".\example\lib\*"
git checkout HEAD -- ".\flutter_map_location_marker.iml"
git checkout HEAD -- ".\LICENSE"
git checkout HEAD -- ".\lib\*"
git checkout HEAD -- ".\README.md"
git clean -fd        ".\test\"
