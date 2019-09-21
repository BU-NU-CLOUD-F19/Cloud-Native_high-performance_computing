---

## Project Description

## 1. Vision and Goals Of The Project:

The cloud helps organizations connect people, data, and processes in new ways to embrace the possibilities enabled by modern technologies. To succeed in a digital-first world, business leaders are bringing business and IT closer together and optimizing processes to create value, but it’s not enough to rehost applications in the cloud. The goal is to be cloud-native.

Cloud-native is an approach to build and run applications that exploit the advantages of the cloud computing delivery model. Cloud-native is about how applications are created and deployed, not where. Such systems are developed as microservices running in containers. This makes the applications portable across different clouds so that can be easily moved between AWS, Azure, or other cloud providers.
Having a cloud native architecture maximizes resiliency, manageability, and scalability. <locked in> <portable api>

A high-performance computer (HPC system) is a tool used by scientists and engineers to solve problems which require high computing resources or time. HPC systems range in size from the equivalent of just a few personal computers to tens, or even hundreds of thousands of them. 

Cloud native systems typically use Kubernetes (k8s) which provides a reliable and scalable platform for running containerized workloads.
The vision of this project is to build a user-friendly system to run High Performing Computing systems, such as Lustre in Kubernetes. 

The Lustre file system is a very popular parallel distributed file system used in a wide range of HPC environments, small to large, such as oil and gas, seismic processing, the movie industry, and scientific research to address a common problem they all have and that is the ever increasing large amounts of data being created and needing to be processed in a timely manner. In fact it is the most widely used file system by the world’s Top 500 HPC sites. The project would enable one of the most popular high-performance computing (HPC) file system to be portable across different cloud solutions.

----
Build a command-line script to automate running Lustre in Kubernetes, which provide protable APIs that enable the most popular high-performance computing (HPC) file system to be portable across different cloud platforms and minimize the disadvantage by vendor lock-in. We leverage cloud-native features to incorporate <cloud native==no lock in, portable API> resilience to failures and scaling of Lustre components (MGS, MDS, OSS). High-level goals of the project include: Build a user-friendly system to run Lustre in Kubernetes, enabling the most popular high-performance computing (HPC) file system to be portable across different cloud solutions


* Provide a simple, user-friendly command-line interface to setup Lustre on Kubernetes

* Support the ability to add or remove Lustre nodes (hosted on Kubernetes) through scripts / tools

* Leverage the “Rook” framework to develop Kubernetes operator providing features of auto-scaling and resilience to failures of Lustre components (MGS, MDS, OSS) on the cloud.

## 2. Users/Personas Of The Project:

Cloud-native HPC with Lustre will be used by two major groups within the HPC community: 

Technical customers:  scientists and engineers who need to perform number crunching, including climate prediction, protein folding simulations, oil and gas discovery, defense and aerospace work, automotive design, financial forecasting, etc.

Enterprise customers: encompasses the corporate data center, including processing customer records, inventory management, and employee details.

Lustre is used among high-performance computing researchers, and Cloud-native HPC will make it easier for them to use with cloud providers like AWS.

---

## 3. Scope and Features Of The Project

* Make Lustre portable, by integrating it into Kubernetes.

    * Set up Lustre without Kubernetes

    * Set up Kubernetes on a single/multiple nodes

    * Run Kubevirt with centos7 inside a container

    * Run Lustre inside a centos7 container

* Make Lustre’s feature set on par with other file systems supported within the rook framework

    * Write code in Go to implement an operator in Kubernetes which supports Lustre

        * Handle node failures gracefully

        * Users may add/remove Kubernetes nodes.

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

Pod: Kubernetes doesn’t run containers directly; instead it wraps one or more containers into a higher-level structure called a pod. Any containers in the same pod will share the same resources and local network. Containers can easily communicate with other containers in the same pod as though they were on the same machine while maintaining a degree of isolation from others. Pods are the basic unit of replications in Kubernetes.

Kubernetes master: make decisions about cluster (e.g. scheduling), detect and respond to cluster events (e.g. restart a new pod when the old one is killed). Its components include apiserver, etcd, scheduler and controller manager.

