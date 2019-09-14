---

## Project Description

## 1. Vision and Goals Of The Project:

Build a user-friendly system to run Lustre in Kubernetes, enabling the most popular high-performance computing (HPC) file system to be portable across different cloud solutions

* Use “libvirt” as the underlying technology to run Lustre within Kubernetes’ containers

* Handle node crashes and node scaling by implementing Kubernetes operators

* Make it easy to set up Lustre in Kubernetes by adding scripts and documentation

## 2. Users/Personas Of The Project:

Lustre is used among high-performance computing researchers and Cloud-native HPC will make it easier for them to use with cloud providers like AWS.

We are mainly targeting the HPC community members, or anyone who uses the Lustre file system.

---

## 3. Scope and Features Of The Project

* Make Lustre portable to Kubernetes.

     * Set up Lustre without Kubernetes

* Set up Kubernetes on a single/multiple nodes

    * Run Kubevirt with centos7 inside a container

    * Run Lustre inside a centos7 container

* Make Lustre’s feature set on par with other file systems supported within the rook framework

* Write code in Go to implement an operator in Kubernetes which supports Lustre

    * Handle node failures gracefully

* Users may add/remove Kubernetes nodes.

    * The size of the “Luster cluster” is elastic.

    * Integrate HPC hardware (RDMA/infiniband).

* Create yml scripts that make the system setup easy to use;

* To easily create and tear down lustre systems

* To invoke add/remove Kubernetes nodes by user

* Make a Github site with the documentation for the open-source community  

---

## 4. Solution Concept

### Global Architectural Structure Of the Project

Container: Lightweight virtualization of runtime environment at the application level. It create isolation for different applications that share the OS and portable across clouds and OS distributions since it’s decoupled from the underlying infrastructure.

Kubernetes: a portable, extensible, open-source platform for managing containerized workloads and services which facilitates both declarative configuration and automation. It abstracts away the hardware and exposes the whole data center as a single computational resource.

Kubernetes master: make decisions about cluster (e.g. scheduling), detect and respond to cluster events (e.g. restart a new pod when the old one is killed). Its components include apiserver, etcd, scheduler and controller manager.

Kubernetes node: maintain running pods (a container wrapper, unit of replication of Kubernetes operation) and providing runtime environment. It consists of kubelet (the agent that run the node and make sure containers running in pods), kube-proxy (network proxy that mains network rules on nodes) and container run time.

Lustre: is an open-source, distributed parallel file system software platform designed for scalability, high-performance, and high-availability. Lustre is purpose-built to provide a coherent, global POSIX-compliant namespace for very large scale computer infrastructure, including the world's largest supercomputer platforms. It can support hundreds of petabytes of data storage and hundreds of gigabytes per second in simultaneous, aggregate throughput. Some of the largest current installations have individual file systems in excess of fifty petabytes of usable capacity, and have reported throughput speeds exceeding one terabyte/sec

### Goal of the project

<img src="images/css6620 diagram.jpg?raw=true"/>

Write an Kubernetes “operator” using Golang, to make lustre available into Kubernetes nodes and have features to handle node failures or node scalability based on usage. Will make use of “Rook” framework for file-storage on Kubernetes.
---

## 5. Acceptance criteria

The minimum acceptance criteria is to have “Lustre” up and running with Kubernetes cluster
Have YML scripts to easily bring up and tear down the infrastructure
Configure Luster to run with Kubernetes
Write an Operator learning from Rook framework

---

## 6. Release Planning

**Phase 1** goals (Finish by 09/26): setup lustre and kubernetes individually, then run lustre inside kubernetes.

- Set up Lustre without kubernetes
- Set up kubernetes on a single node without Lustre (e.g. laptop or single instance)
- Set up kubernetes on multiple nodes without Luster (4 MOC instances)
- Run kubevirt with centos7 inside a container
- Run lustre inside a centos7 container
- Learn the rook system and understand how to write an “operator”

Demo on *9/27* - run simple lustre setup in kubernetes: cannot yet tolerate node failures or handle elasticity.

**Phase 2** goals (Sprint Planning *after* Phase 1): Remainder of course. Make Lustre’s feature set on par with other file systems supported within the rook framework. Desirable features are elasticity, redundancy on failure, and ease of use. Stretch goal is to integrate HPC hardware (RDMA/infiniband).

Write Go code using the “operator” design pattern within the rook framework

- Node failure
- Manual adding/removing nodes (invoked by user with yml scripts)
- “Elegant” yml scripts to easily create and tear down lustre systems
- Time and equipment permitting, use RDMA/infiniband.
  - TODO - ask professors about availability on Mass Open Cloud (MOC).
- Choose a good high performance computing workload to demo. Commit clean code to git repository for the open source community to consume.
  - If successful, we’ll make an announcement and possibly give a talk at an open source conference.
