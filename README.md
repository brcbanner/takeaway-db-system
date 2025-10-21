# 🍽️ Takeaway Database Management System

> **Project:** `takeaway-db-system`  
> **Language:** SQL (MySQL)  
> **Author:** Matteo Pinzani
> **Purpose:** Design and implementation of a relational database system for managing a chain of sandwich takeaway stores.

---

## 📘 Overview

This project implements a complete **Database Management System** for an Italian takeaway sandwich chain.  
It covers the entire lifecycle of database design:

1. **Conceptual Design** → identifying entities, relationships, and constraints.  
2. **Logical Design** → translation into a relational model.  
3. **Physical Implementation (MySQL)** → creation of tables, triggers, procedures, and functions.

The system manages all aspects of operations:
- Customer and worker data  
- Orders, payments, and deliveries  
- Ingredients and inventory  
- Employee contracts and store management  

---

## 🧩 Features

### 🔹 Core Entities
- **Customer** — personal and contact details  
- **Employee / Rider** — staff and delivery workers  
- **Store** — unique per city, with its own inventory  
- **Ingredient** — categorized and tracked with expiration  
- **Sandwich** — recipes composed of ingredients  
- **Order** — contains multiple sandwiches  
- **Payment** — linked directly to an order  
- **Delivery** — managed by riders between store and customer  

### 🔹 Constraint Rules
- Orders require a successful payment (`CR1`)  
- Permanent contracts cannot have an end date (`CR3`)  
- Customers can only order from stores in their province (`CR6`)  
- Workers must provide either ID or passport number (`CR5`)  

### 🔹 Key Relationships
- `Contract` — Employee ↔ Store  
- `Inventory` — Store ↔ Ingredient  
- `Composition` — Sandwich ↔ Ingredient  
- `OrderDetails` — Order ↔ Sandwich  
- `Transaction` — Customer ↔ Payment ↔ Order  
- `Delivery` — Rider ↔ Order ↔ Customer ↔ Store  

---
## 🏗️ Project Structure

```plaintext
takeaway-db-system/
│
├── [DOC.md](DOC.md)                # Full documentation (conceptual, logical, and physical design)
├── [LICENSE](LICENSE)              # License information
├── [README.md](README.md)          # Project overview (this file)
│
├── 📁 er-diagrams/                 # ER and relational diagrams
│   ├── [customer-payment-order-before.png](er-diagrams/customer-payment-order-before.png)
│   ├── [customer-payment-order-after.png](er-diagrams/customer-payment-order-after.png)
│   ├── [delivery-overview.png](er-diagrams/delivery-overview.png)
│   ├── [employee-store.png](er-diagrams/employee-store.png)
│   ├── [final-overview.png](er-diagrams/final-overview.png)
│   ├── [final.png](er-diagrams/final.png)
│   ├── [initial-overview.png](er-diagrams/initial-overview.png)
│   ├── [order-overview.png](er-diagrams/order-overview.png)
│   ├── [person-generalization.png](er-diagrams/person-generalization.png)
│   ├── [rider-order.png](er-diagrams/rider-order.png)
│   └── [store-overview.png](er-diagrams/store-overview.png)
│
└── 📁 sql/                         # SQL scripts for database implementation
    ├── 📁 database/ 
    │   ├── [create_tables.sql](sql/create_tables.sql)
    │   ├── [functions.sql](sql/functions.sql)
    │   ├── [populate_tables.sql](sql/populate_tables.sql)
    │   ├── [procedures.sql](sql/procedures.sql)
    │   └── [triggers.sql](sql/triggers.sql)
    │ 
    └── 📁 data/                        # Input datasets
        ├── [past-contract.txt](data/past-contract.txt)
        └── [store.csv](data/store.csv)




