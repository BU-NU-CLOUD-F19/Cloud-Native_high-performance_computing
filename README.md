## Project Description

## 1. Vision and Goals Of The Project:

Build command-line Scripts to automate running [Lustre](http://wiki.lustre.org/Main_Page) in [Kubernetes](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/), which provide APIs that enable the most popular high-performance computing (HPC) file system to be portable across different cloud platforms and minimize the disadvantage by vendor lock-in. We leverage cloud-native features such portable API and no cloud vendor lock-in, to incorporate resilience to failures and scaling of [Lustre components](#lustre-components) (MGS, MDS, OSS). High-level goals of the project include: 

- Provide simple, user-friendly command-line scripts to setup Lustre on Kubernetes

- Support the ability to add or remove Lustre nodes (hosted on Kubernetes) through scripts / tools

- Leverage the [Rook](https://rook.io/docs/rook/v1.1/) framework to develop Kubernetes operator providing features of bootstrapping, configuration, scaling and disaster recovery of Lustre components (MGS, MDS, OSS) on the cloud

## 2. Users/Personas Of The Project:

Cloud-native HPC with Lustre will be used by two major groups within the HPC community: 

- Technical customers:  scientists and engineers who need to perform number crunching, including climate prediction, protein folding simulations, oil and gas discovery, defense and aerospace work, automotive design, financial forecasting, etc.

- Enterprise customers: encompasses the corporate data center, including processing customer records, inventory management, and employee details.

Lustre is used among high-performance computing researchers and Cloud-native HPC will make it easier for them to use with multiple cloud providers like AWS, GCP, Azure. Hence, the command line scripts will help the System Administrators to bootstrap the Lustre infrastructure on Kubernetes. The researchers will be able to access Lustre client hosted on Kubernetes to access Lustre filesystem. 

## 3. Scope and Features Of The Project:

Command-Line Scripts to automate running Lustre in Kubernetes.

- Easy-to-use interface for setting up all the Lustre components (MGS, MDS, OSS) on Kubernetes

- Ability to grow/expand any Lustre component:
   1. Creates new instance on the cloud (MOC, AWS, Azure, GCP etc.)
   2. Install KubeVirt on the instance to support Lustre to run within a container
   3. Setup the requested Lustre component (MGS, MDS, OSS)
   4. Join this instance setup to already existing Lustre configuration
   
- Ability to shrink/destroy any Lustre component:
   1. Remove the requested component (MGS, MDS, OSS) from existing Lustre configuration
   2. Delete the instance from the cloud (MOC, AWS, Azure, GCP etc.) and return the resources 

- Create a Github Wiki with all the documentations for the open-source community to enable easy setup and future enhancements to the project

 (Below needs more investigation, will be clarified in further sprints)
- Leverage the Rook framework to create a Kubernetes operator to provide features of bootstrapping, configuration, scaling and disaster recovery of Lustre components (MGS, MDS, OSS) on the cloud
- Refer [Ceph](https://docs.ceph.com/docs/master/start/intro/) for understanding the use-case for utilizing Rook framework and take inspiration for implementing similar feature of Lustre

## 4. Solution Concept

### Global Architectural Structure Of the Project

<img src="images/kubernetes.png?raw=true"/>

**Container:** Lightweight virtualization of runtime environment at the application level. It create isolation for different applications that share the OS and portable across clouds and OS distributions since it’s decoupled from the underlying infrastructure.

**Kubernetes:** a portable, extensible, open-source platform for managing containerized workloads and services which facilitates both declarative configuration and automation. It abstracts away the hardware and exposes the whole data center as a single computational resource.

**Pod:** Kubernetes doesn’t run containers directly; instead it wraps one or more containers into a higher-level structure called a pod. Any containers in the same pod will share the same resources and local network. Containers can easily communicate with other containers in the same pod as though they were on the same machine while maintaining a degree of isolation from others. Pods are the basic unit of replications in Kubernetes.

**Kubernetes master:** make decisions about cluster (e.g. scheduling), detect and respond to cluster events (e.g. restart a new pod when the old one is killed). Its components include apiserver, etcd, scheduler and controller manager.

**Kubernetes node:** maintain running pods (a container wrapper, unit of replication of Kubernetes operation) and providing runtime environment. It consists of kubelet (the agent that run the node and make sure containers running in pods), kube-proxy (network proxy that mains network rules on nodes) and container run time.

**Rook:** a storage orchestrator of Kubernetes. It automates the following processes: deployment, bootstrapping, configuration, provisioning, scaling, upgrading, migration, disaster recovery, monitoring, and resource management. As a result, it turns the distributed storage system into self-managing, self-scaling and self-healing systems.

**Kubevirt:** a tool that allows you to run a VM inside of a pod/container and have that VM be managed by Kubernetes. KubeVirt also allows virtual machines to benefit from features in Kubernetes, using the various storage classes, networking concepts from overlay networks to routes and load balancers, multi-tenancy, RBAC, integrated monitoring and logging, and service mesh (necessary because Lusture has kernel drivers!). It is essential to our project since Lustre has kernel drivers and would need kubevirt to containerize.  

**Lustre:** is an open-source, distributed parallel file system software platform designed for scalability, high-performance, and high-availability. Lustre is purpose-built to provide a coherent, global POSIX-compliant namespace for very large scale computer infrastructure, including the world's largest supercomputer platforms. It can support hundreds of petabytes of data storage and hundreds of gigabytes per second in simultaneous, aggregate throughput. Some of the largest current installations have individual file systems in excess of fifty petabytes of usable capacity, and have reported throughput speeds exceeding one terabyte/sec

### Lustre components:

**Management Server (MGS):** The MGS is a global resource that can be associated with one or more Lustre file systems. It
acts as a global registry for configuration information and service state. It does not participate in file system operations.

**Management Target (MGT):** MGT is the management service storage target used to store configuration data.
 
**Metadata Servers (MDS):** The MDS makes metadata stored in one or more MDTs available to Lustre clients. Each MDS manages the names and directories in the Lustre file system(s) and provides network request handling for one or more local MDTs.
 
**Metadata Targets (MDT):** For Lustre software release 2.3 and earlier, each file system has one MDT. The MDT stores metadata (such as filenames, directories, permissions and file layout) on storage attached to an MDS. Each file system has one MDT. An MDT on a shared storage target can be available to multiple MDSs, although only one can access it at a time. If an active MDS fails, a standby MDS can serve the MDT and make it available to clients. This is referred to as MDS failover.
 
**Object Storage Servers (OSS):** The OSS provides file I/O service and network request handling for one or more local OSTs. Typically, an OSS serves between two and eight OSTs, up to 16 TiB each. A typical configuration is an MDT on a dedicated node, two or more OSTs on each OSS node, and a client on each of a large number of compute nodes.
 
**Object Storage Target (OST):** User file data is stored in one or more objects, each object on a separate OST in a Lustre file system. The number of objects per file is configurable by the user and can be tuned to optimize performance for a given workload.
 
**Lustre clients:** Lustre clients are computational, visualization or desktop nodes that are running Lustre client software, allowing them to mount the Lustre file system.The Lustre client software provides an interface between the Linux virtual file system and the Lustre servers. The client software includes a management client (MGC), a metadata client (MDC), and multiple object storage clients (OSCs), one corresponding to each OST in the file system.

<img src="images/cluster.png?raw=true"/>

<img src="images/new_diagram.png?raw=true"/>

**Figure 1:** project architecture. Lustre’s MGS/MDS/OSS nodes running inside VMs that was setup by utlizing kubevirt and managed in containers. Containers are managed in the unit of pods in Kubernetes and each Kubernetes node could nest multiple pods. MSG pods, MDS pods and OSS pods are isolated from each, running inside different nodes.

The command-line scripts will allow us to easily grow/shrink the Lustre components within the Kubernetes setup.
Leveraging the Rook framework to build a Kubernetes operator will allow us to bootstrap, configure, scale and disaster recovery of Lustre components (MGS, MDS, OSS) on the Kubernetes.

## 5. Acceptance criteria

The minimum acceptance criteria is to have “Lustre” up and running with Kubernetes cluster

- Provide scripts to easily bring up and tear down the Lustre infrastructure on Kubernetes

- Provide ability to add or remove Lustre components on the existing setup

- Leverage Rook framework to build a Kubernetes operator for bootstrapping, configuration, scaling and resilience to failures of Lustre components (MGS, MDS, OSS) on the cloud

## 6. Release Planning

**Demo1**  (Finish by 09/27): setup lustre and kubernetes individually.

- Set up Lustre without Kubernetes
- Set up Kubernetes on a single node without Lustre (e.g. laptop or single instance)
- Create a Kubernetes cluster with Minikube, start a testVM with Kubevirt on top of it

Demo on *9/27* - run simple lustre setup in kubernetes: cannot yet tolerate node failures or handle elasticity.

**Demo2**  (Finish by 10/09): setup multi-node kubernetes cluster, run virtual machine in Kubernetes with Kubevirt.

- Set up Minikube on single node and start virtual machine with Kubevirt
- Set up Kubernetes cluster (without Minikube) on multiple nodes without Luster (1 master, 2 nodes)
- Start centos7 VM with Kubevirt inside Kubernetes cluster, without Persistent Volume

Demo on *10/09* - Further setup in Kubernetes cluster: able to start centos VM with Kubevirt.

**Demo3**  (Finish by 10/25): setup Persistent Volume for Kubernetes pods, start lustre virtual machine in Kubernetes nodes with Kubevirt, explore benchmarking with lustre.

- Start centos7 VM with Kubevirt inside Kubernetes cluster with Persistent Volume
- Set up Lustre in Kubernetes cluster on multiple nodes (1 master, 2 nodes)
- Benchmarking for Lustre on Kubernetes MOC (LNET)

Demo on *10/25* - Finalize setup in Kubernetes cluster: able to do benchmarking on Lustre w/o Kubernetes.

**Demo4**  (Finish by 11/08): Creating Lustre server and client image; Lustre benchmarking

- Create Lustre Docker image (server, client) for easier deployment on Kubernetes
- Evaluate more benchmarking tests 
- Understand and setup Ceph with Rook framework on existing Kubernetes setup

Demo on *11/08* .

**Future goals** 

(Unfinished tasks *from* Demo 4): 

- Deep-dive into Rook framework
- Modify Ceph operator understand how changes are reflected
- Create an initial Lustre setup with Rook


Remainder of course: Make Lustre’s feature set on par with other file systems supported within the rook framework. Desirable features are elasticity, redundancy on failure, and ease of use. Stretch goal is to integrate HPC hardware (RDMA/infiniband).

Write Go code using the “operator” design pattern within the rook framework

- Node failure
- Manual adding/removing nodes (invoked by user with yml scripts)
- “Elegant” yml scripts to easily create and tear down lustre systems
- Time and equipment permitting, use RDMA/infiniband.
  - TODO - ask professors about availability on Mass Open Cloud (MOC).
- Choose a good high performance computing workload to demo. Commit clean code to git repository for the open source community to consume.
  - If successful, we’ll make an announcement and possibly give a talk at an open source conference.

## 7. Open questions and risks:

- Setting up Lustre components on MOC
- Using Kubevirt to run Luster components in a container (pod)
- Understanding Rook framework and how Ceph leverages it for its filesystem

## 8. Demo slides:
- [Demo 1 - 09/27/2019](https://docs.google.com/presentation/d/11-5E0pl9JrQ1s5jjbWnUuhI7mBM081c694kGdY1zb0s/edit?usp=sharing)

- [Demo 2 - 10/09/2019](https://docs.google.com/presentation/d/16h66UZD1-1A3WeCJlkk5Czx8uli1WVLX_mfRJjoSNdE/edit#slide=id.p)

- [Paper Presentation- 10/22/2019](https://docs.google.com/presentation/d/1pHBd9kxckNLg6qRDKbj5swUbpeb2MqQmD2AWmgGmLv4/edit#slide=id.g6240183895_1_7)

- [Demo 3 - 10/24/2019](https://docs.google.com/presentation/d/1l06Gs6PNi8ent285efJvWWkberFa2y6y_yWkRt6yyko/edit?usp=sharing)

- [Demo 4 - 11/08/2019](https://docs.google.com/presentation/d/1bmxDqdsMl1rL9_8-XkGlVrLt9L2k6OvBasVC9A0ClVQ/edit?usp=sharing)
