# Seabass build scripts

The script is intented for automatic building of Seabass code editor for Ubuntu Touch (fetching sources, managing dependencies, code compilation, ...).

* for v0.4.8+ use *master* branch
* for v0.4.7 and before use *before-0.4.7* branch.

Available scripts:
* build-release.sh - build [latest Seabass release](https://github.com/milikhin/seabass/releases/latest)

## Requirements
* Ubuntu 16.04

## How to use
1. Clone this repo into separate directory
2. Run `bash build-release.sh` from this directory
3. [Patch Cordova's manifest.js](https://github.com/milikhin/seabass/blob/master/building.md#31-patch-for-an-unconfined-version) when asked if needed

## State
The script was tested on a few instances of Ubuntu 16.04 and should just work. In case something goes wrong, complete build instructions are also [available](https://github.com/milikhin/seabass/blob/master/building.md) in the main Seabass repo.

