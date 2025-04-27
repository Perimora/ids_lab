# Lab: Inline Gateway with Suricata IDS

This lab simulates a network security environment with an inline Layer-3 Gateway that mirrors all traffic to a Suricata IDS.

## 🔹 Project Structure

```bash
.
├── README.md
├── docker
│   ├── adversary         # Simulated attacker (nmap, curl, etc.)
│   ├── docker-compose.yml # Container orchestration
│   ├── gateway            # Gateway container (routing and traffic mirroring)
│   ├── scripts            # Setup scripts (e.g., tc-mirror setup)
│   ├── suricata           # Suricata IDS container
│   └── target             # Simulated production target (SSH, Nginx)
├── docs                # Documentation and diagrams
```

## 🔹 Core Concept

**Goal:**
- Simulate adversary attacks (nmap, ICMP, HTTP probes)
- Traffic is routed through an inline **Gateway**
- Gateway mirrors all traffic to **Suricata IDS** via **tc-mirred** (Layer-2 mirroring)

**Traffic Flow:**

```
Adversary (external-net)
    ⇨ Gateway (external-net)
        ⇨ Gateway (production-net)
            ⇨ Target (production-net)
Response:
Target ⇨ Gateway (production-net) ⇨ Gateway (external-net) ⇨ Adversary
Meanwhile:
Traffic ⇨ mirrored from Gateway eth0/eth1 ⇨ eth2 (sensor-net) ⇨ Suricata
```

## 🔹 Key Components

| Component | Purpose |
|:----------|:--------|
| **adversary** | Attack simulation (nmap, curl, custom scans) |
| **gateway** | Layer-3 router & inline TAP (tc-mirred traffic mirroring) |
| **target** | Production server (SSH and Nginx) |
| **suricata** | IDS to monitor mirrored traffic |

## 🔹 Important Details

- **IP forwarding** is enabled on the Gateway.
- **tc-mirred** is used for real Layer-2 traffic mirroring:
  - eth0 (external-net) ⇨ mirrored to eth2
  - eth1 (production-net) ⇨ mirrored to eth2
- **Suricata** listens on eth0 inside sensor-net.
- **Privileged Mode** is enabled where needed (for tc and net admin).
- **No NAT**, pure IP routing (transparent Gateway).

## 🔹 Quick Start

1. Move into docker folder:

```bash
cd docker
```

2. Start all containers:

```bash
docker compose up -d
```

3. Verify services:

```bash
docker ps
```

4. Test traffic:
- From adversary: `ping 172.30.0.3`
- Launch nmap scans: `nmap -p 22,80,443 172.30.0.3`

5. Monitor mirrored traffic:
- On gateway:
  ```bash
  docker exec -it gateway bash
  tcpdump -i eth2 -n
  ```
- On Suricata:
  ```bash
  docker exec -it suricata bash
  tail -f /var/log/suricata/fast.log
  ```

## 🔹 Notes

- Ensure tc-mirrored setup runs inside gateway container (`/tmp/tc.sh`).
- The gateway must stay privileged to control traffic redirection.
- Target container has default route set to Gateway.
- Adversary routes via Gateway to reach production targets.

## 🔹 Next Steps

- Expand attack simulations
- Tune Suricata rulesets
- Introduce threat hunting scenarios
- Visualize traffic flows with live dashboards

