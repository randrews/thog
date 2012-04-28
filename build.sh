rm -f *.so

if [ ! -r tmx.so ]; then
    pushd TmxParser
    g++ *.cpp base64/*.cpp tinyxml/*.cpp -c
    g++ -bundle -undefined dynamic_lookup -o tmx.so *.o -lz
    cp tmx.so ..
    popd
fi

if [ ! -r kb.so ]; then
    gcc -shared -o kb.so -undefined dynamic_lookup kb.c -lncurses
fi