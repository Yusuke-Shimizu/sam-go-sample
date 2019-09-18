.PHONY: deps clean build

deps:
	go get -u ./...

test:
	go test -v ./hello-world/
	
clean: 
	rm -rf ./hello-world/hello-world
	
build:
	GOOS=linux GOARCH=amd64 go build -o hello-world/hello-world ./hello-world

deploy:
	sam package --output-template template.yaml --s3-bucket $(SAM_BUCKET)
	sam deploy --template-file template.yaml --region ap-northeast-1 --capabilities CAPABILITY_IAM --stack-name aws-sam-getting-started
	
show-output:
	aws cloudformation describe-stacks --stack-name aws-sam-getting-started --query "Stacks[*].Outputs[?OutputKey=='HelloWorldAPI'].OutputValue" --output text
	
clean-deployment:
	aws cloudformation delete-stack --stack-name aws-sam-getting-started
