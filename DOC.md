# 🍽️ Takeaway Database Management System
> **Project:** takeaway-db-system  
> **Purpose:** Design and implementation of a database system for managing a piadina (Italian flatbread sandwich) takeaway chain.  
> **Language:** SQL / MySQL

---

## 📚 Table of Contents
1. [Conceptual Design](#-conceptual-design)
  - 1.1 [Sample Owner Request](#-sample-owner-request)
  - 1.2 [Requirements Analysis](#-requirements-analysis)
  - 1.3 [Requirements Gathering](#-requirements-gathering)
    - 1.3.1 [Data Requirements](#-data-requirements)
    - 1.3.2[Operation Requirements](#-operation-requirements)
  - 1.4 [Conceptual Data Representation](#-conceptual-data-representation)
  - 1.5 [Documentation of the Conceptual Data Schema](#-documentation-of-the-conceptual-data-schema)
2. [Logical Design](#-logical-design)
  - 2.1 [E-R Schema Restructuring](#-e-r-schema-restructuring)
    - 2.1.1 [Redundancy Analysis](#-redundancy-analysis)
    - 2.1.2 [Removal of Generalizations](#-removal-of-generalizations)
    - 2.1.3 [Removal of Multivalued Attributes](#-removal-of-multivalued-attributes)
    - 2.1.4 [Selection of Primary Identifiers](#-selection-of-primary-identifiers)
    - 2.1.5 [Restructured Schema](#-restructured-schema)
  - 2.2 [Translation to the Relational Model](#translation-to-the-relational-model)
    - 2.2.1 [Logical Schema](#logical-schema)
3. [MySQL Implementation](#mysql-implementation)
  - 3.1 [Procedures](#procedures)
    - 3.1.1 [RemoveExpiredIngredients](#removeexpiredingredients)
    - 3.1.2 [ListShopsWithLimitedIngredient](#listshopswithlimitedingredient)
    - 3.1.3 [ChainMenu](#chainmenu)
    - 3.1.4 [PrintOrderReceipt](#printorderreceipt)
    - 3.1.5 [DailyDeliveryReport](#dailydeliveryreport)
    - 3.1.6 [CreateCustomerOrderHistory](#createcustomerorderhistory)
    - 3.1.7 [FindBest](#findbest)
  - [Functions](#functions)
    - 3.1.8 [MonthlySalesTotal](#monthlysalestotal)
    - 3.1.9 [CountPiadinePerOrder](#countpiadineperorder)

---

## 1. CONCEPTUAL DESIGN

### 1.1 Sample Owner Request
A chain of takeaway sandwich _shops_, with _locations_ in the main cities of Italy, requires a well-organized database to manage information about customers, orders, workers, inventory, sandwiches and _branches_.

For each `customer`, personal information is recorded, including **first name**, **last name**, **age**, **email**, **tax code**, **phone number**, **_address_**, and, if applicable, the **_floor_**.

The staff at each _point of sale_ is divided into different categories (such as cleaning staff, sandwich makers, and packaging staff). For each `employee`, the **first name**, **last name**, **phone number**, and **_details of documents required for hiring_** are recorded. Additional useful information is also stored, including **job title**, **type of contract** (fixed-term or permanent), **_salary_**, **department**, **_contract period_** (for fixed-term contracts), and **previous employment**.

For _those who work independently_, the situation is different: they have a **VAT number** and are not associated with a specific _store_.

Each worker, whether employed or self-employed, can also be a customer.

The chain has only one _shop_ per city. Each `store` is registered through its **_address_** and has its own staff, and an `inventory` consisting of the ingredients required to prepare sandwiches. Each `ingredient` is recorded with a **unique code**, **name**, **category** (e.g., meat, fish, vegetables), **_unit price_**, **expiration date**, and **_available quantity_**.

Each `sandwich` has a **unique code**, a **name**, a **description**, and a **_price_**. Each `order`, placed by a customer, is delivered by a `rider` from a specific _store_. Orders are recorded with a **unique code** and **_total order price_**. The delivery _price_ varies depending on the delivery type (for “standard” the price doesn’t change, while for “express” it increases by €3) and on the _distance_ (each kilometer adds €0.20).  

Each order is linked to a `payment` transaction, recorded with a **payment code** and **method**. For each stage of the order (request, delivery, and payment), the **date** and **time** are recorded.

---

### 1.2 Requirements Analysis
This text presents a number of ambiguities and inaccuracies. At this stage, it is important to:

🔹 **Avoid overly generic terms**, which make a concept unclear, and replace them with more meaningful ones or define them clearly:
  - `Address` → address including region, province, street (street or square), postal code, and street number  
  - `Floor` → floor number  
  - `Details of documents required for hiring` → tax code and ID card number, or alternatively passport number  
  - `Contract period` → employment start and end dates  
  - `Available quantity` → available weight  
  - `Distance` → distance between the delivery address (customer residence) and the store from which the order is sent  

🔹 **Simplify convoluted sentences** that make the text difficult to understand:
  - `Those who work independently` → freelance workers

🔹 **Identify synonyms and homonyms** to clarify ambiguities:
  - `Location`, `shop`, `point of sale` and `branch` → store

🔹 **Make references between terms explicit:**
  - `Freelance workers` → riders

🔹 **Indicate the unit of measurement** for all quantities:
  - `Unit price` → euro per kg 
  - `Available weight` → kilograms  
  - `Distance` → kilometers  
  - `Price` and `total order price` → euro

To clarify and understand the terms used, a glossary of terms is presented below.

---

### 📖 Glossary of Terms

> **Purpose:** Clarify the key terms used throughout the conceptual and logical design.

| **Term** | **Description** | **Synonyms** | **Related terms** |
|-----------|-----------------|---------------|--------------------|
| `Distance` | Distance between the store and the delivery address (customer's residence). | — | `Order` |
| `Documents for hiring` | Tax code and an identity document, i.e., ID card or passport. | — | `Worker`, `Store` |
| `Riders` | Workers of the chain, with a VAT number, who deliver the orders. | `Self-employed workers` | `Staff` |
| `Address` | Address of the customer or a store, including region, province, postal code, street/square, and street number. | — | `Customer`, `Order`, `Store` |
| `Workers` | Staff employed in each store, i.e., employees. Also includes self-employed ones. | `Staff`, `Employees` | `Store`, `Worker` |
| `Store` | A store of the chain. | `Location`, `Shop`, `Point of sale` | `Worker`, `Order` |
| `Contract period` | Start and end date of a work contract. | — | `Staff` |
| `Floor` | Number of the floor of an apartment. | — | `Customer` |
| `Available quantity` | Available weight. | — | `Ingredient` |
| `Street` | General term for indicating a street or square in an address. | — | `Address` |

---

### 1.3 Requirements Gathering

#### 1.3.1 On Data
Following the request and the glossary, we proceed with requirements gathering — that is, identifying the characteristics that our database must possess.  
After reformulating certain terms and removing ambiguities, the text is broken down into groups of related sentences.

---

#### 🧑‍💼 Sentences Related to Workers
Each `Worker` is recorded with personal information such as **first name**, **last name**, **phone number**, **tax code**, and **ID card number** (or passport number).  
For `Staff`, additional information is stored, including **professional title**, **type of contract** (fixed-term or permanent), **salary**, **department**, **employment start and end dates** (for fixed-term contracts), and **previous work experience**.
`Riders` are self-employed workers with a VAT number and are not associated with a specific `Store`.  
Each worker, whether an employee or a rider, can also be a `Customer`.

---

#### 🏪 Sentences Related to Stores
The chain operates **one** `Store` **per city**.  
Each store is recorded with its **address**, which includes region, province, postal code, street, and street number.  
Every store mantains its own `Staff` and `Inventory`, independent of other locations.

---

#### 🧂 Sentences Related to Ingredients
The `Inventory` includes all `Ingredients` used to prepare sandwiches.  
Each ingredient is identified with a **unique code**, **name**, **category** (e.g., meat, fish, vegetables), **unit price** (in euros per kg), **expiration date**, and **available weight** (in kg).

---

#### 🥪 Sentences Related to Sandwiches
Each `Sandwich` is defined by a **unique code**, **name**, **description**, and **price**.

---

#### 🧾 Sentences Related to Orders
Each `Order`, placed by a `Customer`, is delivered by a `Rider` from a specific `Store`.  
Orders are recorded with a **unique code** and the **total order price**.  
The delivery fee depends on **delivery type** and **distance** between the customer and the store.  
Each stage of the order — request, delivery, and payment — is recorded with **date** and **time**.

---

#### 💳 Sentences Related to Transactions
Each `Transaction` is recorded with a **payment code** and **payment method**, and is associated with a specific `Order`.

---

#### 1.3.1 On Operations
Alongside the data specifications, the operations to be performed on the data and their average frequencies are collected.

| **Operation** | **Description** | **Average Frequency** |
|----------------|------------------|------------------------|
| **1** | Remove expired ingredients from inventory | Once a day |
| **2** | Check available weight of an ingredient against a limit | Several times a day |
| **3** | Print the chain’s menu (list of available sandwiches) | Several times a day |
| **4** | Print the receipt of an order | 20 times a day |
| **5** | Print a daily delivery report | Once a day |
| **6** | Create a historical record of orders for a specific customer | 10 times a day |
| **7** | Select the 3 best among riders, stores, customers, and orders | Once a month |
| **8** | Calculate total sales for a specific month and year | 5 times a month |
| **9** | Calculate the number of sandwiches in an order | 20 times a day |

### 1.4 Conceptual Data Representation
Following the analysis and gathering of requirements, we proceed to the **conceptual representation of data**, which leads to the creation of the **conceptual schema**.
We first identify the most relevant concepts in our context: **Customer**, **Employee**, **Riders**, **Store**, **Ingredient**, **Sandwich**, **Order**, and **Payment**. These form the **skeleton of the system**.

- An `Order` consists of several activities: the `Customer`’s _request_ for a certain number of `Sandwiches`, _delivery_ from a `Store` through a `Rider`, and the successful _execution_ of the `Payment`.
- Both Rider and Employee are `Workers`; however, an `Employee`, unlike a Rider, has a _contract_ with a specific Store.
- Similarly, a Customer and a Worker can be considered a single `Person`.
- Each Store has its own _inventory_, composed of available `Ingredients` which are *combined* to create Sandwiches — the main _content_ of each Order.

`Objects` are transformed into **entities**, and the _relationships_ among them are represented as **relations** (each term expressed in singular form).

<p align="center">
  <img src="er-diagrams/initial-overview.png" width="80%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| Italian Term   | English Translation  |
|----------------|-------------------|
| Cliente        | Customer          |
| Composizione   | Composition       |
| Consegna       | Delivery          |
| Contenuto      | Content           |
| Dipendente     | Employee          |
| Esecuzione     | Execution         |
| Fattorino      | Rider             |
| Impiego        | Contract          |
| Ingrediente    | Ingredient        |
| Inventario     | Inventory         |
| Lavoratore     | Worker            |
| Locale         | Store             |
| Ordine         | Order             |
| Pagamento      | Payment           |
| Piadina        | Sandwhich         |
| Persona        | Person            |
| Richiesta      | Request           |

</details>

We now analyze all entities and their relationships, indicating their attributes.

#### PERSON Entity
The `Person` entity is the parent of both `Worker` and `Customer`; this generalization is **total and overlapping**.
`Worker` is further divided into `Employee` and `Rider`; this generalization is **total and exclusive**.

<p align="center">
  <img src="er-diagrams/person-generalization.png" width="60%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| Italian Term          | English Translation            |
|-----------------------|--------------------------------|
| CAP                   | Postal Code / ZIP Code         |
| Cliente               | Customer                       |
| CodFiscale            | Tax Code                       |
| Cognome               | Last Name / Surname            |
| Dipendente            | Employee                       |
| Email                 | Email                          |
| Eta                   | Age                            |
| Fattorino             | Rider                          |
| Indirizzo             | Address                        |
| Lavoratore            | Worker                         |
| Nome                  | First Name                     |
| NumCartaId            | ID Card Number                 |
| NumCivico             | Street Number                  |
| NumPassaporto         | Passport Number                |
| NumPiano              | Floor Number                   |
| NumTelefono           | Phone Number                   |
| PartitaIVA            | VAT Number                     |
| Persona               | Person                         |
| Regione               | Region                         |
| Provincia             | Province                       |
| Strada                | Street                         |
| TitoloProfessionale   | Job Title / Professional Title |

</details>

#### Relationship between EMPLOYEE & STORE
Each `Employee` has only one `Contract` with a `Store`, represented as a **one-to-many relationship**.
To record previous employment, we use a **many-to-many relationship** called `PastContract`.
The two relationships share most attributes, but the first includes a **Type** attribute (fixed-term or permanent), which determines whether an **EndDate** is required.

<p align="center">
  <img src="er-diagrams/employee-store.png" width="60%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| Italian Term                  | English Translation           |
|-------------------------------|-------------------------------|
| Contratto                     | Contract                      |
| ContrattoPassato              | Past / Previous Contract      |
| DataFine                      | End Date                      |
| DataInizio                    | Start Date                    |
| DataInizio DataFine           | Start Date / End Date         |
| Dipendente                    | Employee                      |
| Locale                        | Location / Store              |
| Stipendio Settore             | Salary / Sector               |
| Tipo                          | Type                          |
| TitoloProfessionale Contratto | Job Title (Contract)          |

</details>

#### Relationship between RIDER & ORDER
Each `Rider` can deliver multiple orders, but each `Order` is delivered by only one Rider, forming a **one-to-many relationship** called `Delivery` between Order and Rider.

<p align="center">
  <img src="er-diagrams/rider-order.png" width="60%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| Italian Term        | English Translation     |
|---------------------|-------------------------|
| Consegna            | Delivery                |
| DataConsegna        | Delivery Date           |
| Distanza            | Distance                |
| Fattorino           | Delivery Person         |
| MetodoConsegna      | Delivery Method         |
| MetodoPagamento     | Payment Method          |
| OraConsegna         | Delivery Time           |
| Ordine              | Order                   |
| PartitaIVA          | VAT Number              |
| PrezzoConsegna      | Delivery Price          |

</details>

#### CUSTOMER Entity
Each `Customer` can place multiple `Orders` and perform multiple `Payments`; however, each order is requested and paid for by one and only one Customer.

<p align="center">
  <img src="er-diagrams/customer-payment-order-before.png" width="60%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| Italian Term        | English Translation     |
|---------------------|-------------------------|
| Cliente             | Customer                |
| DataEsecuzione      | Execution Date          |
| DataRichiesta       | Request Date            |
| Email               | Email                   |
| Esecuzione          | Execution               |
| Eta                 | Age                     |
| Fattorino           | Delivery Person         |
| IDPagamento         | Payment ID              |
| MetodoPagamento     | Payment Method          |
| NumPiano            | Floor Number            |
| OraEsecuzione       | Execution Time          |
| OraRichiesta        | Request Time            |
| Ordine              | Order                   |
| Pagamento           | Payment                 |
| Richiesta           | Request                 |

</details>

#### TRANSACTION Entity
Since `Execution` and `Request` alone don't ensure a connection between `Order` and `Payment` - because a customer could make a payment without an order, or an order could exist without payment - we introduce a **ternary relationship** `Transaction` among `Customer`, `Payment`, and `Order`.
This resolves the ambiguity and ensures a unified and centralized interaction: the request and the payment occur simultaneously.

<p align="center">
  <img src="er-diagrams/customer-payment-order-after.png" width="60%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| Italian Term        | English Translation     |
|---------------------|-------------------------|
| Cliente             | Customer                |
| DataEsecuzione      | Execution Date          |
| DataRichiesta       | Request Date            |
| Email               | Email                   |
| Esecuzione          | Execution               |
| Eta                 | Age                     |
| Fattorino           | Delivery Person         |
| IDPagamento         | Payment ID              |
| MetodoPagamento     | Payment Method          |
| NumPiano            | Floor Number            |
| OraEsecuzione       | Execution Time          |
| OraRichiesta        | Request Time            |
| Ordine              | Order                   |
| Pagamento           | Payment                 |
| Richiesta           | Request                 |

</details>

#### STORE Entity
Each `Store` is uniquely identified by the **province code** (e.g., FI for Florence), because there is only one store per city.
The `Inventory` relationship between `Store` and `Ingredient` records the **UnitPrice**, which is _not stored in Ingredient entity_ because it varies by store location.

<p align="center">
  <img src="er-diagrams/store-overview.png" width="70%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| Italian Term         | English Translation           |
|----------------------|-------------------------------|
| CAP                  | Postal Code / ZIP Code        |
| Categoria            | Category                      |
| CodIngrediente       | Ingredient Code               |
| CodPiadina           | Sandwich Code                 |
| Composizione         | Composition                   |
| Consegna             | Delivery                      |
| Contratto            | Contract                      |
| Contenuto            | Content                       |
| DataScadenza         | Expiration Date               |
| Descrizione          | Description                   |
| Dipendente           | Employee                      |
| Fattorino            | Rider                         |
| Ingrediente          | Ingredient                    |
| Indirizzo            | Address                       |
| Inventario           | Inventory                     |
| Locale               | Store                         |
| Nome                 | Name                          |
| NumCivico            | Street Number                 |
| Passato              | Past / Previous               |
| PesoDisponibile      | Available Weight              |
| Piadina              | Sandwich                      |
| Prezzo               | Price                         |
| PrezzoUnitario       | Unit Price                    |
| Provincia            | Province                      |
| Regione              | Region                        |
| SiglaProvincia       | Province Abbreviation         |
| Strada               | Street                        |

</details>

#### ORDER Entity
The Order entity includes the attribute TotalOrderPrice, which equals the sum of the DeliveryPrice and the total price of all piadinas ordered (calculated as the sum of TotalPiadinaPrice for each piadina type in the order).
Since it is essential to track the details of the ordered piadinas — i.e., their number and price — we make the relationship between Order and Piadina explicit, naming it OrderDetails and recording NumPiadinas and TotalPiadinaPrice.
Distance can also be derived from the difference between the customer’s and store’s addresses; therefore, it makes sense to associate the Delivery also with Customer.

<p align="center">
  <img src="er-diagrams/order-overview.png" width="65%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| Italian Term               | English Translation           |
|----------------------------|-------------------------------|
| Cliente                    | Customer                      |
| Consegna                   | Delivery                      |
| DataConsegna               | Delivery Date                 |
| DataTransazione            | Transaction Date              |
| Dettaglio                  | Detail                        |
| Distanza                   | Distance                       |
| Fattorino                  | Delivery Person               |
| IDOrdine                   | Order ID                      |
| Locale                     | Location / Store              |
| MetodoConsegna             | Delivery Method               |
| NumPiadine                 | Number of Sandwiches          |
| Ordine                     | Order                         |
| Ordini                     | Orders                        |
| OraConsegna                | Delivery Time                 |
| OraTransazione             | Transaction Time              |
| Pagamento                  | Payment                       |
| Piadina                    | Sandwich                      |
| PrezzoConsegna             | Delivery Price                |
| PrezzoTotalePiadina        | Sandwich Total Price          |
| PrezzoTotaleOrdine         | Total Order Price             |

</details>

At this point, we notice that Delivery has become an association involving four entities and contains several attributes; therefore, it is more convenient to treat it as an entity itself, identified externally by the combination of Customer, Rider, Order, and Store.

<p align="center">
  <img src="er-diagrams/delivery-overview.png" width="60%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>
| Italian Term       | English Translation           |
|-------------------|--------------------------------|
| Arrivo             | Arrival                       |
| Cliente            | Customer                      |
| Consegna           | Delivery                      |
| DataConsegna       | Delivery Date                 |
| Distanza           | Distance                      |
| Fattorino          | Delivery Person               |
| Incarico           | Contract                      |
| Locale             | Store                         |
| MetodoConsegna     | Delivery Method               |
| OraConsegna        | Delivery Time                 |
| Ordine             | Order                         |
| Partenza           | Departure                     |
| PrezzoConsegna     | Delivery Price                |

</details>

The final schema is obtained by integrating all partial schemas produced so far.

<p align="center">
  <img src="er-diagrams/final-overview.png" width="80%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| Italian Term               | English Translation              |
|----------------------------|----------------------------------|
| Arrivo                     | Arrival                          |
| CAP                        | Postal Code / ZIP Code           |
| Categoria                  | Category                         |
| Cliente                    | Customer                         |
| CodFiscale                 | Tax Code / SSN                   |
| CodIngrediente             | Ingredient Code                  |
| CodPiadina                 | Sandwich Code                    |
| Composizione               | Composition                      |
| Consegna                   | Delivery                         |
| Contratto                  | Contract                         |
| ContrattoPassato           | Past Contract                    |
| DataConsegna               | Delivery Date                    |
| DataEsecuzione             | Execution Date                   |
| DataFine                   | End Date                         |
| DataInizio                 | Start Date                       |
| DataScadenza               | Expiration Date                  |
| DataTransazione            | Transaction Date                 |
| DettaglioOrdini            | Order Details                    |
| Descrizione                | Description                      |
| Dipendente                 | Employee                         |
| Distanza                   | Distance                         |
| Email                      | Email                            |
| Eta                        | Age                              |
| Fattorino                  | Delivery Person                  |
| IDOrdine                   | Order ID                         |
| IDPagamento                | Payment ID                       |
| Incarico                   | Contract                         |
| Ingrediente                | Ingredient                       |
| Inventario                 | Inventory                        |
| Indirizzo                  | Address                          |
| Lavoratore                 | Worker                           |
| Locale                     | Store                            |
| MetodoConsegna             | Delivery Method                  |
| MetodoPagamento            | Payment Method                   |
| NumCartaId                 | ID Card Number                   |
| NumCivico                  | Street Number                    |
| NumPiano                   | Floor Number                     |
| NumPiadine                 | Number of Sandwiches             |
| NumTelefono                | Phone Number                     |
| OraConsegna                | Delivery Time                    |
| OraTransazione             | Transaction Time                 |
| Ordine                     | Order                            |
| Pagamento                  | Payment                          |
| Partenza                   | Departure                        |
| PartitaIVA                 | VAT Number                       |
| Piadina                    | Sandwich                         |
| PesoDisponibile            | Available Weight                 |
| Prezzo                     | Price                            |
| PrezzoConsegna             | Delivery Price                   |
| PrezzoTotaleOrdine         | Total Order Price                |
| PrezzoTotalePiadina        | Sandwich Total Price             |
| PrezzoUnitario             | Unit Price                       |
| Regione                    | Region                           |
| SiglaProvincia             | Province Abbreviation            |
| Settore                    | Sector                           |
| Stipendio                  | Salary                           |
| Strada                     | Street                           |
| Tipo                       | Type                             |
| Transazione                | Transaction                      |

</details>

### 1.5 Documentation of the Conceptual Data Schema

### UML Entities

|**Entity**|**Description**|**Attributes**|**Identifiers**|
|-----------|---------------|---------------|----------------|
|**Person**|Generic individual|Name, Surname, TaxCode, PhoneNumber, Address (Region, Province, Street, PostalCode, StreetNumber)|TaxCode|
|**Customer**|Person who places an order|Email, Age, FloorNumber|TaxCode|
|**Worker**|Person who works for or within the chain|IDCardNumber, PassportNumber|TaxCode|
|**Rider**|Worker who delivers orders|VATNumber|TaxCode|
|**Employee**|Worker who works or has worked for a specific store|ProfessionalTitle|TaxCode|
|**Store**|Structure belonging to the chain|ProvinceCode, Address (Region, Province, Street, PostalCode, StreetNumber)|ProvinceCode|
|**Ingredient**|Raw material used to prepare piadinas|IngredientCode, Category, Name|IngredientCode|
|**Sandwich**|Main product sold|SandwichCode, Name, Price, Description|SandwichCode|
|**Order**|Order containing one or more piadinas for a customer|OrderID, TotalOrderPrice|OrderID|
|**Payment**|Payment of the order by the customer|PaymentID, PaymentMethod|PaymentID|
|**Delivery**|Delivery of an order, carried out by a rider from a store to a customer|DeliveryMethod, DeliveryPrice, DeliveryDate, DeliveryTime, Distance|Rider, Customer, Order, Store|

### UML Constraint Rules

|**ID**|**Rule Description**|
|------|--------------------|
|**CR1**|An order can be delivered if and only if the payment has been made.|
|**CR2**|For each contract, if an EndDate exists, the StartDate must precede it.|
|**CR3**|Every permanent contract must not have an EndDate.|
|**CR4**|Every fixed-term contract must have an EndDate.|
|**CR5**|Each worker must possess either an IDCardNumber or a PassportNumber.|
|**CR6**|Each customer can place orders only from the store in their province.|

### UML Relationships

|**Relationship**|**Description**|**Related Entities**|**Attributes**|
|----------------|----------------|--------------------|---------------|
|**Contract**|Specifies the details of a contract between a store and an employee.|Employee - Store|StartDate, EndDate, Sector, Salary, Type|
|**Past Contract**|Specifies completed employment contracts.|Employee - Contract|StartDate, EndDate, Sector, Salary|
|**Inventory**|Represents the food stock of a store.|Store - Ingredient|AvailableWeight, UnitPrice, ExpirationDate|
|**Composition**|Specifies the ingredients of a sandwich.|Sandwich - Ingredient|-|
|**Order Details**|Lists the details of the sandwiches in an order.|Order - Sandwich|NumberOfSandwiches, TotalSandwichPrice|
|**Transaction**|Associates an order with a payment from a specific customer.|Order - Payment - Customer|TransactionDate, TransactionTime|
|**Departure**|Indicates the store from which the delivery starts.|Delivery - Store|-|
|**Arrival**|Associates the customer with the delivery.|Delivery - Customer|-|
|**Transport**|Specifies the rider assigned to the delivery.|Delivery - Rider|-|
|**Assignment**|Associates an order with a delivery.|Delivery - Order|-|

## 2. LOGICAL DESIGN

### 2.1 E-R Schema Restructuring

#### 2.1.1 Redundancy Analysis
The E-R schema contains some redundant attributes:

- **DeliveryPrice** in `Delivery`, which can be derived, within the same entity, from the attributes *DeliveryMethod* and *Distance*.

  ```text
  DeliveryPrice_Distance = Distance × 0.2
  DeliveryPrice_Method = (DeliveryMethod = 'Express') ? 3 : 0
  DeliveryPrice = DeliveryPrice_Distance + DeliveryPrice_Method
  ```

- **TotalSandwichTypePrice** in `OrderDetails`, which can be obtained, through `OrderDetails` and `Sandwich`, by multiplying the price of the specific type of sandwich (*Price*) by the number of sandwiches of that type (*NumSandwiches*).

  ```text
  TotalSandwichTypePrice = Price × NumSandwiches
  ```

- **TotalOrderPrice** in `Order`, which is derived, through `OrderDetails`, `Sandwich`, and `Delivery`, as the sum of all the sandwiches ordered (or equivalently, the sum of *TotalSandwichTypePrice* for each different type, i.e., for each *SandwichCode* present in the order) plus the *DeliveryPrice*.

  ```text
  for (type ∈ SandwichCode)
    TotalSandwichesPrice = TotalSandwichesPrice + TotalSandwichTypePrice
  TotalOrderPrice = TotalSandwichesPrice + DeliveryPrice
  ```
We consider only operations 4, 5, 6, and 8, which are the only operations that handle the *TotalOrderPrice*, which also involves the other redundant attributes. For the purpose of analysis, the following load data assumptions are made.

## Volume and Operation Tables

### Table of Volumes

| **Concept** | **Type** | **Volume** |
|--------------|-----------|-------------|
| Person | E | 10,000 |
| Customer | E | 9,500 |
| Worker | E | 500 |
| Rider | E | 250 |
| Employee | E | 250 |
| Store | E | 25 |
| Ingredient | E | 100 |
| Sandwich | E | 15 |
| Order | E | 20,000 |
| Payment | E | 20,000 |
| Delivery | E | 20,000 |
| Contract | R | 250 |
| Past Contract | R | 200 |
| Inventory | R | 1,500 |
| Composition | R | 1,000 |
| OrderDetails | R | 40,000 |
| Transaction | R | 20,000 |
| Departure | R | 20,000 |
| Arrival | R | 20,000 |
| Transport | R | 20,000 |
| Assignment | R | 20,000 |

---

### Table of Operations

| **Operation** | **Frequency** |
|----------------|----------------|
| Op.4 | 20/day |
| Op.5 | 1/day |
| Op.6 | 10/day |
| Op.8 | 5/month |

---

### Analysis of DeliveryPrice
Assuming each of the 25 store has performed an average of 800 deliveries, there are 20,000 total deliveries for the chain. Storing `DeliveryPrice` requires 20,000 bytes (20KB) of additional memory. Whether the data is redundant or not, obtaining `DeliveryPrice` requires a single read access to `Order`, `Assignment`, and `Delivery`. However, in the absence of the redundant data, calculating it requires three distinct operations (a product, a conditional expression, and a sum), although the total complexity is constant. Given that the number of accesses per day (20 times per day for Operation 4, totaling 60 read accesses per day) is the same, and the number of deliveries can increase significantly over time, it is convenient to **eliminate this redundant data**.

### Analysis of TotalSandwichTypePrice
This attribute can be derived, for each different type of sandwich (i.e., for each `SandwichCode`), by multiplying the sandwich's `Price` by the `NumberOfSandwiches`. However, this datum is not essential for calculating `TotalOrderPrice`, which can be computed directly by summing the price of each sandwich associated with the same `OrderID`. Since the same procedure would be executed for each type of sandwich to determine `TotalSandwichTypePrice`, we can directly **eliminate TotalSandwichTypePrice**.

### Analysis of TotalOrderPrice

#### Case with redundancy
Since the total number of deliveries is 20,000, 20KB of additional memory is required to store the attribute. To determine `TotalOrderPrice` in this case, only one access to `Order` is required, resulting in 20 accesses per day.

#### Case without redundancy
Calculating TotalOrderPrice requires accessing several constructs: first Order, then Delivery (via Assignment) to calculate DeliveryPrice, and subsequently Sandwich (via OrderDetails) to find the prices of all ordered piadinas. Given that the volumes of OrderDetails (40,000) and Delivery (20,000) suggest that, on average, each delivery includes about 2 sandwiches, the number of accesses to OrderDetails and Sandwich is approximately 2. The total daily accesses needed for Operation 4 would be 20 * (1 [Order] + 1 [Assignment] + 1 [Delivery] + 2 [OrderDetails] + 2 [Sandwich]) = 140 accesses.

#### Choice
The choice between mantaining or removing `TotalOrderPrice` is not trivial and is *deferred to the physical design phase*; however, for the logical design, the attribute is **mantained**.

#### 2.1.2 Removing Generalizations
There are two generalizations in the E-R schema:
- `Person` into `Worker` and `Customer`
- `Worker` into `Employee` and `Rider`
Both are total, and the parent entities are not directly connected to other entities. Therefore, it is possible to merge them into theri child entities, adding the parent attributes to the children. In this way, we get three separate entities - `Customer`, `Employee` and `Rider` - which participate in different associations.

#### 2.1.3 Removing Multivalued Attributes
Instead of storing `Customer`'s and `Store`'s multivalued attribute `Address`, I decide to inlcude the associated attributes directly in their respective entities.

#### 2.1.4 Selection of Primary Identifiers
After removing generalizations and creating three separate entities, I assign internal identifiers of the *EntityCode* to these entities, while mantaining *TaxCode* as an attribute.
Additionally, instead of using the external identifier for `Delivery` - which includes `Order`, `Customer`, `Rider`, and `Store` - I introduce an internal identifier called `DeliveryID`.

#### 2.1.5 Restructered Schema

<p align="center">
  <img src="er-diagrams/final.png" width="80%">
</p>

<details>
<summary>🇬🇧 English Legend</summary>

| **Italian Term**    | **English Translation** |
| ------------------- | ----------------------- |
| Arrivo              | Arrival                 |
| CAP                 | Postal Code             |
| Categoria           | Category                |
| Cliente             | Customer                |
| CodCliente          | Customer Code           |
| CodDipendente       | Employee Code           |
| CodFattorino        | Rider Code              |
| CodFiscale          | Tax Code                |
| CodIngrediente      | Ingredient Code         |
| CodPiadina          | Sandwich Code           |
| Composizione        | Composition             |
| Consegna            | Delivery                |
| Contratto           | Contract                |
| Cognome             | Last Name               |
| DataConsegna        | Delivery Date           |
| DataFine            | End Date                |
| DataInizio          | Start Date              |
| DataScadenza        | Expiration Date         |
| DataTransazione     | Transaction Date        |
| DettaglioOrdini     | Order Details           |
| Dipendente          | Employee                |
| Descrizione         | Description             |
| Distanza            | Distance                |
| Email               | Email                   |
| Eta                 | Age                     |
| Fattorino           | Rider                   |
| IDConsegna          | Delivery ID             |
| IDOrdine            | Order ID                |
| IDPagamento         | Payment ID              |
| Incarico            | Assignment              |
| Ingrediente         | Ingredient              |
| Inventario          | Inventory               |
| Locale              | Store                   |
| MetodoConsegna      | Delivery Method         |
| MetodoPagamento     | Payment Method          |
| Nome                | First Name              |
| NumCartaId          | ID Card Number          |
| NumCivico           | Street Number           |
| NumPassaporto       | Passport Number         |
| NumPiano            | Floor Number            |
| NumTelefono         | Phone Number            |
| Ordine              | Order                   |
| OraConsegna         | Delivery Time           |
| OraTransazione      | Transaction Time        |
| Pagamento           | Payment                 |
| Partenza            | Departure               |
| PartitaIVA          | VAT Number              |
| PesoDisponibile     | Available Weight        |
| Piadina             | Sandwich                |
| Prezzo              | Price                   |
| PrezzoUnitario      | Unit Price              |
| Provincia           | Province                |
| Regione             | Region                  |
| Settore             | Department / Sector     |
| SiglaProvincia      | Province Code           |
| Stipendio           | Salary                  |
| Strada              | Street                  |
| Tipo                | Type                    |
| TitoloProfessionale | Professional Title      |
| Transazione         | Transaction             |
| Trasporto           | Transport               |

</details>

### 2.2 Translation to the Relational Model

#### 2.2.1 Logical Schema
- **Employee** (EmployeeCode, Name, Surname, TaxCode, PhoneNumber, IDCardNumber*, PassportNumber*, ProfessionalTitle, ContractType, StartDate, EndDate*, Salary, Sector, Store)
- **PastContract** (EmployeeCode, StoreCode, StartDate, EndDate, Salary, Sector)
- **Store** (ProvinceCode, Region, Province, Street, PostalCode, StreetNumber)
- **Inventory** (StoreCode, IngredientCode, AvailableWeight, UnitPrice, ExpirationDate)
- **Ingredient** (IngredientCode, Category, Name)
- **Composition** (IngredientCode, SandwichCode)
- **Sandwich** (SandwichCode, Name, Price, Description)
- **OrderDetails** (OrderID, SandwichCode, NumberOfSandwiches, TotalSandwichPrice)
- **Order** (OrderID, TotalOrderPrice)
- **Payment** (PaymentID, PaymentMethod, TransactionTime, TransactionDate, CustomerCode, OrderID)
- **Customer** (CustomerCode, Name, Surname, TaxCode, Age, Email, PhoneNumber, Region, Province, Street, PostalCode, StreetNumber, FloorNumber*)
- **Rider** (RiderCode, Name, Surname, TaxCode, PhoneNumber, IDCardNumber*, PassportNumber*, VATNumber)
- **Delivery** (DeliveryID, DeliveryMethod, Distance, DeliveryDate, DeliveryTime, OrderID, CustomerCode, RiderCode, StoreCode)

Note: * refers to Optional attrbutes

#### 2.2.2 Referential Integrity Costraints

- Employee.StoreCode         → Store.ProvinceCode
- PastContract.EmployeeCode  → Employee.EmployeeCode
- PastContract.StoreCode     → Store.ProvinceCode
- Inventory.StoreCode        → Store.ProvinceCode
- Inventory.IngredientCode   → Ingredient.IngredientCode
- Composition.IngredientCode → Ingredient.IngredientCode
- Composition.SandwichCode   → Sandwich.SandwichCode
- OrderDetails.OrderID       → Order.OrderID
- OrderDetails.SandwichCode  → Sandwich.SandwichCode
- Payment.CustomerCode       → Customer.CustomerCode
- Payment.OrderID            → Order.OrderID
- Delivery.OrderID           → Order.OrderID
- Delivery.CustomerCode      → Customer.CustomerCode
- Delivery.RiderCode         → Rider.RiderCode
- Delivery.StoreCode         → Store.ProvinceCode

## 3 MYSQL IMPLEMENTATION
For the MySQL implementations, I've followed the logical schema and the referential integrity costraints, which have allowed me to define all the tables of my physical schema (`CreateTables.sql` and `Triggers`.sql).

> Within `Triggers.sql`, a trigger has been included to calculate *TotalOrderPrice*. According to the logical schema, this attribute belongs to the `Order` table; however, in the physical design, its value is initialized to 0 and calculated only after a `Delivery` instance referencing that order is created.

Tables have been populated with realistic random values (`PopulateTables.sql`) using both `INSERT INTO` and `LOAD DATA (from `PopulateStore.csv` and `PopulatePastContract`.txt).

Finally, the nine operations defined during the requirements gathering phase have been implemented as procedures (first seven) and functions (last two).

### 3.1 Procedures

### 3.1.1 RemoveExpiredIngredients
- Deletes expired ingredients from the Inventory table (rows where ExpirationDate < CURDATE())
- No input parameters, returns nothing
- No error handling required

### 3.1.2 ListStoresWithLimitedIngredient
- Returns a list of stores where a specific ingredient is below a threshold
- Input parameters:
  - WeightLimit: maximum allowed weight
  - IngredientName: ingredient to check
- Returns the store list (ProvinceCode) and the corresponding AvailableWeight
- Error handling:
  - WeightLimit < 0
  - IngredientName not found in Ingredient table

### 3.1.3 ChainMenu
- Generates a list of sandwiches available in the chain, with ingredients and price
- No input parameters, returns a joined list from Composition, Sandwich, and Ingredient
- No error handling required

### 3.1.4 PrintOrderReceipt
- Generates a receipt for a specific order, including customer name, total price, and payment details
- Input: OrderID
- Returns one row from a join of Order, Payment, and Customer
- Error handling:
  - OrderID does not match ^O_[0-9]+$
  - OrderID not found
  - OrderID exists but the order has not been delivered yet (so TotalOrderPrice = 0)

### 3.1.5 DailyDeliveryReport
- Generates a daily delivery report with total deliveries and total earnings
- Input: Date
- Returns one row with COUNT(DeliveryID) AS TotalDeliveries and SUM(TotalOrderPrice) AS TotalEarnings
- Error checks:
  - Date > CURDATE()
  - Date with no deliveries

### 3.1.6 CreateCustomerOrderHistory
- Dynamically creates/updates a view CustomerOrderHistory with all orders of a specific customer, sorted from latest to earliest delivery
- Input: CustomerCode
- Creates a view via a dynamic query (@sql)
- Error handling:
  - CustomerCode does not match ^CL_[0-9]+$
  - CustomerCode not found

### 3.1.7 FindBest
- Returns statistics of top performers in several categories (riders, stores, customers, most ordered sandwiches)
- No input parameters
- Returns four lists with top three entries per category
- No error handling required

## 3.2 Functions

### 3.2.1 MonthlySalesTotal
- Calculates total sales for a given month and year
- Input: Month, Year
- Output: formatted string indicating total sales
- Error: Month < 1 OR Month > 12

### 3.2.2 CountSandwichesPerOrder
- Returns the number of sandwiches in a specified order
- Input: OrderID
- Output: formatted string indicating total sandwiches
- Error handling:
  - OrderID does not match ^O_[0-9]+$
  - OrderID not found




