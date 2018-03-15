.PHONY: all
all: vagrantUp vagrantExport vagrantImport

.PHONY: clean
clean:
	rm -f *.box

.PHONY: vagrantUp
vagrantUp:
	## Create, start and provision the VM.
	vagrant up

.PHONY: vagrantExport
vagrantExport: ${KDK_FILENAME}
	## Export VM as a Vagrant Box file.
	vagrant package --output ${KDK_FILENAME}

.PHONY: vagrantImport
vagrantImport:
	## Import Vagrant Box file.
	vagrant box add ${KDK_FILENAME} --name ${KDK_NAME}

${KDK_FILENAME}:
