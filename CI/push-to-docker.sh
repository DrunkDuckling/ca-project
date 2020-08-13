docker build -t drunkduckling/flaskapp .
echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin
docker push drunkduckling/flaskapp