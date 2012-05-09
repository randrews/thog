libs=(kb lfov tmx)

for lib in ${libs[@]}; do
    pushd $lib
    make

    if [ ! -r $lib.so ]; then
        echo "Failed to build $lib"
        exit 1
    fi

    cp $lib.so ..
    popd
done
