# Swagger-ui-simple

一个简单的小工具，用来方便查看本地 swagger api 文档。

本地编写的 yaml 文件通常不方便查看，所以做了这个小工具。简单集成了 swagger-ui，使用 go 语言编写，鉴于 go 优势将静态文件打包进了一个文件，真正的简单易用。

把编译后的 swagger-ui 复制到环境路径下，就可以在任意目录调用它了。

## 使用方法

以当前目录为根目录

```
./swagger-ui
```

指定文件根目录
```
./swagger-ui docs
```

## 编译

### 安装依赖
```
go get -u github.com/mjibson/esc
```

### 编译运行
```
bash build.sh
```

编译完毕之后，会自动运行程序

## 更新 swagger-ui

执行一下脚本后重新编译即可
```
bash update-swagger-ui.sh
```