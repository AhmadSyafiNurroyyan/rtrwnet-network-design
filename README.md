# Simulasi Jaringan RT/RW Net Berbasis MikroTik

[![GNS3](https://img.shields.io/badge/GNS3-Network%20Simulator-green)](https://www.gns3.com/)
[![MikroTik](https://img.shields.io/badge/MikroTik-RouterOS-blue)](https://mikrotik.com/)
[![License](https://img.shields.io/badge/License-Educational-orange)](https://github.com)

Simulasi infrastruktur jaringan RT/RW Net lengkap menggunakan perangkat MikroTik di GNS3, mendemonstrasikan implementasi wireless backbone Point-to-Point (PtP), manajemen bandwidth dengan PCQ, dan segmentasi VLAN untuk distribusi internet komunitas yang efisien dan terjangkau.

---

## 📋 Daftar Isi

- [Ikhtisar](#ikhtisar)
- [Arsitektur Jaringan](#arsitektur-jaringan)
- [Topologi](#topologi)
- [Fitur Utama](#fitur-utama)
- [Segmentasi VLAN](#segmentasi-vlan)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Spesifikasi Perangkat](#spesifikasi-perangkat)
- [Konfigurasi Perangkat](#konfigurasi-perangkat)
- [Memulai](#memulai)
- [Struktur Project](#struktur-project)
- [Hasil Pengujian](#hasil-pengujian)
- [Dokumentasi Lengkap](#dokumentasi-lengkap)

---

## 🎯 Ikhtisar

Project ini merupakan simulasi perancangan jaringan **RT/RW Net** (Rukun Tetangga/Rukun Warga Network) yang mengimplementasikan best practices dalam distribusi internet komunitas. Terinspirasi dari implementasi nyata RT/RW Net di Indonesia yang memberikan akses internet terjangkau bagi masyarakat, khususnya di daerah dengan keterbatasan infrastruktur.

### Latar Belakang

RT/RW Net pertama kali muncul sekitar tahun 1996 sebagai solusi berbagi biaya internet yang mahal. Konsep ini masih sangat relevan hingga kini, terutama di daerah pelosok yang memerlukan solusi nirkabel untuk mengatasi tantangan geografis seperti perbukitan atau jarak jauh dimana penarikan kabel fiber optik tidak ekonomis.

### Tujuan Project

- **Distribusi Internet Efisien**: Mendistribusikan satu sumber internet ISP ke ~100 pengguna
- **Wireless Backbone**: Implementasi Point-to-Point (PtP) untuk jarak jauh KOTA → DESA
- **Manajemen Bandwidth Adil**: Quality of Service (QoS) menggunakan PCQ untuk pembagian bandwidth proporsional
- **Segmentasi Jaringan**: VLAN untuk memisahkan lalu lintas manajemen dan pengguna
- **Skalabilitas**: Desain yang mendukung ekspansi pengguna dan area

---

## 🏗️ Arsitektur Jaringan

Jaringan dirancang dengan dua lokasi utama yang dihubungkan oleh wireless backbone:

### **Lokasi KOTA (Sumber Internet)**

- **Router Gateway** (MikroTik RB750Gr3): Terminasi koneksi ISP dan NAT
- **Antenna PtP Transmitter** (MikroTik LHG XL 5ac): Pemancar ke lokasi desa

### **Lokasi DESA (Area Pengguna)**

- **Antenna PtP Receiver** (MikroTik LHG XL 5ac): Penerima dari lokasi kota
- **Router Inti** (MikroTik RB4011iGS+RM): Pusat manajemen (Routing, DHCP, NAT, QoS)
- **Core Switch** (Ruijie RG-ES228GS-P): Agregasi dan distribusi VLAN
- **Aggregation Switches** (Ruijie RG-ES220GS-P): Ekspansi port untuk area pengguna
- **Base Station** (Ubiquiti Rocket M5 + Sectoral MIMO): Point-to-MultiPoint untuk jangkauan luas
- **CPE** (Ubiquiti LBE-M5-23): Perangkat di rumah pengguna
- **AP Indoor** (TP-Link TL-WR840N): Wi-Fi lokal di rumah pengguna

---

## 🗺️ Topologi

### Alur Data

```
ISP → Router Gateway (KOTA) → PtP Wireless Backbone → Router Inti (DESA)
    → Core Switch → [Kabel LAN / Wireless PtMP] → User
```

### Diagram Topologi

Visualisasi lengkap tersedia dalam folder `diagrams/`:

- **Desain Topologi Konseptual** - Blueprint awal desain jaringan
- **Implementasi Topologi GNS3** - Screenshot implementasi simulasi

### Link Jaringan

- **Backbone**: Wireless PtP (MikroTik LHG XL 5ac) - KOTA ↔ DESA
- **Distribusi Kabel**: Switch agregasi untuk pengguna <80m
- **Distribusi Wireless**: Base Station (Ubiquiti) untuk pengguna >80m

---

## ✨ Fitur Utama

### Desain Jaringan

- ✅ **Wireless Backbone**: Link PtP jarak jauh dengan MikroTik LHG
- ✅ **Bridge Mode**: Layer 2 transparan untuk VLAN traffic
- ✅ **Segmentasi VLAN**: Pemisahan manajemen dan pengguna
- ✅ **Dual Distribution**: Kabel (LAN) dan Nirkabel (PtMP)

### Manajemen Bandwidth

- 🚀 **PCQ (Per Connection Queue)**: Pembagian bandwidth otomatis dan adil
- 🚀 **Simple Queue**: Limitasi bandwidth per subnet pengguna
- 🚀 **Dynamic Allocation**: Bandwidth dibagi sesuai jumlah pengguna aktif
- 🚀 **Rasio 1:3**: Download:Upload optimization (560k:186k)

### Layanan & Routing

- 🔄 **DHCP Server**: Alokasi IP otomatis untuk pengguna (VLAN 20)
- 🔄 **Static Routing**: Routing antar segmen jaringan
- 🔄 **NAT Masquerade**: Berbagi satu IP publik untuk semua pengguna
- 🔄 **DNS Server**: Google DNS (8.8.8.8) dan Cloudflare (1.1.1.1)

### Keamanan

- 🔒 **VLAN Isolation**: Pemisahan lalu lintas manajemen dan pengguna
- 🔒 **Firewall Rules**: Filter dan forward policy
- 🔒 **Network Segmentation**: Isolasi jaringan logis

---

## 🔧 Segmentasi VLAN

Jaringan menggunakan dua VLAN utama yang dikelola oleh Router Inti:

| VLAN ID | Nama         | Network       | Gateway    | Fungsi                                                          |
| ------- | ------------ | ------------- | ---------- | --------------------------------------------------------------- |
| VLAN 10 | Management   | 172.16.0.0/24 | 172.16.0.1 | Jaringan manajemen perangkat (IP statis)                        |
| VLAN 20 | User Network | 172.16.1.0/24 | 172.16.1.1 | Jaringan pengguna dengan DHCP (Pool: 172.16.1.2 - 172.16.1.254) |

### Alokasi IP Manajemen (VLAN 10)

| Perangkat                | IP Address | Lokasi |
| ------------------------ | ---------- | ------ |
| Router Inti (RB4011)     | 172.16.0.1 | DESA   |
| PtP Receiver (LHG #2)    | 172.16.0.2 | DESA   |
| PtP Transmitter (LHG #1) | 172.16.0.3 | KOTA   |
| Router Gateway (RB750)   | 172.16.0.4 | KOTA   |

---

## 🛠️ Teknologi yang Digunakan

### Hardware (Simulasi)

- **MikroTik RB4011iGS+RM**: Router inti dengan 10 port Gigabit
- **MikroTik RB750Gr3**: Router gateway 5 port untuk terminasi ISP
- **MikroTik LHG XL 5ac**: Antena PtP dual-chain 27dBi untuk backbone
- **Ruijie RG-ES228GS-P**: PoE switch 28-port untuk core
- **Ruijie RG-ES220GS-P**: PoE switch 20-port untuk agregasi
- **Ubiquiti Rocket M5**: Base station dengan antena sectoral
- **Ubiquiti LBE-M5-23**: CPE 23dBi untuk client premises

### Software & Platform

- **MikroTik RouterOS**: v7.20 (CHR untuk simulasi)
- **GNS3**: Platform simulasi dan emulasi jaringan
- **VMware Workstation**: Hypervisor untuk menjalankan CHR

### Protokol & Teknologi Kunci

- **Bridging**: Layer 2 bridge untuk PtP transparency
- **VLAN (802.1Q)**: Segmentasi jaringan logis
- **DHCP**: Dynamic Host Configuration Protocol
- **NAT**: Network Address Translation (Masquerade)
- **QoS**: Quality of Service dengan PCQ
- **Static Routing**: Inter-VLAN routing

---

## 💰 Spesifikasi Perangkat

### Estimasi Biaya Infrastruktur Inti

| No  | Perangkat                      | Qty | Harga Satuan (Rp) | Total (Rp)      |
| --- | ------------------------------ | --- | ----------------- | --------------- |
| 1   | MikroTik RB750Gr3              | 1   | 1.020.000         | 1.020.000       |
| 2   | MikroTik RB4011iGS+RM          | 1   | 4.099.000         | 4.099.000       |
| 3   | MikroTik LHG XL 5ac            | 2   | 2.109.000         | 4.218.000       |
| 4   | Tower Triangle                 | 2   | 1.200.000         | 2.400.000       |
| 5   | Ruijie RG-ES228GS-P (Core)     | 1   | 5.500.000         | 5.500.000       |
| 6   | Ruijie RG-ES220GS-P (Agregasi) | 2   | 9.011.000         | 18.022.000      |
| 7   | Sectoral MIMO 20 dBi           | 1   | 3.100.000         | 3.100.000       |
| 8   | Rocket M5 (Base Station)       | 1   | 831.979           | 831.979         |
|     |                                |     | **TOTAL INTI**    | **~Rp 39,2 Jt** |

**Perangkat per Pelanggan** (disesuaikan dengan jumlah pengguna):

- Ubiquiti LBE-M5-23 (CPE): ~Rp 1.020.000/unit
- TP-Link TL-WR840N (AP Indoor): ~Rp 199.000/unit
- POE Injector 24V: ~Rp 150.000/unit

---

## 📝 Konfigurasi Perangkat

### 1️⃣ MikroTik RB4011iGS+RM (Router Inti - Otak Jaringan)

**Fungsi**: Pusat manajemen jaringan di sisi DESA

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

**Konfigurasi Lengkap**: [`configs/MikroTik-RB4011iGS+RM-1.rsc`](configs/MikroTik-RB4011iGS+RM-1.rsc)

---

### 2️⃣ MikroTik RB750Gr3 (Router Gateway - Terminasi ISP)

**Fungsi**: Gateway ke ISP di sisi KOTA

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

**Konfigurasi Lengkap**: [`configs/MikroTik-RB750Gr3.rsc`](configs/MikroTik-RB750Gr3.rsc)

---

### 3️⃣ MikroTik LHG XL 5ac (Point-to-Point Backbone)

**Fungsi**: Wireless backbone KOTA ↔ DESA (Bridge Mode Layer 2)

#### **LHG #1 - Transmitter (KOTA)**

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

**Konfigurasi Lengkap**: [`configs/MikroTik-LHGXL5ac-1.rsc`](configs/MikroTik-LHGXL5ac-1.rsc)

#### **LHG #2 - Receiver (DESA)**

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

**Konfigurasi Lengkap**: [`configs/MikroTik-LHGXL5ac-2.rsc`](configs/MikroTik-LHGXL5ac-2.rsc)

---

### 4️⃣ Switch Configuration

**Core Switch (Ruijie RG-ES228GS-P)**

- Port ke Router Inti: **Trunk** (VLAN 10, 20)
- Port ke PtP Antenna: **Access VLAN 10**
- Port ke Base Station: **Trunk** (VLAN 10, 20)
- Port ke Aggregation Switch: **Access VLAN 20**
- Port ke User Kabel: **Access VLAN 20**

**Aggregation Switch (Ruijie RG-ES220GS-P)**

- Semua port: **Access VLAN 20** (khusus untuk user)

---

## 🚀 Memulai

### Prasyarat

1. **GNS3** (Versi 2.2+)

   ```bash
   # Download dari https://www.gns3.com/software/download
   ```

2. **MikroTik CHR Image**

   ```bash
   # Download CHR image untuk GNS3
   # https://mikrotik.com/download
   ```

3. **VMware Workstation** (atau VirtualBox)
   - Untuk menjalankan GNS3 VM

### Langkah Instalasi

1. **Clone repository**

   ```bash
   git clone https://github.com/AhmadSyafiNurroyyan/rtrwnet-network-design
   cd rtrwnet-network-design
   ```

2. **Import Project GNS3**

   - Buka GNS3
   - File → Import portable project
   - Pilih file project dari folder `link_gns3_project.md`

3. **Load Konfigurasi**

   - Konfigurasi sudah tersimpan dalam project
   - Jika perlu reload manual, copy dari folder `configs/`
   - Paste ke terminal masing-masing perangkat

4. **Jalankan Simulasi**
   - Klik "Start All Nodes" di GNS3
   - Tunggu semua perangkat booting (~2-3 menit)
   - Verifikasi konektivitas

### Perintah Verifikasi

```bash
# Cek interface dan IP address
/ip address print

# Verifikasi VLAN
/interface vlan print

# Cek DHCP leases
/ip dhcp-server lease print

# Test routing
/ip route print

# Monitoring bandwidth (real-time)
/queue simple print stats

# Test konektivitas
/ping 172.16.0.1
/ping 8.8.8.8
```

---

## 📂 Struktur Project

```
rtrwnet-network-design/
├── README.md                              # Dokumentasi project
├── link_gns3_project.md                   # Link download project GNS3
├── configs/                               # Konfigurasi perangkat
│   ├── MikroTik-RB4011iGS+RM-1.rsc       # Router inti (DESA)
│   ├── MikroTik-RB750Gr3.rsc             # Router gateway (KOTA)
│   ├── MikroTik-LHGXL5ac-1.rsc           # PtP transmitter (KOTA)
│   └── MikroTik-LHGXL5ac-2.rsc           # PtP receiver (DESA)
├── diagrams/                              # Diagram topologi
│   ├── Desain_Topologi_Konseptual.jpg
│   └── Implementasi_Topologi_GNS3.png
└── doc/                                   # Dokumentasi lengkap
    └── Full_Documentation_Portfolio_RTRWNet.md
```

---

## 🧪 Hasil Pengujian

### ✅ Pengujian DHCP & Alokasi IP

**Test**: PC user terhubung ke VLAN 20 dan mendapatkan IP otomatis

**Hasil**:

- IP diterima dari pool: `172.16.1.2 - 172.16.1.254`
- Gateway: `172.16.1.1`
- DNS: `8.8.8.8`, `1.1.1.1`

### ✅ Pengujian Konektivitas Internet

**Test**: Ping ke DNS publik Google

```bash
ping 8.8.8.8
# Result: 64 bytes from 8.8.8.8: icmp_seq=1 ttl=56 time=12.3 ms
```

**Status**: ✅ Koneksi internet berhasil

### ✅ Pengujian Manajemen Bandwidth (QoS)

**Kondisi**: 4 host aktif dengan PCQ rate 140k download / 46k upload

**Test**: Speedtest pada setiap user

| Metrik     | Sebelum QoS  | Setelah QoS (4 user aktif) |
| ---------- | ------------ | -------------------------- |
| Download   | ~560 kbps    | ~140 kbps/user             |
| Upload     | ~920 kbps    | ~46 kbps/user              |
| Distribusi | Tidak merata | Merata semua user          |

**Hasil**: ✅ Bandwidth terbagi rata sesuai konfigurasi PCQ

### 📊 Kesimpulan Pengujian

Seluruh konfigurasi berjalan sesuai perancangan:

- ✅ DHCP Server berfungsi normal
- ✅ Konektivitas internet stabil
- ✅ QoS dengan PCQ membagi bandwidth secara adil
- ✅ VLAN isolation bekerja dengan baik
- ✅ Bridge mode PtP transparan untuk semua traffic

---

## 📚 Dokumentasi Lengkap

### Dokumen Teknis Lengkap

Untuk pemahaman mendalam tentang:

- **Landasan Teori**: Konsep RT/RW Net, jaringan komputer, DNS, VLAN
- **Perancangan Detail**: Pemilihan perangkat, estimasi biaya
- **Konfigurasi Step-by-Step**: Panduan lengkap dengan screenshot
- **Analisis Hasil**: Testing dan troubleshooting

📄 **Lihat**: [`doc/Full_Documentation_Portfolio_RTRWNet.md`](doc/Full_Documentation_Portfolio_RTRWNet.md)

---

## 🎓 Pembelajaran Kunci

Project ini mendemonstrasikan:

1. **Wireless Networking**: Implementasi PtP backbone untuk jarak jauh
2. **Bridge Mode**: Layer 2 transparency untuk VLAN traffic
3. **QoS Management**: PCQ untuk pembagian bandwidth yang adil dan dinamis
4. **Network Segmentation**: VLAN untuk isolasi manajemen dan pengguna
5. **Scalable Design**: Arsitektur yang mendukung ekspansi pengguna
6. **Community Networking**: Konsep distribusi internet berbasis komunitas

---

## 💡 Inspirasi & Konteks

Project ini terinspirasi dari implementasi nyata RT/RW Net di Indonesia, khususnya penelitian dari **Husaini & Sari (Universitas Muhammadiyah Sumatera Utara)** tentang implementasi RT/RW Net di Dusun V Suka Damai, Desa Sei Meran.

RT/RW Net membuktikan bahwa inovasi jaringan dapat memberikan **dampak sosial langsung** dengan menyediakan akses internet terjangkau bagi masyarakat, menjadi solusi cerdas di tengah keterbatasan infrastruktur.

---

## 👤 Pembuat

**Ahmad Syafi Nurroyyan**

- 🔗 LinkedIn: [ahmad-syafi-nurroyyan](https://www.linkedin.com/in/ahmad-syafi-nurroyyan-34ab81321/)
- 💻 GitHub: [@AhmadSyafiNurroyyan](https://github.com/AhmadSyafiNurroyyan)
- 📧 Email: ahmadsyafinurroyyan@gmail.com

---

## 📄 Lisensi

Project ini tersedia untuk tujuan **edukasi dan portfolio**. Silakan gunakan sebagai referensi untuk implementasi RT/RW Net atau project network engineering Anda.

---

## 🙏 Acknowledgments

- **Pak Onno W. Purbo** - Pioneer dan inspirator RT/RW Net Indonesia
- **MikroTik** - Platform RouterOS yang powerful dan fleksibel
- **GNS3 Community** - Platform simulasi jaringan yang excellent
- **Peneliti UMM (1996)** - Penggagas konsep RT/RW Net pertama di Indonesia
- **Komunitas RT/RW Net Indonesia** - Untuk berbagi pengetahuan dan pengalaman

---

## 📞 Kontak & Kolaborasi

Tertarik untuk berdiskusi tentang network engineering, RT/RW Net, atau kolaborasi project?

Jangan ragu untuk menghubungi! 🚀

---

**⭐ Jika project ini bermanfaat, pertimbangkan untuk memberikan star!**

---

_Terakhir Diperbarui: Januari 2026_
