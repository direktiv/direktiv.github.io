package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

var nav string

func main() {

	dir := os.Args[1]

	nav = "  - Examples:\n"

	fmt.Printf("building examples from %s\n", dir)
	entries, err := os.ReadDir(dir)
	if err != nil {
		log.Fatal(err)
	}

	outDir := filepath.Join(dir, "out")

	err = os.MkdirAll(outDir, 0777)
	if err != nil {
		log.Fatal(err)
	}

	for _, e := range entries {
		processExample(filepath.Join(dir, e.Name()), outDir)
	}

	fmt.Println(outDir)

	err = os.WriteFile(fmt.Sprintf("%s/nav.out", outDir), []byte(nav), 0777)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("generated examples in %s\n", filepath.Join(outDir, "nav.out"))

}

func processExample(dir, out string) {

	if strings.Contains(dir, ".git") || strings.Contains(dir, "LICENSE") ||
		strings.Contains(dir, "README.md") || strings.Contains(dir, "out") {
		return
	}

	fileName := filepath.Base(dir)

	fmt.Printf("processing example %s\n", fileName)

	rm, err := os.ReadFile(filepath.Join(dir, "README.md"))
	if err != nil {
		fmt.Printf("no readme for %s\n", dir)
		return
	}

	base := string(rm)

	title := strings.Split(base, "\n")[0]
	title = strings.Replace(title, "# ", "", 1)
	fmt.Printf("title: %s\n", title)

	base2 := strings.Split(base, "\n")
	base = strings.Join(base2[1:], "\n")

	base = fmt.Sprintf("# %s \n [%s on Github](https://github.com/direktiv/direktiv-examples/tree/main/%s)\n", title, title, fileName) + base

	// find workflow links and replace them
	r, err := regexp.Compile("\\[([a-zA-Z0-9\\s]*)\\]\\((?P<Day>[0-9a-zA-Z\\-]*.yaml)\\)")
	if err != nil {
		panic(err)
	}
	sm := r.FindAllStringSubmatch(base, -1)

	// iterate through linked workflows
	for a := range sm {
		// this explodes if the links are broken
		s := sm[a][2]

		wf, err := os.ReadFile(filepath.Join(dir, s))
		if err != nil {
			log.Fatalf("can not read workflow %s in %s", s, dir)
		}

		replace := fmt.Sprintf(`
%syaml title="%s"
%s
%s
`, "```", sm[a][1], string(wf), "```")

		base = strings.Replace(base, sm[a][0], replace, 1)
	}

	err = os.WriteFile(filepath.Join(out, fmt.Sprintf("%s.md", fileName)), []byte(base), 0777)
	if err != nil {
		log.Fatalf("can not write doc %s: %s", fileName, err)
	}

	nav = nav + fmt.Sprintf("    - %s: examples/%s\n", title, fmt.Sprintf("%s.md", fileName))

}
