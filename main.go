package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"path"
)

//go:generate esc -o assets.go assets

// 文档的根目录
var docPath string

func handerGetFile(w http.ResponseWriter, r *http.Request) {
	// 获取程序运行路径
	pwd, _ := os.Getwd()
	// r.URL.Path（含最前面的 / )
	// /index.html 和 / 都直接访问 index.html
	if r.URL.Path == "/index.html" || r.URL.Path == "/" {
		fileData, _ := FSByte(false, "/assets/index.html")
		w.Write(fileData)
		// 其他路径都读取本地文件
	} else {
		var des string        // 目标路径
		var pathPrefix string // 路径前缀
		if docPath != "" {
			isAbs := path.IsAbs(docPath)
			if isAbs {
				pathPrefix = docPath
			} else {
				pathPrefix = path.Join(pwd, docPath)
			}
		} else {
			pathPrefix = pwd
		}

		des = path.Join(pathPrefix, r.URL.Path[1:len(r.URL.Path)])

		// 判断文件是否存在
		_, err := os.Stat(des)
		if err != nil {
			log.Println("File Not Exit", des)
			http.NotFoundHandler().ServeHTTP(w, r)
		} else {
			http.ServeFile(w, r, des)
		}
	}
}

func printHelp() {
	fmt.Printf("Usage of Swagger-ui-simple: \n\n")
	fmt.Printf("  swagger-ui docPath \n\n")
	fmt.Printf("     - docPath \n")
	fmt.Printf("          the directory of your yaml/json files, default (current directory) \n")
	fmt.Printf("     - h/help \n")
	fmt.Printf("          help info \n")
}

func main() {
	if len(os.Args) > 1 && len(os.Args) < 3 {
		if os.Args[1] == "-h" || os.Args[1] == "--help" {
			printHelp()
			os.Exit(1)

		} else {
			docPath = os.Args[1]
		}
	} else if len(os.Args) >= 3 {
		printHelp()
		os.Exit(1)
	}

	fmt.Printf("Running on http://localhost:8080 \n")
	http.HandleFunc("/", handerGetFile)
	// 静态文件路径
	http.Handle("/assets/", http.FileServer(FS(false)))
	http.ListenAndServe(":8080", nil)
}
