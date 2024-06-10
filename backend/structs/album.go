package album

import (
	"fmt"
	"reflect"
)

type Album struct {
	ID     int     `field:"id" json:"id"`
	Artist string  `field:"artist" json:"artist" binding:"required"`
	Title  string  `field:"title" json:"title" binding:"required"`
	Price  float64 `field:"price" json:"price" binding:"required"`
}

func (a Album) AddNew(albums []Album) {
	albums = append(albums, a)
}

func (a *Album) Update(updates map[string]interface{}) {
	t := reflect.TypeOf(a).Elem()
	v := reflect.ValueOf(a).Elem()
	// the idea here is to update the filed by checking the key. usually it's uppercase in the struct but we're most likely sending a payload of json with lowercase key's. Steps are below:

	// take all the fields
	var albumTags = make(map[string]reflect.Value)
	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		fieldtag := field.Tag.Get("json")
		albumTags[fieldtag] = v.FieldByName(field.Name)
	}

	// now map the tags (key is the string key, and val represent value of that key)
	for key, val := range updates {
		if fieldValue, exist := albumTags[key]; exist && key != "id" {
			if fieldValue.CanSet() {
				fieldType := fieldValue.Type()
				updateVal := reflect.ValueOf(val)

				if updateVal.Type().ConvertibleTo(fieldType) {
					fieldValue.Set(updateVal.Convert(fieldType))
				}

			}
		} else {
			fmt.Println("Doesn't exist", key)

		}
	}
}
