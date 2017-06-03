.PHONY: release debug clean generate-version tag

ToolchainLibPath=/Library/Developer/Toolchains/swift-3.1.1-RELEASE.xctoolchain/usr/lib
Flags=-Xswiftc -framework -Xswiftc sourcekitd -Xswiftc -F -Xswiftc $(ToolchainLibPath) -Xlinker -rpath -Xlinker $(ToolchainLibPath)

debug: generate-version generate-sourcekit-map
	swift build -c debug $(Flags)
	swift test -c debug $(Flags)

release: generate-version generate-sourcekit-map
ifeq ($(shell uname -s),Darwin)
	swift build -c release -Xswiftc -static-stdlib $(Flags)
	swift test -c release $(Flags)
else
	swift build -c release $(Flags)
endif

clean:
	swift package clean

generate-version:
	./Scripts/genvers.sh

generate-sourcekit-map:
	./Scripts/genskmap.sh

tag:
	git tag "v$(shell sed 's/^version: \(.*\)/\1/' ./Sources/VersionInfo/VersionInfo.yaml)"
