# Steps to run the policy demo.

Requires `kubectl` and `vagrant` to be installed.


Start the vagrant cluster:

	vagrant up

Wait for three nodes to appear:

	kubectl get nodes
	NAME            STATUS                     AGE
	172.18.18.101   Ready,SchedulingDisabled   1m
	172.18.18.102   Ready                      2m
	172.18.18.103   Ready                      2m

Run the demo script:

	./demo.sh


# Building a new image.

You can modify the deployed frontend Flask app by modifying app/app.py.


To rebuild the image:

	docker build -t <your tag> .

Push your image.  You will need to modify `frontend-rc.yaml` to use the newly tagged image.
