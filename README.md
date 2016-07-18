# habitat-vagrant

## 1. Setup VirtualMachines

```
$ git clone https://github.com/takaishi/habitat-vagrant.git
$ cd habitat-vagrant
$ VBoxManage natnetwork add --netname habitat_network --network 192.168.33.0/24
$ vagrant up
```

## 2. start PostgreSQL

```
$ vagrant ssh habitat_node_0
$ sudo LANG=C HAB_POSTGRESQL='initdb_superuser_password="hab"' hab start core/postgresql --listen-peer 192.168.33.10:9634 --group prod
```

## 3. start Rails Apps

```
$ vagrant ssh habitat_node_1
$ sudo HAB_RUBY_RAILS_SAMPLE='database_username="hab" database_password="hab"' hab start core/ruby-rails-sample --listen-peer 192.168.33.11:9634 --peer 192.168.33.10:9634 --bind database:postgresql.prod --group prod
```

```
$ vagrant ssh habitat_node_2
$ sudo HAB_RUBY_RAILS_SAMPLE='database_username="hab" database_password="hab"' hab start core/ruby-rails-sample --listen-peer 192.168.33.12:9634 --peer 192.168.33.10:9634 --bind database:postgresql.prod --group prod
```

## 4. start Nginx

```
$ vagrant ssh habitat_node_4
$ git clone https://github.com/takaishi/nginx-plan.git
$ cd nginx-plan
$ sudo hab origin key generate r_takaishi
$ sudo hab studio -k r_takaishi enter
[1][default:/src:0]# build
...
[2][default:/src:0]# exit
$ sudo hab install ./results/r_takaishi-nginx-1.8.0-20160718021020-x86_64-linux.hart # filename depend on create time
$ sudo hab start r_takaishi/nginx --listen-peer 192.168.33.14:9634 --peer 192.168.33.10:9634 --bind app:ruby-rails-sample.prod --group prod

# upstreams is rails app node ip addresses.
$ grep -A2 'upstream app' /hab/svc/nginx/config/nginx.conf
    upstream app {
      server 192.168.33.11:3000;
      server 192.168.33.12:3000;
```

## 5. Scale up Rails App

```
$ vagrant ssh habitat_node_3
$ sudo HAB_RUBY_RAILS_SAMPLE='database_username="hab" database_password="hab"' hab start core/ruby-rails-sample --listen-peer 192.168.33.13:9634 --peer 192.168.33.10:9634 --bind database:postgresql.prod --group prod

$ vagrant ssh habitat_node_4

# added ip address of added rails app.
$ grep -A3 'upstream app' /hab/svc/nginx/config/nginx.conf
    upstream app {
      server 192.168.33.11:3000;
      server 192.168.33.12:3000;
      server 192.168.33.13:3000;
```
