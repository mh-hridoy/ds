run: 
	flutter run

proto:
	protoc --proto_path=../grpc/ --dart_out=./lib/grpc --dart_opt=grpc --proto_path=. ../grpc/album.proto

.PHONY: run proto
