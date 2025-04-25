#!/usr/bin/env bash

set -e
cd $(dirname $0)
CMD=$1

# Revision of the data sources
REV=b99e2eed84917d13ccb28a1a7090703d4eda76d1
shift

case "$CMD" in
    download-all)
        rm -rf ./sources/
        git clone https://github.com/mspm0-rs/mspm0-data-sources ./sources/ --recursive --shallow-submodules
        cd ./sources/
        git checkout $REV
    ;;
    install-chiptool)
        cargo install --git https://github.com/embassy-rs/chiptool
    ;;
    extract-all)
        peri=$1
        trans=$2
        shift
        echo $@

        if [ ! -z "$trans" ]; then
          trans="--transform $trans"
          echo $trans
        fi

        rm -rf tmp/$peri
        mkdir -p tmp/$peri

        for f in $(ls sources/svd); do
          if [[ $f == MSPM0*.svd ]]; then
            f=${f#"MSPM0"}
            f=${f%".svd"}
            echo -n processing $f ...
            if chiptool extract-peripheral --svd sources/svd/MSPM0$f.svd $trans --peripheral $peri >tmp/$peri/$f.yaml 2>tmp/$peri/$f.err; then
              rm tmp/$peri/$f.err
              echo OK
            else
              if grep -q 'peripheral not found' tmp/$peri/$f.err; then
                echo No Peripheral
              else
                echo OTHER FAILURE
              fi
              rm tmp/$peri/$f.yaml
            fi
          fi
        done
    ;;
    gen)
        rm -rf build/data
        cargo run --release --bin mspm0-data-gen
    ;;
    build-metapac)
        rm -rf build/mspm0-metapac
        cargo run --release --bin mspm0-metapac-gen
    ;;
    ci)
        ./d download-all
        ./d gen
        ./d build-metapac
    ;;
    check)
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0c110x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0g110x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0g150x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0g151x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0g310x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0g350x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0g351x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0l110x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0l122x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0l130x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0l134x
        cargo build --release --manifest-path build/mspm0-metapac/Cargo.toml --features pac,metadata,mspm0l222x
    ;;
    *)
        echo "unknown command"
    ;;
esac
