package deps

import "github.com/jackc/pgx/v5"

type Dependencies struct {
	DB *pgx.Conn
}
