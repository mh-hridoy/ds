package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"discover.com/controllers"
	"discover.com/deps"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables from .env file
	err := godotenv.Load()
	if err != nil {
		log.Fatalf("Error loading .env file: %v", err)
	}

	// Get the database URL from the environment variable
	databaseURL := os.Getenv("DATABASE_URL")
	if databaseURL == "" {
		log.Fatal("DATABASE_URL is not set")
	}
	// Connect to the database
	conn, err := pgx.Connect(context.Background(), databaseURL)
	if err != nil {
		log.Fatalf("Failed to connect to the database: %v\n", err)
	}
	fmt.Println("Database connected")
	defer func() {
		fmt.Println("Connection closed")
		conn.Close(context.Background())
	}()

	dependencies := deps.Dependencies{
		DB: conn,
	}

	router := gin.Default()

	router.GET("/albums", func(ctx *gin.Context) {
		controllers.GetAllAlbums(ctx, &dependencies)
	})
	router.GET("/albums/:id", func(ctx *gin.Context) {
		controllers.GetSingleAlbum(ctx, &dependencies)
	})
	router.PATCH("/albums/:id", func(ctx *gin.Context) {
		controllers.UpdateAlbum(ctx, &dependencies)
	})
	router.DELETE("/albums/:id", func(ctx *gin.Context) {
		controllers.DeleteAlbum(ctx, &dependencies)
	})
	router.POST("/albums", func(ctx *gin.Context) {
		controllers.PostAlbum(ctx, &dependencies)
	})

	router.Run("localhost:3000")

}
