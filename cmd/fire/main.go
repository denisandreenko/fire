package main

import (
	"fmt"
	"gopkg.in/yaml.v3"
	"io/ioutil"
	"log"
	"os"

	"github.com/denisandreenko/fire/internal/app/fire"
)

func main() {
	config := &fire.Config{}

	appRoot := os.Getenv("APP_ROOT")
	fireEnv := os.Getenv("FIRE_ENV")
	configPath := fmt.Sprintf("%s/configs/%s.yaml", appRoot, fireEnv)

	configFile, err := ioutil.ReadFile(configPath)
	if err != nil {
		log.Fatal(err)
	}

	err = yaml.Unmarshal(configFile, &config)
	if err != nil {
		log.Fatal(err)
	}

	s := fire.New(config)
	if err := s.Start(); err != nil {
		log.Fatal(err)
	}
}