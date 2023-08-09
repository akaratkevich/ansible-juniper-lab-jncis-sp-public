# Service Provider Routing and Switching, Specialist (JNCIS-SP) (JN0-363) -- Labs

>"I hear and I forget. I see and I remember. I do and I understand." – Confucius.

These labs are part of my preparation for [JNCIS-SP](https://www.juniper.net/gb/en/training/certification/tracks/service-provider-routing-switching/jncis-sp.html) certification. 
The intention was to create a series of readily available labs, encompassing all conceivable topics related to this exam track, that I was able to replicate in this virtualised environment."


The labs are broken down by [exam topics](https://www.juniper.net/gb/en/training/certification/tracks/service-provider-routing-switching/jncis-sp.html)

- [Protocol-Independent Routing](#protocol-independent-routing)
- [Open Shortest Path First (OSPF)](#open-shortest-path-first)
- [Intermediate System to Intermediate System (IS-IS)](#intermediate-system-to-intermediate-system)
- [Border Gateway Protocol (BGP)](#border-gateway-protocol)
- [Layer 2 Bridging or VLANs](#layer-2-bridging)
- [Spanning-Tree Protocols](#spanning-tree-protocols)
- [Multiprotocol Label Switching (MPLS)](#multiprotocol-label-switching)
- [IPv6](#ipv6)
- [Tunnels](#tunnels)
- [High Availability](#high-availability)

Using Makefile, each lab is set up with the appropriate topology and foundational configuration using Containerlab, in conjunction with Ansible and a selection of other scripts and tools. The base configuration includes essential prerequisites like interface descriptions and IP assignments, enabling you to dive directly into the specific learning objectives in question.

>PREREQUISITES:
>
> - [Containerlab](https://containerlab.dev/)
> - [Ansible](https://www.juniper.net/documentation/us/en/software/junos-ansible/ansible/topics/concept/junos-ansible-modules-overview.html)
> - [Docker images](https://www.redhat.com/en/topics/containers/what-is-docker?sc_cid=7013a0000026OQwAAM&gclid=CjwKCAjw8symBhAqEiwAaTA__FWw8RjodY_dtI7BjNtE4cNU8Lw48xDIH7Qn6Q_X-YUQH4yvjB8bdRoCmBEQAvD_BwE&gclsrc=aw.ds)
> - [Jinja2](https://pypi.org/project/Jinja2/)
> - [Expect](https://phoenixnap.com/kb/linux-expect)
> - Very possible that I may have missed some of the prerequisites as these labs are built in my pre-existing lab environment :)  


>ADMINISTRATION:
>
>Please make sure to verify and update any paths and username referenced in any playbooks, scripts or variables

## Protocol-Independent Routing

The first lab covers the learning objectives for Protocol-Independent Routing.

This is the lab topology diagram:

![Topology](pictures/pir-topology.png)

Lab is deployed by running the following command:
```
make start-pir
```

Lab is destroyed by running the following command:
```
make stop-pir
```
Demo of staring the lab:

```
anton@mcc:~/git_hub/ansible-juniper-lab-jncis-sp-public$ make start-pir 
Executing playbook to deploy Protocol Independent Routing topology with nodes r1,r2,r3
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details
Enter the sudo password: 

PLAY [Deploy Containerlab Topology] ************************************************************************************************************************************************************************************************

TASK [Run clab deploy command] *****************************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Wait for the deployment to complete] *****************************************************************************************************************************************************************************************
Pausing for 180 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [localhost]

TASK [Check Docker containers status] **********************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Check for healthy status] ****************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "All containers are healthy"
}

PLAY RECAP *************************************************************************************************************************************************************************************************************************
localhost                  : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

Waiting 10 seconds before running script
Executing script to enable ssh/rsa auth on the nodes
spawn ./scripts/deploy-conf-file -config ./configuration/sshRSA.cfg
Enter the Juniper nodes (IP addresses or hostnames):seperated by comma
r1,r2,r3
Successfully executed configuration on r1
Successfully executed configuration on r2
Successfully executed configuration on r3
Waiting 3 seconds before rendering config
Running playbook to render configuration
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details

PLAY [vr-vmx] **********************************************************************************************************************************************************************************************************************

TASK [Include variables from r1.yml] ***********************************************************************************************************************************************************************************************
skipping: [r2]
skipping: [r3]
ok: [r1]

TASK [Include variables from r2.yml] ***********************************************************************************************************************************************************************************************
skipping: [r1]
skipping: [r3]
ok: [r2]

TASK [Include variables from r3.yml] ***********************************************************************************************************************************************************************************************
skipping: [r1]
skipping: [r2]
ok: [r3]

TASK [Render configuration template] ***********************************************************************************************************************************************************************************************
ok: [r3]
ok: [r1]
ok: [r2]

PLAY RECAP *************************************************************************************************************************************************************************************************************************
r1                         : ok=2    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
r2                         : ok=2    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
r3                         : ok=2    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   

Running playbook to configure nodes
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details

PLAY [Load and commit base configuration] ******************************************************************************************************************************************************************************************

TASK [Load configuration from a local file and commit] *****************************************************************************************************************************************************************************
changed: [r1]
changed: [r3]
changed: [r2]

TASK [Print the response] **********************************************************************************************************************************************************************************************************
ok: [r1] => {
    "response": {
        "changed": true,
        "diff": {
            "prepared": "\n[edit interfaces]\n+   ge-0/0/0 {\n+       description \"Link from R1 to R2 - primary\";\n+       unit 0 {\n+           family inet {\n+               address 10.0.0.1/24;\n+           }\n+       }\n+   }\n+   ge-0/0/2 {\n+       description \"Link from R1 to R2 - secondary\";\n+       unit 0 {\n+           family inet {\n+               address 10.20.20.1/24;\n+           }\n+       }\n+   }\n+   lo0 {\n+       unit 0 {\n+           family inet {\n+               address 10.100.100.1/32;\n+           }\n+       }\n+   }\n"
        },
        "diff_lines": [
            "",
            "[edit interfaces]",
            "+   ge-0/0/0 {",
            "+       description \"Link from R1 to R2 - primary\";",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.0.0.1/24;",
            "+           }",
            "+       }",
            "+   }",
            "+   ge-0/0/2 {",
            "+       description \"Link from R1 to R2 - secondary\";",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.20.20.1/24;",
            "+           }",
            "+       }",
            "+   }",
            "+   lo0 {",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.100.100.1/32;",
            "+           }",
            "+       }",
            "+   }"
        ],
        "failed": false,
        "file": "./configuration/r1-base-config.txt",
        "msg": "Configuration has been: opened, loaded, checked, diffed, committed, closed."
    }
}
ok: [r3] => {
    "response": {
        "changed": true,
        "diff": {
            "prepared": "\n[edit interfaces]\n+   ge-0/0/1 {\n+       description \"Link from R3 to R2\";\n+       unit 0 {\n+           family inet {\n+               address 10.0.1.3/24;\n+           }\n+       }\n+   }\n+   lo0 {\n+       unit 0 {\n+           family inet {\n+               address 10.100.100.3/32;\n+           }\n+       }\n+   }\n"
        },
        "diff_lines": [
            "",
            "[edit interfaces]",
            "+   ge-0/0/1 {",
            "+       description \"Link from R3 to R2\";",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.0.1.3/24;",
            "+           }",
            "+       }",
            "+   }",
            "+   lo0 {",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.100.100.3/32;",
            "+           }",
            "+       }",
            "+   }"
        ],
        "failed": false,
        "file": "./configuration/r3-base-config.txt",
        "msg": "Configuration has been: opened, loaded, checked, diffed, committed, closed."
    }
}
ok: [r2] => {
    "response": {
        "changed": true,
        "diff": {
            "prepared": "\n[edit interfaces]\n+   ge-0/0/0 {\n+       description \"Link from R2 to R1 - primary\";\n+       unit 0 {\n+           family inet {\n+               address 10.0.0.2/24;\n+           }\n+       }\n+   }\n+   ge-0/0/1 {\n+       description \"Link from R2 to R3\";\n+       unit 0 {\n+           family inet {\n+               address 10.0.1.2/24;\n+           }\n+       }\n+   }\n+   ge-0/0/2 {\n+       description \"link from R2 to R1 - secondary\";\n+       unit 0 {\n+           family inet {\n+               address 10.20.20.2/24;\n+           }\n+       }\n+   }\n+   lo0 {\n+       unit 0 {\n+           family inet {\n+               address 10.100.100.2/32;\n+           }\n+       }\n+   }\n"
        },
        "diff_lines": [
            "",
            "[edit interfaces]",
            "+   ge-0/0/0 {",
            "+       description \"Link from R2 to R1 - primary\";",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.0.0.2/24;",
            "+           }",
            "+       }",
            "+   }",
            "+   ge-0/0/1 {",
            "+       description \"Link from R2 to R3\";",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.0.1.2/24;",
            "+           }",
            "+       }",
            "+   }",
            "+   ge-0/0/2 {",
            "+       description \"link from R2 to R1 - secondary\";",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.20.20.2/24;",
            "+           }",
            "+       }",
            "+   }",
            "+   lo0 {",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.100.100.2/32;",
            "+           }",
            "+       }",
            "+   }"
        ],
        "failed": false,
        "file": "./configuration/r2-base-config.txt",
        "msg": "Configuration has been: opened, loaded, checked, diffed, committed, closed."
    }
}

PLAY RECAP *************************************************************************************************************************************************************************************************************************
r1                         : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
r2                         : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
r3                         : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

Lab setup complete with basic configuration

>[!INFO]
> EXAM OBJECTIVES: Identiy the concepts, operation, and functionality of various protocol-independent routing components;

- Static, aggregate, and generated routes
- Martian addresses
- Routing instances, including routing information base (RIB) (also known as routing table) group
- Load balancing
- Filter-based forwarding

>[!IMPORTANT]
>Demonstrate knowledge of how to configure, monitor, and troubleshoot various protocol-independent routing components:

- Static, aggregate, and generated routes
- Load balancing
- Filter-based forwarding
```

### Objectives

- [Static](#static-routes), [aggregate, and generated routes](#aggregate-and-generated-routes);
- Configuration and monitoring of static, aggregate, and generated routes;
- Martian routes and how to add new entries to the default list;
- Routing instances and their typical uses;
- Configuration and sharing of routes between routing instances.

##### Static Route Default Options

Static routes are used in a networking environment for multiple purposes, including a default route for the autonomous system (AS) and as routes to customer networks. Unlike dynamic routing protocols, you manually configure the routing information provided by static routes on each router or multilayer switch in the network.

Starting state on `r1`
```
anton@r1> show interfaces descriptions                          
Interface       Admin Link Description
ge-0/0/0        up    up   Link from R1 to R2 - primary
ge-0/0/2        up    up   Link from R1 to R2 - secondary

anton@r1> show interfaces terse | match "ge-0/0/[02].0|lo0.0"   
ge-0/0/0.0              up    up   inet     10.0.0.1/24     
ge-0/0/2.0              up    up   inet     10.20.20.1/24   
lo0.0                   up    up   inet     10.100.100.1

anton@r1> show route table inet.0   

inet.0: 5 destinations, 5 routes (5 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.0.0.0/24        *[Direct/0] 00:03:36
                    >  via ge-0/0/0.0
10.0.0.1/32        *[Local/0] 00:03:36
                       Local via ge-0/0/0.0
10.20.20.0/24      *[Direct/0] 00:03:36
                    >  via ge-0/0/2.0
10.20.20.1/32      *[Local/0] 00:03:36
                       Local via ge-0/0/2.0
10.100.100.1/32    *[Direct/0] 00:03:36
                    >  via lo0.0
```

##### Scenario 1 - simple static route

##### **Basic Next-Hop**:

All configuration for static routes occurs at the [edit routing-options] level of the hierarchy. A basic static route consists of a destination prefix and its associated next hop.

*Configuration*
```
anton@r1# show | compare 
[edit]
+  routing-options {
+      static {
+          route 10.100.100.2/32 next-hop 10.0.0.2;
+      }
+  }

[edit]
```

```
anton@r1# run show route 10.100.100.2 exact 

inet.0: 4 destinations, 4 routes (4 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.100.100.2/32    *[Static/5] 00:00:16
                    >  to 10.0.0.2 via ge-0/0/0.0
                    
```

##### Scenario 2 - qualified next-hop

##### **Qualified Next-Hop**:

With qualified next-hop, you can specify multiple next-hops for the same destination, each with different properties such as preference, weight, or color. This allows for more granular control over how traffic is routed to a destination.

The default preference value of static routes is 5. This preference makes them more likely to be active than OSPF, IS-IS, or BGP for matching prefixes. Use this option to increase the value of the static routes to prefer other sources of routing information.

*Configuration*
```
anton@r1# show | compare 
[edit]
+  routing-options {
+      static {
+          route 10.100.100.2/32 {
+              next-hop 10.0.0.2;
+              qualified-next-hop 10.20.20.2 {
+                  preference 6;
+              }
+          }
+    
```

In the sample configuration shown, the 10.0.0.2 next hop assumes the default static route preference of 5, whereas the qualified 10.20.20.2 next hop uses the defined route preference of 6. All traffic using this static route uses the 10.0.0.2 next hop unless it becomes unavailable. 

```
anton@r1> show route 10.100.100.2 exact    

inet.0: 6 destinations, 7 routes (6 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.100.100.2/32    *[Static/5] 00:00:19
                    >  to 10.0.0.2 via ge-0/0/0.0
                    [Static/6] 00:00:19
                    >  to 10.20.20.2 via ge-0/0/2.0
```

Static routes remain in the routing table until you remove them or until they become inactive. One possible scenario in which a static route becomes inactive is when the IP address used as the next hop becomes unreachable.

To test the qualified next-hop we can shutdown 'primary' interface on `r1`:
```
anton@r1# run show interfaces descriptions    
Interface       Admin Link Description
ge-0/0/0        down  down Link from R1 to R2 - primary
ge-0/0/2        up    up   Link from R1 to R2 - secondary

[edit]
anton@r1# run show route                      

inet.0: 5 destinations, 5 routes (5 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.0.0.1/32        *[Local/0] 00:00:11
                       Reject
10.20.20.0/24      *[Direct/0] 00:00:33
                    >  via ge-0/0/2.0
10.20.20.1/32      *[Local/0] 00:00:33
                       Local via ge-0/0/2.0
10.100.100.1/32    *[Direct/0] 01:56:09
                    >  via lo0.0
10.100.100.2/32    *[Static/6] 00:00:33
                    >  to 10.20.20.2 via ge-0/0/2.0
```

##### Static Route Default Options

If no options are defined at the lower more specific hierarchy level the static routes will inherit the default options. 
Following options can be applied at the [routing-options static defaults] hierarchy:
```
[edit routing-options static defaults]
anton@r1# set ?
Possible completions:
  active               Remove inactive route from forwarding table
+ apply-groups         Groups from which to inherit configuration data
+ apply-groups-except  Don't inherit configuration data from these groups
> as-path              Autonomous system path
> color                Color (preference) value
> color2               Color (preference) value 2
+ community            BGP community identifier
  install              Install route into forwarding table
  longest-match        Always use longest prefix match to resolve next hops
> metric               Metric value
> metric2              Metric value 2
> metric3              Metric value 3
> metric4              Metric value 4
  no-install           Don't install route into forwarding table
  no-longest-match     Don't always use longest prefix match to resolve next hops
  no-readvertise       Don't mark route as eligible to be readvertised
  no-resolve           Don't allow resolution of indirectly connected next hops
  no-retain            Don't always keep route in forwarding table
  passive              Retain inactive route in forwarding table
> preference           Preference value
> preference2          Preference value 2
  readvertise          Mark route as eligible to be readvertised
  resolve              Allow resolution of indirectly connected next hops
  retain               Always keep route in forwarding table
> tag                  Tag string
> tag2                 Tag string 2
[edit routing-options static defaults]
```

For example lets set the default route preference at the defaults hierarchy and also at the route level:
*Configuration*
```
anton@r1# edit routing-options static 

[edit routing-options static]
anton@r1# show 
defaults {
    preference 14;
}
route 10.100.100.2/32 {
    next-hop 10.0.0.2;
    qualified-next-hop 10.20.20.2;
    preference 10;
}
route 0.0.0.0/0 next-hop 10.0.0.2;

[edit routing-options static]
```

```
anton@r1# run show route protocol static                 

inet.0: 7 destinations, 7 routes (7 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

0.0.0.0/0          *[Static/14] 00:01:36
                    >  to 10.0.0.2 via ge-0/0/0.0
10.100.100.2/32    *[Static/10] 00:04:23
                       to 10.0.0.2 via ge-0/0/0.0
                    >  to 10.20.20.2 via ge-0/0/2.0
```

#### Aggregate and generated routes

Aggregate routes allow you to combine groups of routes with common addresses into a single entry. By combining routes into a single entry, you can decrease the number of route advertisements sent by your device, thus decreasing the size of the routing tables maintained by neighboring devices. A second advantage of advertising a single route prefix that represents all other internal route prefixes is that internal routing instabilities can be hidden from external peers.

##### Scenario 1 - aggregated routes

We will split 172.20.0.0/24 into /29s and assign them to Lo0 on R3
*Configuration*
```
anton@r3# show | compare 
[edit interfaces lo0 unit 0 family inet]
        address 10.100.100.3/32 { ... }
+       address 172.20.0.1/29;
+       address 172.20.0.9/29;
+       address 172.20.0.17/29;
+       address 172.20.0.25/29;
+       address 172.20.0.33/29;
+       address 172.20.0.41/29;
+       address 172.20.0.249/29;
+       address 172.20.0.241/29;
+       address 172.20.0.233/29;
```

This is the current routing table on `r3`
```
anton@r3# run show route table inet.0 

inet.0: 21 destinations, 21 routes (21 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.0.1.0/24        *[Direct/0] 00:05:55
                    >  via ge-0/0/1.0
10.0.1.3/32        *[Local/0] 00:05:55
                       Local via ge-0/0/1.0
10.100.100.3/32    *[Direct/0] 00:05:55
                    >  via lo0.0
172.20.0.0/29      *[Direct/0] 00:00:11
                    >  via lo0.0
172.20.0.1/32      *[Local/0] 00:00:11
                       Local via lo0.0
172.20.0.8/29      *[Direct/0] 00:00:11
                    >  via lo0.0
172.20.0.9/32      *[Local/0] 00:00:11
                       Local via lo0.0
172.20.0.16/29     *[Direct/0] 00:00:11
                    >  via lo0.0
172.20.0.17/32     *[Local/0] 00:00:11
                       Local via lo0.0
172.20.0.24/29     *[Direct/0] 00:00:11
                    >  via lo0.0
172.20.0.25/32     *[Local/0] 00:00:11
                       Local via lo0.0
172.20.0.32/29     *[Direct/0] 00:00:11
                    >  via lo0.0
172.20.0.33/32     *[Local/0] 00:00:11
                       Local via lo0.0
172.20.0.40/29     *[Direct/0] 00:00:11
                    >  via lo0.0
172.20.0.41/32     *[Local/0] 00:00:11
                       Local via lo0.0
172.20.0.232/29    *[Direct/0] 00:00:11
                    >  via lo0.0
172.20.0.233/32    *[Local/0] 00:00:11
                       Local via lo0.0
172.20.0.240/29    *[Direct/0] 00:00:11
                    >  via lo0.0
172.20.0.241/32    *[Local/0] 00:00:11
                       Local via lo0.0
172.20.0.248/29    *[Direct/0] 00:00:11
                    >  via lo0.0
172.20.0.249/32    *[Local/0] 00:00:11
                       Local via lo0.0
```

When aggregating the routes we need to find the closest subnet that will cover all the routes:

Options are: 

*Overly broad aggregation can lead to routing anomalies*
172.20.0.0/26 - will cover the following: 172.20.0.1 - 62 
172.20.0.224/27 -  will cover the following: 172.20.0.225 - 254

or:

172.20.0.0/27 - will cover the following: 172.20.0.1 - 30
172.20.0.240/28  - will cover the following: 172.20.0.241 - 254
*Configuration*
```
anton@r3# show | compare 
[edit routing-options aggregate]
+ route 172.20.0.0/27;
+ route 172.20.0.240/28;

[edit routing-options aggregate]
```


```
anton@r3> show route table inet.0 

inet.0: 23 destinations, 23 routes (23 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.0.1.0/24        *[Direct/0] 00:30:43
                    >  via ge-0/0/1.0
10.0.1.3/32        *[Local/0] 00:30:43
                       Local via ge-0/0/1.0
10.100.100.3/32    *[Direct/0] 00:30:43
                    >  via lo0.0
172.20.0.0/27      *[Aggregate/130] 00:00:17
                       Reject
172.20.0.0/29      *[Direct/0] 00:24:59
                    >  via lo0.0
172.20.0.1/32      *[Local/0] 00:24:59
                       Local via lo0.0
172.20.0.8/29      *[Direct/0] 00:24:59
                    >  via lo0.0
172.20.0.9/32      *[Local/0] 00:24:59
                       Local via lo0.0
172.20.0.16/29     *[Direct/0] 00:24:59
                    >  via lo0.0
172.20.0.17/32     *[Local/0] 00:24:59
                       Local via lo0.0
172.20.0.24/29     *[Direct/0] 00:24:59
                    >  via lo0.0
172.20.0.25/32     *[Local/0] 00:24:59
                       Local via lo0.0
172.20.0.32/29     *[Direct/0] 00:24:59
                    >  via lo0.0
172.20.0.33/32     *[Local/0] 00:24:59
                       Local via lo0.0
172.20.0.40/29     *[Direct/0] 00:24:59
                    >  via lo0.0
172.20.0.41/32     *[Local/0] 00:24:59
                       Local via lo0.0
172.20.0.232/29    *[Direct/0] 00:24:59
                    >  via lo0.0
172.20.0.233/32    *[Local/0] 00:24:59
                       Local via lo0.0
172.20.0.240/28    *[Aggregate/130] 00:00:17
                       Reject
172.20.0.240/29    *[Direct/0] 00:24:59
                    >  via lo0.0
172.20.0.241/32    *[Local/0] 00:24:59
                       Local via lo0.0
172.20.0.248/29    *[Direct/0] 00:24:59
                    >  via lo0.0
172.20.0.249/32    *[Local/0] 00:24:59
                       Local via lo0.0

```

You can see the contributing routes to the aggregate:
```
anton@r3> show route table inet.0 protocol aggregate detail 

inet.0: 23 destinations, 23 routes (23 active, 0 holddown, 0 hidden)
172.20.0.0/27 (1 entry, 1 announced)
        *Aggregate Preference: 130
                Next hop type: Reject, Next hop index: 0
                Address: 0x78992b4
                Next-hop reference count: 4, key opaque handle: 0x0, non-key opaque handle: 0x0
                State: <Active Int Ext>
                Age: 4:08 
                Validation State: unverified 
                Task: Aggregate
                Announcement bits (1): 0-KRT 
                AS path: I  (LocalAgg)
                Flags:                  Depth: 0        Active
                AS path list:
                AS path: I Refcount: 8
                Contributing Routes (8):
                        172.20.0.0/29 proto Direct
                        172.20.0.1/32 proto Local
                        172.20.0.8/29 proto Direct
                        172.20.0.9/32 proto Local
                        172.20.0.16/29 proto Direct
                        172.20.0.17/32 proto Local
                        172.20.0.24/29 proto Direct
                        172.20.0.25/32 proto Local
                Thread: junos-main 

172.20.0.240/28 (1 entry, 1 announced)
        *Aggregate Preference: 130
                Next hop type: Reject, Next hop index: 0
                Address: 0x78992b4
                Next-hop reference count: 4, key opaque handle: 0x0, non-key opaque handle: 0x0
                State: <Active Int Ext>
                Age: 4:08 
                Validation State: unverified 
                Task: Aggregate
                Announcement bits (1): 0-KRT 
                AS path: I  (LocalAgg)
                Flags:                  Depth: 0        Active
                AS path list:
                AS path: I Refcount: 4
                Contributing Routes (4):
                        172.20.0.240/29 proto Direct
                        172.20.0.241/32 proto Local
                        172.20.0.248/29 proto Direct
                        172.20.0.249/32 proto Local
                Thread: junos-main 
```


##### Scenario 2 - aggregated routes redistribution

Although OSPF is not covered in this lab we will set up a quick OSPF between `r2` and `r3` and redistribute the aggregate to see the results

*Configuration*
```
anton@r2# run show configuration | match ospf | display set 
set policy-options policy-statement CONNECTED-TO-OSPF from protocol direct
set policy-options policy-statement CONNECTED-TO-OSPF then accept
set protocols ospf area 0.0.0.0 interface ge-0/0/1.0
set protocols ospf export CONNECTED-TO-OSPF
```

*Configuration*
```
anton@r3# run show configuration | match ospf | display set 
set policy-options policy-statement AGGREGATE-TO-OSPF from protocol aggregate
set policy-options policy-statement AGGREGATE-TO-OSPF then accept
set protocols ospf area 0.0.0.0 interface ge-0/0/1.0
set protocols ospf export AGGREGATE-TO-OSPF
```


```
anton@r2> show ospf neighbor          
Address          Interface              State           ID               Pri  Dead
10.0.1.3         ge-0/0/1.0             Full            10.100.100.3     128    37

anton@r2> show route protocol ospf    

inet.0: 10 destinations, 10 routes (10 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

172.20.0.0/27      *[OSPF/150] 00:00:41, metric 0, tag 0
                    >  to 10.0.1.3 via ge-0/0/1.0
172.20.0.240/28    *[OSPF/150] 00:00:41, metric 0, tag 0
                    >  to 10.0.1.3 via ge-0/0/1.0
224.0.0.5/32       *[OSPF/10] 00:04:04, metric 1
                       MultiRecv

mgmt_junos.inet.0: 3 destinations, 3 routes (3 active, 0 holddown, 0 hidden)

inet6.0: 1 destinations, 1 routes (1 active, 0 holddown, 0 hidden)

anton@r2> 
```


```
anton@r3> show route protocol ospf 

inet.0: 27 destinations, 27 routes (27 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.0.0.0/24        *[OSPF/150] 00:02:34, metric 0, tag 0
                    >  to 10.0.1.2 via ge-0/0/1.0
10.20.20.0/24      *[OSPF/150] 00:02:34, metric 0, tag 0
                    >  to 10.0.1.2 via ge-0/0/1.0
10.100.100.2/32    *[OSPF/150] 00:02:34, metric 0, tag 0
                    >  to 10.0.1.2 via ge-0/0/1.0
224.0.0.5/32       *[OSPF/10] 00:10:13, metric 1
                       MultiRecv

mgmt_junos.inet.0: 3 destinations, 3 routes (3 active, 0 holddown, 0 hidden)

inet6.0: 1 destinations, 1 routes (1 active, 0 holddown, 0 hidden)
```

As a result with static default route on `r1` towards `r2` and OSPF between `r2` and `r3` redistributing direct routes from `r2` to `r3` and aggregate routes from `r3` to `r2` we have a reachability between `r1` and loopbacks on `r3` (*that were aggregated*)

```
anton@r1> ping 172.20.0.1 
PING 172.20.0.1 (172.20.0.1): 56 data bytes
64 bytes from 172.20.0.1: icmp_seq=0 ttl=63 time=1.441 ms
64 bytes from 172.20.0.1: icmp_seq=1 ttl=63 time=1.257 ms
^C
--- 172.20.0.1 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max/stddev = 1.257/1.349/1.441/0.092 ms
```

## Open Shortest Path First
## Intermediate System to Intermediate System
## Border Gateway Protocol
## Layer 2 Bridging
## Spanning-Tree Protocols
## Multiprotocol Label Switching
## IPv6
## Tunnels
## High Availability

