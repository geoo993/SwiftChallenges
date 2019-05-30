
## Bootstrap

* run `carthage bootstrap --cache-builds --platform ios` in Terminal

## Sourcery

* ./bin/Sourcery/bin/sourcery --watch --config ./StoryView/.sourcery.yml

## Build Times
* run `defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES` in Terminal

## Build Optimization
* To recursively find the latest modified files in a directory:
>  `find . -type f -name "*.swift" | sed 's/.*/"&"/' | xargs ls -tl | awk '{ print $6," ", $7," ", $8," ", $9 }' | head -10`
