## Dependencies


sudo npm install -g speccy



1. **mkdocs**  
   Site: https://github.com/mkdocs/mkdocs/releases

```sh
sudo apt-get install mkdocs
```

2. **mkdocs-material**  
   Site: https://github.com/squidfunk/mkdocs-material

If you are on a Mac, please follow [these instructions](https://suedbroecker.net/2021/01/25/how-to-install-mkdocs-on-mac-and-setup-the-integration-to-github-pages/).

```sh
pip install mkdocs-material
```

## Run Locally

```sh
mkdocs serve
```

## Test Broken Links

```sh
make test-links
```

## Deploy Docs Live

```sh
mike deploy --push --update-aliases VERSION_TAG
# Example: mike deploy --push --update-aliases v0.5.10
mike set-default --push latest
```
