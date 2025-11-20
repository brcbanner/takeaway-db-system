# 🍽️ Takeaway Database Management System

**Project:** `takeaway-db-system`  
**Language:** SQL (MySQL Workbench)  
**Author:** Matteo Pinzani  
**Purpose:** Design and implementation of a relational database system for managing a chain of sandwich takeaway stores


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

### 🔹 Relationships
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
├── DOC.md                  # Full project documentation
├── LICENSE                 # License information
├── README.md               # Project overview
│
├── 📁 er-diagrams/                   # ER and relational diagrams
│   ├── customer-payment-order-before.png
│   ├── customer-payment-order-after.png
│   ├── delivery-overview.png
│   ├── employee-store.png
│   ├── final-overview.png
│   ├── final.png
│   ├── initial-overview.png
│   ├── order-overview.png
│   ├── person-generalization.png
│   ├── rider-order.png
│   └── store-overview.png
│
└── 📁 sql/                           # SQL scripts and data
    ├── 📁 database/                  # Database implementation scripts
    │   ├── create_tables.sql
    │   ├── functions.sql
    │   ├── populate_tables.sql
    │   ├── procedures.sql
    │   └── triggers.sql
    │
    └── 📁 data/                      # Input datasets
        ├── past-contract.txt
        └── store.csv
```

---

## 💻 SQL Implementation
The physical database follows the **logical schema** and **referential integrity constraints** defined in `DOC.md`.
The implementation includes:
- Table creation and triggers (`create_tables.sql`, `triggers.sql`)
- Populating tables with sample data (`populate_tables.sql`)
- Operations implemented as **procedures** and **functions** (`procedures.sql`, `functions.sql`)

### ⚙️ Key Procedures & Functions
- **RemoveExpiredIngredients** — removes expired items from inventory
- **ListStoresWithLimitedIngredient** — lists stores where ingredient stock is below a threshold
- **ChainMenu** — lists all sandwiches, ingredients, and prices
- **PrintOrderReceipt** — generates receipts for specific orders
- **DailyDeliveryReport** — generates daily delivery summaries
- **CreateCustomerOrderHistory** — creates historical records of customer orders
- **FindTopPerformers** — lists top riders, stores, customers, and sandwiches
- **MonthlySalesTotal (function)** — calculates total sales for a given month
- **CountSandwichesPerOrder (function)** — counts sandwiches per order

---

## 📎 References

- **DBMS**: MySQL 8.0
- **ER Modelling Tool**: draw.io
- **Dataset Generation**: custom CSV + random scripts

---

## 📄 Documentation
Full documentation of the **conceptual, logical, and physical design** is available in [`DOC.md`](DOC.md).
It includes:
- Conceptual ER diagrams
- Logical relational schema
- Physical MySQL implementation details
- Procedures and functions explanations