Kubernetes node: maintain running pods (a container wrapper, unit of replication of Kubernetes operation) and providing runtime environment. It consists of kubelet (the agent that run the node and make sure containers running in pods), kube-proxy (network proxy that mains network rules on nodes) and container run time.

Lustre: is an open-source, distributed parallel file system software platform designed for scalability, high-performance, and high-availability. Lustre is purpose-built to provide a coherent, global POSIX-compliant namespace for very large scale computer infrastructure, including the world's largest supercomputer platforms. It can support hundreds of petabytes of data storage and hundreds of gigabytes per second in simultaneous, aggregate throughput. Some of the largest current installations have individual file systems in excess of fifty petabytes of usable capacity, and have reported throughput speeds exceeding one terabyte/sec

Lustre components:
 
* Metadata Servers (MDS)- The MDS makes metadata stored in one or more MDTs available to Lustre clients. Each MDS manages the names and directories in the Lustre file system(s) and provides network request handling for one or more local MDTs.
 
* Metadata Targets (MDT) - For Lustre software release 2.3 and earlier, each file system has one MDT. The MDT stores metadata (such as filenames, directories, permissions and file layout) on storage attached to an MDS. Each file system has one MDT. An MDT on a shared storage target can be available to multiple MDSs, although only one can access it at a time. If an active MDS fails, a standby MDS can serve the MDT and make it available to clients. This is referred to as MDS failover.
 
* Object Storage Servers (OSS): The OSS provides file I/O service and network request handling for one or more local OSTs. Typically, an OSS serves between two and eight OSTs, up to 16 TiB each. A typical configuration is an MDT on a dedicated node, two or more OSTs on each OSS node, and a client on each of a large number of compute nodes.
 
* Object Storage Target (OST): User file data is stored in one or more objects, each object on a separate OST in a Lustre file system. The number of objects per file is configurable by the user and can be tuned to optimize performance for a given workload.
 
* Lustre clients: Lustre clients are computational, visualization or desktop nodes that are running Lustre client software, allowing them to mount the Lustre file system.The Lustre client software provides an interface between the Linux virtual file system and the Lustre servers. The client software includes a management client (MGC), a metadata client (MDC), and multiple object storage clients (OSCs), one corresponding to each OST in the file system.

Rook: a storage orchestrator of Kubernetes. It automates the following processes: deployment, bootstrapping, configuration, provisioning, scaling, upgrading, migration, disaster recovery, monitoring, and resource management. As a result, it turns the distributed storage system into self-managing, self-scaling and self-healing systems.

Kubevirt: a tool that allows you to run a VM inside of a pod/container and have that VM be managed by Kubernetes. KubeVirt also allows virtual machines to benefit from features in Kubernetes, using the various storage classes, networking concepts from overlay networks to routes and load balancers, multi-tenancy, RBAC, integrated monitoring and logging, and service mesh <necessary because Lusture has kernel drivers!>

### Goal of the project

<img src="images/css6620 diagram.jpg?raw=true"/>

* Figure 1: project architecture. Lustre’s OSS/MDS process running inside VMs that ran by kubevirt and managed in containers. Containers are managed in the unit of pods in Kubernetes and each Kubernetes node could nest multiple pods. OSS pods and MDS pods are isolated from each, running inside different nodes.

As shown in figure 1, the project will have an elastic Kubernetes cluster with a master node and multiple worker nodes. Each node will host pods that consist of containers that contain VM processes managed by kubevirt. 

The goal of this project is to write a Kubernetes “operator” using Golang, to make lustre available into Kubernetes nodes and have features to handle node failures or node scalability based on usage. Will make use of the “Rook” framework for file-storage on Kubernetes.

---

## 5. Acceptance criteria

The minimum acceptance criteria is to have “Lustre” up and running with Kubernetes cluster

* Have YML scripts to easily bring up and tear down the infrastructure

* Configure Luster to run with Kubernetes

* Write an Operator learning from Rook framework

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
