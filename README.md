# ABAP RAP Read-Only Scenario - Learning Notes

## Overview

This repository contains my learning notes, code samples, and implementation artifacts for developing a **Read-Only SAP ABAP RAP (RESTful Application Programming Model) Application** using CDS Views, OData V4, Service Definitions, Service Bindings, and Fiori Elements.

The implementation uses the SAP `/DMO/*` flight reference model and demonstrates:

* RAP Read-Only Application Development
* CDS View Modeling
* CDS Associations
* Search Annotations
* Value Helps (F4 Help)
* Text Associations
* Object Page Facets
* Fiori Elements UI Annotations
* OData V4 Service Exposure

---

# Architecture

```text
Database Tables (/DMO/*)
        │
        ▼
CDS Interface Views
        │
        ▼
CDS Projection Views
        │
        ▼
Service Definition
        │
        ▼
Service Binding (OData V4 UI)
        │
        ▼
Fiori Elements Application
```

---

# RAP Development Flow

The standard RAP development pipeline:

```text
Interface View (I-View)
        │
        ▼
Projection View (C-View)
        │
        ▼
Service Definition
        │
        ▼
Service Binding
        │
        ▼
Fiori Elements Application
```

---

# Project Data Model

```text
Connection (Root Entity)
│
├── Airline (Text Association)
│
└── Flights (Child Association)
```

### CDS Views

| CDS View           | Purpose                |
| ------------------ | ---------------------- |
| ZI_CONNECTION_ZAKA | Root Connection Entity |
| ZI_FLIGHT_ZAKA     | Child Flight Entity    |
| ZI_CARRIER_ZAKA    | Airline Text Provider  |
| ZI_AIRPORT_VH_ZAKA | Airport Value Help     |

---

# Semantics Annotations

Used to connect amounts and quantities with their corresponding currency/unit fields.

## Quantity

```abap
@Semantics.quantity.unitOfMeasure: 'UnitField'
QuantityField
```

Example:

```abap
@Semantics.quantity.unitOfMeasure: 'DistanceUnit'
Distance
```

---

## Amount

```abap
@Semantics.amount.currencyCode: 'CurrencyField'
AmountField
```

Example:

```abap
@Semantics.amount.currencyCode: 'CurrencyCode'
Price
```

---

# UI Annotations

## Header Information

Used to configure Object Page headers.

```abap
@UI.headerInfo: {
  typeName: 'Connection',
  typeNamePlural: 'Connections',
  title: {
      value: 'ConnectionId'
  }
}
```

---

## Line Items

Controls List Report columns.

```abap
@UI.lineItem: [{
  position: 10,
  label: 'Airline'
}]
```

---

## Selection Fields

Controls filter bar fields.

```abap
@UI.selectionField: [{
  position: 10
}]
```

---

## Identification Fields

Controls Object Page content.

```abap
@UI.identification: [{
  position: 10,
  label: 'Airline'
}]
```

---

# UI Facets

Facets define Object Page sections.

## Identification Section

```abap
@UI.facet: [{
    id: 'ConnectionDetails',
    type: #IDENTIFICATION_REFERENCE,
    position: 10,
    label: 'Connection Details'
}]
```

---

## Child Table Section

```abap
@UI.facet: [{
    id: 'FlightDetails',
    type: #LINEITEM_REFERENCE,
    position: 20,
    label: 'Flights',
    targetElement: '_Flight'
}]
```

> Note: The target association must be exposed in the CDS projection.

---

# CDS Associations

Associations define relationships between CDS entities.

```abap
association [0..*] to zi_flight_zaka as _Flight
  on $projection.CarrierId = _Flight.CarrierId
 and $projection.ConnectionId = _Flight.ConnectionId
```

---

## Cardinality Examples

| Cardinality | Meaning      |
| ----------- | ------------ |
| [1]         | Exactly One  |
| [0..1]      | Optional One |
| [1..*]      | One or More  |
| [0..*]      | Zero or More |

---

# Text Associations

Used to automatically display descriptions for IDs.

## Main CDS

```abap
@ObjectModel.text.association: '_Airline'
CarrierId
```

## Text CDS

```abap
@Semantics.text: true
Name
```

Result:

```text
LH Lufthansa
```

instead of:

```text
LH
```

---

# Search Functionality

Enable search at CDS level.

## Searchable CDS

```abap
@Search.searchable: true
define view entity ...
```

---

## Searchable Fields

```abap
@Search.defaultSearchElement: true
@Search.fuzzinessThreshold: 0.8
Name
```

---

## Fuzzy Search

```abap
@Search.fuzzinessThreshold: 0.8
```

Example:

```text
Input: Luftansa
Result: Lufthansa
```

---

# Value Help (F4 Help)

Provides lookup values for fields.

```abap
@Consumption.valueHelpDefinition: [{
  entity: {
      name: 'ZI_AIRPORT_VH_ZAKA',
      element: 'AirportId'
  }
}]
AirportFromId
```

---

# Service Definition

Expose CDS entities.

```abap
@EndUserText.label: 'Flight Service'

define service ZS_FLIGHT_ZAKA {

  expose zi_connection_zaka;
  expose zi_flight_zaka;

}
```

---

# Service Binding

Used to publish OData services.

Example:

```text
Service Binding:
ZSB_FLIGHT_AKA_V4

Type:
OData V4 - UI
```

Activation Flow:

```text
Activate
    ↓
Publish
    ↓
Preview
```

---

# Fiori Elements Output

## List Report

Displays:

* Airline
* Connection
* Airport From
* Airport To
* Departure Time
* Arrival Time

---

## Object Page

Displays:

### Connection Details

* Carrier
* Connection
* Airports
* Departure Time
* Arrival Time
* Distance

### Flights

Child table displaying:

* Flight Date
* Price
* Currency
* Plane Type
* Seats Max
* Seats Occupied

---

# Useful Developer Tips

## View Final Annotations

To inspect active annotations:

```text
CDS View
 └── Open With
      └── Active Annotations
```

This displays:

* Inherited annotations
* Metadata extensions
* Generated RAP metadata

---

## Recommended RAP Development Sequence

```text
1. Database Tables
2. Interface Views
3. Projection Views
4. Associations
5. UI Annotations
6. Value Helps
7. Service Definition
8. Service Binding
9. Publish
10. Preview
```

---

# Key Learnings

* RAP follows a layered architecture.
* CDS Associations drive navigation.
* Facets structure Object Pages.
* Text Associations improve usability.
* Value Helps provide F4 assistance.
* Search annotations enable fuzzy search.
* Service Definitions expose entities.
* Service Bindings publish OData services.
* Fiori Elements automatically generates the UI from annotations.

---

# Technologies Used

* SAP ABAP RAP
* CDS View Entities
* OData V4
* Fiori Elements
* SAP HANA
* SAP S/4HANA Flight Reference Model (/DMO/*)

```
```
