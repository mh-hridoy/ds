package controllers

import (
	"fmt"
	"net/http"
	"strconv"

	utils "discover.com/db"
	"discover.com/structs"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

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
