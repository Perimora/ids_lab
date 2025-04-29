# Suricata-Based Network Security Lab

This lab simulates a realistic network security environment using Suricata IDS and multiple Docker-based components. It enables hands-on testing of attack detection, traffic routing, and network visibility using modern container workflows.

---

## 📁 Project Structure

```bash
.
├── README.md
├── docker
│   ├── adversary          # Simulated attacker (nmap, curl, etc.)
│   ├── docker-compose.yml # Container orchestration
│   ├── gateway            # Layer-3 router and traffic mirror
│   ├── scripts            # Setup scripts (e.g. tc-mirror)
│   ├── suricata           # IDS container (Suricata)
│   ├── target             # Simulated production target (SSH, Nginx)
│   └── test               # Additional test scripts
├── docs                   # Documentation and diagrams
```

---

## 🎯 Objective

**Main goals:**

- Simulate network attacks (e.g., ICMP, HTTP probes, port scans)
- Route traffic through an inline **gateway**
- Mirror traffic to **Suricata IDS** using **tc-mirred**

**Traffic flow:**

```
Adversary (external-net)
    ⇨ Gateway (external-net)
        ⇨ Gateway (internal-net)
            ⇨ Target (internal-net)

Response:
Target ⇨ Gateway ⇨ Adversary

Meanwhile:
Traffic mirrored via tc-mirred (eth0 & eth1 → eth2) ⇨ Suricata (sensor-net)
```

---

## 🧩 Components & Networks

| Container  | Purpose                                          | Networks (with IPs)                           |
|------------|--------------------------------------------------|-----------------------------------------------|
| `adversary`| Simulates attacks (nmap, curl, etc.)             | `external-net` – `172.28.0.4`                 |
| `gateway`  | Inline Layer-3 router + traffic mirroring        | `external-net` – `172.28.0.5`<br>`sensor-net` – `172.29.0.5`<br>`internal-net` – `172.30.0.5` |
| `target`   | Simulated production host (SSH, Nginx)           | `internal-net` – `172.30.0.3`                 |
| `suricata` | Intrusion Detection System (passive analysis)    | `sensor-net` – `172.29.0.2`                   |
| `dns`      | Local DNS server (dnsmasq)                       | `external-net` – `172.28.0.53`                |

**Defined Docker networks:**

- `external-net` → 172.28.0.0/24  
- `sensor-net`   → 172.29.0.0/24  
- `internal-net` → 172.30.0.0/24

---

## 🚀 Getting Started (via VS Code Tasks)

All workflows are integrated as **VS Code Tasks**. Open the **Command Palette** (`F1` or `Ctrl+Shift+P`) and run the desired task by name.

### 1. Start the lab

- Run: **`System: Start All Services`**  
  *Launches all containers and prepares logging directories.*

---

### 2. Validate the network

- Run: **`System: Validate Network Setup`**  
  *Automatically verifies correct connectivity and shuts down the containers afterward.*

---

### 3. Access container terminals

- **`Service: Terminal Access - Adversary`**  
- **`Service: Terminal Access - Gateway`**  
- **`Service: Terminal Access - Target`**  
- **`Service: Terminal Access - Suricata`**  
- **`Service: Terminal Access - DNS`**

---

### 4. Launch attack simulation

- Run: **`Adversary: Run Port Scan (→ Target)`**  
  > Launches a simulated scan from the `adversary` to `target` (172.30.0.3).

---

### 5. Clear Suricata logs

- Run: **`Suricata: Clear Log Files`**  
  *Deletes all `.log` and `.json` files from Suricata logs.*

---

### 6. Stop or clean up the environment

- Stop containers: **`System: Stop All Services`**  
- Full cleanup: **`System: Full Cleanup (Images + Volumes)`**

---

### 7. Reload DNS configuration

- Run: **`DNS: Reload DNSMasq Configuration`**  
  *Sends `SIGHUP` to reload `dnsmasq` inside the DNS container*
