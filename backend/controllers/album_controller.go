package album

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"reflect"
	"strconv"
	"strings"

	pb "discover.com/grpc"

	utils "discover.com/db"
	structs "discover.com/structs"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

type ValidationError map[string]string

func (v ValidationError) Error() string {
	var errMsg string
	for field, err := range v {
		errMsg += field + ": " + err + "; "
	}
	return "validation error: " + errMsg
}

type AlbumServer struct {
	pb.UnsafeAlbumServicesServer
	*utils.DBConnect
}

type AlbumStruct struct {
	Id     int32   `json:"id"`
	Title  string  `json:"title"`
	Artist string  `json:"artist"`
	Price  float64 `json:"price"` // Use float64 to handle numeric(6, 2) in DB
}
type ErrorResponse struct {
	Errors map[string]string `json:"errors"`
}

func FormatValidationError(err error) ErrorResponse {
	errors := make(map[string]string)
	for _, e := range err.(validator.ValidationErrors) {
		errors[e.Field()] = fmt.Sprintf("%v is required", e.Field())
	}
	return ErrorResponse{Errors: errors}
}

func GetAllAlbums(c *gin.Context, d *utils.DBConnect) {
	var allAlbums []structs.Album
	rows, e := d.DB.Query(c.Request.Context(), "SELECT * from album")
	if e != nil {
		c.IndentedJSON(http.StatusBadRequest, e.Error())
		return
	}

	for rows.Next() {
		var album structs.Album

		err := rows.Scan(&album.ID, &album.Artist, &album.Title, &album.Price)
		if err != nil {
			c.IndentedJSON(http.StatusBadRequest, err)
			return
		}

		allAlbums = append(allAlbums, album)
	}

	c.IndentedJSON(http.StatusOK, allAlbums)

}

func GetSingleAlbum(c *gin.Context, d *utils.DBConnect) {
	id := c.Param("id")
	intId, err := strconv.Atoi(id)

	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "Not a valid albumID"})
	}

	var album structs.Album
	row := d.DB.QueryRow(c.Request.Context(), "Select * FROM album WHERE id = $1", intId)

	if err := row.Scan(&album.ID, &album.Artist, &album.Title, &album.Price); err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return
	}

	c.IndentedJSON(http.StatusOK, album)
}

func UpdateAlbum(c *gin.Context, d *utils.DBConnect) {
	paramId := c.Param("id")
	id, err := strconv.Atoi(paramId)

	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "Not a valid albumID"})
		return
	}

	var partialAlbum = make(map[string]interface{})
	e := c.BindJSON(&partialAlbum)
	if e != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "Not valid payload."})
		return
	}

	query := "UPDATE album SET "
	values := []interface{}{}
	i := 1

	for key, val := range partialAlbum {
		if i > 1 {
			query += ","
		}

		query += fmt.Sprintf("%s=$%d", key, i)
		values = append(values, val)
		i++
	}

	query += fmt.Sprintf(" WHERE id=$%d RETURNING id, artist, title, price", i)
	values = append(values, id)
	var updatedAlbum structs.Album
	row := d.DB.QueryRow(c.Request.Context(), query, values...)

	er := row.Scan(&updatedAlbum.ID, &updatedAlbum.Artist, &updatedAlbum.Title, &updatedAlbum.Price)
	if er != nil {
		c.IndentedJSON(http.StatusBadRequest, er.Error())
		return
	}
	c.IndentedJSON(http.StatusOK, updatedAlbum)

}

func DeleteAlbum(c *gin.Context, d *utils.DBConnect) {
	paramId := c.Param("id")
	id, err := strconv.Atoi(paramId)

	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "Not a valid albumID"})
		return
	}

	result, er := d.DB.Exec(c.Request.Context(), "DELETE  from album  WHERE id=$1", id)

	if er != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": er.Error()})
		return
	}

	affected := result.RowsAffected()

	if affected == 0 {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"message": "Album not found!"})
	}

	c.IndentedJSON(http.StatusOK, gin.H{"message": "Album deleted successfully!"})

}

