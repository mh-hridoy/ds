package utils

import (
	"fmt"
	"log"
	"os"
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
	// get the previous version
	prev, _, pe := m.Version()
	if pe != nil && pe != migrate.ErrNilVersion {
		fmt.Println("There's no previous migration version available!", pe.Error())
	}

	err := m.Up()

	if err != nil && err != migrate.ErrNoChange {
		fmt.Println("Error migrating db", err.Error())
		// Rollback to prev version
		err := m.Force(int(prev))
		// err := m.Steps(1)
		if err != nil {
			fmt.Println("Error rolling back migration:", err.Error())
			return
		}
		fmt.Println("Rolled back to previous migration version:", prev)
		log.Fatalln("Please fix the migration file before proceed!")
		os.Exit(1)
		return
	}

	if err == migrate.ErrNoChange {
		fmt.Println("No changes detected in migrations dir!")
		return
	}

	if err == nil {
		fmt.Println("Migration was successful!")
	}

}
