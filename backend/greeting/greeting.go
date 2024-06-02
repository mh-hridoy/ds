package greeting

import (
	"errors"
	"fmt"
	"math/rand"
)

func Greeting(name string) (string, error) {
	if name == "" {
		return "", errors.New("name was not give")
	}
	return fmt.Sprintf(randomFormat(), name), nil
}

func Greetings(names []string) (map[string]string, error) {

	greetings := make(map[string]string)

	for _, name := range names {
		message, err := Greeting(name)

		if err != nil {
			return nil, err
		}
		greetings[name] = message

	}

	return greetings, nil

}

func randomFormat() string {
	formats := []string{
		"Hi %v. I'm from the greetings",
		"youu %v. Here from the greeting",
		"Pheww %v. Coming from greeting",
	}

	return formats[rand.Intn(len(formats))]
}