func PostAlbum(c *gin.Context, d *utils.DBConnect) {
	var newAlbum structs.Album

	err := c.ShouldBindJSON(&newAlbum)
	if err != nil {
		if validationErrors, ok := err.(validator.ValidationErrors); ok {
			c.JSON(http.StatusBadRequest, FormatValidationError(validationErrors))
			return
		}
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var createdAlbum structs.Album
	query := "INSERT INTO album (artist, title, price) VALUES ($1, $2, $3) RETURNING id, artist, title, price"
	row := d.DB.QueryRow(c.Request.Context(), query, newAlbum.Artist, newAlbum.Title, newAlbum.Price)

	e := row.Scan(&createdAlbum.ID, &createdAlbum.Artist, &createdAlbum.Title, &createdAlbum.Price)
	if e != nil {
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": e.Error()})
		return
	}

	c.IndentedJSON(http.StatusOK, createdAlbum)
}

func (s *AlbumServer) GetAllAlbum(ctx context.Context, req *pb.AlbumEmptyRequest) (*pb.GetAllAlbumResponse, error) {
	var albums []*AlbumStruct

	rows, err := s.DB.Query(ctx, "SELECT id, title, artist, price FROM album")
	if err != nil {
		log.Printf("error: %v", err)
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var album AlbumStruct
		err := rows.Scan(&album.Id, &album.Title, &album.Artist, &album.Price)
		if err != nil {
			log.Printf("error: %v", err)
			return nil, fmt.Errorf("error scanning row: %v", err)
		}
		albums = append(albums, &album)
	}

	if err := rows.Err(); err != nil {
		log.Printf("error: %v", err)

		return nil, err
	}

	var pbAlbums []*pb.Album
	for _, album := range albums {
		pbAlbum := &pb.Album{
			Id:     album.Id,
			Title:  album.Title,
			Artist: album.Artist,
			Price:  float32(album.Price), // Convert float64 to float32 for protobuf
		}
		pbAlbums = append(pbAlbums, pbAlbum)
	}
	return &pb.GetAllAlbumResponse{Albums: pbAlbums}, nil
}

func (s *AlbumServer) GetSingleAlbumWithId(ctx context.Context, req *pb.AlbumWithIdRequest) (*pb.Album, error) {
	id := req.Id

	var album pb.Album
	row := s.DB.QueryRow(ctx, "Select * FROM album WHERE id = $1", id)

	if err := row.Scan(&album.Id, &album.Artist, &album.Title, &album.Price); err != nil {
		log.Printf("error: %v", err)

		return nil, err
	}

	return &album, nil

}

func (s *AlbumServer) PostSingleAlbum(ctx context.Context, req *pb.Album) (*pb.Album, error) {
	var validateData = make(map[string]interface{})
	var errors = map[string]string{}
	validateData["artist"] = req.Artist
	validateData["title"] = req.Title
	validateData["price"] = req.Price

	// Validate the input data
	for key, val := range validateData {
		if val == "" || val == nil {
			errors[key] = fmt.Sprintf("%s is required", key)
		}
	}

	// Check if there are any validation errors
	if len(errors) > 0 {
		log.Printf("validation errors: %v", errors)
		return nil, ValidationError(errors)
	}

	var newAlbum pb.Album
	query := "INSERT INTO album (artist, title, price) VALUES ($1, $2, $3) RETURNING id, artist, title, price"
	row := s.DB.QueryRow(ctx, query, req.Artist, req.Title, req.Price)

	// Scan the result into the newAlbum struct
	e := row.Scan(&newAlbum.Id, &newAlbum.Artist, &newAlbum.Title, &newAlbum.Price)
	if e != nil {
		log.Printf("database error: %v", e)
		return nil, e
	}

	return &newAlbum, nil
}

func (s *AlbumServer) UpdateSingleAlbum(ctx context.Context, req *pb.Album) (*pb.Album, error) {
	id := req.Id
	var partialAlbum = make(map[string]interface{})

	v := reflect.ValueOf(req).Elem() //values of the object
	t := reflect.TypeOf(req).Elem()  //types of object

	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		tag := strings.Split(field.Tag.Get("json"), ",")[0]
		if tag != "id" && tag != "" {
			fieldValue := v.FieldByName(field.Name).Interface()
			if !reflect.DeepEqual(fieldValue, reflect.Zero(field.Type).Interface()) {
				partialAlbum[tag] = fieldValue
			}
		}
	}

	query := "UPDATE album SET "
	values := []interface{}{}
	i := 1
	for key, val := range partialAlbum {
		if i > 1 {
			query += ","
		}

		query += fmt.Sprintf("%s=$%d", key, i)
		values = append(values, val)
		i++
	}

	query += fmt.Sprintf(" WHERE id=$%d RETURNING id, artist, title, price", i)
	values = append(values, id)
	var updatedAlbum pb.Album
	row := s.DB.QueryRow(ctx, query, values...)

	er := row.Scan(&updatedAlbum.Id, &updatedAlbum.Artist, &updatedAlbum.Title, &updatedAlbum.Price)
	if er != nil {
		log.Printf("error: %v", er)

		return nil, er
	}
	return &updatedAlbum, nil
}

func (s *AlbumServer) DeleteSingleAlbumWithId(ctx context.Context, req *pb.AlbumWithIdRequest) (*pb.AlbumDeleteInfo, error) {
	id := req.Id

	result, er := s.DB.Exec(ctx, "DELETE  from album  WHERE id=$1", id)

	if er != nil {
		log.Printf("error: %v", er)

		return nil, er
	}

	affected := result.RowsAffected()

	if affected == 0 {
		return nil, ValidationError(map[string]string{"message": "Album does not exist!"})
	}
	return &pb.AlbumDeleteInfo{Message: "Album deleted successfully!"}, nil

}
