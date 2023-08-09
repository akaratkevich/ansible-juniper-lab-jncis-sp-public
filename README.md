
>[!INFO]
> These labs are part of my preparation for [JNCIS-SP](https://www.juniper.net/gb/en/training/certification/tracks/service-provider-routing-switching/jncis-sp.html) certification. 
Learn by doing has always been my approach to learning. The idea here was to have multiple labs available that cover all possible topics in this exam track (*limited by virtualization caveats*) 


The labs are broken down by [exam objectives](https://www.juniper.net/gb/en/training/certification/tracks/service-provider-routing-switching/jncis-sp.html)

- Protocol-Independent Routing
- Open Shortest Path First (OSPF)
- Intermediate System to Intermediate System (IS-IS)
- Border Gateway Protocol (BGP)
- Layer 2 Bridging or VLANs
- Spanning-Tree Protocols
- Multiprotocol Label Switching (MPLS)
- IPv6
- Tunnels
- High Availability

Individual labs are deployed with base configuration via Makefile, on the back of the [Containerlab](https://containerlab.dev/) Ansible and few other scripts. Base configuration refers to any prerequisites, such as interface description, ip assignments etc. to allow you jump straight into the learning objective(s) in question. 

>[!PREREQUISITES]
> - Containerlab setup and running
> - Ansible setup and running with respective Ansible-Galaxy collections/modules installed
> - Docker images
> - Jinja2 installed
> - Expect installed


>[!ADMINISTRATION]
>Please make sure to verify and update any paths and username referenced in any playbooks or scripts or variables

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


### Objectives

Demo of staring the lab:

```
anton@mcc:~/git_hub/ansible-juniper-lab-jncis-sp-public$ make start-pir 
Executing playbook to deploy Protocol Independent Routing topology with nodes r1,r2,r3
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details
Enter the sudo password: 

PLAY [Deploy Containerlab Topology] ****************************************************************************************************************************

TASK [Run clab deploy command] *********************************************************************************************************************************
changed: [localhost]

TASK [Wait for the deployment to complete] *********************************************************************************************************************
Pausing for 180 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [localhost]

TASK [Check Docker containers status] **************************************************************************************************************************
changed: [localhost]

TASK [Check for healthy status] ********************************************************************************************************************************
ok: [localhost] => {
    "msg": "All containers are healthy"
}

PLAY RECAP *****************************************************************************************************************************************************
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

PLAY [vr-vmx] **************************************************************************************************************************************************

TASK [Include variables from r1.yml] ***************************************************************************************************************************
skipping: [r2]
skipping: [r3]
ok: [r1]

TASK [Include variables from r2.yml] ***************************************************************************************************************************
skipping: [r1]
skipping: [r3]
ok: [r2]

TASK [Include variables from r3.yml] ***************************************************************************************************************************
skipping: [r1]
skipping: [r2]
ok: [r3]

TASK [Render configuration template] ***************************************************************************************************************************
ok: [r2]
changed: [r1]
ok: [r3]

PLAY RECAP *****************************************************************************************************************************************************
r1                         : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
r2                         : ok=2    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
r3                         : ok=2    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   

Running playbook to configure nodes
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details

PLAY [Load and commit base configuration] **********************************************************************************************************************

TASK [Load configuration from a local file and commit] *********************************************************************************************************
changed: [r2]
changed: [r3]
changed: [r1]

TASK [Print the response] **************************************************************************************************************************************
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
ok: [r1] => {
    "response": {
        "changed": true,
        "diff": {
            "prepared": "\n[edit interfaces]\n+   ge-0/0/0 {\n+       description \"Link from R1 to R2\";\n+       unit 0 {\n+           family inet {\n+               address 10.0.0.1/24;\n+           }\n+       }\n+   }\n+   lo0 {\n+       unit 0 {\n+           family inet {\n+               address 10.100.100.1/32;\n+           }\n+       }\n+   }\n"
        },
        "diff_lines": [
            "",
            "[edit interfaces]",
            "+   ge-0/0/0 {",
            "+       description \"Link from R1 to R2\";",
            "+       unit 0 {",
            "+           family inet {",
            "+               address 10.0.0.1/24;",
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
ok: [r2] => {
    "response": {
        "changed": true,
        "diff": {
            "prepared": "\n[edit interfaces]\n+   ge-0/0/0 {\n+       description \"Link from R2 to R1\";\n+       unit 0 {\n+           family inet {\n+               address 10.0.0.2/24;\n+           }\n+       }\n+   }\n+   ge-0/0/1 {\n+       description \"Link from R2 to R3\";\n+       unit 0 {\n+           family inet {\n+               address 10.0.1.2/24;\n+           }\n+       }\n+   }\n+   lo0 {\n+       unit 0 {\n+           family inet {\n+               address 10.100.100.2/32;\n+           }\n+       }\n+   }\n"
        },
        "diff_lines": [
            "",
            "[edit interfaces]",
            "+   ge-0/0/0 {",
            "+       description \"Link from R2 to R1\";",
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

PLAY RECAP *****************************************************************************************************************************************************
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

#### Static routes

Starting state on `r1`
```
anton@r1> show interfaces descriptions 
Interface       Admin Link Description
ge-0/0/0        up    up   Link from R1 to R2

anton@r1> show interfaces terse | match "ge-0/0/0|lo"    
Interface               Admin Link Proto    Local                 Remote
ge-0/0/0                up    up
ge-0/0/0.0              up    up   inet     10.0.0.1/24     
lo0                     up    up
lo0.0                   up    up   inet     10.100.100.1        --> 0/0
lo0.16384               up    up   inet     127.0.0.1           --> 0/0
lo0.16385               up    up   inet 

anton@r1> show route  

inet.0: 3 destinations, 3 routes (3 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.0.0.0/24        *[Direct/0] 00:06:15
                    >  via ge-0/0/0.0
10.0.0.1/32        *[Local/0] 00:06:15
                       Local via ge-0/0/0.0
10.100.100.1/32    *[Direct/0] 00:06:15
                    >  via lo0.0
```

Starting state on `r2`
```
anton@r2> show interfaces descriptions 
Interface       Admin Link Description
ge-0/0/0        up    up   Link from R2 to R1
ge-0/0/1        up    up   Link from R2 to R3

anton@r2> show interfaces terse | match "ge-0/0/0|lo"    
Interface               Admin Link Proto    Local                 Remote
ge-0/0/0                up    up
ge-0/0/0.0              up    up   inet     10.0.0.2/24     
lo0                     up    up
lo0.0                   up    up   inet     10.100.100.2        --> 0/0
lo0.16384               up    up   inet     127.0.0.1           --> 0/0
lo0.16385               up    up   inet    

anton@r2> show route 

inet.0: 5 destinations, 5 routes (5 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.0.0.0/24        *[Direct/0] 00:09:38
                    >  via ge-0/0/0.0
10.0.0.2/32        *[Local/0] 00:09:38
                       Local via ge-0/0/0.0
10.0.1.0/24        *[Direct/0] 00:09:38
                    >  via ge-0/0/1.0
10.0.1.2/32        *[Local/0] 00:09:38
                       Local via ge-0/0/1.0
10.100.100.2/32    *[Direct/0] 00:09:38
                    >  via lo0.0
```

Starting state on `r3`
```
anton@r3> show interfaces descriptions 
Interface       Admin Link Description
ge-0/0/1        up    up   Link from R3 to R2

anton@r3> show interfaces terse | match "ge-0/0/0|lo" 
Interface               Admin Link Proto    Local                 Remote
ge-0/0/0                up    up
ge-0/0/0.16386          up    up  
lo0                     up    up
lo0.0                   up    up   inet     10.100.100.3        --> 0/0
lo0.16384               up    up   inet     127.0.0.1           --> 0/0
lo0.16385               up    up   inet    

anton@r3> show route 

inet.0: 3 destinations, 3 routes (3 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.0.1.0/24        *[Direct/0] 00:11:04
                    >  via ge-0/0/1.0
10.0.1.3/32        *[Local/0] 00:11:04
                       Local via ge-0/0/1.0
10.100.100.3/32    *[Direct/0] 00:11:04
                    >  via lo0.0
```

##### Scenario 1 - simple static route

##### **Basic Next-Hop**:

In a regular static route, you have a destination network and a next-hop (or exit interface) through which traffic destined for that network is sent.

>[!ERROR]
>anton@r1> ping 10.100.100.2 
PING 10.100.100.2 (10.100.100.2): 56 data bytes
ping: sendto: No route to host
ping: sendto: No route to host
ping: sendto: No route to host

Add a static route on `r1` to `r2` lo0 10.100.100.2 via directly connected interface
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

>[!SUCCESS]
>anton@r1# run ping 10.100.100.2 
PING 10.100.100.2 (10.100.100.2): 56 data bytes
64 bytes from 10.100.100.2: icmp_seq=0 ttl=64 time=1.049 ms
64 bytes from 10.100.100.2: icmp_seq=1 ttl=64 time=1.180 ms

##### Scenario 2 - qualified next-hop

>[!INFO] I have added a secondary link between `r1` and `r2` in the clab topology file

##### **Qualified Next-Hop**:

With qualified next-hop, you can specify multiple next-hops for the same destination, each with different properties such as preference, weight, or color. This allows for more granular control over how traffic is routed to a destination.

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


```
anton@r1> show route 10.100.100.2 exact    

inet.0: 6 destinations, 7 routes (6 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.100.100.2/32    *[Static/5] 00:00:19
                    >  to 10.0.0.2 via ge-0/0/0.0
                    [Static/6] 00:00:19
                    >  to 10.20.20.2 via ge-0/0/2.0
```


```
anton@r1> show route    

inet.0: 6 destinations, 7 routes (6 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.0.0.0/24        *[Direct/0] 01:53:50
                    >  via ge-0/0/0.0
10.0.0.1/32        *[Local/0] 01:53:50
                       Local via ge-0/0/0.0
10.20.20.0/24      *[Direct/0] 01:53:50
                    >  via ge-0/0/2.0
10.20.20.1/32      *[Local/0] 01:53:50
                       Local via ge-0/0/2.0
10.100.100.1/32    *[Direct/0] 01:53:50
                    >  via lo0.0
10.100.100.2/32    *[Static/5] 00:03:56
                    >  to 10.0.0.2 via ge-0/0/0.0
                    [Static/6] 00:03:56
                    >  to 10.20.20.2 via ge-0/0/2.0
```

If we shutdown one of the interfaces the route switches over to the qualified next-hop:
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

