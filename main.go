package main

import (
	"log"
	"os/exec"
)

func main() {
	cmd := exec.Command("nuclei", "-t", "/opt/test/nuclei-templates/cves/2020", "-u", "https://10.101.12.1/")

	out, err := cmd.CombinedOutput()
	if err != nil {
		log.Println(err)
	}

	st := string(out)
	log.Println(st)
}
