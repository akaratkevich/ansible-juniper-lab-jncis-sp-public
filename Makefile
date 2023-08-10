.PHONY: start-pir stop-pir start-bgp stop-bgp

start-pir:
	@NODES="r1,r2,r3"; \
	echo "Executing playbook to deploy Protocol Independent Routing topology with nodes $$NODES"; \
	ansible-playbook ./playbooks/deploy-clab-topology.yml --extra-vars "topology_path=/home/anton/git_hub/ansible-juniper-lab-jncis-sp-public/clab/pir-topology.yml"; \
	echo "Waiting 10 seconds before running script"; \
	sleep 10; \
	echo "Executing script to enable ssh/rsa auth on the nodes"; \
	expect ./scripts/expect.exp $$NODES; \
	echo "Waiting 3 seconds before rendering config"; \
	sleep 3; \
	echo "Running playbook to render configuration"; \
	ansible-playbook ./playbooks/render-pir-base.yml -i ./inventory/pir-inventory.yml; \
	echo "Running playbook to configure nodes"; \
	ansible-playbook ./playbooks/conf-base.yml -i ./inventory/pir-inventory.yml; \
	echo "Lab setup complete with basic configuration"; \
	FILE="/home/anton/git_hub/ansible-juniper-lab-jncis-sp-public/docs/protocol-independent-routing.md"; \
	cat $$FILE

stop-pir:
	@DIRECTORY="/home/anton/git_hub/ansible-juniper-lab-jncis-sp-public/playbooks/"; \
	echo "Running cleanup"; \
	ansible-playbook ./playbooks/destroy-clab-topology.yml --extra-vars "topology_path=/home/anton/git_hub/ansible-juniper-lab-jncis-sp-public/clab/pir-topology.yml"; \
	sudo find $${DIRECTORY} -maxdepth 0 -type d -name 'clab*' -exec rm -rf {} \;; \
	echo "Cleanup complete"

start-bgp:
	@NODES="r1,r2,r3"; \
	echo "Executing playbook to deploy BGP topology with nodes $$NODES"; \
	ansible-playbook ./playbooks/deploy-clab-topology.yml --extra-vars "topology_path=/home/anton/git_hub/ansible-juniper-lab-jncis-sp-public/clab/bgp-topology.yml"; \
	echo "Waiting 10 seconds before running script"; \
	sleep 10; \
	echo "Executing script to enable ssh/rsa auth on the nodes"; \
	expect ./scripts/expect.exp $$NODES; \
	echo "Waiting 3 seconds before rendering config"; \
	sleep 3; \
	echo "Running playbook to render configuration"; \
	ansible-playbook ./playbooks/render-bgp-base.yml -i ./inventory/bgp-inventory.yml; \
	echo "Running playbook to configure nodes"; \
	ansible-playbook ./playbooks/conf-bgp-base.yml -i ./inventory/bgp-inventory.yml; \
	echo "Configuring ISP container..."; \
	sudo docker exec isp1 /bin/sh -c "ifconfig eth1 10.0.0.18 netmask 255.255.255.252 up"; \
	echo "Starting exabgp inside Docker container..."; \
	sudo docker exec isp1 /bin/sh -c "tmux new-session -d 'exabgp ./exa.cfg'"; \
	echo "Lab setup complete with basic configuration"; \
	FILE="/home/anton/git_hub/ansible-juniper-lab-jncis-sp-public/docs/bgp.md"; \
	cat $$FILE

stop-bgp:
	@DIRECTORY="/home/anton/git_hub/ansible-juniper-lab-jncis-sp-public/playbooks/"; \
	echo "Running cleanup"; \
	ansible-playbook ./playbooks/destroy-clab-topology.yml --extra-vars "topology_path=/home/anton/git_hub/ansible-juniper-lab-jncis-sp-public/clab/bgp-topology.yml"; \
	sudo find $${DIRECTORY} -maxdepth 0 -type d -name 'clab*' -exec rm -rf {} \;; \
	echo "Cleanup complete"

