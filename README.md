## Dependencies

1) **mkdocs**  
Site: https://github.com/mkdocs/mkdocs/releases
```sh
sudo apt-get install mkdocs
```

1) **mkdocs-material**  
Site: https://github.com/squidfunk/mkdocs-material
```sh
pip install mkdocs-material
```

## Run Locally
```sh
mkdocs serve
```

## Deploy Docs Live
```sh
mike deploy --push --update-aliases VERSION_TAG
# Example: mike deploy --push --update-aliases v0.5.10
mike set-default --push latest
```