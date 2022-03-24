#!/bin/bash

mike deploy --update-aliases $TAG latest  
mike set-default latest
mike serve -a :8000