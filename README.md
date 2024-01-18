## Dependencies

The following dependencies need to be installed:

- make
- git
- docker


```
sudo apt install npm
sudo npm install speccy -g 
pip install mkdocs
pip install mkdocs-render-swagger-plugin
pip install mkdocs-awesome-pages-plugin
pip install pymdown-extensions
pip install mkdocs-material
```

## Docker

The doumentation can be started with Docker. Changes in the docuemntation will be hot-swapped.

```
make docker
```

## Build API Docs and Specification

The API documentation and specification are getting automatically generated. There are two `make` targets for it.

```
make update-api
```


```
make update-spec
```

For both targets the direktiv main repository will be cloned from `main`. If changes in the specification or API documentation are required
the repository can be cloned `ssh` to be able to push back changes. If the variable `DEV` is set the Makefile will use SSH.

```
make update spec DEV=true
```

## Running

```
make serve
```

## Publishing

```
make publish
```

