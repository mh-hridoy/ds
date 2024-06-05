package utils

import (
	"fmt"
	"path/filepath"

	"github.com/golang-migrate/migrate/v4"
	pg "github.com/golang-migrate/migrate/v4/database/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/jackc/pgx/v5/stdlib"
)

type DBConnect struct {
	DB *pgxpool.Pool
}

func RunMigrations(pool *pgxpool.Pool) {
	db := stdlib.OpenDBFromPool(pool)

	d, e := pg.WithInstance(db, &pg.Config{})
	defer func() {
		d.Close()
		e := db.Close()
		if e == nil {
			fmt.Println("Closed migration pool")
		}
	}()

	if e != nil {
		d.Close()
		fmt.Println("Error creating driver", e.Error())
		return
	}
	path, fr := filepath.Abs("./db/migrations")
	if fr != nil {
		fmt.Println("Couldn't find migration dir", fr.Error())
		return
	}
	migrationDir := fmt.Sprintf("file://%s", path)
	m, er := migrate.NewWithDatabaseInstance(migrationDir, "recordings", d)

	if er != nil {
		fmt.Println("Error creating migration instance", er.Error())
		return
	}
	err := m.Up()

	if err != nil && err != migrate.ErrNoChange {
		fmt.Println("Error migrating db", err.Error())
	}

	if err == migrate.ErrNoChange {
		fmt.Println("No changes detected in migrations dir!")
	}

	if err == nil {
		fmt.Println("Migration was successful!")
	}

}
