
## Make sure command-line xcode-select is pointing to the correct compiler
* `xcode-select -p` to print the current compiler
# OR
* `xcode-select -s` to select the current compiler

## Bootstrap

* run `carthage bootstrap --no-use-binaries --cache-builds --platform ios` in Terminal

# OR 

## Update

* run `carthage update [RepositoryName] --no-use-binaries --cache-builds --platform ios` in Terminal

# OR To Ignore warnings issued by the find command)

* run `carthage checkout`
# OR
* run `carthage update --no-build --new-resolver --verbose`
# THEN
* run `carthage build --platform iOS --cache-builds`

## Sourcery

* ./bin/Sourcery/bin/sourcery --watch --config ./DemoProject/.sourcery.yml

## Build Times
* run `defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES` in Terminal

## Build Optimization
* To recursively find the latest modified files in a directory:
>  `find . -type f -name "*.swift" | sed 's/.*/"&"/' | xargs ls -tl | awk '{ print $6," ", $7," ", $8," ", $9 }' | head -10`
