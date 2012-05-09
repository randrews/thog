rm -f *.so

if [ ! -r tmx.so ]; then
    pushd TmxParser
    g++ *.cpp base64/*.cpp tinyxml/*.cpp -c
    g++ -bundle -undefined dynamic_lookup -o tmx.so *.o -lz
    cp tmx.so ..
    popd
fi

libs=(kb lfov)

for lib in ${libs[@]}; do
    pushd $lib
    make

    if [ ! -r $lib.so ]; then
        echo "Failed to build $lib"
        exit 1
    fi

    mv $lib.so ..
    popd
done
