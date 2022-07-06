# Registry-Harvester

Harvest Blobs from Docker Registry V2.

Generated with [Bashly](https://github.com/DannyBen/bashly).

## Requirements

- curl
- jq

## Usage

```bash
./regharvest --help
regharvest - Harvest Blobs from Docker Registry V2

Usage:
  regharvest SOURCE OUTPUT [options]
  regharvest --help | -h
  regharvest --version | -v

Options:
  --help, -h
    Show this help

  --version, -v
    Show version number

  --user, -u USER
    Username to use for logging in

  --pass, -p PASSWORD
    Password to use for logging in

  --insecure, -k
    Allow insecure server connections when using SSL

  --debug, -d
    Print Debug output

Arguments:
  SOURCE
    URL (or IP) to download from

  OUTPUT
    Output folder

Examples:
  regharvest example.com output-folder
  regharvest example.com output-folder --user username --pass password
  regharvest example.com output-folder --insecure
```
