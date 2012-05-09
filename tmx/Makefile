default: tmx.so

tmx.so:
	g++ *.cpp base64/*.cpp tinyxml/*.cpp -c
	g++ -bundle -undefined dynamic_lookup -o tmx.so *.o -lz

clean:
	rm -f *~
	rm -f *.o
	rm -f tmx.so
