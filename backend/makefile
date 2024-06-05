migrate:
	@if [ -z "$(name)" ]; then \
		read -p "Enter migration name: " name; \
	fi; \
	migrate create -ext sql -dir db/migrations $$name

run: 
	go run .

dev:
	gow run .

.PHONY: migrate run dev
