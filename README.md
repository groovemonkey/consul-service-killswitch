# Fun Consul Trick: Service Killswitch

Consul (and the tools it enables -- watches, templates, etc.) is so flexible that you can solve many annoying problems in creative ways.

You may have a plethora of machines and services running across your infrastructure. Maybe some nodes are running multiple non-critical services, any one of which could misbehave and accidentally starve its machine of resources.

For example, perhaps you have 100 nodes running some kind of profiling daemon, and you want to create a killswitch just in case its resource usage goes ballistic.

Wouldn't it be nice to be able to stop -- more or less instantaneously -- a process on all relevant machines by updating a single key in the consul KV store?

## Demo
Let's wire up something simple that gives us this behavior. Just install (Vagrant)[https://www.vagrantup.com/] and let's go!

```
vagrant up

# Visit nginx in your (host machine's) browser, or just:
curl 127.0.0.1:8080

# Connect to the machine
vagrant ssh

# Check nginx
curl localhost

# See if our little mechanism works
consul kv put service/nginx/enabled "false"
Success! Data written to: service/nginx/enabled

# Check to see if nginx has been turned off
curl localhost
curl: (7) Failed to connect to localhost port 80: Connection refused

# Log back out with ctrl-d

# Cleanup
vagrant destroy
```

## Visit the Consul UI in your browser

Visit the (Consul UI)[127.0.0.1:8500/ui]



## Notes
Tools like `consul exec` can be a great way to do this flexibly, but it can be slightly complicated to configure and use them safely. For example, `consul exec` should be wired up to vault and require the operator to have a token that lets them use the appropriate role to make changes on the box.
