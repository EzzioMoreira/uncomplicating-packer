# Uncomplicating Packer
Curso descomplicando packer Linuxtips. 

### Run container packer
```docker run -it -v $PWD:/app -w /app --entrypoint "" hashicorp/packer:light sh```

### Install Ansible container

```apk -U add ansible```

### Adicionado provisioner ansible e shell
- Instalando o Docker
- Install k8s

### Running project
```packer build app.json.pkr.hc```

### Add variables
- variable "ami_name"
- variable "region"
- variable "type"
- variable "instance_typ"

### Debugging Packer Builds
```packer build -debug```
- Debug mode informs the builders that they should output debugging information.
