package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"
	"os"

	controller "discover.com/controllers"
	utils "discover.com/db"
	pb "discover.com/grpc"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
	"google.golang.org/grpc"
)

var (
	port = flag.Int("port", 50051, "port for the server")
)

func main() {
	flag.Parse()
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

	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", *port))

	if err != nil {
		log.Fatalf("Failed to listen %v", err)
	}

	// Create a pool and connect to db
	conn, err := pgxpool.New(context.Background(), databaseURL)
	if err != nil {
		log.Fatalf("Failed to connect to the database: %v\n", err)
	}
	fmt.Println("Database connected")

	defer func() {
		fmt.Println("Db disconnected!")
		conn.Close()
	}()
	dependencies := utils.DBConnect{
		DB: conn,
	}
	s := grpc.NewServer()
	pb.RegisterAlbumServicesServer(s, &controller.AlbumServer{
		DBConnect: &dependencies,
	})
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}

	// // run migration
	// utils.RunMigrations(conn)

	// router := gin.Default()

	// router.GET("/albums", func(ctx *gin.Context) {
	// 	controllers.GetAllAlbums(ctx, &dependencies)
	// })
	// router.GET("/albums/:id", func(ctx *gin.Context) {
	// 	controllers.GetSingleAlbum(ctx, &dependencies)
	// })
	// router.PATCH("/albums/:id", func(ctx *gin.Context) {
	// 	controllers.UpdateAlbum(ctx, &dependencies)
	// })
	// router.DELETE("/albums/:id", func(ctx *gin.Context) {
	// 	controllers.DeleteAlbum(ctx, &dependencies)
	// })
	// router.POST("/albums", func(ctx *gin.Context) {
	// 	controllers.PostAlbum(ctx, &dependencies)
	// })
	// srv := http.Server{
	// 	Addr:    ":3000",
	// 	Handler: router,
	// }

	// go func() {
	// 	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
	// 		log.Fatalln("Server did not start", err.Error())
	// 	}
	// }()

	// quit := make(chan os.Signal, 1)
	// signal.Notify(quit, os.Interrupt, syscall.SIGTERM)
	// <-quit

	// fmt.Println("Shuttign down the server")
	// c, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	// defer func() {
	// 	cancel()
	// 	fmt.Println("Server closed!")
	// }()
	// srv.Shutdown(c)

}
