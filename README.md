# MikroTik-Based RT/RW Net Network Simulation

[![GNS3](https://img.shields.io/badge/GNS3-Network%20Simulator-green)](https://www.gns3.com/)
[![MikroTik](https://img.shields.io/badge/MikroTik-RouterOS-blue)](https://mikrotik.com/)
[![License](https://img.shields.io/badge/License-Educational-orange)](https://github.com)

A comprehensive RT/RW Net network infrastructure simulation using MikroTik devices in GNS3, demonstrating implementation of wireless Point-to-Point (PtP) backbone, PCQ-based bandwidth management, and VLAN segmentation for efficient and affordable community internet distribution.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Network Architecture](#network-architecture)
- [Topology](#topology)
- [Key Features](#key-features)
- [VLAN Segmentation](#vlan-segmentation)
- [Technologies Used](#technologies-used)
- [Device Specifications](#device-specifications)
- [Device Configuration](#device-configuration)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Testing Results](#testing-results)
- [Complete Documentation](#complete-documentation)

---

## 🎯 Overview

This project is a comprehensive **RT/RW Net** (Neighborhood Network) simulation that implements best practices in community internet distribution. Inspired by real-world RT/RW Net implementations in Indonesia that provide affordable internet access to communities, particularly in areas with infrastructure limitations.

### Background

RT/RW Net first emerged around 1996 as a solution to share expensive internet costs. This concept remains highly relevant today, especially in remote areas that require wireless solutions to overcome geographical challenges such as hills or long distances where fiber optic cable deployment is not economical.

### Project Objectives

- **Efficient Internet Distribution**: Distribute a single ISP internet source to ~100 users
- **Wireless Backbone**: Point-to-Point (PtP) implementation for long-distance CITY → VILLAGE connectivity
- **Fair Bandwidth Management**: Quality of Service (QoS) using PCQ for proportional bandwidth allocation
- **Network Segmentation**: VLAN for separating management and user traffic
- **Scalability**: Design that supports user and area expansion

---

## 🏗️ Network Architecture

The network is designed with two main locations connected by a wireless backbone:

### **CITY Location (Internet Source)**

- **Gateway Router** (MikroTik RB750Gr3): ISP connection termination and NAT
- **PtP Transmitter Antenna** (MikroTik LHG XL 5ac): Transmitter to village location

### **VILLAGE Location (User Area)**

- **PtP Receiver Antenna** (MikroTik LHG XL 5ac): Receiver from city location
- **Core Router** (MikroTik RB4011iGS+RM): Management center (Routing, DHCP, NAT, QoS)
- **Core Switch** (Ruijie RG-ES228GS-P): VLAN aggregation and distribution
- **Aggregation Switches** (Ruijie RG-ES220GS-P): Port expansion for user areas
- **Base Station** (Ubiquiti Rocket M5 + Sectoral MIMO): Point-to-MultiPoint for wide coverage
- **CPE** (Ubiquiti LBE-M5-23): Customer premises equipment
- **Indoor AP** (TP-Link TL-WR840N): Local Wi-Fi at user premises

---

## 🗺️ Topology

### Data Flow

```
ISP → Gateway Router (CITY) → PtP Wireless Backbone → Core Router (VILLAGE)
    → Core Switch → [LAN Cable / Wireless PtMP] → User
```

### Topology Diagram

Complete visualizations are available in the `diagrams/` folder:

- **Conceptual Topology Design** - Initial network design blueprint
- **GNS3 Topology Implementation** - Simulation implementation screenshot

### Network Links

- **Backbone**: Wireless PtP (MikroTik LHG XL 5ac) - CITY ↔ VILLAGE
- **Cable Distribution**: Aggregation switch for users <80m
- **Wireless Distribution**: Base Station (Ubiquiti) for users >80m

---

## ✨ Key Features

### Network Design

- ✅ **Wireless Backbone**: Long-distance PtP link with MikroTik LHG
- ✅ **Bridge Mode**: Layer 2 transparency for VLAN traffic
- ✅ **VLAN Segmentation**: Separation of management and user traffic
- ✅ **Dual Distribution**: Cable (LAN) and Wireless (PtMP)

### Bandwidth Management

- 🚀 **PCQ (Per Connection Queue)**: Automatic and fair bandwidth distribution
- 🚀 **Simple Queue**: Bandwidth limitation per user subnet
- 🚀 **Dynamic Allocation**: Bandwidth divided according to active user count
- 🚀 **1:3 Ratio**: Download:Upload optimization (560k:186k)

### Services & Routing

- 🔄 **DHCP Server**: Automatic IP allocation for users (VLAN 20)
- 🔄 **Static Routing**: Inter-segment network routing
- 🔄 **NAT Masquerade**: Single public IP shared for all users
- 🔄 **DNS Server**: Google DNS (8.8.8.8) and Cloudflare (1.1.1.1)

### Security

- 🔒 **VLAN Isolation**: Separation of management and user traffic
- 🔒 **Firewall Rules**: Filter and forward policies
- 🔒 **Network Segmentation**: Logical network isolation

---

## 🔧 VLAN Segmentation

The network uses two main VLANs managed by the Core Router:

| VLAN ID | Name         | Network       | Gateway    | Function                                                 |
| ------- | ------------ | ------------- | ---------- | -------------------------------------------------------- |
| VLAN 10 | Management   | 172.16.0.0/24 | 172.16.0.1 | Device management network (Static IP)                    |
| VLAN 20 | User Network | 172.16.1.0/24 | 172.16.1.1 | User network with DHCP (Pool: 172.16.1.2 - 172.16.1.254) |

### Management IP Allocation (VLAN 10)

| Device                   | IP Address | Location |
| ------------------------ | ---------- | -------- |
| Core Router (RB4011)     | 172.16.0.1 | VILLAGE  |
| PtP Receiver (LHG #2)    | 172.16.0.2 | VILLAGE  |
| PtP Transmitter (LHG #1) | 172.16.0.3 | CITY     |
| Gateway Router (RB750)   | 172.16.0.4 | CITY     |

---

## 🛠️ Technologies Used

### Hardware (Simulation)

- **MikroTik RB4011iGS+RM**: Core router with 10 Gigabit ports
- **MikroTik RB750Gr3**: 5-port gateway router for ISP termination
- **MikroTik LHG XL 5ac**: 27dBi dual-chain PtP antenna for backbone
- **Ruijie RG-ES228GS-P**: 28-port PoE switch for core
- **Ruijie RG-ES220GS-P**: 20-port PoE switch for aggregation
- **Ubiquiti Rocket M5**: Base station with sectoral antenna
- **Ubiquiti LBE-M5-23**: 23dBi CPE for client premises

### Software & Platform

- **MikroTik RouterOS**: v7.20 (CHR for simulation)
- **GNS3**: Network simulation and emulation platform
- **VMware Workstation**: Hypervisor for running CHR

### Key Protocols & Technologies

- **Bridging**: Layer 2 bridge for PtP transparency
- **VLAN (802.1Q)**: Logical network segmentation
- **DHCP**: Dynamic Host Configuration Protocol
- **NAT**: Network Address Translation (Masquerade)
- **QoS**: Quality of Service with PCQ
- **Static Routing**: Inter-VLAN routing

---

## 💰 Device Specifications

### Core Infrastructure Cost Estimation

| No  | Device                            | Qty | Unit Price (IDR) | Total (IDR)       |
| --- | --------------------------------- | --- | ---------------- | ----------------- |
| 1   | MikroTik RB750Gr3                 | 1   | 1,020,000        | 1,020,000         |
| 2   | MikroTik RB4011iGS+RM             | 1   | 4,099,000        | 4,099,000         |
| 3   | MikroTik LHG XL 5ac               | 2   | 2,109,000        | 4,218,000         |
| 4   | Tower Triangle                    | 2   | 1,200,000        | 2,400,000         |
| 5   | Ruijie RG-ES228GS-P (Core)        | 1   | 5,500,000        | 5,500,000         |
| 6   | Ruijie RG-ES220GS-P (Aggregation) | 2   | 9,011,000        | 18,022,000        |
| 7   | Sectoral MIMO 20 dBi              | 1   | 3,100,000        | 3,100,000         |
| 8   | Rocket M5 (Base Station)          | 1   | 831,979          | 831,979           |
|     |                                   |     | **CORE TOTAL**   | **~IDR 39.2 Mil** |

**Per-Customer Equipment** (scaled based on user count):

- Ubiquiti LBE-M5-23 (CPE): ~IDR 1,020,000/unit
- TP-Link TL-WR840N (Indoor AP): ~IDR 199,000/unit
- POE Injector 24V: ~IDR 150,000/unit

---

## 📝 Device Configuration

### 1️⃣ MikroTik RB4011iGS+RM (Core Router - Network Brain)

**Function**: Network management center at VILLAGE side

```routeros
# Interface VLAN
/interface vlan
add interface=ether1 name=vlan10-manajemen vlan-id=10
add interface=ether1 name=vlan20-users vlan-id=20

# IP Address & Gateway
/ip address
add address=172.16.0.1/24 interface=vlan10-manajemen
add address=172.16.1.1/24 interface=vlan20-users

# DHCP Server untuk User (VLAN 20)
/ip pool
add name=pool_vlan20 ranges=172.16.1.2-172.16.1.254

/ip dhcp-server
add address-pool=pool_vlan20 interface=vlan20-users name=dhcp_vlan20

/ip dhcp-server network
add address=172.16.1.0/24 gateway=172.16.1.1 dns-server=8.8.8.8,1.1.1.1

# QoS - PCQ untuk pembagian bandwidth adil
/queue type
add name=pcq-download kind=pcq pcq-classifier=dst-address pcq-rate=140k
add name=pcq-upload kind=pcq pcq-classifier=src-address pcq-rate=46k

/queue simple
add name="bandwidth-management" target=172.16.1.0/24 \
    queue=pcq-download/pcq-upload max-limit=560k/186k

# Routing ke Gateway
/ip route
add dst-address=0.0.0.0/0 gateway=172.16.0.4
```

**Complete Configuration**: [`configs/MikroTik-RB4011iGS+RM-1.rsc`](configs/MikroTik-RB4011iGS+RM-1.rsc)

---

### 2️⃣ MikroTik RB750Gr3 (Gateway Router - ISP Termination)

**Function**: ISP gateway at CITY side

```routeros
# DHCP Client ke ISP
/ip dhcp-client
add interface=ether1

# IP Address untuk VLAN 10
/ip address
add address=172.16.0.4/24 interface=ether2

# NAT untuk internet forwarding
/ip firewall nat
add chain=srcnat action=masquerade out-interface=ether1

# DNS Server
/ip dns
set servers=8.8.8.8,1.1.1.1 allow-remote-requests=yes
```

**Complete Configuration**: [`configs/MikroTik-RB750Gr3.rsc`](configs/MikroTik-RB750Gr3.rsc)

---

### 3️⃣ MikroTik LHG XL 5ac (Point-to-Point Backbone)

**Function**: Wireless backbone CITY ↔ VILLAGE (Layer 2 Bridge Mode)

#### **LHG #1 - Transmitter (CITY)**

```routeros
# Bridge Interface
/interface bridge
add name=bridge-ptp

/interface bridge port
add bridge=bridge-ptp interface=ether1
add bridge=bridge-ptp interface=ether2

# IP Address
/ip address
add address=172.16.0.3/24 interface=bridge-ptp

# Default Route
/ip route
add dst-address=0.0.0.0/0 gateway=172.16.0.1
```

**Complete Configuration**: [`configs/MikroTik-LHGXL5ac-1.rsc`](configs/MikroTik-LHGXL5ac-1.rsc)

#### **LHG #2 - Receiver (VILLAGE)**

```routeros
# Bridge Interface
/interface bridge
add name=bridge-ptp

/interface bridge port
add bridge=bridge-ptp interface=ether1
add bridge=bridge-ptp interface=ether2

# IP Address
/ip address
add address=172.16.0.2/24 interface=bridge-ptp

# Default Route
/ip route
add dst-address=0.0.0.0/0 gateway=172.16.0.1
```

**Complete Configuration**: [`configs/MikroTik-LHGXL5ac-2.rsc`](configs/MikroTik-LHGXL5ac-2.rsc)

---

### 4️⃣ Switch Configuration

**Core Switch (Ruijie RG-ES228GS-P)**

- Port to Core Router: **Trunk** (VLAN 10, 20)
- Port to PtP Antenna: **Access VLAN 10**
- Port to Base Station: **Trunk** (VLAN 10, 20)
- Port to Aggregation Switch: **Access VLAN 20**
- Port to Cable User: **Access VLAN 20**

**Aggregation Switch (Ruijie RG-ES220GS-P)**

- All ports: **Access VLAN 20** (dedicated for users)

---

## 🚀 Getting Started

### Prerequisites

1. **GNS3** (Version 2.2+)

   ```bash
   # Download from https://www.gns3.com/software/download
   ```

2. **MikroTik CHR Image**

   ```bash
   # Download CHR image for GNS3
   # https://mikrotik.com/download
   ```

3. **VMware Workstation** (or VirtualBox)
   - For running GNS3 VM

### Installation Steps

1. **Clone repository**

   ```bash
   git clone https://github.com/AhmadSyafiNurroyyan/rtrwnet-network-design
   cd rtrwnet-network-design
   ```

2. **Import GNS3 Project**

   - Open GNS3
   - File → Import portable project
   - Select project file from `link_gns3_project.md` folder

3. **Load Configuration**

   - Configurations are already saved in the project
   - For manual reload, copy from `configs/` folder
   - Paste into respective device terminals

4. **Run Simulation**
   - Click "Start All Nodes" in GNS3
   - Wait for all devices to boot (~2-3 minutes)
   - Verify connectivity

### Verification Commands

```bash
# Check interfaces and IP addresses
/ip address print

# Verify VLAN
/interface vlan print

# Check DHCP leases
/ip dhcp-server lease print

# Test routing
/ip route print

# Monitor bandwidth (real-time)
/queue simple print stats

# Test connectivity
/ping 172.16.0.1
/ping 8.8.8.8
```

---

## 📂 Project Structure

```
rtrwnet-network-design/
├── README.md                              # Project documentation
├── link_gns3_project.md                   # GNS3 project download link
├── configs/                               # Device configurations
│   ├── MikroTik-RB4011iGS+RM-1.rsc       # Core router (VILLAGE)
│   ├── MikroTik-RB750Gr3.rsc             # Gateway router (CITY)
│   ├── MikroTik-LHGXL5ac-1.rsc           # PtP transmitter (CITY)
│   └── MikroTik-LHGXL5ac-2.rsc           # PtP receiver (VILLAGE)
├── diagrams/                              # Topology diagrams
│   ├── Topology Design.jpg
│   └── Topology Implementation in GNS3.png
└── doc/                                   # Complete documentation
    └── Full_Documentation_Portfolio_RTRWNet.pdf
```

---

## 🧪 Testing Results

### ✅ DHCP & IP Allocation Testing

**Test**: User PC connected to VLAN 20 and receives automatic IP

**Result**:

- IP received from pool: `172.16.1.2 - 172.16.1.254`
- Gateway: `172.16.1.1`
- DNS: `8.8.8.8`, `1.1.1.1`

### ✅ Internet Connectivity Testing

**Test**: Ping to Google public DNS

```bash
ping 8.8.8.8
# Result: 64 bytes from 8.8.8.8: icmp_seq=1 ttl=56 time=12.3 ms
```

**Status**: ✅ Internet connection successful

### ✅ Bandwidth Management Testing (QoS)

**Condition**: 4 active hosts with PCQ rate 140k download / 46k upload

**Test**: Speedtest on each user

| Metric       | Before QoS | After QoS (4 active users) |
| ------------ | ---------- | -------------------------- |
| Download     | ~560 kbps  | ~140 kbps/user             |
| Upload       | ~920 kbps  | ~46 kbps/user              |
| Distribution | Uneven     | Even for all users         |

**Result**: ✅ Bandwidth fairly distributed according to PCQ configuration

### 📊 Testing Conclusion

All configurations work as designed:

- ✅ DHCP Server functioning normally
- ✅ Internet connectivity stable
- ✅ QoS with PCQ distributes bandwidth fairly
- ✅ VLAN isolation working properly
- ✅ PtP bridge mode transparent for all traffic

---

## 📚 Complete Documentation

### Comprehensive Technical Documentation

For in-depth understanding of:

- **Theoretical Foundation**: RT/RW Net concept, computer networking, DNS, VLAN
- **Detailed Design**: Device selection, cost estimation
- **Step-by-Step Configuration**: Complete guide with screenshots
- **Results Analysis**: Testing and troubleshooting

📄 **View**: [`doc/Full_Documentation_Portfolio_RTRWNet.pdf`](doc/Full_Documentation_Portfolio_RTRWNet.pdf)

---

## 🎓 Key Learnings

This project demonstrates:

1. **Wireless Networking**: Long-distance PtP backbone implementation
2. **Bridge Mode**: Layer 2 transparency for VLAN traffic
3. **QoS Management**: PCQ for fair and dynamic bandwidth distribution
4. **Network Segmentation**: VLAN for management and user isolation
5. **Scalable Design**: Architecture that supports user expansion
6. **Community Networking**: Community-based internet distribution concept

---

## 💡 Inspiration & Context

This project is inspired by real-world RT/RW Net implementations in Indonesia, particularly research by **Husaini & Sari (Muhammadiyah University of North Sumatra)** on RT/RW Net implementation in Dusun V Suka Damai, Desa Sei Meran.

RT/RW Net proves that network innovation can provide **direct social impact** by providing affordable internet access to communities, becoming a smart solution amid infrastructure limitations.

---

## 👤 Author

**Ahmad Syafi Nurroyyan**

- 🔗 LinkedIn: [ahmad-syafi-nurroyyan](https://www.linkedin.com/in/ahmad-syafi-nurroyyan-34ab81321/)
- 💻 GitHub: [@AhmadSyafiNurroyyan](https://github.com/AhmadSyafiNurroyyan)
- 📧 Email: ahmadsyafinurroyyan@gmail.com

---

## 📄 License

This project is available for **educational and portfolio purposes**. Feel free to use as a reference for RT/RW Net implementation or your network engineering projects.

---

## 🙏 Acknowledgments

- **Mr. Onno W. Purbo** - Pioneer and inspiration for RT/RW Net in Indonesia
- **MikroTik** - Powerful and flexible RouterOS platform
- **GNS3 Community** - Excellent network simulation platform
- **UMM Researchers (1996)** - Pioneers of the first RT/RW Net concept in Indonesia
- **Indonesian RT/RW Net Community** - For sharing knowledge and experience

---

## 📞 Contact & Collaboration

Interested in discussing network engineering, RT/RW Net, or project collaboration?

Feel free to reach out! 🚀

---

**⭐ If this project is helpful, please consider giving it a star!**

---

_Last Updated: January 2026_
