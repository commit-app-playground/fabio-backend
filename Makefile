# Creates (or updates) secrets object on the k8s cluster server
upsert-secrets:
	kubectl apply -n fabio-backend -f secrets/secrets.yml
