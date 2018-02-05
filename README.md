
# dns-check

Test DNS lookups across different revision of the `dns` library, and interopolates the results with `dig`.

## Usage

There is a single Haskell script you should care about, and is the top-level `DnsCheck.hs`. It's a standalone
Haskell script which can be run simply by doing:

```
chmod +x DnsCheck.hs
./DnsCheck.hs
```

If nothing is passed via the command line, it will use the `dns` library currently in use in Cardano, otherwise
you can pass a `git tag`, like `3.0.1` (the latest and the only supported at the moment).
