# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: vantum android ios vantum-cross swarm evm all test clean
.PHONY: vantum-linux vantum-linux-386 vantum-linux-amd64 vantum-linux-mips64 vantum-linux-mips64le
.PHONY: vantum-linux-arm vantum-linux-arm-5 vantum-linux-arm-6 vantum-linux-arm-7 vantum-linux-arm64
.PHONY: vantum-darwin vantum-darwin-386 vantum-darwin-amd64
.PHONY: vantum-windows vantum-windows-386 vantum-windows-amd64
##export GOPATH=$(pwd)
GOBIN = $(shell pwd)/build/bin
GO ?= latest

vantum:
	build/env.sh go run build/ci.go install ./cmd/vantum
	@echo "Done building."
	@echo "Run \"$(GOBIN)/vantum\" to launch vantum."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/vantum.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/vantum.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

vantum-cross: vantum-linux vantum-darwin vantum-windows vantum-android vantum-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/vantum-*

vantum-linux: vantum-linux-386 vantum-linux-amd64 vantum-linux-arm vantum-linux-mips64 vantum-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-*

vantum-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/vantum
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep 386

vantum-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/vantum
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep amd64

vantum-linux-arm: vantum-linux-arm-5 vantum-linux-arm-6 vantum-linux-arm-7 vantum-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep arm

vantum-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/vantum
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep arm-5

vantum-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/vantum
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep arm-6

vantum-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/vantum
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep arm-7

vantum-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/vantum
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep arm64

vantum-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/vantum
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep mips

vantum-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/vantum
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep mipsle

vantum-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/vantum
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep mips64

vantum-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/vantum
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/vantum-linux-* | grep mips64le

vantum-darwin: vantum-darwin-386 vantum-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/vantum-darwin-*

vantum-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/vantum
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-darwin-* | grep 386

vantum-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/vantum
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-darwin-* | grep amd64

vantum-windows: vantum-windows-386 vantum-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/vantum-windows-*

vantum-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/vantum
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-windows-* | grep 386

vantum-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/vantum
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/vantum-windows-* | grep amd64
