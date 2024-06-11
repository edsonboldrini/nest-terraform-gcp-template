deploy-prepare: 
	npm run build && \
	cd terraform && \
	terraform init -upgrade && \
	terraform get -update && \
	(terraform workspace select $(stage) || terraform workspace new $(stage)) && \
	terraform apply -var=stage=$(stage)

deploy-dev:
	make deploy-prepare stage=dev