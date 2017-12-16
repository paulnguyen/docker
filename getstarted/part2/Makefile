
build:
	docker build -t friendlyhello .

images:
	docker images

run:
	docker run -p 4000:80 friendlyhello

run-detached:
	docker run -d -p 4000:80 friendlyhello

test:
	curl http://localhost:4000

ls:
	docker container ls

stop:
	docker container stop $(id)

login:
	docker login

tag:
	docker tag friendlyhello paulnguyen/get-started:part2

publish:
	docker push paulnguyen/get-started:part2

run-from-repo:
	docker run -p 4000:80 paulnguyen/get-started:part2


