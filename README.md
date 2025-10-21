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
├── 📄 DOC.md                # Full documentation (conceptual + logical design)
├── 📄 README.md             # Project overview (this file)
├── 📄 LICENSE.md
│
├── 📁 sql/
│   ├── CreateTables.sql     # Physical schema definition
│   ├── PopulateTables.sql   # Sample data insertion
│   ├── Triggers.sql         # Triggers (e.g., for TotalOrderPrice)
│   ├── Procedures.sql       # Stored procedures (operations 1–7)
│   ├── Functions.sql        # Stored functions (operations 8–9)
│   ├── PopulateStore.csv    # CSV dataset for stores
│   ├── PopulatePastContract.txt # Dataset for past contracts
│
└── 📁 er-diagrams/          # All conceptual/logical ER diagrams
    ├── final-overview.png
    ├── person-generalization.png
    ├── ...


