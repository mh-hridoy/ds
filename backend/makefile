migrate:
	@if [ -z "$(name)" ]; then \
		read -p "Enter migration name: " name; \
	fi; \
	migrate create -ext sql -dir db/migrations $$name

run: 
	go run .

dev:
	gow run .

proto:
	protoc --proto_path=../grpc/ --go_out=./grpc --go_opt=paths=source_relative --go-grpc_out=./grpc --go-grpc_opt=paths=source_relative ../grpc/album.proto

.PHONY: migrate run dev proto
