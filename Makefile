.PHONY: init install test build serve clean pack deploy ship

include .env
export $(shell sed 's/=.*//' .env)

APP_NAME=$(shell basename $(CURDIR))
TAG?=$(shell git rev-list HEAD --max-count=1 --abbrev-commit)



export TAG
export APP_NAME

init:
	

install: init
	go get .

test: init
	go test ./...

build: install
	rm -rf ./dist
	mkdir dist
	GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=$(TAG)" -o ./dist/$(APP_NAME) .
	cp ./static ./dist/ -r
serve: build
	./dist/$(APP_NAME)

clean:
	rm ./$(APP_NAME)

pack:
	docker build -t gattal/$(APP_NAME):$(TAG) .
	
upload:
	docker push gattal/$(APP_NAME):$(TAG)	

deploy:	
	envsubst < k8s/deployment.yaml | kubectl apply -f -
	envsubst < k8s/service.yaml | kubectl apply -f -
ship: init test pack upload deploy clean