# secrets

## sops-nix

- <https://github.com/tedski999/dots/blob/ab2b24dd76920a449ea6e5527c9aaefe89359454/README.md>

### Supported encryption methods

The [sops-nix](https://github.com/mic92/sops-nix) module supports two basic ways of encryption, GPG and `age`.

GPG is based on [GnuPG](https://gnupg.org/) and encrypts with GPG private keys.

The [`ssh-to-pgp`](https://github.com/mic92/ssh-to-pgp) tool can be used to derive a GPG key from a SSH (host) key in RSA format.

The other method is `age` which is based on [`age`](https://github.com/filosottile/age).

The tool ([`ssh-to-age`](https://github.com/mic92/ssh-to-age)) can convert SSH host or user keys in Ed25519
format to `age` keys.

### Flakes

- Use experimental nix flakes support.

``` nix
{
  inputs.sops-nix.url = "github:mic92/sops-nix";
  # optional, not necessary for the module
  # inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  outputs = { self, nixpkgs, sops-nix }: {
      # ...
      modules = [
        # ...
        sops-nix.nixosModules.sops
      ];
    };
  };
}
```

- The following command starts the configured editor defined with `$EDITOR` environment variable.

```shell
nix-shell --packages sops --run "sops secrets/example.yaml"
nix-shell --packages sops --run "sops secrets/hosts/tp95v9lwwl.yaml"
nix-shell --packages sops --run "sops secrets/users/leonardlee.yaml"
```

- The unencryped example will be displayed for editing.

```yaml
hello: Welcome to SOPS! Edit this file as you please!
example_key: example_value
# Example comment
example_array:
    - example_value1
    - example_value2
example_number: 1234.56789
example_booleans:
    - true
    - false
```

- The example encrypted result after saving this file.

```yaml
hello: ENC[AES256_GCM,data:HZAGb62sprHONIa3sfyTlsN8/Z++trOCjwoDPp9Uao+cRlnnoZNXsnzbTaHRCg==,iv:bjIoXYXFge28Dlz833q8grw+QhNXEh91Un5pRZUMWGI=,tag:J+VBTUTTeQGJ15D0c0ir5w==,type:str]
example_key: ENC[AES256_GCM,data:iV0Hgu6pdj7AU7OBRg==,iv:Caj/Kjo04209U093Exjb1+OgdWOExA1fclRZVtTFmug=,tag:Ftc6hgerlOI/YPzqfFSCyw==,type:str]
#ENC[AES256_GCM,data:D4qMpbdiuz2F/GC3WW1zBQ==,iv:y50dgudEmqHHdCx3uc/HF91JdQpUD+gSxV4ZeLBR/ng=,tag:RXkvgpcYKAwfh5+a9Qe+mA==,type:comment]
example_array:
    - ENC[AES256_GCM,data:qzmn0wqYjxyy51ShT0g=,iv:DcBm++oY0wHH/aW04xjoljsNyk6OfCwizpiWHRiBLGA=,tag:/WrxQfpowE07pn1QRb7zAQ==,type:str]
    - ENC[AES256_GCM,data:k1wnZBkrDyrKsS6sWdU=,iv:lL2iHJuqjH+9i5FauWS4iZ8I0/bt+wzmHsqJdbsARc8=,tag:71IX2sf98VvqFpfwfu0NGg==,type:str]
example_number: ENC[AES256_GCM,data:WkiD+XKYTMODtw==,iv:nPK8FjCoKkMe7EkWYDG5+MtdKzYo5awJEOTqDPhAR3Y=,tag:Ndli9P8szWSxPcs0tm0Mqg==,type:float]
example_booleans:
    - ENC[AES256_GCM,data:59LHHw==,iv:pFebQXG1iukH/vRTlT6ZzgaQtlFOPUdcdKe5nLvhlCQ=,tag:dsUIFIAU68xeSM/XOvdcGw==,type:bool]
    - ENC[AES256_GCM,data:urIpmzc=,iv:AaSCTOekk8FM/QFGW6eOebtaXopO+2u29qBWU5+FNEU=,tag:9wte3mYnLnGzWu/ERxgfJQ==,type:bool]
```
