# Steps to setup the policy demo.

Requires `kubectl` and `vagrant` to be installed.

I'm using https://github.com/tomdee/kubeadm-vagrant and this demo assumes that the master node is called `n1` and that the config is in place to just do `ssh n1`

The demo also assumes that networking and policy are in place.

A sample file to install flannel for networking and Calico for policy is checked in

Flannel:
``

Calico:
``


# Run the demo script:

	./demo.sh


# Building a new image.

You can modify the deployed frontend Flask app by modifying app/app.py.


To rebuild the image:

	docker build -t <your tag> .

Push your image.  You will need to modify `frontend-rc.yaml` to use the newly tagged image.
